//
//  Annotation.m
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/16.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import "Annotation.h"

@implementation Annotation

//イニシャライザ
-(id)initWithCoordinate:(CLLocationCoordinate2D)pinCoordiante title:(NSString *)pinTitle
{
    //座標
    _coordinate = pinCoordiante;
    
    //タイトル
    _title = pinTitle;

    return self;
}

@end
