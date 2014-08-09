//
//  UtilityMethods.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UtilityMethods : NSObject
{
    
}
+ (void)feedbackUserWithMessage:(NSString*)stringMessage inSuperview:(UIView*)viewSuperview;
+ (void)removeActivityViewFromView:(UIView*)viewSuperview;
+ (CGSize)createSizeFitToTextForLabel:(UILabel*)label withMaximumSize:(CGSize)sizeMaximum;
+ (CGSize)getRecommendedSizeForLabel:(UILabel*)label;
+ (void)createFrameForView:(UIView*)viewToAdjust withSize:(CGSize)sizeRecommended;
+ (void)adjustFrameVerticallyForView:(UIView*)viewToAdjust toShowBelowView:(UIView*)viewAbove withPadding:(CGFloat)padding;
@end
