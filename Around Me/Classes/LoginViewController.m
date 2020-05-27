//
//  LoginViewController.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/19/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "LoginViewController.h"
#import <LocalAuthentication/LocalAuthentication.h>
#import "MainViewController.h"
//#import "ServerCommunicator.h"
#import "IQKeyboardManager.h"

@interface LoginViewController ()

@property(nonatomic, strong)MainViewController *mainViewController;

@end

@implementation LoginViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.mainViewController = [[UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil] instantiateViewControllerWithIdentifier:@"MainViewController"];
    [self.loginButton addTarget:self action:@selector(loginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    //    ServerCommunicator *comm = [[ServerCommunicator alloc]init];
    //    [comm requestWithQuery:@""];
    self.userNameField.text = @"admin";
    self.passwordField.text = @"password";
    
    [self.userNameField setHidden:YES];
    [self.passwordField setHidden:YES];
    [self.loginButton setHidden:YES];
    
    [self authenticateButtonTapped];
    
    [[IQKeyboardManager sharedManager] setToolbarManageBehaviour:IQAutoToolbarByPosition];
    [IQKeyboardManager sharedManager].shouldToolbarUsesTextFieldTintColor = YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    _mainViewController = nil;
}
#pragma mark - Other Useful Methods

-(void)loginButtonClicked
{
    
    if ([self.userNameField.text isEqualToString: @"admin"] && [self.passwordField.text isEqualToString:@"password"]) {
        
        [self.navigationController pushViewController:self.mainViewController animated:YES];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Invalid Logon" message:@"Please enter a valid login credentials" delegate:self cancelButtonTitle:nil otherButtonTitles:@"ok", nil];
        [alert show];
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

#pragma mark - Other Methods

-(void)authenticateButtonTapped
{
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    
    LAContext *context = [[LAContext alloc] init];
    
    NSError *error = nil;
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        activityIndicator.center=self.view.center;
        [activityIndicator startAnimating];
        UILabel *lbl = [[UILabel alloc] initWithFrame:CGRectMake(-40, 20, 150, 30)];
        lbl.text = @"Authenticating";
        [activityIndicator addSubview:lbl];
        [self.view addSubview:activityIndicator];
        
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics
                localizedReason:@"Are you the device owner?"
                          reply:^(BOOL success, NSError *error) {
                              
                              if (error) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      [activityIndicator stopAnimating];
                                      
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                      message:@"There was a problem verifying your identity."
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"Ok"
                                                                            otherButtonTitles:nil];
                                      [alert show];
                                  });
                                  return;
                              }
                              
                              if (success) {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      [self.navigationController pushViewController:self.mainViewController animated:YES];
                                      [activityIndicator stopAnimating];
                                      
                                  });
                                  
                              } else {
                                  dispatch_async(dispatch_get_main_queue(), ^{
                                      
                                      [activityIndicator stopAnimating];
                                      
                                      UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                      message:@"You are not the device owner."
                                                                                     delegate:nil
                                                                            cancelButtonTitle:@"Ok"
                                                                            otherButtonTitles:nil];
                                      [alert show];
                                  });
                              }
                              
                          }];
        
    }
    else
    {
        [activityIndicator stopAnimating];
        [self otherAuthentication];
    }
}

-(void)otherAuthentication
{
    
    [self.userNameField setHidden:NO];
    [self.passwordField setHidden:NO];
    [self.loginButton setHidden:NO];
    
}


@end
