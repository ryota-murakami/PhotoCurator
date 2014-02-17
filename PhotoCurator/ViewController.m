//
//  ViewController.m
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/12.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import "ViewController.h"
#import "Annotation.h"

@interface ViewController ()
{
    Annotation *pin;
}

@property (weak, nonatomic) IBOutlet MKMapView *MapView;

- (IBAction)CurrentLocationButtonTapped:(id)sender;


@end

@implementation ViewController

- (void)viewDidLoad
{
    //初回起動時に利用規約を表示する
    NSUserDefaults *database = [NSUserDefaults standardUserDefaults];
    BOOL agree = [database boolForKey:@"agree"];
    
    if(!agree){
        [self performSegueWithIdentifier:@"Auth" sender:self];
    }
    
    [super viewDidLoad];
	//マップの設定
    _MapView.delegate = self;
    _MapView.showsUserLocation = YES;

    
    
    //左上のボタン
    UIBarButtonItem *photoButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemOrganize target:self action:@selector(photoButtonTapped:)];
    self.navigationItem.leftBarButtonItem = photoButton;
    
    //検索バー
    UISearchBar *searchBar = [[UISearchBar alloc]init];
    searchBar.placeholder = @"場所/住所を検索";
    searchBar.delegate = self;
    self.navigationItem.titleView = searchBar;

    
    //右上のボタン
    UIBarButtonItem *albumButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(albumButtonTapped:)];
    self.navigationItem.rightBarButtonItem = albumButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Auth_ViewController

-(void)authEnd:(Auth_ViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -

#pragma mark segue
//ViewControllerを遷移後の画面のデリゲートにセットする
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    [[segue destinationViewController]setDelegate:self];
}
#pragma mark -

#pragma mark photoViewController

-(void)photoButtonTapped:(UIBarButtonItem*)sender
{
    NSLog(@"photoボタン");
}
#pragma mark -

#pragma mark albumViewContoroller

-(void)albumButtonTapped:(UIBarButtonItem *)sender
{
    NSLog(@"albumボタン");
}
#pragma mark -


#pragma mark searchBar

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if(pin){
        [_MapView removeAnnotation:pin];
    }
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [searchBar resignFirstResponder];

    //検索結果に座標を付与
    CLGeocoder *geocoder = [[CLGeocoder alloc]init];
    [geocoder geocodeAddressString:searchBar.text completionHandler:^(NSArray *placemark,NSError *error){
        if(error){
            UIAlertView *alert = [[UIAlertView alloc]
                                  initWithTitle : @"検索エラー"
                                  message : @"エラーが発生しました"
                                  delegate : nil
                                  cancelButtonTitle : @"OK"
                                  otherButtonTitles : nil];
            [alert show];
            
        }else{
            CLPlacemark *place = placemark[0];
            CLLocationDegrees latitude = place.location.coordinate.latitude;//緯度
            CLLocationDegrees longitude = place.location.coordinate.longitude;//経度
            
            //検索した場所へ移動
            [self goRegionPointLatitude:latitude longitude:longitude];
            
            //検索した場所へピンを表示
            NSString *placeName = place.addressDictionary[@"FormattedAddressLines"][0];
            pin = [[Annotation alloc]initWithCoordinate:place.location.coordinate title:placeName];
            [_MapView addAnnotation:pin];
        
            }
        }
    ];
}

//指定座標へ移動するメソッド
-(void)goRegionPointLatitude:(CLLocationDegrees)latitude longitude:(CLLocationDegrees)longitude
{
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    MKCoordinateRegion spot = MKCoordinateRegionMakeWithDistance(coordinate, 500, 500);
    [_MapView setRegion:spot animated:YES];
}


#pragma mark -

#pragma mark MKMapViewDelegate

//addAnnotationの直前にピンの形状を要求するメソッド
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    //現在地のアノテーションが表示される時はこのメソッドを無効化する
    if([annotation.title isEqualToString:@"Current Location"]){
        return nil;
    }
 
    NSString *identifier = @"MyPin";
    MKPinAnnotationView *newPin =(MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
    
    if(newPin == nil){
        newPin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:identifier];
        newPin.animatesDrop = YES;
        newPin.pinColor = MKPinAnnotationColorRed;
        newPin.canShowCallout = YES;
    }
    return newPin;
}
#pragma mark -

#pragma mark ToolBar

- (IBAction)CurrentLocationButtonTapped:(id)sender {
    
    CLLocationDegrees lattitude = _MapView.userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = _MapView.userLocation.location.coordinate.longitude;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lattitude, longitude);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location,2000,2000);

    [_MapView setRegion:region animated:YES];
    
}
#pragma mark -
@end























