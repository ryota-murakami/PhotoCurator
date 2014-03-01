//
//  ViewController.m
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/12.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import "ViewController.h"
#import "Annotation.h"
#import "LocationAlubumViewController.h"

@interface ViewController ()
{
    Annotation *pin;
}

//マップビュー
@property (weak, nonatomic) IBOutlet MKMapView *MapView;
//サーチバー
@property (strong,nonatomic) IBOutlet UISearchBar *searchBar;





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
    _MapView.userLocation.title = @"現在地";
    
    //タイトル
    self.navigationItem.title = @"マップ";
    
    //現在地ボタン
    UIBarButtonItem *currentButton = [[UIBarButtonItem alloc ]initWithBarButtonSystemItem:100 target:self action:@selector(CurrentButtonTapped:)];
    self.navigationItem.leftBarButtonItem = currentButton;
    
    
    //検索バー
    _searchBar.placeholder = @"場所/住所を検索";
    _searchBar.delegate = self;
    _searchBar.searchBarStyle = UISearchBarStyleDefault;
    
    _searchBar.hidden = YES;
    _searchBar.alpha = 0;
    _searchBar.showsCancelButton = YES;
    

   

        

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    //認証画面
    if([[segue identifier] isEqualToString:@"Auth"]){
        
        [[segue destinationViewController]setDelegate:self];
    }

    if([[segue identifier] isEqualToString:@"Detail"]){
        LocationAlubumViewController *locationAlbumViewController = [segue destinationViewController];
        locationAlbumViewController.pinCoordinate = pin.coordinate;
    }



}

#pragma mark Auth_ViewControllerDetegate

//認証画面を閉じる
-(void)authEnd:(Auth_ViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -



#pragma mark searchBar
//検索開始時に前回の検索結果をクリア
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    if(pin){
        [_MapView removeAnnotation:pin];
    }
}
//キャンセルボタンタップでサーチバーを隠す
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{_searchBar.alpha = 0;} completion:^(BOOL finished){_searchBar.hidden = !_searchBar.hidden;}];
}

//背面タップでキーボードを消す
- (IBAction)mapViewTapped:(id)sender {
    if([_searchBar isFirstResponder]){
    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{_searchBar.alpha = 0;} completion:^(BOOL finished){_searchBar.hidden = !_searchBar.hidden;}];
    }
}

//検索ボタンタップ時
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{

    [_searchBar resignFirstResponder];
    [UIView animateWithDuration:0.3 animations:^{_searchBar.alpha = 0;} completion:^(BOOL finished){_searchBar.hidden = !_searchBar.hidden;}];

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
    if([annotation.title isEqualToString:@"現在地"]){
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

#pragma mark NavigationBar
//現在地へ移動する
- (void)CurrentButtonTapped:(id)sender {
    
    CLLocationDegrees lattitude = _MapView.userLocation.location.coordinate.latitude;
    CLLocationDegrees longitude = _MapView.userLocation.location.coordinate.longitude;
    CLLocationCoordinate2D location = CLLocationCoordinate2DMake(lattitude, longitude);
    
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location,2000,2000);

    [_MapView setRegion:region animated:YES];
    
}

//検索ボタンでサーチバーを表示/非表示
- (IBAction)searchButtontapped:(id)sender {
    
    if([_searchBar isFirstResponder]){
        
        [_searchBar resignFirstResponder];
        [UIView animateWithDuration:0.3 animations:^{_searchBar.alpha = 0;} completion:^(BOOL finished){_searchBar.hidden = !_searchBar.hidden;}];
        
    }else{
    [_searchBar becomeFirstResponder];
    
    _searchBar.hidden = !_searchBar.hidden;
    [UIView animateWithDuration:0.3 animations:^{_searchBar.alpha = 1.0;}];
    }
}

#pragma mark -

#pragma mark MKMapviewDekegate

//ピンに詳細ボタンを追加
- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)views {
  
    [views enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL* stop) {
        if(![((MKAnnotationView*)obj).annotation.title isEqualToString:@"現在地"]){
        ((MKAnnotationView*)obj).rightCalloutAccessoryView
        = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        }
        }];
    
}

//詳細画面へ遷移
-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
    [self performSegueWithIdentifier:@"Detail" sender:self];
}


#pragma mark -

@end























