//
//  SettingsModelClass.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/22/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SettingsModelClass : NSObject

@property(nonatomic, strong) NSString *industry;
@property(nonatomic, assign) double revenueFrom;
@property(nonatomic, assign) double revenueTo;
@property(nonatomic, strong) NSString *locationCity;
@property(nonatomic, strong) NSString *locationCountry;
@property(nonatomic, strong) NSString *locationState;
@property(nonatomic, strong) NSString *locationZip;
@property(nonatomic, assign) int *range;

+ (id)sharedSettings;

@end
