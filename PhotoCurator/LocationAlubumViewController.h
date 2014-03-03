//
//  LocationAlubumViewController.h
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/27.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import "ViewController.h"

#import <UIKit/UIKit.h>

#import "AlbumData.h"

@interface LocationAlubumViewController : UITableViewController<UIAlertViewDelegate>

//遷移元ピンの座標
@property CLLocationCoordinate2D pinCoordinate;

@end
