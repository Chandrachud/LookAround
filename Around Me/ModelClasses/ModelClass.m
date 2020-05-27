//
//  ModelClass.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/12/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//
NSString *const K_COMMENTS_KEY = @"comments";
NSString *const K_FIRSTNAME_KEY = @"firstName";
NSString *const K_LASTNAME_KEY = @"lastName";
NSString *const K_IMAGENAME_KEY = @"image";
NSString *const K_CONTACT_KEY = @"contact";

#import "ModelClass.h"

@implementation ModelClass


-(ModelClass *)parseDataWith:(NSDictionary *)responseArray
{
    self.commentsDict = [NSDictionary dictionary];
    self.commentsDict =[responseArray objectForKey:K_COMMENTS_KEY];
    self.contactsDictionary = [responseArray valueForKey:K_CONTACT_KEY];
    _firstName = [responseArray valueForKey:K_FIRSTNAME_KEY];
    _lastName = [responseArray valueForKey:K_LASTNAME_KEY];
    _imageName = [responseArray valueForKey:K_IMAGENAME_KEY];
    
    return self;
}

-(void)dealloc
{
    _commentsDict = nil;
    _contactsDictionary = nil;
    _firstName = nil;
    _lastName = nil;
    _imageName = nil;
}

@end
