//
//  SettingsModelClass.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/22/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "SettingsModelClass.h"

@implementation SettingsModelClass

+ (id)sharedSettings
{
    static SettingsModelClass *sharedSettings = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedSettings = [[self alloc] init];
    });
    return sharedSettings;
}

- (id)init {
    if (self = [super init]) {
    }
    return self;
}
-(void)saveIndustry:(NSString *)industry
{
    self.industry = industry;
}

-(void)saveRevenueData:(double)minRevenue to:(double)maxRevenue
{
    self.revenueFrom = minRevenue;
    self.revenueTo = maxRevenue;
}

-(void)saveLocationData:(NSString*)country state:(NSString *)state city:(NSString *)city zipCode:(NSString *)zipCode range:(int)range
{
    self.locationState = state;
    self.locationCountry = country;
    self.locationCity = city;
    self.locationZip = zipCode;
    self.range = &(range);
}

-(void)dealloc
{
    _industry = nil;
    _locationCity = nil;
    _locationCountry = nil;
    _locationState = nil;
    _locationZip = nil;
}
@end
