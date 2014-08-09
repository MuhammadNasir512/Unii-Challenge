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

+ (void)removeActivityViewFromView:(UIView*)viewSuperview
{
    UIView *viewActivityView = [viewSuperview viewWithTag:kTagForActivityView];
    [viewActivityView removeFromSuperview];
}

+ (CGSize)createSizeFitToTextForLabel:(UILabel*)label withMaximumSize:(CGSize)sizeMaximum
{
    CGSize expectedLabelSize;
    if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_6_1)
    {
        // ios 6
        expectedLabelSize = [[label text] sizeWithFont:[label font]
                                     constrainedToSize:sizeMaximum
                                         lineBreakMode:[label lineBreakMode]];
    }
    else
    {
        // ios 7
        NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                              [label font], NSFontAttributeName,
                                              nil];
        
        CGRect frame = [[label text] boundingRectWithSize:sizeMaximum
                                                  options:(NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading)
                                               attributes:attributesDictionary
                                                  context:nil];
        expectedLabelSize = CGRectIntegral(frame).size;
    }
    return expectedLabelSize;
}

+ (CGSize)getRecommendedSizeForLabel:(UILabel*)label
{
    float maxW = label.frame.size.width;
    float maxH = label.frame.size.height;
    CGSize sizeMax = CGSizeMake(maxW, maxH);
    CGSize sizeRecommended = [UtilityMethods createSizeFitToTextForLabel:label withMaximumSize:sizeMax];
    return sizeRecommended;
}

+ (void)createFrameForView:(UIView*)viewToAdjust withSize:(CGSize)sizeRecommended
{
    float ww = viewToAdjust.frame.size.width;
    float hh = sizeRecommended.height;
    float xx = (viewToAdjust.superview.frame.size.width - ww) / 2;
    float yy = viewToAdjust.frame.origin.y;
    viewToAdjust.frame = CGRectMake(xx, yy, ww, hh);
}

+ (void)adjustFrameVerticallyForView:(UIView*)viewToAdjust toShowBelowView:(UIView*)viewAbove withPadding:(CGFloat)padding
{
    float xx = viewToAdjust.frame.origin.x;
    float yy = viewAbove.frame.origin.y + viewAbove.frame.size.height + padding;
    float ww = viewToAdjust.frame.size.width;
    float hh = viewToAdjust.frame.size.height;
    [viewToAdjust setFrame:CGRectMake(xx, yy, ww, hh)];
}

+ (UIImage*)resizeImageWithRespectToHeight:(UIImage*)originalImage withTargetHeight:(float)targetHeight
{
    UIImage *resizedImage;
    CGSize sizeOfOriginalImage = [originalImage size];
    
    float scale = 0.0;
    float originalImageWidth = (float)sizeOfOriginalImage.width;
    float originalImageHeight = (float)sizeOfOriginalImage.height;
    
    if (originalImageHeight > targetHeight)
    {
        scale = targetHeight/originalImageHeight;
    }
    else
    {
        scale = originalImageHeight/targetHeight;
    }
    
    CGSize destinationImageSize = CGSizeMake(originalImageWidth*scale, originalImageHeight*scale);
    //UIGraphicsBeginImageContext(destinationImageSize);
    UIGraphicsBeginImageContext(destinationImageSize);
    [originalImage drawInRect:CGRectMake(0,0,destinationImageSize.width, destinationImageSize.height)];
    resizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resizedImage;
}

@end
