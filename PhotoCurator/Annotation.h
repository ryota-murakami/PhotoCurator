//
//  Annotation.h
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/16.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <MapKit/MapKit.h>

@interface Annotation : NSObject<MKAnnotation>

@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic,copy) NSString *title;

//イニシャライザ
-(id)initWithCoordinate:(CLLocationCoordinate2D)pinCoordiante title:(NSString *)pinTitle;

@end
