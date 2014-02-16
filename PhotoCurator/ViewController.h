//
//  ViewController.h
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/12.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//
#import "Auth ViewController.h"

#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

@interface ViewController : UIViewController<MKMapViewDelegate,Auth_ViewControllerDelegate,UISearchBarDelegate,CLLocationManagerDelegate>


@end
