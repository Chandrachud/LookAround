//
//  MainViewController.h
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//
@class NYSliderPopover;
@class NMRangeSlider;

#import "FlipsideViewController.h"

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>
{
    CLLocationManager *locationManager;
@private
    CGRect _searchTableViewRect;
}

@property (nonatomic, strong) CLLocationManager *locationManager;
@property (strong, nonatomic) UISearchController *searchController;

@property(nonatomic, weak) IBOutlet UIButton *showLocationSearchBtn;
@property(nonatomic, strong)  UIButton *cameraBtn;
@property(nonatomic, strong)  UIButton *filterBtn;
@property(nonatomic, strong)  UIButton *glassViewButton;

@property (strong, nonatomic)  UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet  NYSliderPopover *slider;

@property (strong, nonatomic)  UIButton *showListViewBtn;
@property (strong, nonatomic)  UIButton *showMapViewBtn;


@property (weak, nonatomic) IBOutlet NMRangeSlider *labelSlider;
@property (weak, nonatomic) IBOutlet UILabel *lowerLabel;
@property (weak, nonatomic) IBOutlet UILabel *upperLabel;
@end
