//
//  JSONParser.m
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/19/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import "JSONParser.h"

@implementation JSONParser

-(id)parseJSONDataWithData:(NSData*)data
{
    id object = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    return object;
}

@end
