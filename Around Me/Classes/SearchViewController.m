//
//  SearchViewController.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/22/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "SearchViewController.h"
#import "DropDownView.h"

@interface SearchViewController ()

@property(nonatomic, strong)DropDownView *dropDown;

@end

@implementation SearchViewController


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

}

-(void)dealloc
{
    _dropDown = nil;
}
-(void)done
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)searchBtnlicked:(id)sender
{
    self.dropDown = [[DropDownView alloc]init];
    CGFloat height = 100;
    NSString *strings[3];
    strings[0] = @"foo";
    strings[1] = @"bar";
    NSArray *array = [NSArray arrayWithObjects:strings count:2];
    [self.dropDown showDropDown:self.searchBtn height:&height arr:array imgArr:nil direction:@"down"];
}
@end
