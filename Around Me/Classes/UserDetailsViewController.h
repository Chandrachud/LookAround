//
//  UserDetailsViewController.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/10/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//
@class ModelClass;

#import <UIKit/UIKit.h>

@interface UserDetailsViewController : UIViewController

@property(strong, nonatomic) NSDictionary *contactsDict;
@property(strong, nonatomic) UIViewController *viewCont;
@property(nonatomic, strong) ModelClass *modelClass;
@property(nonatomic, strong) UINavigationController *customNavigationCont;

@end
