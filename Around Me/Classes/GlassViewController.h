//
//  GlassViewController.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 1/8/15.
//  Copyright (c) 2015 Jean-Pierre Distler. All rights reserved.
//
@class CLLocation;
#import <UIKit/UIKit.h>

@interface GlassViewController : UIViewController

@property(strong,nonatomic)NSString *jsonData;
@property(strong,nonatomic)CLLocation *currentLocation;

@end
