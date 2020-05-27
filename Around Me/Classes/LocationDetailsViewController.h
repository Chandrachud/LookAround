//
//  LocationDetailsViewController.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/3/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//
@class MKMapView;

#import <UIKit/UIKit.h>
@class Place;
@class CLLocation;

@interface LocationDetailsViewController : UIViewController

@property(nonatomic, strong) Place *tappedPlace;
@property(nonatomic, strong) NSData *locationImageData;
@property(nonatomic, strong) CLLocation *userLocation;

- (IBAction)done:(id)sender;

//@property(nonatomic, weak) IBOutlet MKMapView *mapViewOutlet;
//@property(nonatomic, weak) IBOutlet UIView *buttonsView;
//@property(nonatomic, weak) IBOutlet UIView *buttonDetailsView;
//@property(nonatomic, weak) IBOutlet UIView *bottomView;
//@property(nonatomic, weak) IBOutlet UIView *dividerView;
//@property(nonatomic, weak) IBOutlet UIView *dividerView1;


@end
