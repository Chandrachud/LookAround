//
//  ClientsListView.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/31/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "ClientsListView.h"
#import "Place.h"

@implementation ClientsListView

- (id)initWithFrame:(CGRect)frame
{
    self.delegate = self;
    self.dataSource = self;
    return self;
}

-(void)dealloc
{
    _arrayList = nil;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.textLabel.font = [UIFont systemFontOfSize:15];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        
    }
    Place *place = [self.arrayList objectAtIndex:indexPath.row];
    
    [cell.textLabel setText:[NSString stringWithFormat:@"%@",place.placeName]];
    
    return cell;
    
}


@end
