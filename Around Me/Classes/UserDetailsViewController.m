//
//  UserDetailsViewController.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/10/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "UserDetailsViewController.h"
#import "ContactCell.h"
#import "ModelClass.h"
#import "CommentsCell.h"
#import <EventKit/EventKit.h>
#import <EventKitUI/EventKitUI.h>

@interface UserDetailsViewController ()<UITableViewDataSource,UITableViewDelegate,UITextFieldDelegate,EKEventEditViewDelegate>
{
    UIScrollView *scrollview;
    UITextField *textView;
    UIButton *calendarBtn;
}

@property(nonatomic, strong) UITableView *contactsTableView;
@property(nonatomic, strong) NSArray *contactsArr;
@property(nonatomic, strong) UITableView *commentsTableView;
@property(nonatomic, strong) NSString *calendarIdentifier;

@end

@implementation UserDetailsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:NO];
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    self.navigationItem.backBarButtonItem.title = @"All Contacts";
    self.view.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    [self createView];
    
    //Creating Right Bar Button Item
    
    // UINib *nib = [UINib nibWithNibName:@"Cell" bundle:nil];
    [self.contactsTableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:@"ContactCell"];
    self.contactsArr = [[self.contactsDict valueForKey:@"contact"]objectAtIndex:0];
    
    textView = [[UITextField alloc]init];
    textView.delegate = self;
    NSAttributedString * search = [[NSAttributedString alloc] initWithString:@"   Write Comment..." attributes:@{NSForegroundColorAttributeName: [UIColor lightGrayColor]}];
    
    textView.attributedPlaceholder = search;
    textView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:textView];
    
    UIButton *saveBtn = [[UIButton alloc]init];
    [self.view addSubview:saveBtn];
    [saveBtn setTitle:@"Save" forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
    UIView *commentsView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, 500, 200)];
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 100)];
    imageView.image = [UIImage imageNamed:@"comment_1.png"];
    
    [commentsView addSubview:imageView];
    
    UIImageView *imageView1 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 110, 500, 100)];
    imageView1.image = [UIImage imageNamed:@"comment_3.png"];
    
    UIImageView *imageView2 = [[UIImageView alloc]initWithFrame:CGRectMake(0, 210, 500, 50)];
    imageView2.image = [UIImage imageNamed:@"comment_3.png"];
    
    [commentsView addSubview:imageView1];
    //  [self.view addSubview:commentsView];
    
    scrollview=[[UIScrollView alloc]initWithFrame:CGRectMake(0,0,320,480)];
    scrollview.showsVerticalScrollIndicator=YES;
    scrollview.scrollEnabled=YES;
    scrollview.userInteractionEnabled=YES;
    [commentsView addSubview:scrollview];
    scrollview.contentSize = CGSizeMake(commentsView.frame.size.width,commentsView.frame.size.height);
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        textView.frame = CGRectMake(0, 370, 440, 40);
        saveBtn.frame = CGRectMake(445, 370, 60, 40);
    }
    else
    {
        textView.frame = CGRectMake(5, 500, 250, 40);
        saveBtn.frame = CGRectMake(255, 500, 60, 40);
    }
    
}
-(void)viewWillAppear:(BOOL)animated
{
    [self createRightBarBtn];
    [self.customNavigationCont setNavigationBarHidden:NO];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [self.customNavigationCont setNavigationBarHidden:YES];
}

-(void)dealloc
{
    _contactsDict = nil;
    _viewCont = nil;
    _modelClass = nil;
    _contactsArr = nil;
    _contactsTableView = nil;
    _calendarIdentifier = nil;
    _commentsTableView = nil;
    _customNavigationCont = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Other Methods

-(void)createRightBarBtn
{
    calendarBtn = [[UIButton alloc]init];
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        calendarBtn.frame = CGRectMake(380, 0, 150, 44);
    }
    else
    {
        calendarBtn.frame = CGRectMake(220, 0, 100, 44);
    }
    [calendarBtn setTitle:@"Create Event" forState:UIControlStateNormal];
    [calendarBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [calendarBtn addTarget:self action:@selector(createCalendarEvent) forControlEvents:UIControlEventTouchUpInside];
    [self.navigationController.navigationBar addSubview:calendarBtn];
    
}
-(void)createView
{
    UIImageView *imageView = [[UIImageView alloc]init];
    imageView.backgroundColor = [UIColor clearColor];
    imageView.image = [UIImage imageNamed:@"profile_pic.png"];
    [self.view addSubview:imageView];
    
    UILabel *lbl = [[UILabel alloc]init];
    lbl.text = @"Meyer, Robert";
    lbl.font = [UIFont fontWithName:@"HelveticaMedium" size:36.0];
    lbl.textColor = [UIColor colorWithRed:102.0f/256.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0];
    [self.view addSubview:lbl];
    
    UILabel *lblTwo = [[UILabel alloc]initWithFrame:CGRectMake(90, 74, 300, 48)];
    [lblTwo setNumberOfLines:2];
    lblTwo.text = @"VP, Sales and Marketing \nFinancial Instutions";
    lblTwo.font = [UIFont fontWithName:@"HelveticaRegular" size:29];
    lblTwo.textColor = [UIColor colorWithRed:102.0f/256.0f green:102.0/255.0f blue:102.0f/255.0f alpha:1.0];
    [self.view addSubview:lblTwo];
    [self createPhoneNumberTableView];
    [self createCommentsTableView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        imageView.frame = CGRectMake(10, 50, 70, 70);
        lbl.frame = CGRectMake(90, 50, 200, 24);
        lblTwo.frame = CGRectMake(90, 74, 300, 48);
    }
    else
    {
        imageView.frame =  CGRectMake(10, 50+44, 70, 70);
        lbl.frame = CGRectMake(90, 50+44, 200, 24);
        lblTwo.frame = CGRectMake(90, 74+44, 300, 48);
    }
}

-(void)createCommentsTableView
{
    self.commentsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 150, 500, 200) style:UITableViewStylePlain];
    self.commentsTableView.delegate = self;
    self.commentsTableView.dataSource = self;
    [self.contactsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:self.commentsTableView];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
    {
        self.commentsTableView.frame = CGRectMake(0, 150, 500, 200);
    }
    else
    {
        self.commentsTableView.frame = CGRectMake(0, 250, self.view.frame.size.width, 200);
    }
}
-(void)createPhoneNumberTableView
{
    self.contactsTableView = [[UITableView alloc]init];
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    [self.view addSubview:self.contactsTableView];
    self.contactsTableView.backgroundColor = [UIColor clearColor];
    self.contactsTableView.frame = CGRectMake(300, 54, 218, 80);
    [self.contactsTableView showsVerticalScrollIndicator];
    [self.contactsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
}

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


/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark - UITableViewDataSourceDelegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (tableView == self.commentsTableView) {
        return 2;
    }
    else
    {
        return 4;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 40;
    if (tableView == self.commentsTableView) {
        
        //        CGSize constraintSize = CGSizeMake(280.0f, MAXFLOAT);
        //        CGSize labelSize = [cellText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:10.0] constrainedToSize:constraintSize lineBreakMode:NSLineBreakByWordWrapping];
        //        height = labelSize.height;
        height = 100;
    }
    return height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"identifierCell";
    static NSString *customIdentfier = @"customIdentfier";
    
    UITableViewCell *customCell = [tableView dequeueReusableCellWithIdentifier:customIdentfier];
    ContactCell *contactCell = (ContactCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (cell == nil) {
        cell =   [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    
    if (tableView == self.commentsTableView) {
        
        if (customCell == nil) {
            customCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customIdentfier];
        }
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 500, 100)];
        imageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"comment_1.png"]];
        [customCell.contentView addSubview:imageView];
        cell =  customCell;
    }
    else
    {
        
        if (contactCell == nil) {
            [tableView registerNib:[UINib nibWithNibName:@"ContactCell" bundle:nil] forCellReuseIdentifier:CellIdentifier];
            contactCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        }
        contactCell.officeLabel.text = @"Office";
        [contactCell.phoneNumberBtn setTitle:@"210.770.7000" forState:UIControlStateNormal];
        [contactCell.phoneNumberBtn sizeToFit];
        
        if (indexPath.row == 1) {
            contactCell.officeLabel.text = @"Mobile";
            [contactCell.faceTimeBtn setHidden:NO];
            [contactCell.audioFaceimeBtn setHidden:NO];
            
        }
        if (indexPath.row == 2) {
            contactCell.officeLabel.text = @"Home";
            
        }
        
        if (indexPath.row == 3) {
            [contactCell.faceTimeBtn setHidden:YES];
            [contactCell.audioFaceimeBtn setHidden:YES];
            contactCell.officeLabel.text = @"Email";
            [contactCell.phoneNumberBtn setTitle:@"robert@aig.com" forState:UIControlStateNormal];
            contactCell.phoneNumberBtn.frame = CGRectMake(contactCell.phoneNumberBtn.frame.origin.x, contactCell.phoneNumberBtn.frame.origin.y, 500, contactCell.phoneNumberBtn.frame.size.height);
            contactCell.cellIndex = @"3";
        }
        contactCell.rootViewCont = self.viewCont;
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        cell.backgroundColor = [UIColor clearColor];
        
        cell = contactCell;
    }
    cell.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
    
    return cell;
}

#pragma mark - UITableView Delegate Methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

#pragma mark - TextView Delegate Methods

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
    return YES;
}


- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [self.view endEditing:YES];
    return YES;
}


- (void)keyboardDidShow:(NSNotification *)notification
{
    // Assign new frame to your view
    [self.view setFrame:CGRectMake(0,-200,self.view.frame.size.width,self.view.frame.size.height)]; //here taken -20 for example i.e. your view will be scrolled to -20. change its value according to your requirement.
    
}

-(void)keyboardDidHide:(NSNotification *)notification
{
    [self.view setFrame:CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height)];
}

///////////////////////
/* Creating Event Without User Interface
 
 
 - (BOOL)addEventAt:(NSDate*)eventDate withTitle:(NSString*)title inLocation:(NSString*)location
 {
 EKEventStore *eventStore = [[EKEventStore alloc] init];
 EKEvent *event = [EKEvent eventWithEventStore:eventStore];
 EKCalendar *calendar = nil;
 NSString *calendarIdentifier = [[NSUserDefaults standardUserDefaults] valueForKey:@"my_calendar_identifier"];
 
 // when identifier exists, my calendar probably already exists
 // note that user can delete my calendar. In that case I have to create it again.
 if (calendarIdentifier) {
 calendar = [eventStore calendarWithIdentifier:calendarIdentifier];
 }
 
 // calendar doesn't exist, create it and save it's identifier
 if (!calendar) {
 // http://stackoverflow.com/questions/7945537/add-a-new-calendar-to-an-ekeventstore-with-eventkit
 calendar = [EKCalendar calendarForEntityType:EKEntityTypeEvent eventStore:eventStore];
 
 // set calendar name. This is what users will see in their Calendar app
 [calendar setTitle:@"Hi There"];
 
 // find appropriate source type. I'm interested only in local calendars but
 // there are also calendars in iCloud, MS Exchange, ...
 // look for EKSourceType in manual for more options
 for (EKSource *s in eventStore.sources) {
 if (s.sourceType == EKSourceTypeLocal) {
 calendar.source = s;
 break;
 }
 }
 
 // save this in NSUserDefaults data for retrieval later
 NSString *calendarIdentifier = [calendar calendarIdentifier];
 
 NSError *error = nil;
 BOOL saved = [eventStore saveCalendar:calendar commit:YES error:&error];
 if (saved) {
 // http://stackoverflow.com/questions/1731530/whats-the-easiest-way-to-persist-data-in-an-iphone-app
 // saved successfuly, store it's identifier in NSUserDefaults
 [[NSUserDefaults standardUserDefaults] setObject:calendarIdentifier forKey:@"my_calendar_identifier"];
 } else {
 // unable to save calendar
 return NO;
 }
 }
 
 // this shouldn't happen
 if (!calendar) {
 return NO;
 }
 
 // assign basic information to the event; location is optional
 event.calendar = calendar;
 event.location = location;
 event.title = title;
 
 // set the start date to the current date/time and the event duration to two hours
 NSDate *startDate = eventDate;
 event.startDate = startDate;
 event.endDate = [startDate dateByAddingTimeInterval:3600 * 2];
 
 NSError *error = nil;
 // save event to the callendar
 BOOL result = [eventStore saveEvent:event span:EKSpanThisEvent commit:YES error:&error];
 if (result) {
 return YES;
 } else {
 // NSLog(@"Error saving event: %@", error);
 // unable to save event to the calendar
 return NO;
 }
 }
 */

/////////////////////
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
    
    [_viewCont presentViewController:controller animated:YES completion:nil];
}

- (EKEvent *)findOrCreateEvent:(EKEventStore *)store
{
    NSString *title = @"My event title";
    
    // try to find an event
    
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
    [_viewCont dismissViewControllerAnimated:YES completion:nil];
}

@end
