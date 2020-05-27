//
//  ClientsListView.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/31/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ClientsListView : UITableView <UITableViewDataSource,UITableViewDelegate>

@property(nonatomic, strong)NSArray *arrayList;

@end
