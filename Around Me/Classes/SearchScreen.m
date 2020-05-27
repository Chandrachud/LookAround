//
//  SearchScreen.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/22/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "SearchScreen.h"
#import "RootSplitViewController.h"
#import "DetailsViewController.h"
@interface SearchScreen()


@end

@implementation SearchScreen

-(void)viewDidLoad
{
//    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
//    UIColor *labelTopColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
//    UIColor *labelBottomClor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
//    CAGradientLayer *gradient = [CAGradientLayer layer];
//    gradient.frame = myView.bounds;
//    gradient.colors = [NSArray arrayWithObjects:(id)[labelBottomClor CGColor], (id)[labelTopColor CGColor], nil];
//    [myView.layer insertSublayer:gradient atIndex:0];
//    [self.view addSubview:myView];
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
//    UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, 50, 30)];
//    // doneButton.titleLabel.text = @"Done";
//    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
//    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    [doneButton addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
//    doneButton.titleLabel.textColor = [UIColor blackColor];
//    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
//    [myView addSubview:doneButton];

//    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(20, self.view.frame.size.height - 45, 100, 50)];
//    [btn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
//
//    btn.backgroundColor = [UIColor darkGrayColor];
//    [self.view addSubview:btn];
    
    //self.preferredDisplayMode = UISplitViewControllerDisplayModeAllVisible;

    //[Inside application:didFinishLaunchingWithOptions:
    UINavigationController *leftNavController = [self.viewControllers objectAtIndex:0];
    RootSplitViewController *rootSplitViewController = (RootSplitViewController *)[leftNavController topViewController];
    DetailsViewController *detailsViewController = [self.viewControllers objectAtIndex:1];
    rootSplitViewController.delegate = detailsViewController;
    
}

-(void)done
{
    self.view.window.rootViewController = self.rootCont;
    [self.searchDelegate didDismissViewController:nil];
}

- (BOOL)splitViewController:(UISplitViewController *)svc shouldHideViewController:(UIViewController *)vc inOrientation:(UIInterfaceOrientation)orientation{
    return NO;
}
@end
