//
//  ContactCell.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/10/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "ContactCell.h"

@implementation ContactCell

- (void)awakeFromNib {
    // Initialization code
    [self.phoneNumberBtn addTarget:self action:@selector(makeCall) forControlEvents:UIControlEventTouchUpInside];
    
    [self.faceTimeBtn addTarget:self action:@selector(launchFaceTime) forControlEvents:UIControlEventTouchUpInside];
    
    [self.audioFaceimeBtn addTarget:self action:@selector(launchFaceTimeAudioCall) forControlEvents:UIControlEventTouchUpInside];
    
    self.phoneNumberBtn.titleLabel.textAlignment = NSTextAlignmentLeft;
}

-(void)dealloc
{
    _mailController = nil;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

-(void)launchFaceTime
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"facetime://anantha.sharma@icloud.com"]];
}

-(void)makeCall
{

    if ([self.cellIndex isEqualToString: @"3"]) {
        [self sendEmail];
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@" Cannot Make a Call" message:@"Call Service is not available on this device" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alertView show];
    }
}

-(void)launchFaceTimeAudioCall
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"facetime-audio://anantha.sharma@icloud.com"]];

}
-(void)sendEmail
{
    if ([MFMailComposeViewController canSendMail]) {
        
        _mailController = [[MFMailComposeViewController alloc] init];
        _mailController.mailComposeDelegate = self;
        [_mailController setSubject:@"Book An Appointment"];
        [_mailController setMessageBody:@"Your message goes here." isHTML:NO];
        [_mailController setToRecipients:[NSArray arrayWithObjects:@"robert@aig.com", nil]];
    
        [self.rootViewCont presentViewController:_mailController animated:YES completion:nil];
    }
    else {
        
        NSLog(@"Device is unable to send email in its current state.");
    }
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
