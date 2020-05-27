//
//  Place.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 11/27/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CLLocation;

@interface Place : NSObject

@property (nonatomic, strong) CLLocation *location;
@property (nonatomic, copy) NSString *reference;
@property (nonatomic, copy) NSString *placeName;
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *phoneNumber;
@property (nonatomic, copy) NSString *website;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *appIcon;

- (id)initWithLocation:(CLLocation *)location reference:(NSString *)reference name:(NSString *)name address:(NSString *)address iconUrl:(NSString *)iconUrl;

- (NSString *)infoText;

@end
