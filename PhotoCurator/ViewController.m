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
@property (strong,nonatomic) UISearchBar *searchBar;

//左下の現在地ボタン
- (IBAction)CurrentLocationButtonTapped:(id)sender;

- (IBAction)mapViewTapped:(id)sender;


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
    _searchBar = [[UISearchBar alloc]init];
    _searchBar.placeholder = @"場所/住所を検索";
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleMinimal;
    _searchBar.keyboardType = UIKeyboardAppearanceDark;
    self.navigationItem.titleView = _searchBar;

    //右上のボタン
    UIBarButtonItem *albumButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemBookmarks target:self action:@selector(albumButtonTapped:)];
    self.navigationItem.rightBarButtonItem = albumButton;
    
    //戻るボタン
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc]init];
    backButton.title = @"戻る";
    self.navigationItem.backBarButtonItem = backButton;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark Auth_ViewController
//遷移先のdelegateにセット
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([[segue identifier] isEqualToString:@"Auth"]){
        
        [[segue destinationViewController]setDelegate:self];
    }
}
//認証画面を閉じる
-(void)authEnd:(Auth_ViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

    [self performSegueWithIdentifier:@"album" sender:self];
}
#pragma mark -


#pragma mark searchBar

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if(pin){
        [_MapView removeAnnotation:pin];
    }
}

//背面タップでキーボードを消す
- (IBAction)mapViewTapped:(id)sender {
    
    if([self.searchBar isFirstResponder]){
    [self.searchBar resignFirstResponder];
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
                                  message : @"結果が見つかりません"
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
//現在地へ移動する
- (IBAction)CurrentLocationButtonTapped:(id)sender {
    
    CLLocationDegrees lattitude = _MapView.userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = _MapView.userLocation.location.coordinate.longitude;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lattitude, longitude);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location,2000,2000);

    [_MapView setRegion:region animated:YES];
    
}

#pragma mark -
@end























