//
//  RootSplitViewController.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/22/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "RootSplitViewController.h"
#import "DetailsViewController.h"
#import "SettingsModelClass.h"

@interface RootSplitViewController()

@property(nonatomic, strong)NSArray *arrayList;

@end

@implementation RootSplitViewController

-(void)viewDidLoad
{
    self.arrayList = [NSArray arrayWithObjects:@"Summary",@"Industry",@"Revenue",@"Location", nil];
    [_doneBtn setAction:@selector(done)];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
    }
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",[self.arrayList objectAtIndex:indexPath.row]]];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate objectSelected:indexPath.row];
}

-(void)dealloc
{
    
}
@end
