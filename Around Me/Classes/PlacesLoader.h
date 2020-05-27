//
//  PlacesLoader.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 11/27/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//
@class Place;

#import <Foundation/Foundation.h>

//1
@class CLLocation;

//2
typedef void (^SuccessHandler)(NSDictionary *responseDict,NSData *data);
typedef void (^ErrorHandler)(NSError *error);

@interface PlacesLoader : NSObject

//3
+ (PlacesLoader *)sharedInstance;

//4
- (void)loadPOIsForLocation:(CLLocation *)location radius:(int)radius successHandler:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;

- (void)loadDetailInformation:(Place *)location successHanlder:(SuccessHandler)handler errorHandler:(ErrorHandler)errorHandler;


@end