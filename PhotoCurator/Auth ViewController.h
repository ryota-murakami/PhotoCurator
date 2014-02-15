//
//  Auth ViewController.h
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/14.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Auth_ViewController;
@protocol Auth_ViewControllerDelegate
-(void)authEnd:(Auth_ViewController *)controller;

@end

@interface Auth_ViewController : UIViewController

@property(weak, nonatomic) id <Auth_ViewControllerDelegate> delegate;

@end
