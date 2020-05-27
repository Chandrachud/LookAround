//
//  LocationDetailsiPhone.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 1/5/15.
//  Copyright (c) 2015 Jean-Pierre Distler. All rights reserved.
//

@class Place;
@class CLLocation;

#import <UIKit/UIKit.h>

@interface LocationDetailsiPhone : UIViewController

@property(nonatomic, strong) Place *tappedPlace;
@property(nonatomic, strong) NSData *locationImageData;
@property(nonatomic, strong) CLLocation *userLocation;

@property(nonatomic, strong)  UITableView *contactsTableView;

@end
