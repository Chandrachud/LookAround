//
//  LocationDetailsViewContiPhone.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 1/1/15.
//  Copyright (c) 2015 Jean-Pierre Distler. All rights reserved.
//

#import "LocationDetailsiPhone.h"
#import <MapKit/MapKit.h>
#import "PlaceAnnotation.h"
#import "Place.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UserDetailsViewController.h"
#import "ModelClass.h"
#import "ContactsTableViewController.h"

#define kBackgroundColor_header [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0]
#define kBackgroundColor_header_text [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0]

@interface LocationDetailsiPhone ()<UITextFieldDelegate,MKMapViewDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,MFMailComposeViewControllerDelegate>
{
    UIView *headerView;
    UIViewController *navigationCont;
    UINavigationController *customNavigationController;
    UIImageView *imageView;
    ContactsTableViewController *contactsTableViewiPhone;
}
@property(nonatomic, strong)  MKMapView *mapView;
@property(nonatomic, strong)  UIView *bottomBtnView;

@property(nonatomic, strong)  UIView *detailsView;
@property (nonatomic, strong) MKPolyline *routeLine; //your line
@property (nonatomic, strong) MKPolylineView *routeLineView; //overlay view
@property(nonatomic, strong) MFMailComposeViewController *mailController;
@property(nonatomic, strong) MFMessageComposeViewController *messageController;
@property(nonatomic, strong) UserDetailsViewController *detailsController;
@property(nonatomic, strong) NSArray *imagesArray;
@property(nonatomic, strong) NSArray *entryListArray;


@property(nonatomic, strong) NSDictionary *contactsDict;
@property (nonatomic, strong) ModelClass *modelClass;
@property(nonatomic, strong) NSMutableArray *modelArray;

@property(nonatomic, strong)UIScrollView *scrollView;
@end

@implementation LocationDetailsiPhone

-(void)viewDidLoad
{
    [super viewDidLoad];
    [self addNavigationController];
    //Add a view to contain everything seperately
    //Ading custom view
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    UIColor *labelTopColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    UIColor *labelBottomClor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = myView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[labelBottomClor CGColor], (id)[labelTopColor CGColor], nil];
    [myView.layer insertSublayer:gradient atIndex:0];
    //[self.view addSubview:myView];
    
    //Adding Done Button
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, 50, 30)];
    // doneButton.titleLabel.text = @"Done";
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.titleLabel.textColor = [UIColor blackColor];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [myView addSubview:doneButton];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo#1.png"]];
    titleView.frame = CGRectMake(280, 20, 37, 37);
    [myView addSubview:titleView];
    
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 2)];
    dividerView.backgroundColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:0.5f];
    [myView addSubview:dividerView];
    
    // [self addScrollView];
    [self setUpMap];
    [self addClientInfoImage];
    [self setUpBottomBtnView];
    self.entryListArray = [NSArray arrayWithObjects:@"Contacts",@"Relationship Hierarchy",@"Revenue Chart",@"Revenue Data", nil];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}
-(void)dealloc
{
    _tappedPlace = nil;
    _locationImageData = nil;
    _userLocation = nil;
    _contactsTableView = nil;
    
    _mapView = nil;
    _bottomBtnView = nil;
    _detailsView = nil;
    _routeLine = nil;
    _routeLineView = nil;
    _mailController = nil;
    _messageController = nil;
    _detailsController = nil;
    _imagesArray = nil;
    _entryListArray = nil;
    _contactsDict = nil;
    _modelClass = nil;
    _modelArray = nil;
    _scrollView = nil;
}
#pragma mark - Other Helpful methods

-(void)done:(id)sender
{
    //   [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)setUpMap
{
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 150)];
    [headerView addSubview:self.mapView];
    self.mapView.delegate = self;
    Place *currentPlace = [[Place alloc] initWithLocation:self.tappedPlace.location reference:self.tappedPlace.reference name:self.tappedPlace.placeName address:self.tappedPlace.address iconUrl:self.tappedPlace.imageUrl];
    PlaceAnnotation *annotation = [[PlaceAnnotation alloc] initWithPlace:currentPlace];
    [_mapView addAnnotation:annotation];
    MKCoordinateSpan span = MKCoordinateSpanMake(0.02, 0.02);
    MKCoordinateRegion region = MKCoordinateRegionMake([self.tappedPlace.location coordinate], span);
    [_mapView setRegion:region animated:YES];
    _mapView.showsUserLocation = YES;
    [self drawTestLine];
    NSLog(@"%f",self.view.frame.size.width);
    
}

-(void)setUpBottomBtnView
{
    self.bottomBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 54, self.view.frame.size.width, 54)];
    self.view.backgroundColor = [UIColor darkGrayColor];
    [self.view addSubview:self.bottomBtnView];
    
    UIButton *emailBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width/3.0,54)];
    UIButton *facetimeBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/3, 0, self.view.frame.size.width/3.0,54)];
    UIButton *shareBtn = [[UIButton alloc]initWithFrame:CGRectMake(emailBtn.frame.size.width * 2, 0, self.view.frame.size.width/3.0,54)];
    
    [self.bottomBtnView addSubview:emailBtn];
    [self.bottomBtnView addSubview:shareBtn];
    [self.bottomBtnView addSubview:facetimeBtn];
    
    
    [emailBtn addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    [facetimeBtn addTarget:self action:@selector(launchFaceTime) forControlEvents:UIControlEventTouchUpInside];
    [emailBtn setBackgroundImage:[UIImage imageNamed:@"send_email_iphone@2x.png"] forState:UIControlStateNormal];
    [emailBtn setBackgroundImage:[UIImage imageNamed:@"send_email_click_iPhone@2x.png"] forState:UIControlStateHighlighted];
    [facetimeBtn setBackgroundImage:[UIImage imageNamed:@"facetime_call@2x.png"] forState:UIControlStateNormal];
    [facetimeBtn setBackgroundImage:[UIImage imageNamed:@"facetime_call_click@2x.png"] forState:UIControlStateHighlighted];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share@2x.png"] forState:UIControlStateNormal];
    [shareBtn setBackgroundImage:[UIImage imageNamed:@"share_click@2x.png"] forState:UIControlStateHighlighted];
    
}
- (void)drawTestLine
{
    CLLocation *location0 = self.tappedPlace.location;
    
    CLLocation *location1 = _userLocation;
    
    NSArray *array = [NSArray arrayWithObjects:location0, location1, nil];
    
    CLLocationCoordinate2D coordinates[array.count];
    for (NSInteger index = 0; index < array.count; index++) {
        CLLocation *location = [array objectAtIndex:index];
        CLLocationCoordinate2D coordinate = location.coordinate;
        
        coordinates[index] = coordinate;
    }
    self.routeLine = [MKPolyline polylineWithCoordinates:coordinates count:array.count];
    [self.mapView addOverlay:self.routeLine];
}

-(void)addClientInfoImage
{
    //Add Image
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 150 , self.view.frame.size.width, 100)];
    
    imageView.image = [UIImage imageNamed:@"details@2x.png"];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 250 , self.view.frame.size.width, 150)];
    
    imageView1.image = [UIImage imageNamed:@"buisness_d@2x.png"];
    //Add all Subviews
    // [detailsView addSubview:composeMailBtn];
    [headerView addSubview:imageView];
    [headerView addSubview:imageView1];
}

-(void)addScrollView
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height)];
    _scrollView.scrollEnabled = YES;
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = YES;
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(self.view.bounds.size.width, self.view.bounds.size.height + 200.0);
    
    [self.view addSubview:self.scrollView];
}
-(void)addNavigationController
{
    self.contactsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 54.0) style:UITableViewStyleGrouped];
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    [self.contactsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    headerView = [[UIView alloc]init];
    //    headerView.frame = CGRectMake(0, 0, self.contactsTableView.frame.size.width, 100);
    // self.contactsTableView.tableHeaderView = headerView;
    [self.view addSubview:self.contactsTableView];
    //    self.contactsTableView.backgroundColor = [UIColor darkGrayColor];
    //  self.contactsTableView.tableHeaderView = headerView;
    //    self.contactsTableView.contentInset = UIEdgeInsetsMake(-headerView.frame.size.height, 0, 0, 0);
}


#pragma mark - Click To Action Methods

-(void)sendEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        
        _mailController = [[MFMailComposeViewController alloc] init];
        _mailController.mailComposeDelegate = self;
        [_mailController setSubject:@"Book An Appointment"];
        [_mailController setMessageBody:@"Your message goes here." isHTML:NO];
        [_mailController setToRecipients:[NSArray arrayWithObjects:@"mohankumar.atapaka@wellsfargo.com",@"chandrachud.patil@wellsfargo.com", nil]];
        [self presentViewController:_mailController animated:YES completion:nil];
    }
    else {
        
        NSLog(@"Device is unable to send email in its current state.");
    }
}

-(void)launchFaceTime
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"facetime://anantha.sharma@icloud.com"]];
    
}

#pragma mark - MKMapView Delegate Methods


- (MKOverlayView *)mapView:(MKMapView *)mapView rendererForOverlay:(id)overlay
{
    self.routeLineView = [[MKPolylineView alloc] initWithPolyline:self.routeLine];
    self.routeLineView.fillColor = [UIColor redColor];
    self.routeLineView.strokeColor = [UIColor redColor];
    self.routeLineView.lineWidth = 3;
    return self.routeLineView;
}

#pragma mark - UITableViewDataSourceDelegate Methods


-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.entryListArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setAccessoryType:UITableViewCellAccessoryDisclosureIndicator];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",[self.entryListArray objectAtIndex:indexPath.row]];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 44;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    contactsTableViewiPhone = [[ContactsTableViewController alloc]init];
    contactsTableViewiPhone.rowNumber = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    [self.navigationController pushViewController:contactsTableViewiPhone animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 444;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    // 1. Dequeue the custom header cell
    UILabel* headerLabel = [[UILabel alloc] init];
    headerLabel.frame = CGRectMake(0, 400, tableView.frame.size.width, 44);
    headerLabel.backgroundColor = kBackgroundColor_header;
    headerLabel.textColor = kBackgroundColor_header_text;
    headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
    headerLabel.text = @" More Information";
    headerLabel.textAlignment = NSTextAlignmentLeft;
    
    // 4. Add the label to the header view
    
    [headerView addSubview:headerLabel];
    return headerView;
}

#pragma mark - MFMailComposeViewController Delegate Methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    {
        switch (result) {
            case MFMailComposeResultSent:
                NSLog(@"You sent the email.");
                break;
            case MFMailComposeResultSaved:
                NSLog(@"You saved a draft of this email");
                break;
            case MFMailComposeResultCancelled:
                NSLog(@"You cancelled sending this email.");
                break;
            case MFMailComposeResultFailed:
                NSLog(@"Mail failed:  An error occurred when trying to compose this email");
                break;
            default:
                NSLog(@"An error occurred when trying to compose this email");
                break;
        }
        [self.mailController dismissViewControllerAnimated:YES completion:nil];
        
    }
    
}
@end
