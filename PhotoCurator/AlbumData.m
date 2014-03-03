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

//コーダー
-(void)encodeWithCoder:(NSCoder *)aCoder
{

    [aCoder encodeObject:_title forKey:@"title"];
    [aCoder encodeDouble:_location.latitude forKey:@"latitude"];
    [aCoder encodeDouble:_location.longitude forKey:@"longitude"];
    [aCoder encodeObject:_photoList forKey:@"photoList"];
    
}

-(id)initWithCoder:(NSCoder *)aDecoder

{
    self = [super init];
    if(self){
        _title = [aDecoder decodeObjectForKey:@"title"];
        _location.latitude = [aDecoder decodeDoubleForKey:@"latitude"];
        _location.longitude = [aDecoder decodeDoubleForKey:@"longitude"];
        _photoList = [aDecoder decodeObjectForKey:@"photoList"];
        

    }
    return self;
}

@end
