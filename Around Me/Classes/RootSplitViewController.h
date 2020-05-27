//
//  RootSplitViewController.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/22/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//
#import <UIKit/UIKit.h>

@protocol RightSplitViewControllerDelegate;

@interface RootSplitViewController : UITableViewController

@property (nonatomic, assign) id<RightSplitViewControllerDelegate> delegate;
@property(weak, nonatomic) IBOutlet UIBarButtonItem *doneBtn;

@end

@protocol RightSplitViewControllerDelegate <NSObject>
@optional
-(void)objectSelected:(NSInteger)indexPath;
@end
