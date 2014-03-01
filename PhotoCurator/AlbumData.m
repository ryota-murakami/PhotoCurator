//
//  AlbumData.m
//  PhotoCurator
//
//  Created by tokyorefrain on 2014/02/26.
//  Copyright (c) 2014年 tokyorefrain. All rights reserved.
//

#import "AlbumData.h"

@implementation AlbumData

-(id)initWithTitle:(NSString *)title location:(CLLocationCoordinate2D)location
{
    _title = title;
    _location = location;
    return self;
}
@end
