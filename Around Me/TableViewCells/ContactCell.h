//
//  ContactCell.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/10/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MessageUI/MFMailComposeViewController.h>

@interface ContactCell : UITableViewCell<MFMailComposeViewControllerDelegate>
{
}
@property(strong, nonatomic) NSString *cellIndex;
@property(strong, nonatomic) UIViewController *rootViewCont;

@property(weak, nonatomic) IBOutlet UILabel *officeLabel;
@property(weak, nonatomic) IBOutlet UIButton *phoneNumberBtn;
@property(weak, nonatomic) IBOutlet UIButton *faceTimeBtn;
@property(weak, nonatomic) IBOutlet UIButton *audioFaceimeBtn;
@property(nonatomic, strong) MFMailComposeViewController *mailController;


@end
