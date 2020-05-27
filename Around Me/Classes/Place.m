//
//  Place.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 11/27/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "Place.h"

@implementation Place


- (id)initWithLocation:(CLLocation *)location reference:(NSString *)reference name:(NSString *)name address:(NSString *)address iconUrl:(NSString*)iconUrl {
    if((self = [super init])) {
        _location = location;
        _reference = reference;
        _placeName = name;
        _address = address;
        _imageUrl = iconUrl;
    }
    return self;
}

- (NSString *)infoText {
    return [NSString stringWithFormat:@"Name:%@\nAddress:%@\nPhone:%@\nWeb:%@", _placeName, _address, _phoneNumber, _website];
}

-(void)dealloc
{
    _location = nil;
    _reference = nil;
    _placeName = nil;
    _address = nil;
    _imageUrl = nil;
    _phoneNumber = nil;
    _website = nil;
}
@end
