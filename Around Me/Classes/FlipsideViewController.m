//
//  FlipsideViewController.m
//  Around Me
//
//  Created by Jean-Pierre Distler on 30.01.13.
//  Copyright (c) 2013 Jean-Pierre Distler. All rights reserved.
//

#import "FlipsideViewController.h"
#import "Place.h"
#import "MarkerView.h"
#import "PlacesLoader.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "LocationDetailsViewController.h"
#import "LocationDetailsiPhone.h"

#define kBackgroundColor_BarTintColor [UIColor colorWithRed:204.0f/255.0f green:50.0f/255.0f blue:50.0f/255.0f alpha:1.0]

NSString * const kPhoneKey = @"formatted_phone_number";
NSString * const kWebsiteKey = @"website";

const int kInfoViewTag = 1001;

@interface FlipsideViewController () <MarkerViewDelegate>
{
    UIButton *emailBtn;
}

@property (nonatomic, strong) AugmentedRealityController *arController;
@property (nonatomic, strong) NSMutableArray *geoLocations;

@end

@implementation FlipsideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    if(!_arController) {
        _arController = [[AugmentedRealityController alloc] initWithView:[self view] parentViewController:self withDelgate:self];
    }
    
    [_arController setMinimumScaleFactor:0.55];
    [_arController setScaleViewsBasedOnDistance:YES];
    [_arController setRotateViewsBasedOnPerspective:YES];
    [_arController setDebugMode:NO];
    [_arController setMaximumScaleDistance:10];
    
    [[UINavigationBar appearance] setBarTintColor:kBackgroundColor_BarTintColor];
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:kBackgroundColor_BarTintColor, NSForegroundColorAttributeName,nil]
                                                                                            forState:UIControlStateNormal];
    
    
    UIColor *labelTopColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    UIColor *labelBottomClor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = self.navigationController.navigationBar.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[labelTopColor CGColor], (id)[labelBottomClor CGColor], nil];
    
    
    // [self.navigationController.navigationBar.layer insertSublayer:gradient atIndex:0];
    
    
    //    [_arController.previewLayer setTransform:CATransform3DMakeScale(2.0, 2.0, 2.0)];
    //    UIPinchGestureRecognizer *pinchRecogniser = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(zoomIn:)];
    //    [self.view addGestureRecognizer:pinchRecogniser];
}

//-(void)zoomIn:(id)sender
//{
//    [_arController.previewLayer setTransform:CATransform3DMakeScale(5.0, 5.0, 2.0)];
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    [self geoLocations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _arController = nil;
    _geoLocations = nil;
    _locations = nil;
    _userLocation = nil;
    emailBtn = nil;
}

-(void)dealloc
{
    _arController = nil;
    _geoLocations = nil;
    _locations = nil;
    _userLocation = nil;
}

#pragma mark - Actions

- (IBAction)done:(id)sender
{
    //    [self.delegate flipsideViewControllerDidFinish:self];
    //    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - ARDelegate Methods

-(void)didUpdateHeading:(CLHeading *)newHeading {
    
}

-(void)didUpdateLocation:(CLLocation *)newLocation {
    
}

-(void)didUpdateOrientation:(UIDeviceOrientation)orientation {
    
}

-(void)locationClicked:(ARGeoCoordinate *)coordinate
{
    
}

#pragma mark - ARLocationDelegateARMarkerDelegate Methods

- (void)didTapMarker:(ARGeoCoordinate *)coordinate {
    
}


- (NSMutableArray *)geoLocations {
    if(!_geoLocations) {
        [self generateGeoLocations];
    }
    return _geoLocations;
}


#pragma mark - Other Methods

- (void)generateGeoLocations {
    //1
    [self setGeoLocations:[NSMutableArray arrayWithCapacity:[_locations count]]];
    NSLog(@"Number of locaions = %ld",(unsigned long)[_locations count]);
    //2
    
    for(Place *place in _locations) {
        //3
        ARGeoCoordinate *coordinate = [ARGeoCoordinate coordinateWithLocation:[place location] locationTitle:[place placeName]];
        //4
        //            [coordinate calibrateUsingOrigin:[_userLocation location]];
        [coordinate calibrateUsingOrigin:self.userLocation];
        
        NSLog(@"Number of locaions = %ld",(unsigned long)[_locations count]);
        
        //more code later
        MarkerView *markerView = [[MarkerView alloc] initWithCoordinate:coordinate delegate:self iconUrl:[place imageUrl]];
        [coordinate setDisplayView:markerView];
        
        //5
        [_arController addCoordinate:coordinate];
        [_geoLocations addObject:coordinate];
    }
}

- (void)didTouchMarkerView:(MarkerView *)markerView {
    //1
    ARGeoCoordinate *tappedCoordinate = [markerView coordinate];
    CLLocation *myLocation = [tappedCoordinate geoLocation];
    
    //2
    int index = [_locations indexOfObjectPassingTest:^(Place *obj, NSUInteger index, BOOL *stop) {
        return [[obj location] isEqual:myLocation];
    }];
    //    //3
    Place *tappedPlace = [_locations objectAtIndex:index];
    
    //    if(index != NSNotFound) {
    //        [[PlacesLoader sharedInstance] loadDetailInformation:tappedPlace successHanlder:^(NSDictionary *response) {
    //            //5
    //            NSLog(@"Response: %@", response);
    //            NSDictionary *resultDict = [response objectForKey:@"result"];
    //            [tappedPlace setPhoneNumber:[resultDict objectForKey:kPhoneKey]];
    //            [tappedPlace setWebsite:[resultDict objectForKey:kWebsiteKey]];
    //            [self showInfoViewForPlace:tappedPlace];
    //        } errorHandler:^(NSError *error) {
    //            NSLog(@"Error: %@", error);
    //        }];
    //    }
    [self showDetailViewControllerwithLocation:tappedPlace withImageData:markerView.dataImage];
    
}

- (void)showInfoViewForPlace:(Place *)place {
    CGRect frame = [[self view] frame];
    UITextView *infoView = [[UITextView alloc] initWithFrame:CGRectMake(50.0f, 50.0f, frame.size.width - 300.0f, frame.size.height - 300.0f)];
    [infoView setCenter:[[self view] center]];
    [infoView setAutoresizingMask:UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth];
    
    //1
    [infoView setText:[place infoText]];
    [infoView setTag:kInfoViewTag];
    [infoView setEditable:NO];
    //  [self.view addSubview:infoView];
    //  [self createButtons];
    //  [self animateButtons];
}

-(void)showDetailViewControllerwithLocation:(Place *)tappedPlace withImageData:(NSData *)imageData
{
    LocationDetailsViewController *detailsViewCont;
    LocationDetailsiPhone *detailsViewContiPhone;
    UIViewController *viewCont;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        detailsViewCont = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationDetailsController"];
        detailsViewCont.tappedPlace = tappedPlace;
        detailsViewCont.locationImageData = imageData;
        detailsViewCont.userLocation = self.userLocation;
        viewCont = detailsViewCont;
        
    } else {
        //        detailsViewContiPhone = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"LocationDetailsViewContiPhone"];
        detailsViewContiPhone = [[LocationDetailsiPhone alloc]init];
        detailsViewContiPhone.tappedPlace = tappedPlace;
        detailsViewContiPhone.locationImageData = imageData;
        detailsViewContiPhone.userLocation = self.userLocation;
        viewCont = detailsViewContiPhone;
    }
    
    [self.navigationController pushViewController:viewCont animated:YES];
}
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event {
    
    UIView *infoView = [[self view] viewWithTag:kInfoViewTag];
    [infoView removeFromSuperview];
    //  [self removeButtons];
}

#pragma mark - Button Creation and Animation Methods

-(void)removeButtons
{
    [emailBtn removeFromSuperview];
}
-(void)createButtons
{
    emailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    emailBtn.frame = CGRectMake(-100, 0, 200, 30);
    emailBtn.layer.cornerRadius = 10;
    emailBtn.clipsToBounds = YES;
    
    emailBtn.backgroundColor = [UIColor grayColor];
    [self.view addSubview:emailBtn];
}

-(void)animateButtons
{
    
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         
                         emailBtn.frame = CGRectMake(50, 50, 100, 50);
                         
                     }
                     completion:^(BOOL finished){
                         
                     }];
}
//Dummy Location

-(CLLocation *)getCurrentLocation
{
    double location_latitude_value = [@"17.423297" floatValue];
    double location_longitude_value = [@"78.378798" floatValue];
    
    CLLocation *currentLocation = [[CLLocation alloc] initWithCoordinate:CLLocationCoordinate2DMake(location_latitude_value, location_longitude_value) altitude:CLLocationDistanceMax horizontalAccuracy:5.0 verticalAccuracy:5.0 course:-1.00 speed:-1.00 timestamp:[NSDate date]];
    return currentLocation;
}

@end
