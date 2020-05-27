//
//  ModelClass.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/12/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ModelClass : NSObject


@property(nonatomic, strong)NSDictionary *commentsDict;
@property(nonatomic, strong)NSDictionary *contactsDictionary;
@property(nonatomic, strong) NSString *firstName;
@property(nonatomic, strong) NSString *imageName;
@property(nonatomic, strong) NSString *lastName;

-(ModelClass *)parseDataWith:(NSDictionary*)responseArray;

@end
