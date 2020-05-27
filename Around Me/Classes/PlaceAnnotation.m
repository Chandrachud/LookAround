//
//  PlaceAnnotation.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 11/27/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "PlaceAnnotation.h"
#import "Place.h"

@interface PlaceAnnotation ()

@property (nonatomic, strong) Place *place;

@end

@implementation PlaceAnnotation


- (id)initWithPlace:(Place *)place {
    if((self = [super init])) {
        _place = place;
    }
    return self;
}

- (CLLocationCoordinate2D)coordinate {
    return [_place location].coordinate;
}

- (NSString *)title {
    return [_place placeName];
}

-(void)dealloc
{
    _place = nil;
}
@end
