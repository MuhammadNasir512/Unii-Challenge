//
//  UIView+ErrorFeedbackView.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kTagForActivityView 121212

@interface UIView (ErrorFeedbackView)
{
    
}
+ (UIView*)getErrorFeedbackViewWithMessage:(NSString*)stringMessage inSuperview:(UIView*)viewSuperview;
+ (UIView*)getActivityViewWithMessage:(NSString*)stringMessage inSuperview:(UIView*)viewSuperview;
@end
