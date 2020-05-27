//
//  SearchScreen.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/22/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchViewControllerDelegate;

@interface SearchScreen : UISplitViewController<UISplitViewControllerDelegate>

@property(nonatomic, strong)UIViewController *rootCont;
@property (nonatomic, assign) id<SearchViewControllerDelegate> searchDelegate;

@end

@protocol SearchViewControllerDelegate <NSObject>
@optional
-(void)didDismissViewController:(NSArray *)locationsArray;

@end
