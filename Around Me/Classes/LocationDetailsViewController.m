//
//  LocationDetailsViewController.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/3/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "LocationDetailsViewController.h"
#import <MapKit/MapKit.h>
#import "PlaceAnnotation.h"
#import "Place.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>
#import "UserDetailsViewController.h"
#import "ModelClass.h"

#define IDIOM    UI_USER_INTERFACE_IDIOM()
#define IPAD     UIUserInterfaceIdiomPad

@interface LocationDetailsViewController ()<UITextFieldDelegate,UIGestureRecognizerDelegate,MKMapViewDelegate,MFMailComposeViewControllerDelegate,MFMessageComposeViewControllerDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UIView *buttonsView;
    UIButton *buttonOne;
    UIButton *buttonTwo;
    UIButton *buttonThree;
    UIButton *buttonFour;
    UIButton *buttonFive;
    UIView *buttonDetailsView;
    UIView *bottomView;
    UIImageView *myImageView;
    UIViewController *navigationCont;
    UINavigationController *customNavigationController;
}

@property(nonatomic, strong)  MKMapView *mapView;
@property(nonatomic, strong)  UIView *detailsView;
@property (nonatomic, strong) MKPolyline *routeLine; //your line
@property (nonatomic, strong) MKPolylineView *routeLineView; //overlay view
@property(nonatomic, strong) MFMailComposeViewController *mailController;
@property(nonatomic, strong) MFMessageComposeViewController *messageController;
@property(nonatomic, strong) UserDetailsViewController *detailsController;
@property(nonatomic, strong) UITableView *contactsTableView;
@property(nonatomic, strong) NSArray *imagesArray;

@property(nonatomic, strong) NSDictionary *contactsDict;
@property (nonatomic, strong) ModelClass *modelClass;
@property(nonatomic, strong) NSMutableArray *modelArray;

@end

@implementation LocationDetailsViewController

@synthesize detailsView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self setUpMap];
    
    UIView *myView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
    UIColor *labelTopColor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    UIColor *labelBottomClor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = myView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[labelBottomClor CGColor], (id)[labelTopColor CGColor], nil];
    [myView.layer insertSublayer:gradient atIndex:0];
    // [self.view addSubview:myView];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
    UIButton *doneButton = [[UIButton alloc]initWithFrame:CGRectMake(20, 25, 50, 30)];
    // doneButton.titleLabel.text = @"Done";
    doneButton.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    [doneButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [doneButton addTarget:self action:@selector(done:) forControlEvents:UIControlEventTouchUpInside];
    doneButton.titleLabel.textColor = [UIColor blackColor];
    [doneButton setTitle:@"Done" forState:UIControlStateNormal];
    [myView addSubview:doneButton];
    self.modelClass = [[ModelClass alloc]init];
    
    [self setupView];
    self.imagesArray = [NSArray arrayWithObjects:@"Contact_1.png",@"Contact_2.png",@"Contact_3.png", nil];
    
    UIImageView *titleView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo#1.png"]];
    titleView.frame = CGRectMake(700, 20, 37, 37);
    [myView addSubview:titleView];
    
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 62, self.view.frame.size.width, 2)];
    dividerView.backgroundColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:0.5f];
    [myView addSubview:dividerView];
    [self setUpButtonsView];
    [self setupDetailsViewWithButtonOne];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
}

-(void)dealloc
{
    _mapView = nil;
    detailsView = nil;
    _tappedPlace = nil;
    _locationImageData = nil;
    _userLocation = nil;
    _routeLine = nil;
    _routeLineView = nil;
    _mailController = nil;
    buttonDetailsView = nil;
    buttonFive = nil;
    buttonFour = nil;
    buttonThree = nil;
    buttonTwo = nil;
    buttonOne = nil;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    _mapView = nil;
    detailsView = nil;
    _tappedPlace = nil;
    _locationImageData = nil;
    _userLocation = nil;
    _routeLine = nil;
    _routeLineView = nil;
    _mailController = nil;
    buttonDetailsView = nil;
    buttonFive = nil;
    buttonFour = nil;
    buttonThree = nil;
    buttonTwo = nil;
    buttonOne = nil;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */
#pragma mark - Other Utility Methods

-(void)setUpMap
{
    self.mapView = [[MKMapView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width/2.0, self.view.frame.size.height/2.0 - 104)];
    [self.view addSubview:self.mapView];
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

-(void)setupView
{
    detailsView = [[UIView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2.0, 64, self.view.frame.size.width/2.0, self.view.frame.size.height/2.0 - 104)];
    //  _detailsView.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:detailsView];
    
    
    //Add Image
    UIImageView *iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, 100, 50)];
    iconImageView.image = [UIImage imageNamed:@"client_info_top_right_v2.png"];
    iconImageView.frame = detailsView.bounds;

    //nameLabel
    UILabel *nameLbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 80, self.detailsView.frame.size.width, 50)];
    [nameLbl setNumberOfLines:2.0];
    nameLbl.text =[NSString stringWithFormat:@"AIG RETIREMENT"];
    nameLbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:30.0];
    nameLbl.textColor = [UIColor grayColor];
    
    //addressLabel
    UILabel *addressLbl = [[UILabel alloc]initWithFrame:CGRectMake(162, 60, self.detailsView.frame.size.width/1.2, 150)];
    addressLbl.textAlignment = NSTextAlignmentLeft;
    [addressLbl setNumberOfLines:5.0];
    addressLbl.text = [NSString stringWithFormat:@"Address:\n180 Maiden Lane\nCity: New York\nState: New York\nCountry:United States"];
    
    //linkButton
    UIButton *linkButton = [[UIButton alloc]initWithFrame:CGRectMake(162, 300, self.detailsView.frame.size.width/2.0, 50)];
    linkButton.titleLabel.text = [NSString stringWithFormat:@"Visit:%@",self.tappedPlace.website];
    [linkButton addTarget:self action:@selector(openURL) forControlEvents:UIControlEventTouchUpInside];
    linkButton.backgroundColor = [UIColor clearColor];
    linkButton.titleLabel.textColor = [UIColor blackColor];
    linkButton.layer.cornerRadius = 10;
    linkButton.clipsToBounds = YES;
    
    UITextField *linkField = [[UITextField alloc]initWithFrame:CGRectMake(120, 180, self.detailsView.frame.size.width/1.5, 50)];
    
    //  if ([self.tappedPlace.website hasPrefix:@"http"] || [self.tappedPlace.website hasPrefix:@"https"])
    {
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"Web:www.aig.com"]];
        [str addAttribute: NSLinkAttributeName value:@"www.aig.com" range: NSMakeRange(0, str.length)];
        linkField.attributedText = str;
        linkField.delegate = self;
        //  }
        //Gesture Recogniser
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
        gesture.delegate = self;
        [linkField addGestureRecognizer:gesture];
        
        //Mail Button
        UIButton *composeMailBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        composeMailBtn.frame = CGRectMake(162, 180, 150, 50);
        composeMailBtn.backgroundColor = [UIColor clearColor];
        composeMailBtn.titleLabel.text = @"Send Email";
        composeMailBtn.titleLabel.textColor = [UIColor blackColor];
        UIImage *image = [UIImage imageNamed:@"images.png"];
        [composeMailBtn setBackgroundImage:image forState:UIControlStateNormal];
        // composeMailBtn.layer.cornerRadius = 10;
        [composeMailBtn addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
        
        //Add all Subviews
        [detailsView addSubview:iconImageView];

         [detailsView addSubview:composeMailBtn];
         // [detailsView addSubview:linkField];
         // [detailsView addSubview:nameLbl];
         // [detailsView addSubview:addressLbl];
        
        //Gradient to UIView
        CAGradientLayer *gradient = [CAGradientLayer layer];
        gradient.frame = detailsView.bounds;
        gradient.colors = [NSArray arrayWithObjects:(id)[[UIColor cyanColor] CGColor], (id)[[UIColor darkGrayColor] CGColor], nil];
        // [detailsView.layer insertSublayer:gradient atIndex:0];
    }
}

-(void)labelTapped
{
    if ([[UIApplication sharedApplication]canOpenURL:[NSURL URLWithString:@"http://www.aig.com"]]) {
        
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.aig.com"]];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Invalid URL" message:@"The URL Provided is not valid" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
    }
}

-(void)done:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
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

-(void)setUpButtonsView
{
    buttonsView = [[UIView alloc]initWithFrame:CGRectMake(0, 524, 250, 410)];
    buttonsView.backgroundColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:0.5f];
    [self.view addSubview:buttonsView];
    
    //Button 1
    buttonOne = [[UIButton alloc]initWithFrame:CGRectMake(0, 2, buttonsView.frame.size.width - 2, 80)];
    //    buttonOne.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    buttonOne.backgroundColor = [UIColor whiteColor];
    buttonOne.tag = 0;
    [buttonOne setTitle:@"Contacts" forState:UIControlStateNormal];
    [buttonOne setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    buttonOne.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0];
    [buttonOne addTarget:self action:@selector(detailsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //Button 2
    buttonTwo =[[UIButton alloc]initWithFrame:CGRectMake(0, 84, buttonsView.frame.size.width - 2, 80)];
    buttonTwo.backgroundColor = [UIColor whiteColor];
    buttonTwo.tag = 1;
    [buttonTwo setTitle:@"Relationship Hierarchy" forState:UIControlStateNormal];
    [buttonTwo setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    buttonTwo.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0];
    [buttonTwo addTarget:self action:@selector(detailsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //Buton 3
    buttonThree =[[UIButton alloc]initWithFrame:CGRectMake(0, 166, buttonsView.frame.size.width - 2, 80)];
    buttonThree.backgroundColor = [UIColor whiteColor];
    buttonThree.tag = 2;
    [buttonThree setTitle:@"Revenue Chart" forState:UIControlStateNormal];
    [buttonThree setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    buttonThree.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0];
    
    [buttonThree addTarget:self action:@selector(detailsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //Button 4
    buttonFour =[[UIButton alloc]initWithFrame:CGRectMake(0, 248, buttonsView.frame.size.width - 2, 80)];
    buttonFour.backgroundColor = [UIColor whiteColor];
    buttonFour.tag = 3;
    [buttonFour setTitle:@"Revenue Data" forState:UIControlStateNormal];
    [buttonFour setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    buttonFour.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0];
    
    [buttonFour addTarget:self action:@selector(detailsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    //Button 5
    buttonFive =[[UIButton alloc]initWithFrame:CGRectMake(0, 330, buttonsView.frame.size.width - 2, 80)];
    buttonFive.backgroundColor = [UIColor whiteColor];
    buttonFive.tag = 4;
    [buttonFive setTitle:@"Business Description" forState:UIControlStateNormal];
    [buttonFive setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    buttonFive.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0];
    [buttonFive addTarget:self action:@selector(detailsButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    [buttonsView addSubview:buttonOne];
    [buttonsView addSubview:buttonTwo];
    [buttonsView addSubview:buttonThree];
    [buttonsView addSubview:buttonFour];
    [buttonsView addSubview:buttonFive];
    
    buttonDetailsView = [[UIView alloc]initWithFrame:CGRectMake(250, 526,518, 410)];
    buttonDetailsView.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    [self.view addSubview:buttonDetailsView];
    
    //Seperation View
    UIView *seperationView = [[UIView alloc]initWithFrame:CGRectMake(0,474, self.view.frame.size.width, 50)];
    UILabel *lbl = [[UILabel alloc]initWithFrame:CGRectMake(20, 5, 500, 40)];
    lbl.backgroundColor = [UIColor clearColor];
    lbl.text = @"More Information";
    lbl.textAlignment = NSTextAlignmentLeft;
    lbl.textColor = [UIColor blackColor];
    lbl.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    [seperationView addSubview:lbl];
    [self.view addSubview:seperationView];
    
    //Gradient to lbl
    UIColor *labelTopColor = [UIColor colorWithRed:204.0f/255.0f green:204.0f/255.0f blue:204.0f/255.0f alpha:1.0f];
    UIColor *labelBottomClor = [UIColor colorWithRed:255.0f/255.0f green:255.0f/255.0f blue:255.0f/255.0f alpha:1.0f];
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.frame = seperationView.bounds;
    gradient.colors = [NSArray arrayWithObjects:(id)[labelTopColor CGColor], (id)[labelBottomClor CGColor], nil];
    [seperationView.layer insertSublayer:gradient atIndex:0];
    
    //View that divides
    UIView *dividerView = [[UIView alloc]initWithFrame:CGRectMake(0, 472, self.view.frame.size.width, 2)];
    dividerView.backgroundColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:0.5f];
    [self.view addSubview:dividerView];
    
    UIView *dividerView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 524, self.view.frame.size.width, 2)];
    dividerView1.backgroundColor = [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:0.5f];
    [self.view addSubview:dividerView1];
    
    //Bottom View
    bottomView = [[UIView alloc]initWithFrame:CGRectMake(0,934, self.view.frame.size.width, 90)];
    bottomView.backgroundColor =  [UIColor colorWithRed:221.0f/255.0f green:221.0f/255.0f blue:221.0f/255.0f alpha:1.0f];
    [self.view addSubview:bottomView];
    
    UIButton *composeMailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    composeMailBtn.frame = CGRectMake(10, 15, 240, 60);
    
    [composeMailBtn setBackgroundImage:[UIImage imageNamed:@"Send_email.png"] forState:UIControlStateNormal];
    [composeMailBtn setBackgroundImage:[UIImage imageNamed:@"Send_email_pressed.png"] forState:UIControlStateHighlighted];
    composeMailBtn.layer.cornerRadius = 10;
    composeMailBtn.clipsToBounds = YES;
    [composeMailBtn addTarget:self action:@selector(sendEmail) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:composeMailBtn];
    
    
    UIButton *callFaceTime = [UIButton buttonWithType:UIButtonTypeCustom];
    callFaceTime.frame = CGRectMake(260, 15, 240, 60);
    //  callFaceTime.backgroundColor = [UIColor lightGrayColor];
    //  [callFaceTime setTitle:@"Connect With Facetime" forState:UIControlStateNormal];
    //  [callFaceTime setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    //  callFaceTime.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    //  callFaceTime.titleLabel.textAlignment = NSTextAlignmentCenter;
    callFaceTime.layer.cornerRadius = 10;
    [callFaceTime setBackgroundImage:[UIImage imageNamed:@"Call_on_Facetime.png"] forState:UIControlStateNormal];
    [callFaceTime setBackgroundImage:[UIImage imageNamed:@"Call_on_Facetime_ckick.png"] forState:UIControlStateHighlighted];
    callFaceTime.clipsToBounds = YES;
    [callFaceTime addTarget:self action:@selector(launchFaceTime) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:callFaceTime];
    
    UIButton *openMessage = [UIButton buttonWithType:UIButtonTypeCustom];
    openMessage.frame = CGRectMake(510, 15, 240, 60);
    //  openMessage.backgroundColor = [UIColor lightGrayColor];
    // [openMessage setTitle:@"Send SMS" forState:UIControlStateNormal];
    // [openMessage setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    // openMessage.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    // openMessage.titleLabel.textAlignment = NSTextAlignmentCenter;
    openMessage.layer.cornerRadius = 10;
    [openMessage setBackgroundImage:[UIImage imageNamed:@"Send_Message.png"] forState:UIControlStateNormal];
    [openMessage setBackgroundImage:[UIImage imageNamed:@"Send_message_click.png"] forState:UIControlStateHighlighted];
    openMessage.clipsToBounds = YES;
    [openMessage addTarget:self action:@selector(launchMessageComposeController) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:openMessage];
}

-(void)changeFont:(NSUInteger)buttonNumber
{
    NSArray *buttonsArray = [NSArray arrayWithObjects:buttonOne,buttonTwo,buttonThree,buttonFour,buttonFive, nil];
    UIButton *btn = [[UIButton alloc]init];
    for (int i = 0 ; i <= buttonsArray.count - 1; i= i+1)
    {
        btn = [buttonsArray objectAtIndex:i];
        btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:18.0];
        [btn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    }
    btn = [buttonsArray objectAtIndex:buttonNumber];
    btn.titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:18.0];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
}
-(void)setupDetailsViewWithButtonOne
{
    [buttonDetailsView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self changeFont:0];
    //    //Change Button Colors
    buttonOne.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    buttonTwo.backgroundColor = [UIColor whiteColor];
    buttonThree.backgroundColor = [UIColor whiteColor];
    buttonFour.backgroundColor = [UIColor whiteColor];
    buttonFive.backgroundColor = [UIColor whiteColor];
    //
    //    UITextView *namesFieldView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, buttonDetailsView.frame.size.width/2.0 - 100, buttonDetailsView.frame.size.height)];
    //    namesFieldView.text = @"RM Name\n\nLOB Division\n\n\nAU\n\nEmail ID\n\nContact No";
    //    [namesFieldView setTextColor:[UIColor redColor]];
    //    namesFieldView.backgroundColor = [UIColor lightGrayColor];
    //    namesFieldView.editable = NO;
    //    namesFieldView.font = [UIFont fontWithName:@"Helvetica-Bold" size:20.0];
    //    [buttonDetailsView addSubview:namesFieldView];
    //
    //    UITextView *namesFieldView1 = [[UITextView alloc]initWithFrame:CGRectMake(namesFieldView.frame.size.width, 0, buttonDetailsView.frame.size.width/2.0 + 100, buttonDetailsView.frame.size.height)];
    //    namesFieldView1.text = @"MEYER, ROBERT\n\nFinancial Institutions - Financial Institutions\n\n2068\n\n-NA-\n\n-NA-";
    //    // [namesFieldView1 setTextColor:[UIColor redColor]];
    //    // namesFieldView1.backgroundColor = [UIColor lightGrayColor];
    //    namesFieldView1.editable = NO;
    //    namesFieldView1.font = [UIFont fontWithName:@"Helvetica" size:20.0];
    //    [buttonDetailsView addSubview:namesFieldView1];
    //
    //    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 20, 50, 50)];
    //    btn.backgroundColor = [UIColor blackColor];
    //    [btn addTarget:self action:@selector(openDetails) forControlEvents:UIControlEventTouchUpInside];
    
    navigationCont = [[UIViewController alloc]init];
    customNavigationController = [[UINavigationController alloc]initWithRootViewController:navigationCont];
    [customNavigationController setNavigationBarHidden:YES];
    navigationCont.title = @"All Contacts";
    [buttonDetailsView addSubview:customNavigationController.view];
    navigationCont.view.backgroundColor = [UIColor clearColor];
    navigationCont.view.frame = buttonDetailsView.bounds;
    
    
    self.contactsTableView = [[UITableView alloc]init];
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    [self.contactsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.contactsTableView.frame = navigationCont.view.bounds;
    [navigationCont.view addSubview:self.contactsTableView];
}

-(void)setupDetailsViewWithButtonTwo
{
    [buttonDetailsView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self changeFont:1];
    
    //Change Button Colors
    buttonOne.backgroundColor = [UIColor whiteColor];
    buttonTwo.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    buttonThree.backgroundColor = [UIColor whiteColor];
    buttonFour.backgroundColor = [UIColor whiteColor];
    buttonFive.backgroundColor = [UIColor whiteColor];
    
    myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,buttonDetailsView.frame.size.width, buttonDetailsView.frame.size.height - 200)];
    myImageView.image = [UIImage imageNamed:@"Hierarchy.png"];
    [buttonDetailsView addSubview:myImageView];
    
}

-(void)setupDetailsViewWithButtonThree
{
    [buttonDetailsView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self changeFont:2];
    
    //Change Button Colors
    buttonOne.backgroundColor = [UIColor whiteColor];
    buttonTwo.backgroundColor = [UIColor whiteColor];
    buttonThree.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    buttonFour.backgroundColor = [UIColor whiteColor];
    buttonFive.backgroundColor = [UIColor whiteColor];
    
    myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20,buttonDetailsView.frame.size.width - 50, buttonDetailsView.frame.size.height - 50)];
    myImageView.image = [UIImage imageNamed:@"Chart.png"];
    [buttonDetailsView addSubview:myImageView];
    
}

-(void)setupDetailsViewWithButtonFour
{
    [buttonDetailsView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self changeFont:3];
    
    //Change Button Colors
    buttonOne.backgroundColor = [UIColor whiteColor];
    buttonTwo.backgroundColor = [UIColor whiteColor];
    buttonThree.backgroundColor = [UIColor whiteColor];
    buttonFour.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    buttonFive.backgroundColor = [UIColor whiteColor];
    
    [buttonDetailsView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    myImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,buttonDetailsView.frame.size.width, buttonDetailsView.frame.size.height - 200)];
    myImageView.image = [UIImage imageNamed:@"RevenueDataImage.png"];
    [buttonDetailsView addSubview:myImageView];
}

-(void)setupDetailsViewWithButtonFive
{
    [buttonDetailsView.subviews makeObjectsPerformSelector: @selector(removeFromSuperview)];
    [self changeFont:4];
    
    //Change Button Colors
    buttonOne.backgroundColor = [UIColor whiteColor];
    buttonTwo.backgroundColor = [UIColor whiteColor];
    buttonThree.backgroundColor = [UIColor whiteColor];
    buttonFour.backgroundColor = [UIColor whiteColor];
    buttonFive.backgroundColor = [UIColor colorWithRed:204.0f/255.0f green:51.0f/255.0f blue:51.0f/255.0f alpha:1.0f];
    
    UITextView *textView= [[UITextView alloc]initWithFrame:CGRectMake(0, 0, buttonDetailsView.frame.size.width, buttonDetailsView.frame.size.height)];
    textView.text = @"American International Group, Inc. Insurance Products and services for the commercial, Instutional and individual customers in United States and internationally. The company operates in two segments:AIG Property Casualty and AIG Lifr and Retirement. The  AIG Property Casualty offers insurance products that cover geeral liability.";
    textView.font = [UIFont fontWithName:@"Helvetica" size:18.0];
    
    [buttonDetailsView addSubview:textView];
    
}

-(void)parseJSON
{
    ////////////////Parser Class
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"JSON" ofType:@"txt"];
    NSData *JSONData = [NSData dataWithContentsOfFile:filePath options:NSDataReadingMappedIfSafe error:nil];
    NSArray *jsonObject = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableContainers error:nil];
    
    NSDictionary *dict = [jsonObject objectAtIndex:0];
    
    NSArray *arr = [dict valueForKey:@"contacts"];
    
    //    NSArray *responseArray = [[jsonObject valueForKey:@"contacts"] objectAtIndex:0];
    NSDictionary *dict1;
    self.modelArray = [NSMutableArray array];
    for (dict1 in arr) {
        [self.modelClass parseDataWith:dict1];
        [self.modelArray addObject:self.modelClass];
    }
    
    
    NSLog(@"%@",[self.modelArray objectAtIndex:0]);
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
-(void)launchMessageComposeController
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString:@"sms:98765432"]];
    
}
-(void)detailsButtonClicked:(id)sender
{
    [self setUpDetailsView:[sender tag]];
}

-(void)setUpDetailsView:(NSUInteger)buttonClicked
{
    switch (buttonClicked)
    {
        case 0:
            [self setupDetailsViewWithButtonOne];
            break;
        case 1:
            [self setupDetailsViewWithButtonTwo];
            break;
        case 2:
            [self setupDetailsViewWithButtonThree];
            break;
        case 3:
            [self setupDetailsViewWithButtonFour];
            break;
        case 4:
            [self setupDetailsViewWithButtonFive];
            break;
            
        default:
            break;
    }
}

#pragma mark - UITextField Delegate Methods

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    return NO;
}

#pragma mark - UIGesture Recogniser Delegate Methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
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

#pragma mark - MFMessageComposeViewController Delegate Methods

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self.messageController dismissViewControllerAnimated:YES completion:nil];
}


-(void)calculateRoute
{
    MKPlacemark *source = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(_mapView.userLocation.location.coordinate.latitude, _mapView.userLocation.location.coordinate.latitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *srcMapItem = [[MKMapItem alloc]initWithPlacemark:source];
    [srcMapItem setName:@""];
    
    MKPlacemark *destination = [[MKPlacemark alloc]initWithCoordinate:CLLocationCoordinate2DMake(_tappedPlace.location.coordinate.longitude, _tappedPlace.location.coordinate.latitude) addressDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"",@"", nil] ];
    
    MKMapItem *distMapItem = [[MKMapItem alloc]initWithPlacemark:destination];
    [distMapItem setName:@""];
    
    MKDirectionsRequest *request = [[MKDirectionsRequest alloc]init];
    [request setSource:srcMapItem];
    [request setDestination:distMapItem];
    [request setTransportType:MKDirectionsTransportTypeAutomobile];
    
    MKDirections *direction = [[MKDirections alloc]initWithRequest:request];
    
    [direction calculateDirectionsWithCompletionHandler:^(MKDirectionsResponse *response, NSError *error) {
        
        NSLog(@"response = %@",error);
        NSArray *arrRoutes = [response routes];
        [arrRoutes enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            
            MKRoute *rout = obj;
            
            MKPolyline *line = [rout polyline];
            self.routeLine = line;
            [_mapView addOverlay:line];
            NSLog(@"Rout Name : %@",rout.name);
            NSLog(@"Total Distance (in Meters) :%f",rout.distance);
            
            NSArray *steps = [rout steps];
            
            NSLog(@"Total Steps : %lu",(unsigned long)[steps count]);
            
            [steps enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
                NSLog(@"Rout Instruction : %@",[obj instructions]);
                NSLog(@"Rout Distance : %f",[obj distance]);
            }];
        }];
    }];
}

#pragma mark - UITableViewDataSourceDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    cell.backgroundView = [[UIImageView alloc] initWithImage:[ [UIImage imageNamed:[self.imagesArray objectAtIndex:indexPath.row]] stretchableImageWithLeftCapWidth:10.0 topCapHeight:5.0] ];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;
{
    return 100;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    _detailsController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"UserDetailsViewController"];
    _detailsController.viewCont = self;
    _detailsController.customNavigationCont = customNavigationController;
    _detailsController.modelClass = [self.modelArray objectAtIndex:indexPath.row];
    _detailsController.contactsDict = self.contactsDict;
    [customNavigationController pushViewController:_detailsController animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}
@end
