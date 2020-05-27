//
//  UserDetailsiPhoneController.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 1/5/15.
//  Copyright (c) 2015 Jean-Pierre Distler. All rights reserved.
//

#import "UserDetailsiPhoneController.h"
#import "ClientsListCell.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define kBackgroundColor_header [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0]
#define kBackgroundColor_header_text [UIColor colorWithRed:102.0f/255.0f green:102.0f/255.0f blue:102.0f/255.0f alpha:1.0]

@interface UserDetailsiPhoneController ()<UITableViewDataSource,UITableViewDelegate,EKEventEditViewDelegate,MFMailComposeViewControllerDelegate>
{
    UIImageView *cmtImageView;
    UIImageView *cmtImageView1;
    UIImageView *cmtIimageView2;
    UIButton *calendarBtn;
}
@property(nonatomic, strong) UITableView *contactsTableView;
@property(nonatomic, strong)  UIView *bottomBtnView;
@property(nonatomic, strong) MFMailComposeViewController *mailController;
@property(nonatomic, strong) NSArray *commentsArray;
@property(nonatomic, strong) NSArray *namesArray;
@property(nonatomic, strong) NSArray *picsArray;
@end

@implementation UserDetailsiPhoneController

-(void)viewDidLoad
{
    
    cmtImageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 110, 500, 100)];
    cmtImageView1.image = [UIImage imageNamed:@"comment_3.png"];
    
    cmtIimageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 210, 500, 50)];
    cmtIimageView2.image = [UIImage imageNamed:@"comment_3.png"];
    
    [self createPhoneNumberTableView];
    [self setUpBottomBtnView];
    
    UIBarButtonItem *anotherButton = [[UIBarButtonItem alloc] initWithTitle:@"Create Event" style:UIBarButtonItemStylePlain target:self action:@selector(createCalendarEvent)];
    anotherButton.tintColor = [UIColor redColor];
    self.navigationItem.rightBarButtonItem = anotherButton;
    self.commentsArray = [NSArray arrayWithObjects:@"Comment2@2x.png",@"Comment3@2x.png",@"Comment4@2x.png", nil];
    self.namesArray = [NSArray arrayWithObjects:@"Meyer, Robert",@"Jennings, Gary",@"Simpsons, Lisa", nil];
    self.picsArray = [NSArray arrayWithObjects:@"profile_pic.png",@"profile_2.png",@"profile_3.png", nil];
}

-(void)dealloc
{
    _rowNumber = nil;
    _contactsTableView = nil;
    _bottomBtnView = nil;
    _mailController = nil;
    _commentsArray = nil;
    _namesArray = nil;
    _picsArray = nil;
    
}
-(UIView*)createView
{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    view.backgroundColor = [UIColor whiteColor];
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor clearColor];
    [view addSubview:imageView];
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.font = [UIFont fontWithName:@"HelveticaMedium" size:36.0];
    lbl.textColor = [UIColor colorWithRed:102.0f/256.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0];
    [view addSubview:lbl];
    
    UILabel *lblTwo = [[UILabel alloc]initWithFrame:CGRectMake(90, 74, 300, 48)];
    [lblTwo setNumberOfLines:2];
    lblTwo.text = @"VP, Sales and Marketing \nFinancial Instutions";
    lblTwo.font = [UIFont fontWithName:@"HelveticaRegular" size:29];
    lblTwo.textColor = [UIColor colorWithRed:102.0f/256.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0];
    [view addSubview:lblTwo];
    
    imageView.frame = CGRectMake(10, 10, 70, 70);
    lbl.frame = CGRectMake(90, 10, 200, 24);
    lblTwo.frame = CGRectMake(90, 34, 300, 48);
    
    NSUInteger object = [self.rowNumber integerValue];
    imageView.image = [UIImage imageNamed:[self.picsArray objectAtIndex:object]];
    lbl.text = [NSString stringWithFormat:@"%@",[self.namesArray objectAtIndex:object]];
    
    return view;
}

-(void)createPhoneNumberTableView
{
    self.contactsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 54) style:UITableViewStyleGrouped];
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    [self.view addSubview:self.contactsTableView];
    self.contactsTableView.backgroundColor = kBackgroundColor_header;
    [self.contactsTableView showsVerticalScrollIndicator];
    [self.contactsTableView setSeparatorStyle:UITableViewCellSeparatorStyleSingleLine];
    
    //    calendarBtn = [[UIButton alloc]init];
    //    calendarBtn.backgroundColor = [UIColor darkGrayColor];
    //    [calendarBtn addTarget:self action:@selector(createCalendarEvent) forControlEvents:UIControlEventTouchUpInside];
    //    calendarBtn.frame = CGRectMake(220, 0, 100, 44);
    //
    //    [self.navigationController.navigationBar addSubview:calendarBtn];
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


#pragma mark - UITableViewDataSourceDelegate Methods

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section;
{
    if (section == 0) {
        return  nil;
    }
    else
    {
        return @"Comments";
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    }
    else
    {
        return 3;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 50;
    if (indexPath.row == 4) {
        height =  80;
    }
    if (indexPath.row == 2) {
        height =  35;
    }
    if (indexPath.section == 1) {
        height = 80;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"listCell";
    
    ClientsListCell *contactCell = (ClientsListCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell =   [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    if (contactCell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"ClientsListCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
        contactCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            
            contactCell.officeLabel.text = @"Office";
            [contactCell.phoneNumberBtn setTitle:@"210.770.7000" forState:UIControlStateNormal];
            [contactCell.phoneNumberBtn sizeToFit];
            contactCell.backgroundColor = [UIColor whiteColor];
        }
        if (indexPath.row == 1) {
            contactCell.officeLabel.text = @"Mobile";
            [contactCell.phoneNumberBtn setTitle:@"210.770.7000" forState:UIControlStateNormal];
            [contactCell.phoneNumberBtn sizeToFit];
            contactCell.backgroundColor = [UIColor whiteColor];
        }
        if (indexPath.row == 2) {
            [contactCell.phoneNumberBtn setHidden:YES];
            [contactCell.officeLabel  setHidden:YES];
            contactCell.backgroundColor = kBackgroundColor_header;
        }
        if (indexPath.row == 3) {
            [contactCell.faceTimeBtn setHidden:YES];
            [contactCell.audioFaceimeBtn setHidden:YES];
            contactCell.officeLabel.text = @"Email";
            [contactCell.phoneNumberBtn setTitle:@"robert@aig.com" forState:UIControlStateNormal];
            contactCell.phoneNumberBtn.frame = CGRectMake(contactCell.phoneNumberBtn.frame.origin.x, contactCell.phoneNumberBtn.frame.origin.y, 500, contactCell.phoneNumberBtn.frame.size.height);
            contactCell.cellIndex = @"3";
            contactCell.backgroundColor = [UIColor whiteColor];
        }
    }
    if (indexPath.section == 1) {
        
        [contactCell.faceTimeBtn setHidden:YES];
        [contactCell.audioFaceimeBtn setHidden:YES];
        [contactCell.phoneNumberBtn setHidden:YES];
        [contactCell.officeLabel setHidden:YES];
        cmtImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
        cmtImageView.image = [UIImage imageNamed:[self.commentsArray objectAtIndex:indexPath.row]];
        [contactCell setBackgroundView:cmtImageView];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    contactCell.rootViewCont = self;
    cell = contactCell;
    return cell;
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

#pragma mark - UITableView Delegate Methods

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    CGFloat height;
    if (section == 0) {
        height = 100;
    }
    if (section == 1) {
        height =  20;
    }
    return height;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view;
    if (section == 0) {
        view  = [self createView];
    }
    else
    {
        // view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
        view.backgroundColor = kBackgroundColor_header;
        
        UILabel* headerLabel = [[UILabel alloc] init];
        headerLabel.frame = CGRectMake(0, 400, tableView.frame.size.width, 40);
        headerLabel.backgroundColor = kBackgroundColor_header;
        headerLabel.textColor = kBackgroundColor_header_text;
        headerLabel.font = [UIFont boldSystemFontOfSize:16.0];
        headerLabel.text = @" Comments";
        headerLabel.textAlignment = NSTextAlignmentLeft;
        
        // 4. Add the label to the header view
        [view addSubview:headerLabel];
    }
    return view;
}

#pragma mark - Other Methods
-(void)createCalendarEvent
{
    EKEventStore *eventStore = [[EKEventStore alloc] init];
    
    if ([eventStore respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // the selector is available, so we must be on iOS 6 or newer
        [eventStore requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error)
                {
                    // display error message here
                }
                else if (!granted)
                {
                    // display access denied error message here
                    
                }
                else
                {
                    // access granted
                    // ***** do the important stuff here *****
                    [self createEventAndPresentViewController:eventStore];
                }
            });
        }];
    }
    else
    {
        // this code runs in iOS 4 or iOS 5
        // ***** do the important stuff here *****
    }
}

/* Presenting the calander view to let user fill in the details */
#pragma mark - Presenting Calander Methods

- (IBAction)didPressCreateEventButton:(id)sender
{
    EKEventStore *store = [[EKEventStore alloc] init];
    
    if([store respondsToSelector:@selector(requestAccessToEntityType:completion:)])
    {
        // iOS 6
        [store requestAccessToEntityType:EKEntityTypeEvent
                              completion:^(BOOL granted, NSError *error) {
                                  if (granted)
                                  {
                                      dispatch_async(dispatch_get_main_queue(), ^{
                                          [self createEventAndPresentViewController:store];
                                      });
                                  }
                              }];
    } else
    {
        // iOS 5
        [self createEventAndPresentViewController:store];
    }
}

- (void)createEventAndPresentViewController:(EKEventStore *)store
{
    EKEvent *event = [self findOrCreateEvent:store];
    
    EKEventEditViewController *controller = [[EKEventEditViewController alloc] init];
    controller.event = event;
    controller.eventStore = store;
    controller.editViewDelegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}

- (EKEvent *)findOrCreateEvent:(EKEventStore *)store
{
    NSString *title = [NSString stringWithFormat:@"Meeting with %@",[self.namesArray objectAtIndex:[self.rowNumber integerValue]]];
    
    EKEvent *event = [self findEventWithTitle:title inEventStore:store];
    
    // if found, use it
    
    if (event)
        return event;
    
    // if not, let's create new event
    
    event = [EKEvent eventWithEventStore:store];
    
    event.title = title;
    event.notes = @"My event notes";
    event.location = @"My event location";
    event.calendar = [store defaultCalendarForNewEvents];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *components = [[NSDateComponents alloc] init];
    components.hour = 4;
    event.startDate = [calendar dateByAddingComponents:components
                                                toDate:[NSDate date]
                                               options:0];
    components.hour = 1;
    event.endDate = [calendar dateByAddingComponents:components
                                              toDate:event.startDate
                                             options:0];
    
    return event;
}

- (EKEvent *)findEventWithTitle:(NSString *)title inEventStore:(EKEventStore *)store
{
    // Get the appropriate calendar
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    // Create the start range date components
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [calendar dateByAddingComponents:oneDayAgoComponents
                                                  toDate:[NSDate date]
                                                 options:0];
    
    // Create the end range date components
    NSDateComponents *oneWeekFromNowComponents = [[NSDateComponents alloc] init];
    oneWeekFromNowComponents.day = 7;
    NSDate *oneWeekFromNow = [calendar dateByAddingComponents:oneWeekFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    
    // Create the predicate from the event store's instance method
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneWeekFromNow
                                                          calendars:nil];
    
    // Fetch all events that match the predicate
    NSArray *events = [store eventsMatchingPredicate:predicate];
    
    for (EKEvent *event in events)
    {
        if ([title isEqualToString:event.title])
        {
            return event;
        }
    }
    
    return nil;
}

- (void)eventEditViewController:(EKEventEditViewController *)controller didCompleteWithAction:(EKEventEditViewAction)action
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
