//
//  AlbumData.h
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/26.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

#import <CoreLocation/CoreLocation.h>

@interface AlbumData : NSObject<NSCoding>

@property(nonatomic,copy) NSString* title;
@property(nonatomic) CLLocationCoordinate2D location;
@property(nonatomic,copy) NSMutableArray* photoList;

-(id)initWithTitle:(NSString *)title location:(CLLocationCoordinate2D)location;

@end
