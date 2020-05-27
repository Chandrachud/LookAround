//
//  WFFilterViewController.h
//  WellsFargoProject
//
//  Created by Ruptapas Chakraborty on 1/1/15.
//  Copyright (c) 2015 Synechron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WFFilterViewController : UIViewController
@property (weak, nonatomic) IBOutlet UILabel *lblSummary;
@property (weak, nonatomic) IBOutlet UIView *filterView;
@property (weak, nonatomic) IBOutlet UITableView *menuTableView;
@property (weak, nonatomic) IBOutlet UITableView *menuDetailTableView;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *menuTableWidthConstraint;

@property (weak, nonatomic) IBOutlet UIButton *doneButton;

-(IBAction)doneButtonClicked:(id)sender;

@end
