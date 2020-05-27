//
//  LoginViewController.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/10/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController

@property(strong, nonatomic) IBOutlet UITextField *userNameField;
@property(strong, nonatomic) IBOutlet UITextField *passwordField;
@property(strong, nonatomic) IBOutlet UIButton *loginButton;

@end
