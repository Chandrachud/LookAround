//
//  ContactsTableViewController.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 1/5/15.
//  Copyright (c) 2015 Jean-Pierre Distler. All rights reserved.
//

#import "ContactsTableViewController.h"
#import "UserDetailsiPhoneController.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

#define kBackgroundColor_header [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0]

@interface ContactsTableViewController()<UITableViewDataSource, UITableViewDelegate,MFMailComposeViewControllerDelegate>

@property(nonatomic, strong)NSArray *imagesArray;
@property(nonatomic, strong)UserDetailsiPhoneController *detailsController;
@property (nonatomic, strong)UITableView *contactsTableView;
@property(nonatomic, strong)  UIView *bottomBtnView;
@property(nonatomic, strong) MFMailComposeViewController *mailController;
@property(nonatomic, strong)NSArray *detailsImagesArr;

@end

@implementation ContactsTableViewController

-(void)viewDidLoad
{
    self.imagesArray = [NSArray arrayWithObjects:@"contact1_iphone.png",@"contact2_iphone.png",@"contact3_iphone.png", nil];
    self.detailsImagesArr = [NSArray arrayWithObjects:@"",@"relationship_hirarchy@2x.png",@"chart_iPhone@2x.png",@"revenue_data_iPhone@2x.png", nil];
    
    self.contactsTableView = [[UITableView alloc]init];
    self.contactsTableView.delegate = self;
    self.contactsTableView.dataSource = self;
    self.contactsTableView.backgroundColor = kBackgroundColor_header;
    [self.contactsTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.contactsTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
    
    if ([self.rowNumber isEqualToString:@"0"])
    {
        [self.view addSubview:self.contactsTableView];
    }
    else
    {
        UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        [self.view addSubview:view];
        view.backgroundColor = [UIColor colorWithRed:239.0f/255.0f green:239.0f/255.0f blue:244.0f/255.0f alpha:1.0f];
        UIImageView *imageView = [[UIImageView alloc]init];
        
        if ([self.rowNumber isEqualToString:@"1"])
        {
            imageView.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, self.view.frame.size.height/2.0 - 150);
        }
        else if ([self.rowNumber isEqualToString:@"2"])
        {
            imageView.frame = CGRectMake(10, 80, self.view.frame.size.width - 20, self.view.frame.size.height/2.0 - 50);
        }
        
        else if ([self.rowNumber isEqualToString:@"3"])
        {
            imageView.frame = CGRectMake(5, 80, self.view.frame.size.width - 10, self.view.frame.size.height/2.0 - 160);
        }
        [view addSubview:imageView];
        imageView.image = [UIImage imageNamed:[self.detailsImagesArr objectAtIndex:[self.rowNumber integerValue]]];
        
    }
    [self setUpBottomBtnView];
}

-(void)dealloc
{
    _rowNumber = nil;
    _imagesArray = nil;
    _detailsController = nil;
    _contactsTableView = nil;
    _bottomBtnView = nil;
    _mailController = nil;
    _detailsImagesArr = nil;
    
}
-(UIView *)createView
{
    UIImageView *view = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 100)];
    view.image = [UIImage imageNamed:@"details@2x.png"];
    return view;
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
    cell.backgroundColor = kBackgroundColor_header;
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
    _detailsController = [[UserDetailsiPhoneController alloc]init];
    _detailsController.rowNumber = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
    
    [self.navigationController pushViewController:_detailsController animated:YES];
}
- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section;
{
    return 100;
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [self createView];
    return view;
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
