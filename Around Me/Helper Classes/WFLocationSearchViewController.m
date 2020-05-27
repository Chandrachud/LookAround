//
//  WFLocationSearchViewController.m
//  WellsFargoProject
//
//  Created by Ruptapas Chakraborty on 12/31/14.
//  Copyright (c) 2014 Synechron. All rights reserved.
//

#import "WFLocationSearchViewController.h"
#import <MapKit/MapKit.h>

#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define kBackgroundColor [UIColor colorWithRed:242.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0]
#define kHeightForHeaderInSection 40.0f
#define kDefaultItemCount 3
#define kHeightForRowForRecent 60.0f
#define kHeightForRowForEvents 90.0f
#define kHeightForRowForShared 60.0f
#define kHeightForRowForMoreButton 30.0f
#define kBackgroundColor_BarTintColor [UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0]


@interface WFLocationSearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,UISearchControllerDelegate>
{
    NSArray *garrRecentSearchItems;
    NSMutableArray *garrEventItems;
    NSMutableArray *garrSharedItems;
    
    bool isMoreButtonTappedForRecent;
    bool isMoreButtonTappedForEvents;
    bool isMoreButtonTappedForShared;
    
    UISearchBar *searchLocation;
    CGRect _searchTableViewRect;
    
    MKLocalSearch *localSearch;
    MKLocalSearchResponse *results;
    
    UITableViewController *searchResultsController;
}

@end

@implementation WFLocationSearchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Do any additional setup after loading the view.
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    
    self.view.backgroundColor = kBackgroundColor;
    searchLocation = [[UISearchBar alloc]initWithFrame:CGRectMake(10, 20, self.view.frame.size.width - 20, 44)];
    [searchLocation setPlaceholder:@"Search Location"];
    searchLocation.delegate = self;
    
    self.navigationController.navigationBar.topItem.title = @"Search";
    self.tableView.backgroundColor = kBackgroundColor;
    self.tableView.separatorColor = [UIColor clearColor];
    garrRecentSearchItems = [[NSMutableArray alloc]init];
    garrEventItems = [[NSMutableArray alloc]init];
    garrSharedItems = [[NSMutableArray alloc]init];
    
    garrEventItems = [self getAllItemsForFileName:@"events" key:@"events"];
    garrSharedItems = [self getAllItemsForFileName:@"shared" key:@"shared"];
    
    [self setupSearchController];
    [self setupSearchBar];
    [[UINavigationBar appearance] setHidden:NO];
    
    garrRecentSearchItems = [self mkmapItems];
    
    // Keep the subviews inside the top and bottom layout guides
    self.edgesForExtendedLayout = UIRectEdgeLeft | UIRectEdgeBottom | UIRectEdgeRight;
    [self.navigationController.view setBackgroundColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setBarTintColor:kBackgroundColor_BarTintColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kBackgroundColor_BarTintColor, NSForegroundColorAttributeName,nil]
                                                                                            forState:UIControlStateNormal];
    
    
    UIColor *labelTopColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    UIColor *labelBottomClor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationController.navigationBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[labelTopColor CGColor], (id)[labelBottomClor CGColor], nil];
}

-(void)viewWillDisappear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    garrRecentSearchItems = nil;
    garrEventItems = nil;
    garrSharedItems = nil;
    searchLocation = nil;
    localSearch = nil;
    results = nil;
    searchResultsController = nil;
}

-(void)dismissKeyboard
{
    [searchLocation resignFirstResponder];
}

-(NSArray *)mkmapItems
{
    double latitude = 18.9750;
    double longitude = 72.8258;
    MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil] ;
    
    double latitude1 = 34.0500;
    double longitude1 = 118.2500;
    MKPlacemark *placemark1 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude1, longitude1) addressDictionary:nil] ;
    
    double latitude2 = +37.72231898;
    double longitude2 = -122.43497935;
    MKPlacemark *placemark2 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude2, longitude2) addressDictionary:nil] ;
    
    double latitude3 = 12.9667;
    double longitude3 = 77.5667;
    
    MKPlacemark *placemark3 = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude3, longitude3) addressDictionary:nil] ;
    
    MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
    MKMapItem *mapItem1 = [[MKMapItem alloc] initWithPlacemark:placemark1];
    MKMapItem *mapItem2 = [[MKMapItem alloc] initWithPlacemark:placemark2];
    MKMapItem *mapItem3 = [[MKMapItem alloc] initWithPlacemark:placemark3];
    
    [mapItem setName:@"Mumbai"];
    [mapItem1 setName:@"New York"];
    [mapItem2 setName:@"San Fransisco"];
    [mapItem3 setName:@"Bangalore"];
    
    NSArray *array = [NSArray arrayWithObjects:mapItem,mapItem2,mapItem3, nil];
    return array;
}

//#pragma mark - Search bar delegate methods
//
//
//- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
//{
//    NSMutableDictionary *mDictionary = [[NSMutableDictionary alloc]init];
//    [mDictionary setValue:searchBar.text forKey:@"enteredtext"];
//    NSDate *today = [NSDate date];
//    [mDictionary setValue: today forKey:@"datetime"];
//
//    [garrRecentSearchItems addObject:mDictionary];
//
//    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc]
//                                        initWithKey: @"datetime" ascending: NO];
//
//    NSArray *sortedArray = [garrRecentSearchItems sortedArrayUsingDescriptors: [NSArray arrayWithObject:sortDescriptor]];
//
//    garrRecentSearchItems = [[NSMutableArray alloc]init];
//    [garrRecentSearchItems addObjectsFromArray: sortedArray];
//
//    [searchBar setText:@""];
//    [searchBar resignFirstResponder];
//
//    [self.tableView reloadData];
//}
//
//
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    // called only once
//    return YES;
//}
//
//
//- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
//{
//    // called only once
//}
//
#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == searchResultsController.tableView) {
        
    }
    else
    {
        if ([cell respondsToSelector:@selector(tintColor)]) {
            if (tableView == self.tableView) {
                CGFloat cornerRadius = 5.f;
                cell.backgroundColor = UIColor.clearColor;
                CAShapeLayer *layer = [[CAShapeLayer alloc] init];
                CGMutablePathRef pathRef = CGPathCreateMutable();
                CGRect bounds = CGRectInset(cell.bounds, 10, 0);
                BOOL addLine = NO;
                if (indexPath.row == 0 && indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                    CGPathAddRoundedRect(pathRef, nil, bounds, cornerRadius, cornerRadius);
                } else if (indexPath.row == 0) {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds));
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds), CGRectGetMidX(bounds), CGRectGetMinY(bounds), cornerRadius);
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds));
                    addLine = YES;
                } else if (indexPath.row == [tableView numberOfRowsInSection:indexPath.section]-1) {
                    CGPathMoveToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMinY(bounds));
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMinX(bounds), CGRectGetMaxY(bounds), CGRectGetMidX(bounds), CGRectGetMaxY(bounds), cornerRadius);
                    CGPathAddArcToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMaxY(bounds), CGRectGetMaxX(bounds), CGRectGetMidY(bounds), cornerRadius);
                    CGPathAddLineToPoint(pathRef, nil, CGRectGetMaxX(bounds), CGRectGetMinY(bounds));
                } else {
                    CGPathAddRect(pathRef, nil, bounds);
                    addLine = YES;
                }
                layer.path = pathRef;
                CFRelease(pathRef);
                layer.fillColor = [UIColor colorWithWhite:1.f alpha:0.8f].CGColor;
                
                if (addLine == YES) {
                    CALayer *lineLayer = [[CALayer alloc] init];
                    CGFloat lineHeight = (1.f / [UIScreen mainScreen].scale);
                    lineLayer.frame = CGRectMake(CGRectGetMinX(bounds)+10, bounds.size.height-lineHeight, bounds.size.width-10, lineHeight);
                    lineLayer.backgroundColor = tableView.separatorColor.CGColor;
                    [layer addSublayer:lineLayer];
                }
                UIView *testView = [[UIView alloc] initWithFrame:bounds];
                [testView.layer insertSublayer:layer atIndex:0];
                testView.backgroundColor = UIColor.clearColor;
                cell.backgroundView = testView;
            }
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger gIntRowHeight;
    if (tableView == searchResultsController.tableView) {
        return 44;
    }
    else{
        if (indexPath.section==0) {
            if (isMoreButtonTappedForRecent) {
                if(indexPath.row == garrRecentSearchItems.count){
                    gIntRowHeight = kHeightForRowForMoreButton;
                }
                else
                {
                    gIntRowHeight = kHeightForRowForRecent;
                }
            }
            else
            {
                if ([garrRecentSearchItems count]>=kDefaultItemCount) {
                    if(indexPath.row == kDefaultItemCount){
                        gIntRowHeight = kHeightForRowForMoreButton;
                    }
                    else
                    {
                        gIntRowHeight = kHeightForRowForRecent;
                    }
                }
                else{
                    if(indexPath.row == [garrRecentSearchItems count]){
                        gIntRowHeight = kHeightForRowForMoreButton;
                    }
                    else
                    {
                        gIntRowHeight = kHeightForRowForRecent;
                    }
                }
                
            }
        }
        else if (indexPath.section==1) {
            if (isMoreButtonTappedForEvents) {
                if(indexPath.row == garrEventItems.count){
                    gIntRowHeight = kHeightForRowForMoreButton;
                }
                else
                {
                    gIntRowHeight = kHeightForRowForEvents;
                }
            }
            else{
                if ([garrEventItems count]>=kDefaultItemCount) {
                    if(indexPath.row == kDefaultItemCount){
                        gIntRowHeight = kHeightForRowForMoreButton;
                    }
                    else
                    {
                        gIntRowHeight = kHeightForRowForEvents;
                    }
                }
                else{
                    if(indexPath.row == [garrEventItems count]){
                        gIntRowHeight = kHeightForRowForMoreButton;
                    }
                    else
                    {
                        gIntRowHeight = kHeightForRowForEvents;
                    }
                }
                
            }
        }
        else if(indexPath.section==2) {
            if (isMoreButtonTappedForShared) {
                if(indexPath.row == garrSharedItems.count){
                    gIntRowHeight = kHeightForRowForMoreButton;
                }
                else
                {
                    gIntRowHeight = kHeightForRowForShared;
                }
            }
            else
            {
                if ([garrSharedItems count]>=kDefaultItemCount) {
                    if(indexPath.row == kDefaultItemCount){
                        gIntRowHeight = kHeightForRowForMoreButton;
                    }
                    else
                    {
                        gIntRowHeight = kHeightForRowForShared;
                    }
                }
                else{
                    if(indexPath.row == [garrSharedItems count]){
                        gIntRowHeight = kHeightForRowForMoreButton;
                    }
                    else
                    {
                        gIntRowHeight = kHeightForRowForShared;
                    }
                }
                
            }
        }
        return gIntRowHeight;
        
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    
    if (tableView == searchResultsController.tableView) {
        return 1;
    }
    else{
        return 3;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return kHeightForHeaderInSection;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    if (tableView == searchResultsController.tableView) {
        return nil;
        
    }
    else{
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, kHeightForHeaderInSection)];
        headerView.backgroundColor = kBackgroundColor;
        UILabel *lblHeaderTitle = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width, kHeightForHeaderInSection)];
        
        if (IS_IPAD) {
            lblHeaderTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:30];
        }
        else{
            lblHeaderTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:18];
        }
        
        if (section==0) {
            lblHeaderTitle.text = @"  Recent";
        }
        else if (section==1) {
            lblHeaderTitle.text = @"  Events";
        }
        else if(section==2) {
            lblHeaderTitle.text = @"  Shared";
        }
        [headerView addSubview:lblHeaderTitle];
        
        return headerView;
    }
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    
    if (tableView == searchResultsController.tableView) {
        return [results.mapItems count];
    }
    else{
        NSInteger intRowCount=0;
        if (section==0) {
            if ([garrRecentSearchItems count]!=0) {
                if (isMoreButtonTappedForRecent) {
                    intRowCount = [garrRecentSearchItems count]+1;
                }
                else{
                    intRowCount = ([garrRecentSearchItems count]>=kDefaultItemCount)? kDefaultItemCount+1:[garrRecentSearchItems count]+1;
                }
            }
        }
        else if (section==1) {
            if ([garrEventItems count]!=0) {
                if (isMoreButtonTappedForEvents) {
                    intRowCount = [garrEventItems count]+1;
                }
                else{
                    intRowCount = ([garrEventItems count]>=kDefaultItemCount)? kDefaultItemCount+1:[garrEventItems count]+1;
                }
            }
        }
        else if(section==2) {
            if ([garrSharedItems count]!=0){
                if (isMoreButtonTappedForShared) {
                    intRowCount = [garrSharedItems count]+1;
                }
                else{
                    intRowCount = ([garrSharedItems count]>=kDefaultItemCount)? kDefaultItemCount+1:[garrSharedItems count]+1;
                }
            }
        }
        
        return intRowCount;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if (tableView == searchResultsController.tableView) {
        static NSString *IDENTIFIER = @"SearchResultsCell";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDENTIFIER];
        }
        MKMapItem *item = results.mapItems[indexPath.row];
        cell.textLabel.text = item.placemark.name;
        cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
        return cell;
        
    }
    else{
        
        static NSString *cellIdentifier = @"Cell";
        
        UITableViewCell *cell;
        UILabel *lblEventTitle,*lblEventLocation,*lblEventDate,*lblEventTime,*lblSharedLocation,*lblSharedName;
        CGRect frame = [tableView rectForRowAtIndexPath:indexPath];
        UIImageView *line = [[UIImageView alloc] initWithFrame:CGRectMake(10, frame.size.height - 0.5, self.tableView.frame.size.width - 20, 0.5)];
        line.backgroundColor = [UIColor lightGrayColor];
        line.tag = 7;
        UIView *moreView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, self.tableView.frame.size.width - 20, frame.size.height)];
        moreView.backgroundColor = [UIColor grayColor];
        UIButton *btnMore = [[UIButton alloc]initWithFrame:moreView.frame];
        [btnMore setTitle:@"More" forState:UIControlStateNormal];
        btnMore.backgroundColor = [UIColor clearColor];
        [btnMore addTarget:self action:@selector(loadMore:) forControlEvents:UIControlEventTouchUpInside];
        [moreView addSubview:btnMore];
        
        if (cell == nil) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
            
            bool addMoreFlag;
            if (indexPath.section == 0) {
                btnMore.tag = 10;
                addMoreFlag = NO;
                if (isMoreButtonTappedForRecent) {
                    if(indexPath.row == garrRecentSearchItems.count){
                        addMoreFlag = YES;
                    }
                }else{
                    if ([garrRecentSearchItems count]>=kDefaultItemCount) {
                        if(indexPath.row == kDefaultItemCount){
                            addMoreFlag = YES;
                        }
                    }else{
                        if (indexPath.row == garrRecentSearchItems.count) {
                            addMoreFlag = YES;
                        }
                    }
                    
                }
                if (addMoreFlag) {
                    [cell addSubview:moreView];
                }else{
                    
                    //                cell.textLabel.text = [[garrRecentSearchItems objectAtIndex:indexPath.row]valueForKey:@"enteredtext"]; // titles[indexPath.row];
                    //                cell.textLabel.numberOfLines = 1.0f;
                    MKMapItem *item = [garrRecentSearchItems objectAtIndex:indexPath.row];
                    NSLog(@"%@",item.name);
                    cell.textLabel.text = item.name;
                    
                    //
                    if (IS_IPAD) {
                        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
                    }
                    else{
                        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                    }
                    
                    if(indexPath.row != garrRecentSearchItems.count-1){
                        [cell addSubview:line];
                        MKMapItem *item = [garrRecentSearchItems objectAtIndex:indexPath.row];
                        cell.textLabel.text = item.name;
                    }
                }
                
            }
            else if (indexPath.section == 1) {
                btnMore.tag = 11;
                addMoreFlag = NO;
                if (isMoreButtonTappedForEvents) {
                    if(indexPath.row == garrEventItems.count){
                        addMoreFlag = YES;
                    }
                }else{
                    if ([garrEventItems count]>=kDefaultItemCount) {
                        if(indexPath.row == kDefaultItemCount){
                            addMoreFlag = YES;
                        }
                    }else{
                        if (indexPath.row == garrEventItems.count) {
                            addMoreFlag = YES;
                        }
                    }
                }
                
                if (addMoreFlag) {
                    [cell addSubview:moreView];
                }else{
                    lblEventTitle = [[UILabel alloc]init];
                    lblEventTitle.tag = 1;
                    lblEventLocation = [[UILabel alloc]init];
                    lblEventLocation.tag = 2;
                    lblEventDate = [[UILabel alloc]init];
                    lblEventDate.tag = 3;
                    lblEventTime = [[UILabel alloc]init];
                    lblEventTime.tag = 4;
                    
                    lblEventTitle.text = [[garrEventItems objectAtIndex:indexPath.row]valueForKey:@"eventtitle"];
                    lblEventTitle.textAlignment = NSTextAlignmentLeft;
                    
                    
                    lblEventLocation.text = [[garrEventItems objectAtIndex:indexPath.row]valueForKey:@"eventlocation"];
                    lblEventLocation.textAlignment = NSTextAlignmentLeft;
                    
                    
                    lblEventDate.text = [[garrEventItems objectAtIndex:indexPath.row]valueForKey:@"eventdate"];
                    lblEventDate.textAlignment = NSTextAlignmentRight;
                    
                    lblEventTime.text = [[garrEventItems objectAtIndex:indexPath.row]valueForKey:@"eventtime"];
                    lblEventTime.textAlignment = NSTextAlignmentRight;
                    
                    
                    if (IS_IPAD) {
                        lblEventTitle.frame = CGRectMake(20, 10, 500, 30);
                        lblEventLocation.frame = CGRectMake(20, 50, 500, 30);
                        lblEventDate.frame = CGRectMake(self.tableView.frame.size.width-220, 10, 200, 30);
                        lblEventTime.frame = CGRectMake(self.tableView.frame.size.width-220, 50, 200, 30);
                        
                        lblEventTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
                        lblEventLocation.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
                        lblEventDate.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
                        lblEventTime.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
                        
                    }
                    else{
                        lblEventTitle.frame = CGRectMake(20, 10, 300, 30);
                        lblEventLocation.frame = CGRectMake(20, 50, 300, 30);
                        lblEventDate.frame = CGRectMake(self.tableView.frame.size.width-140, 10, 120, 30);
                        lblEventTime.frame = CGRectMake(self.tableView.frame.size.width-140, 50, 120, 30);
                        
                        lblEventTitle.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                        lblEventLocation.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                        lblEventDate.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                        lblEventTime.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                    }
                    
                    [cell.contentView addSubview:lblEventTitle];
                    [cell.contentView addSubview:lblEventLocation];
                    [cell.contentView addSubview:lblEventDate];
                    [cell.contentView addSubview:lblEventTime];
                    
                    if(indexPath.row != garrEventItems.count-1){
                        [cell addSubview:line];
                    }
                }
            }
            else if (indexPath.section == 2) {
                btnMore.tag = 12;
                
                
                addMoreFlag = NO;
                if (isMoreButtonTappedForShared) {
                    if(indexPath.row == garrSharedItems.count){
                        addMoreFlag = YES;
                    }
                }else{
                    if ([garrSharedItems count]>=kDefaultItemCount) {
                        if(indexPath.row == kDefaultItemCount){
                            addMoreFlag = YES;
                        }
                    }else{
                        if (indexPath.row == garrSharedItems.count) {
                            addMoreFlag = YES;
                        }
                    }
                }
                
                if (addMoreFlag) {
                    [cell addSubview:moreView];
                }else{
                    lblSharedLocation= [[UILabel alloc]init];
                    lblSharedLocation.tag = 5;
                    lblSharedName = [[UILabel alloc]init];
                    lblSharedName.textColor = [UIColor grayColor];
                    lblSharedName.tag = 6;
                    
                    lblSharedLocation.text = [[garrSharedItems objectAtIndex:indexPath.row]valueForKey:@"sharedlocation"];
                    lblSharedLocation.textAlignment = NSTextAlignmentLeft;
                    lblSharedLocation.font = [UIFont boldSystemFontOfSize:16.0f];
                    lblSharedLocation.numberOfLines = 2;
                    
                    lblSharedName.text = [[garrSharedItems objectAtIndex:indexPath.row]valueForKey:@"sharedname"];
                    lblSharedName.font = [UIFont boldSystemFontOfSize:16.0f];
                    lblSharedName.textAlignment = NSTextAlignmentRight;
                    
                    if (IS_IPAD) {
                        lblSharedLocation.frame = CGRectMake(20, 10, 500, 45);
                        lblSharedName.frame = CGRectMake(self.tableView.frame.size.width-220, 10, 200, 30);
                        
                        lblSharedLocation.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
                        lblSharedName.font = [UIFont fontWithName:@"HelveticaNeue" size:20];
                    }
                    else{
                        lblSharedLocation.frame = CGRectMake(20, 10, 200, 45);
                        lblSharedName.frame = CGRectMake(self.tableView.frame.size.width-140, 10, 120, 30);
                        lblSharedLocation.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                        lblSharedName.font = [UIFont fontWithName:@"HelveticaNeue" size:16];
                    }
                    
                    [cell.contentView addSubview:lblSharedLocation];
                    [cell.contentView addSubview:lblSharedName];
                    
                    if(indexPath.row != garrSharedItems.count-1){
                        [cell addSubview:line];
                    }
                    
                }
            }
        }else{
            lblEventTitle = (UILabel *)[cell.contentView viewWithTag:1];
            lblEventLocation = (UILabel *)[cell.contentView viewWithTag:2];
            lblEventDate = (UILabel *)[cell.contentView viewWithTag:3];
            lblEventTime = (UILabel *)[cell.contentView viewWithTag:4];
            lblSharedLocation = (UILabel *)[cell.contentView viewWithTag:5];
            lblSharedName = (UILabel *)[cell.contentView viewWithTag:6];
            line = (UIImageView *)[cell.contentView viewWithTag:7];
        }
        
        
        return cell;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.tableView && indexPath.section == 0)
    {
        [self.delegate didClickToFindTheLocation:[garrRecentSearchItems objectAtIndex:indexPath.row]];
    }
    if (tableView == searchResultsController.tableView) {
        [self.delegate didClickToFindTheLocation:[results.mapItems objectAtIndex:indexPath.row]];
    }
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(NSMutableArray*)getAllItemsForFileName:(NSString*)fileName key:(NSString*)key
{
    // NSMutableArray *arrTemp = [[NSMutableArray alloc]init];
    
    // serialize the request JSON
    NSError *error;
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    NSData *tempData = [NSData dataWithContentsOfFile:filePath];
    // NSDictionary *tempDict = [[NSDictionary alloc]init];
    
    NSDictionary *tempDict = [NSJSONSerialization
                              JSONObjectWithData:tempData
                              
                              options:kNilOptions
                              error:&error];
    
    NSMutableArray *arrTemp = [tempDict objectForKey:key];
    
    return arrTemp;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [self.tableView reloadData];
    searchLocation.frame = CGRectMake(70, 0, self.view.frame.size.width - 90, 40);
    
    UIDeviceOrientation orientation = [[UIDevice currentDevice] orientation];
    switch (orientation) {
        case 1:
        case 2:
            NSLog(@"portrait");
            // your code for portrait...
            break;
            
        case 3:
        case 4:
            NSLog(@"landscape");
            // your code for landscape...
            break;
        default:
            NSLog(@"other");
            // your code for face down or face up...
            break;
    }
}

- (void)loadMore:(id)sender
{
    UIButton *tappedButton = (UIButton*)sender;
    NSLog(@"%ld", (long)tappedButton.tag);
    
    if (tappedButton.tag == 10) {
        isMoreButtonTappedForRecent = YES;
    }
    else if(tappedButton.tag == 11)
    {
        isMoreButtonTappedForEvents = YES;
    }
    else if(tappedButton.tag == 12)
    {
        isMoreButtonTappedForShared = YES;
    }
    
    [self.tableView reloadData];
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */


#pragma mark - Search Related Methods


-(void) setupSearchController {
    
    // The TableViewController used to display the results of a search
    searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.automaticallyAdjustsScrollViewInsets = NO; // Remove table view insets
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    searchResultsController.tableView.tableFooterView = [UIView new];
    // Initialize our UISearchController
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:searchResultsController];
    self.searchController.delegate = self;
    self.searchController.searchBar.delegate = self;
    
}

-(void) setupSearchBar {
    
    // Set search bar dimension and position
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    CGRect viewFrame = self.view.frame;
    self.searchController.searchBar.frame = CGRectMake(searchBarFrame.origin.x,searchBarFrame.origin.y,viewFrame.size.width,64.0);
    
    NSLog(@"width = %f, height = %f",self.searchController.searchBar.frame.size.width,self.searchController.searchBar.frame.size.height);
    // Add SearchController's search bar to our view and bring it to front
    [self.view addSubview:self.searchController.searchBar];
    //    [self.view bringSubviewToFront:self.searchController.searchBar];
    
}

- (void)searchQuery:(NSString *)query {
    // Cancel any previous searches.
    [localSearch cancel];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = query;
    
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    localSearch = [[MKLocalSearch alloc] initWithRequest:request];
    
    [localSearch startWithCompletionHandler:^(MKLocalSearchResponse *response, NSError *error){
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        
        if (error != nil) {
            [[[UIAlertView alloc] initWithTitle:@"Map Error"
                                        message:[error description]
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
            return;
        }
        
        //			if ([response.mapItems count] == 0) {
        //				[[[UIAlertView alloc] initWithTitle:@"No Results"
        //											message:nil
        //										   delegate:nil
        //								  cancelButtonTitle:@"OK"
        //								  otherButtonTitles:nil] show];
        //				return;
        //			}
        
        results = response;
        
        [[(UITableViewController *)self.searchController.searchResultsController tableView] reloadData];
    }];
}

#pragma mark - UISearchDisplayDelegate Methods

-(void)willPresentSearchController:(UISearchController *)aSearchController {
    
    aSearchController.searchBar.bounds = CGRectInset(aSearchController.searchBar.frame, 0.0f, 0.0f);
    
    // Set the position of the result's table view below the status bar and search bar
    // Use of instance variable to do it only once, otherwise it goes down at every search request
    if (CGRectIsEmpty(_searchTableViewRect)) {
        CGRect tableViewFrame = ((UITableViewController *)aSearchController.searchResultsController).tableView
        .frame;
        tableViewFrame.origin.y = tableViewFrame.origin.y + 64; //status bar (20) + nav bar (44)
        tableViewFrame.size.height =  tableViewFrame.size.height;
        
        _searchTableViewRect = tableViewFrame;
        
    }
    
    [((UITableViewController *)aSearchController.searchResultsController).tableView setFrame:_searchTableViewRect];
    
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    CGRect viewFrame = self.view.frame;
    self.searchController.searchBar.frame = CGRectMake(searchBarFrame.origin.x,searchBarFrame.origin.y,viewFrame.size.width,64.0);
    
}

- (void)searchDisplayControllerDidBeginSearch:(UISearchDisplayController *)controller
{
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    CGRect viewFrame = self.view.frame;
    self.searchController.searchBar.frame = CGRectMake(searchBarFrame.origin.x,searchBarFrame.origin.y,viewFrame.size.width,64.0);
}
-(void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller {
    
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    CGRect viewFrame = self.view.frame;
    self.searchController.searchBar.frame = CGRectMake(searchBarFrame.origin.x,searchBarFrame.origin.y,viewFrame.size.width,64.0);
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (![searchText isEqualToString:@""]) {
        [self searchQuery:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    [self searchQuery:aSearchBar.text];
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    CGRect viewFrame = self.view.frame;
    self.searchController.searchBar.frame = CGRectMake(searchBarFrame.origin.x,searchBarFrame.origin.y,viewFrame.size.width,64.0);
    
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    CGRect searchBarFrame = self.searchController.searchBar.frame;
    CGRect viewFrame = self.view.frame;
    self.searchController.searchBar.frame = CGRectMake(searchBarFrame.origin.x,searchBarFrame.origin.y,viewFrame.size.width,64.0);
    
}
@end
