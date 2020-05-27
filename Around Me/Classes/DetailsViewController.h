//
//  DetailsViewController.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/22/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailsViewController : UIViewController

@property(nonatomic, weak)IBOutlet UIView *locationsView;
@property(nonatomic, weak)IBOutlet UIButton *countryButton;
@property(nonatomic, weak)IBOutlet UIButton *stateButton;
@property(nonatomic, weak)IBOutlet UIButton *cityButton;


-(IBAction)countryBtnClicked:(id)sender;
-(IBAction)stateBtnClicked:(id)sender;
-(IBAction)cityBtnClicked:(id)sender;

@end
