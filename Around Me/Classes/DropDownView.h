//
//  DropDownView.h
//  LookAround
//
//  Created by Patil, Chandrachud K. on 12/15/14.
//  Copyright (c) 2014 Jean-Pierre Distler. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DropDownView;

@protocol NIDropDownDelegate

- (void) niDropDownDelegateMethod: (DropDownView *) sender;
@end

@interface DropDownView : UIView <UITableViewDelegate, UITableViewDataSource>
{
    NSString *animationDirection;
    UIImageView *imgView;
}
@property (nonatomic, weak) id <NIDropDownDelegate> delegate;
@property (nonatomic, strong) NSString *animationDirection;

-(void)hideDropDown:(UIButton *)b;

-(id)showDropDown:(UIButton *)b height:(CGFloat *)height arr:(NSArray *)arr imgArr:(NSArray *)imgArr direction:(NSString *)direction;
@end