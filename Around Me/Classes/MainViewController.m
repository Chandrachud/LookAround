//
//  MainViewController.m
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//
#define kBackgroundColor_BarTintColor [UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0]

#import "MainViewController.h"
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>
#import "PlacesLoader.h"
#import "Place.h"
#import "PlaceAnnotation.h"
#import "ModelClass.h"
#import "NYSliderPopover.h"
#import "ClientsListView.h"
#import "IconDownloader.h"
#import "ClientsListCell.h"
#import "WFLocationSearchViewController.h"
#import "WFFilterViewController.h"
#import "LocationDetailsiPhone.h"
#import "GlassViewController.h"
#import "LocationDetailsViewController.h"

#import "RangeSlider.h"
#import "NMRangeSlider.h"

NSString * const kNameKey = @"name";
NSString * const kReferenceKey = @"reference";
NSString * const kAddressKey = @"vicinity";
NSString * const kLatitudeKeypath = @"geometry.location.lat";
NSString * const kLongitudeKeypath = @"geometry.location.lng";
NSString * const kIconUrl = @"icon";

#define SYSTEM_VERSION_LESS_THAN(v)([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define kBackgroundColor [UIColor colorWithRed:242.0f/255.0f green:236.0f/255.0f blue:236.0f/255.0f alpha:1.0]

@interface MainViewController ()<CLLocationManagerDelegate, MKMapViewDelegate,UISearchDisplayDelegate,UISearchBarDelegate,UISearchControllerDelegate,UITableViewDataSource,UITableViewDelegate,WFLocationSearchViewControllerDelegate>
{
    MKLocalSearch *localSearch;
    MKLocalSearchResponse *results;
    MKCircle *circle;
    MKCircleView *circleView;
    BOOL isUpdated;
    RangeSlider *rangeSlider;
    IconDownloader *iconDownloader;
    NSUserDefaults *defaults;
}

@property (strong, nonatomic)  MKMapView *mapView;
@property (nonatomic, strong) NSArray *locations;
@property(nonatomic, strong) NSArray *annotationsArray;

@property (nonatomic, strong) ModelClass *modelClass;
@property(nonatomic, strong) NSMutableArray *modelArray;
@property(nonatomic, strong)CLLocation *passnewLocation;
@property(nonatomic, strong)ClientsListView *clientsListView;
@property(nonatomic, strong) UIView *bottomBtnView;
@property(nonatomic, strong) LocationDetailsiPhone *detailsViewContiPhone;
@property(nonatomic, strong) WFFilterViewController *filterView;
@property(nonatomic, strong) WFLocationSearchViewController *locationSearchController;
@property(nonatomic, strong) NSString *jsonString;
@property(nonatomic, strong) MKMapItem *previousMapItem;

@end

@implementation MainViewController


@synthesize locationManager;

-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.showListViewBtn addTarget:self action:@selector(showListViewForClients) forControlEvents:UIControlEventTouchUpInside];
    [self.showMapViewBtn addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
    
    /* Range Slider Code
     [self rangeSlider];
     [self.view bringSubviewToFront:self.labelSlider];
     [self.view bringSubviewToFront:self.lowerLabel];
     [self.view bringSubviewToFront:self.upperLabel];
     
     [self configureLabelSlider];
     */
    
    _mapView.delegate=self;
    
    [self.filterBtn addTarget:self action:@selector(showFilterScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.showLocationSearchBtn addTarget:self action:@selector(showLocationSearchBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    
    isUpdated = NO;
    
    if([self respondsToSelector:@selector(setEdgesForExtendedLayout:)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    _filterView = [self.storyboard instantiateViewControllerWithIdentifier:@"WFFilterViewController"];
    _locationSearchController = [self.storyboard instantiateViewControllerWithIdentifier:@"WFLocationSearchViewController"];
    [self setUpBottomBtnView];
    
    [[UINavigationBar appearance] setTintColor:kBackgroundColor_BarTintColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kBackgroundColor_BarTintColor, NSForegroundColorAttributeName,nil]
                                                                                            forState:UIControlStateNormal];
    
//    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo#1.png"]];
//    titleView.frame = CGRectMake(self.view.frame.size.width/2.0 - 19, 1, 42, 42);
//    [self.navigationController.navigationBar addSubview:titleView];
//    
//        CLLocation *location =  [self getCurrentLocation];
//        self.passnewLocation = location;
//        NSArray *array = [NSArray arrayWithObjects:location, nil];
//    
//        [self locationManager:self.locationManager didUpdateLocations:array];
    
    
     defaults = [NSUserDefaults standardUserDefaults];
    [defaults setValue:@"NO" forKey:@"isLoaded"];
   
}

-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = YES;
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
    if (!self.locationManager && !isUpdated) {
        
        self.mapView = [[MKMapView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:self.mapView];
        self.mapView.delegate = self;
        self.locationManager = [[CLLocationManager alloc] init];
        [locationManager setDelegate:self];
        [locationManager setDesiredAccuracy:kCLLocationAccuracyThreeKilometers];
        if (!SYSTEM_VERSION_LESS_THAN(@"8.0")) {
            [locationManager requestWhenInUseAuthorization];
        }
        [locationManager startMonitoringSignificantLocationChanges];
        [locationManager startUpdatingLocation];
        isUpdated = YES;
        
    }
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged:)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    // [self addSearchBar];
    [self.view bringSubviewToFront:self.bottomBtnView];
    [self.view bringSubviewToFront:self.cameraBtn];
    [self.view bringSubviewToFront:self.filterBtn];
    [self.view bringSubviewToFront:self.slider];
    [self.view bringSubviewToFront:self.showListViewBtn];
    [self.view bringSubviewToFront:self.showMapViewBtn];
    [self.view bringSubviewToFront:self.showLocationSearchBtn];
    [self.view bringSubviewToFront:self.glassViewButton];
    
//    if ([[defaults valueForKey:@"isLoaded"] isEqualToString:@"NO"]) {
//        
//        double latitude = 17.423051;
//        double longitude = 78.379126;
//        MKPlacemark *placemark = [[MKPlacemark alloc] initWithCoordinate:CLLocationCoordinate2DMake(latitude, longitude) addressDictionary:nil];
//        MKMapItem *mapItem = [[MKMapItem alloc] initWithPlacemark:placemark];
//        [self didClickToFindTheLocation:mapItem];
//        [defaults setValue:@"YES" forKey:@"isLoaded"];
//    }
//    

    
    //  [self setupSearchController];
    //  [self setupSearchBar];
}

-(void)viewDidDisappear:(BOOL)animated
{
    self.navigationController.navigationBarHidden = NO;
   // [[UINavigationBar appearance] setHidden:NO];
    
}

-(CLLocation *)getCurrentLocation
{
    double location_latitude_value = [@"17.423051" floatValue];
    double location_longitude_value = [@"78.379126" floatValue];
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(location_latitude_value, location_longitude_value) altitude:CLLocationDistanceMax horizontalAccuracy:5.0 verticalAccuracy:5.0 course:-1.00 speed:-1.00 timestamp:[NSDate date]];
    return currentLocation;
}

-(void)addSearchBar
{
    self.searchBar = [[UISearchBar alloc]init];
    self.searchBar.frame = CGRectMake(20, 20, self.view.frame.size.width - 40, 44);
    [self.searchDisplayController setDelegate:self];
    
    [self.searchBar setDelegate:self];
    [self.mapView setShowsUserLocation:YES];
    [self.mapView setUserInteractionEnabled:YES];
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollow];
    
    [self.view addSubview:self.searchBar];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    locationManager = nil;
    _searchController = nil;
}

#pragma mark Other Helpful Method

- (void)updateSliderPopoverText
{
    self.slider.popover.textLabel.text = [NSString stringWithFormat:@"%.2fMiles", self.slider.value];
}
-(void)removeAnnotaions
{
    NSArray *annotations = [self.mapView annotations];
    [self.mapView removeAnnotations:annotations];
}

-(void)rangeSlider
{
    rangeSlider =  [[RangeSlider alloc] initWithFrame:CGRectMake(10, 100, 400, 84)];
    rangeSlider.minimumValue = 1;
    rangeSlider.selectedMinimumValue = 2;
    rangeSlider.maximumValue = 10;
    rangeSlider.selectedMaximumValue = 8;
    rangeSlider.minimumRange = 2;
    [rangeSlider addTarget:self action:@selector(updateRangeLabel:) forControlEvents:UIControlEventValueChanged];
    // [self.view addSubview:rangeSlider];
    // [self.view bringSubviewToFront:rangeSlider];
}

-(void)updateRangeLabel:(RangeSlider *)slider1
{
    
    NSLog(@"Slider Range: %f - %f", slider1.selectedMinimumValue, slider1.selectedMaximumValue);
}

-(void)showListViewForClients
{
    if (!self.clientsListView) {
        self.clientsListView = [[ClientsListView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 80) style:UITableViewStylePlain];
        self.clientsListView.delegate = self;
        self.clientsListView.dataSource = self;
        self.clientsListView.arrayList = self.locations;
        self.clientsListView.backgroundColor = kBackgroundColor;
        self.clientsListView.separatorStyle = UITableViewCellSelectionStyleNone;
        [self.view bringSubviewToFront:self.bottomBtnView];
        [self.view addSubview:self.clientsListView];
        [self.view bringSubviewToFront:self.cameraBtn];
        [self.view bringSubviewToFront:self.filterBtn];
        [self.view bringSubviewToFront:self.slider];
        [self.view bringSubviewToFront:self.showListViewBtn];
        [self.view bringSubviewToFront:self.showMapViewBtn];
        [self.view bringSubviewToFront:self.glassViewButton];
        
    }
    else
    {
        [self.clientsListView setHidden:NO];
        [self.clientsListView reloadData];
    }
    [self.searchController.searchBar setHidden:YES];
}

-(void)showMapView
{
    [self.clientsListView setHidden:YES];
    [self.searchController.searchBar setHidden:NO];
    
}

-(void)setUpBottomBtnView
{
    self.bottomBtnView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 64, self.view.frame.size.width, 64)];
    self.bottomBtnView.backgroundColor = [UIColor colorWithRed:120.0/256.0 green:120.0/256.0 blue:120.0/256.0 alpha:0.7];
    [self.view addSubview:self.bottomBtnView];
    
    self.filterBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 60, 50,25)];
    self.glassViewButton = [[UIButton alloc]initWithFrame:CGRectMake(10, self.view.frame.size.height - 30, 50,25)];
    
    self.cameraBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 95, self.view.frame.size.height - 30,90, 25)];
    
    self.showListViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 95, self.view.frame.size.height - 57, 44, 25)];
    
    self.showMapViewBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width - 95 + 46, self.view.frame.size.height - 57, 44,25)];
    
    [self.cameraBtn addTarget:self action:@selector(pushView) forControlEvents:UIControlEventTouchUpInside];
    
    
    [self.filterBtn addTarget:self action:@selector(showFilterScreen) forControlEvents:UIControlEventTouchUpInside];
    [self.glassViewButton addTarget:self action:@selector(showGlassView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.showListViewBtn addTarget:self action:@selector(showListViewForClients) forControlEvents:UIControlEventTouchUpInside];
    [self.showMapViewBtn addTarget:self action:@selector(showMapView) forControlEvents:UIControlEventTouchUpInside];
    
    [self.filterBtn setBackgroundImage:[UIImage imageNamed:@"filter_btn@2x.png"] forState:UIControlStateNormal];
    
    [self.showListViewBtn setBackgroundImage:[UIImage imageNamed:@"List_view_inactive@2x.png"] forState:UIControlStateNormal];
    [self.showListViewBtn setBackgroundImage:[UIImage imageNamed:@"List_view_active@2x.png"] forState:UIControlStateHighlighted];
    
    [self.showMapViewBtn setBackgroundImage:[UIImage imageNamed:@"Map_view_inactive@2x.png"] forState:UIControlStateNormal];
    [self.showMapViewBtn setBackgroundImage:[UIImage imageNamed:@"Map_view_active@2x.png"] forState:UIControlStateHighlighted];
    
    [self.cameraBtn setBackgroundImage:[UIImage imageNamed:@"Camera_view_inactive.png"] forState:UIControlStateNormal];
    [self.cameraBtn setBackgroundImage:[UIImage imageNamed:@"Camera_view_active.png"] forState:UIControlStateHighlighted];
    [self.glassViewButton setBackgroundImage:[UIImage imageNamed:@"glass_view_btn.png"] forState:UIControlStateNormal];
    
    [self.view addSubview:self.cameraBtn];
    [self.view addSubview:self.showListViewBtn];
    [self.view addSubview:self.filterBtn];
    [self.view addSubview:self.showMapViewBtn];
    [self.view addSubview:self.glassViewButton];
    
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        
        self.bottomBtnView.frame = CGRectMake(0, self.view.frame.size.height - 90, self.view.frame.size.width, 90);
        self.slider.frame = CGRectMake(self.slider.frame.origin.x, self.slider.frame.origin.y, 360, self.slider.frame.size.height);
        
        self.cameraBtn.frame = CGRectMake(self.view.frame.size.width - 115, self.view.frame.size.height - 45,110, 40);
        self.showMapViewBtn.frame = CGRectMake(self.view.frame.size.width - 60, self.view.frame.size.height - 85,55, 40);
        self.showListViewBtn.frame = CGRectMake(self.view.frame.size.width - 115, self.view.frame.size.height - 85,55, 40);
        self.filterBtn.frame =  CGRectMake(5, self.view.frame.size.height - 85, 80,40);
        self.glassViewButton.frame =  CGRectMake(5, self.view.frame.size.height - 45, 80,40);
        
    }
}

-(void)showGlassView
{
    GlassViewController *glassView = [[GlassViewController alloc]init];
    glassView.jsonData = self.jsonString;
    glassView.currentLocation = self.passnewLocation;
    [self.navigationController pushViewController:glassView animated:YES];
}
#pragma mark -
#pragma mark Orientation Method

- (void)orientationChanged:(NSNotification *)notification
{
    self.mapView.frame = self.view.frame;
}

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)pushView
{
    FlipsideViewController *flipView = [[FlipsideViewController alloc]init];
    [flipView setLocations:_locations];
    [flipView setUserLocation:self.passnewLocation];
    [self.navigationController pushViewController:flipView animated:YES];
}
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"showAlternate"]) {
        [[segue destinationViewController] setDelegate:self];
        
        [[segue destinationViewController] setLocations:_locations];
        [[segue destinationViewController] setUserLocation: self.passnewLocation];
        NSLog(@"User Location in mapview %@",self.passnewLocation);
        
    }
}

-(void)showFilterScreen
{
    [self.navigationController presentViewController:_filterView animated:YES completion:nil];
}

-(void)showLocationSearchBtnClicked
{
    _locationSearchController.delegate = self;
    [self.navigationController presentViewController:_locationSearchController animated:YES completion:nil];
    
}
- (IBAction)sliderValueChanged:(UISlider *)sender {
    //    NSLog(@"slider value = %f", sender.value);
    [self updateSliderPopoverText];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setRoundingMode: NSNumberFormatterRoundHalfUp];
    [formatter setMaximumFractionDigits:0];
    
    int radius = [[NSNumber numberWithDouble:sender.value] intValue] * 1000;
    
    circleView = nil;
    
    [self.mapView removeOverlay:circle];
    circle = [MKCircle circleWithCenterCoordinate:self.passnewLocation.coordinate radius:radius];
    [self.mapView addOverlay:circle];
    [self loadPOIsForLocation:self.passnewLocation withRadius:radius/1.2];
}

#pragma mark - CLLocationManagerDelegate Methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //1
    CLLocation *lastLocation = [locations lastObject];
    //2
    //    CLLocationAccuracy accuracy = [lastLocation horizontalAccuracy];
    self.passnewLocation = lastLocation;
    NSLog(@"Received location Latitude =  %f \nLongitude =  %f", lastLocation.coordinate.latitude,lastLocation.coordinate.longitude);
    [_mapView setCenterCoordinate:lastLocation.coordinate animated:YES];
    _mapView.showsUserLocation = YES;
    
    //3
    //  if(accuracy < 100.0) {
    //4
    MKCoordinateSpan span = MKCoordinateSpanMake(0.12, 0.12);
    MKCoordinateRegion region = MKCoordinateRegionMake([lastLocation coordinate], span);
    
    [_mapView setRegion:region animated:YES];
    // More code here
    [self loadPOIsForLocation:[locations lastObject] withRadius:1000];
    
    //First Remove the old overlay and add new one
    circleView = nil;
    [self.mapView removeOverlay:circle];
    circle = [MKCircle circleWithCenterCoordinate:self.passnewLocation.coordinate radius:2000];
    [self.mapView addOverlay:circle];
    [manager stopUpdatingLocation];
    //  }
}

-(void)loadPOIsForLocation:(CLLocation *)location withRadius:(int)radius
{
    [self removeAnnotaions];
   
    [[PlacesLoader sharedInstance] loadPOIsForLocation:location radius:radius successHandler:^(NSDictionary *response, NSData *data) {
        //1
        self.jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        
        if([[response objectForKey:@"status"] isEqualToString:@"OK"]) {
            //2
            id places = [response objectForKey:@"results"];
            //3
            NSMutableArray *temp = [NSMutableArray array];
            NSMutableArray *temp1 = [NSMutableArray array];

            //4
            if([places isKindOfClass:[NSArray class]]) {
                for(NSDictionary *resultsDict in places) {
                    //5
                    CLLocation *location = [[CLLocation alloc] initWithLatitude:[[resultsDict valueForKeyPath:kLatitudeKeypath] floatValue] longitude:[[resultsDict valueForKeyPath:kLongitudeKeypath] floatValue]];
                    
                    //6
                    Place *currentPlace = [[Place alloc] initWithLocation:location reference:[resultsDict objectForKey:kReferenceKey] name:[resultsDict objectForKey:kNameKey] address:[resultsDict objectForKey:kAddressKey]iconUrl:[resultsDict objectForKey:kIconUrl]];
                    [temp addObject:currentPlace];
                    
                    //7
                    PlaceAnnotation *annotation = [[PlaceAnnotation alloc] initWithPlace:currentPlace];
                    [_mapView addAnnotation:annotation];
                    [temp1 addObject:annotation];

                }
            }
            //8
            // NSArray *arr = [temp subarrayWithRange:NSMakeRange(0, 10)];
            
            _locations = [temp copy];
            _annotationsArray = [temp1 copy];
            
            NSLog(@"Locations: %@", _locations);
        }
    } errorHandler:^(NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    
}
#pragma mark - MapViewDelegate Methods

- (MKOverlayView *)mapView:(MKMapView *)mapView viewForOverlay:(id<MKOverlay>)overlay
{
    if (!circleView) {
        
        circleView = [[MKCircleView alloc] initWithOverlay:overlay];
        [circleView setFillColor:[UIColor colorWithRed:193.0/255.0 green:43.0/255.0 blue:43.0/255.0 alpha:0.1]];
        [circleView setStrokeColor:[UIColor colorWithRed:168.0/255.0 green:28.0/255.0 blue:28.0/255.0 alpha:1]];
        circleView.lineWidth = 2;
    }
    return circleView;
}

-(void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *mypin = [[MKPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"current"];
    mypin.pinColor = MKPinAnnotationColorPurple;
    
    if(annotation == mapView.userLocation){
        mypin.pinColor = MKPinAnnotationColorRed;
    }
    
    mypin.backgroundColor = [UIColor clearColor];
    UIButton *goToDetail = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    mypin.rightCalloutAccessoryView = goToDetail;
    mypin.draggable = NO;
    mypin.highlighted = YES;
    mypin.animatesDrop = TRUE;
    mypin.canShowCallout = YES;
    return mypin;
}

- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view
calloutAccessoryControlTapped:(UIControl *)control
{
    
    NSInteger index = [self.annotationsArray indexOfObject:view.annotation];

    Place *place = [self.locations objectAtIndex:index];

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        LocationDetailsViewController  *detailsViewCont = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationDetailsController"];
        detailsViewCont.tappedPlace = place;
        //        detailsViewCont.locationImageData = imageData;
        detailsViewCont.userLocation = self.passnewLocation;
        [self.navigationController pushViewController:detailsViewCont animated:YES];
        
    }
    else
    {
        _detailsViewContiPhone = [[LocationDetailsiPhone alloc]init];
        _detailsViewContiPhone.userLocation = self.passnewLocation;
        
        
        _detailsViewContiPhone.tappedPlace = place;
        [self.navigationController pushViewController:_detailsViewContiPhone animated:YES];
        
    }
    
}
#pragma mark - SearchViewControllerDelegate Methods

-(void)didDismissViewController:(NSArray *)locationArray
{
    CLLocation *loc = [self getCurrentLocation];
    NSArray *arr = [NSArray arrayWithObjects:loc, nil];
    self.passnewLocation = loc;
    [self locationManager:self.locationManager didUpdateLocations:arr];
}

#pragma mark - Search Related Methods


-(void) setupSearchController {
    
    // The TableViewController used to display the results of a search
    UITableViewController *searchResultsController = [[UITableViewController alloc] initWithStyle:UITableViewStylePlain];
    searchResultsController.automaticallyAdjustsScrollViewInsets = NO; // Remove table view insets
    searchResultsController.tableView.dataSource = self;
    searchResultsController.tableView.delegate = self;
    searchResultsController.tableView.backgroundColor = [UIColor darkGrayColor];
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
    self.searchController.searchBar.frame = CGRectMake(searchBarFrame.origin.x,searchBarFrame.origin.y,viewFrame.size.width,44.0);
    
    NSLog(@"width = %f, height = %f",self.searchController.searchBar.frame.size.width,self.searchController.searchBar.frame.size.height);
    // Add SearchController's search bar to our view and bring it to front
    [self.view addSubview:self.searchController.searchBar];
    [self.view bringSubviewToFront:self.searchController.searchBar];
    
}

- (void)searchQuery:(NSString *)query {
    // Cancel any previous searches.
    [localSearch cancel];
    
    MKLocalSearchRequest *request = [[MKLocalSearchRequest alloc] init];
    request.naturalLanguageQuery = query;
    request.region = self.mapView.region;
    
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
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    if (![searchText isEqualToString:@""]) {
        [self searchQuery:searchText];
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar {
    [self searchQuery:aSearchBar.text];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    NSString *title;
    
    if (tableView == self.clientsListView)
    {
        title = [NSString stringWithFormat:@"Clients Around You (%lu):",(unsigned long)self.locations.count];
    }
    return title;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc]init];
    
    return view;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (tableView == self.clientsListView) {
        return self.locations.count;
    }
    else{
        return [results.mapItems count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *IDENTIFIER = @"SearchResultsCell";
    static NSString *CellIdentifier = @"listCell";
    
    ClientsListCell *contactCell = (ClientsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:IDENTIFIER];
    if (cell == nil) {
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:IDENTIFIER];
        }
        else
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:IDENTIFIER];
        }
    }
    
    if (tableView == self.clientsListView) {
        if (contactCell == nil) {
            
        }
        Place *place = [self.locations objectAtIndex:indexPath.row];
        cell.textLabel.text = place.placeName;
        if (!place.appIcon)
        {
            //            [self calculateDistance:place.location forIndexPath:indexPath];
            cell.detailTextLabel.numberOfLines = 2;
            cell.detailTextLabel.lineBreakMode = NSLineBreakByCharWrapping;
            double distanceFromOrigin = [place.location distanceFromLocation:self.passnewLocation];
            //            NSString *tr =[NSString stringWithFormat:@"%f\nMiles",(distanceFromOrigin/1609.344)];
            
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%fMiles",(distanceFromOrigin/1609.344)];
            
            if (self.clientsListView.dragging == NO && self.clientsListView.decelerating == NO)
            {
                [self startIconDownload:place forIndexPath:indexPath];
            }
            cell.backgroundColor = kBackgroundColor;
            cell.backgroundView = [[UIImageView alloc] initWithImage:[[UIImage imageNamed:@"list_back@2x#1.png"] stretchableImageWithLeftCapWidth:15.0 topCapHeight:25.0]];
            // if a download is deferred or in progress, return a placeholder image
            // cell.imageView.image = [UIImage imageNamed:@"Placeholder.png"];
        }
    }
    else
    {
        MKMapItem *item = results.mapItems[indexPath.row];
        cell.textLabel.text = item.placemark.name;
        cell.detailTextLabel.text = item.placemark.addressDictionary[@"Street"];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (tableView == self.clientsListView) {
        
        Place *place = [self.locations objectAtIndex:indexPath.row];
        
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        {
            LocationDetailsViewController  *detailsViewCont = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationDetailsController"];
            detailsViewCont.tappedPlace = place;
            //        detailsViewCont.locationImageData = imageData;
            detailsViewCont.userLocation = self.passnewLocation;
            [self.navigationController pushViewController:detailsViewCont animated:YES];
            
        }
        else
        {
            _detailsViewContiPhone = [[LocationDetailsiPhone alloc]init];
            _detailsViewContiPhone.userLocation = self.passnewLocation;
            
            _detailsViewContiPhone.tappedPlace = place;
            [self.navigationController pushViewController:_detailsViewContiPhone animated:YES];
            
        }
        
    }
    else
    {
        [self removeAnnotaions];
        // Hide search controller
        [self.searchController setActive:NO];
        MKMapItem *item = results.mapItems[indexPath.row];
        NSLog(@"Selected \"%@\"", item.placemark.name);
        
        [self.mapView addAnnotation:item.placemark];
        [self.mapView selectAnnotation:item.placemark animated:YES];
        [self.mapView setCenterCoordinate:item.placemark.location.coordinate animated:YES];
        
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
        [self.mapView showsUserLocation];
        
        CLLocation *location =  item.placemark.location;
        
        NSArray *array = [NSArray arrayWithObjects:location, nil];
        NSLog(@"Selected \"%@\"",location);
        
        [self locationManager:self.locationManager didUpdateLocations:array];
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.clientsListView) {
        return 100;
    }
    return 44;
}
#pragma mark - UIScrollViewDelegate

// -------------------------------------------------------------------------------
//	scrollViewDidEndDragging:willDecelerate:
//  Load images for all onscreen rows when scrolling is finished.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
    {
        [self loadImagesForOnscreenRows];
    }
}

// -------------------------------------------------------------------------------
//	scrollViewDidEndDecelerating:scrollView
//  When scrolling stops, proceed to load the app icons that are on screen.
// -------------------------------------------------------------------------------
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}


- (void)loadImagesForOnscreenRows
{
    if (self.locations.count > 0)
    {
        NSArray *visiblePaths = [self.clientsListView indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            Place *appRecord = (self.locations)[indexPath.row];
            
            if (!appRecord.appIcon)
                // Avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord forIndexPath:indexPath];
            }
        }
    }
}
#pragma mark -   IconDownLoader Method

// -------------------------------------------------------------------------------
//	startIconDownload:forIndexPath:
// -------------------------------------------------------------------------------
- (void)startIconDownload:(Place *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    if (iconDownloader == nil)
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.appRecord = appRecord;
        __block ClientsListView *clientsView = self.clientsListView;
        [iconDownloader setCompletionHandler:^{
            
            UITableViewCell *cell = [clientsView cellForRowAtIndexPath:indexPath];
            cell.textLabel.numberOfLines = 2;
            cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
            // Display the newly loaded image
            cell.imageView.image = appRecord.appIcon;
            [clientsView reloadData];
            // Remove the IconDownloader from the in progress list.
            // This will result in it being deallocated.
            //            [self.imageDownloadsInProgress removeObjectForKey:indexPath];
            
        }];
        //        (self.imageDownloadsInProgress)[indexPath] = iconDownloader;
        [iconDownloader startDownload];
    }
    iconDownloader = nil;
}

- (void)calculateDistance:(CLLocation*)location forIndexPath:(NSIndexPath *)indexPath
{
    double distanceFromOrigin = [location distanceFromLocation:locationManager.location];
    
    UITableViewCell *cell = [self.clientsListView cellForRowAtIndexPath:indexPath];
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%f",distanceFromOrigin];
}

//RangeSliderCode
//////////////////////////////////////////
#pragma mark -
#pragma mark - Label  Slider

- (void) configureLabelSlider
{
    self.labelSlider.minimumValue = 0;
    self.labelSlider.maximumValue = 100;
    self.labelSlider.lowerValue = 0;
    self.labelSlider.upperValue = 100;
    self.labelSlider.minimumRange = 10;
}

- (void) updateSliderLabels
{
    // You get get the center point of the slider handles and use this to arrange other subviews
    
    CGPoint lowerCenter;
    lowerCenter.x = (self.labelSlider.lowerCenter.x + self.labelSlider.frame.origin.x);
    lowerCenter.y = (self.labelSlider.center.y - 30.0f);
    self.lowerLabel.center = lowerCenter;
    self.lowerLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.lowerValue];
    
    CGPoint upperCenter;
    upperCenter.x = (self.labelSlider.upperCenter.x + self.labelSlider.frame.origin.x);
    upperCenter.y = (self.labelSlider.center.y - 30.0f);
    self.upperLabel.center = upperCenter;
    self.upperLabel.text = [NSString stringWithFormat:@"%d", (int)self.labelSlider.upperValue];
}

// Handle control value changed events just like a normal slider

- (IBAction)labelSliderChanged:(NMRangeSlider*)sender
{
    [self updateSliderLabels];
}

#pragma mark - WFLocationSearchViewControllerDelegate Methods

-(void)didClickToFindTheLocation:(MKMapItem *)item
{
    //    [self.navigationController dismissViewControllerAnimated:_locationSearchController completion:nil];
    [_locationSearchController dismissViewControllerAnimated:YES completion:nil];
    
    if (!(item == _previousMapItem))
    {
        NSLog(@"%@",self.passnewLocation);
        [self removeAnnotaions];
        // Hide search controller
        [self.searchController setActive:NO];
        
        NSLog(@"Selected \"%@\"", item.placemark.name);
        
        [self.mapView addAnnotation:item.placemark];
        [self.mapView selectAnnotation:item.placemark animated:YES];
        [self.mapView setCenterCoordinate:item.placemark.location.coordinate animated:YES];
        
        [self.mapView setUserTrackingMode:MKUserTrackingModeNone];
        [self.mapView showsUserLocation];
        
        CLLocation *location =  item.placemark.location;
        self.passnewLocation = location;
        NSArray *array = [NSArray arrayWithObjects:location, nil];
        NSLog(@"Selected \"%@\"",location);
        _previousMapItem = item;
        [self locationManager:self.locationManager didUpdateLocations:array];
    }
}

@end
