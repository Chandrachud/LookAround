//
//  WFLocationSearchViewController.h
//  WellsFargoProject
//
//  Created by Ruptapas Chakraborty on 12/31/14.
//  Copyright (c) 2014 Synechron. All rights reserved.
//

@protocol WFLocationSearchViewControllerDelegate;

@class MKMapItem;
#import <UIKit/UIKit.h>


@interface WFLocationSearchViewController : UIViewController
{
    
}
@property (strong, nonatomic)  UITableView *tableView;
@property (strong, nonatomic) UISearchController *searchController;

@property (weak, nonatomic) id <WFLocationSearchViewControllerDelegate> delegate;


@end

@protocol WFLocationSearchViewControllerDelegate <NSObject>

-(void)didClickToFindTheLocation:(MKMapItem *)item;


@end