//
//  UtilityMethods.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "UtilityMethods.h"

@implementation UtilityMethods

+ (void)feedbackUserWithMessage:(NSString*)stringMessage inSuperview:(UIView*)viewSuperview
{
    CGFloat floatDuration = 3.0f;
    stringMessage = [NSString stringWithFormat:@"%@\n%@ %.f seconds", stringMessage, @"This view will be dismissed in", floatDuration];
    
    UIView *viewErrorFeedback = [UIView getErrorFeedbackViewWithMessage:stringMessage inSuperview:viewSuperview];
    [viewSuperview addSubview:viewErrorFeedback];
    [viewErrorFeedback setAlpha:0.0f];
    
    [UIView animateWithDuration:1.0 animations:^{
        [viewErrorFeedback setAlpha:1.0f];
        
    } completion:^(BOOL finished) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1.0 animations:^{
                [viewErrorFeedback setAlpha:0.0f];
                
            } completion:^(BOOL finished) {
                
                [viewErrorFeedback removeFromSuperview];
            }];
        });
    }];
}

+ (void)removeActivityViewOnView:(UIView*)viewSuperview
{
    UIView *viewActivityView = [viewSuperview viewWithTag:kTagForActivityView];
    [viewActivityView removeFromSuperview];
}

@end
