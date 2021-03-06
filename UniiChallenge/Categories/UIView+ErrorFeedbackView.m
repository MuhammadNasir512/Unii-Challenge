//
//  UIView+ErrorFeedbackView.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "UIView+ErrorFeedbackView.h"

@implementation UIView (ErrorFeedbackView)

+ (UIView*)getErrorFeedbackViewWithMessage:(NSString*)stringMessage inSuperview:(UIView*)viewSuperview
{
    UIView *viewBG = [[UIView alloc] init];
    [viewBG setFrame:[viewSuperview frame]];
    [viewBG setBackgroundColor:[UIColor redColor]];
    [viewBG setAlpha:0.3];
    
    UIView *viewFG = [[UIView alloc] init];
    [viewFG setFrame:[viewSuperview frame]];
    [viewFG setBackgroundColor:[UIColor clearColor]];
    
    float padding = 20.0f;
    float ww = viewSuperview.frame.size.width - 2*padding;
    float hh = 100.0f;
    float xx = padding;
    float yy = (viewSuperview.frame.size.height - hh) / 2;
    
    UILabel *labelMessage = [[UILabel alloc] init];
    [labelMessage setFrame:CGRectMake(xx, yy, ww, hh)];
    [labelMessage setBackgroundColor:[UIColor blackColor]];
    [labelMessage setText:stringMessage];
    [labelMessage setTextAlignment:NSTextAlignmentCenter];
    [labelMessage setTextColor:[UIColor redColor]];
    [labelMessage setNumberOfLines:0];
    [viewFG addSubview:labelMessage];
    
    UIView *viewToReturn = [[UIView alloc] init];
    [viewToReturn setFrame:[viewSuperview frame]];
    [viewToReturn addSubview:viewBG];
    [viewToReturn addSubview:viewFG];
    
    return viewToReturn;
}

+ (UIView*)getActivityViewWithMessage:(NSString*)stringMessage inSuperview:(UIView*)viewSuperview
{
    UIView *viewBG = [[UIView alloc] init];
    [viewBG setFrame:[viewSuperview frame]];
    [viewBG setBackgroundColor:[UIColor blackColor]];
    [viewBG setAlpha:0.75];
    
    UIView *viewFG = [[UIView alloc] init];
    [viewFG setFrame:[viewSuperview frame]];
    [viewFG setBackgroundColor:[UIColor clearColor]];
    
    float padding = 20.0f;
    float ww = viewSuperview.frame.size.width - 2*padding;
    float hh = 30.0f;
    float xx = padding;
    float yy = (viewSuperview.frame.size.height - hh) / 2;
    
    UILabel *labelMessage = [[UILabel alloc] init];
    [labelMessage setFrame:CGRectMake(xx, yy, ww, hh)];
    [labelMessage setBackgroundColor:[UIColor clearColor]];
    [labelMessage setText:stringMessage];
    [labelMessage setTextAlignment:NSTextAlignmentCenter];
    [labelMessage setTextColor:[UIColor whiteColor]];
    [labelMessage setNumberOfLines:0];
    [viewFG addSubview:labelMessage];
    
    yy += hh;
    ww = hh;
    xx = (viewSuperview.frame.size.width - ww) / 2.0;
    UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    [aiv setFrame:CGRectMake(xx, yy, ww, hh)];
    [aiv startAnimating];
    [viewFG addSubview:aiv];
    
    UIView *viewToReturn = [[UIView alloc] init];
    [viewToReturn setFrame:[viewSuperview frame]];
    [viewToReturn setTag:kTagForActivityView]; // This tag will be used to remove it from superview later.
    [viewToReturn addSubview:viewBG];
    [viewToReturn addSubview:viewFG];
    
    return viewToReturn;
}

@end
