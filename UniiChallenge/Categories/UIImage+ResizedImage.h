//
//  UIImage+ResizedImage.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 09/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ResizedImage)
{
    
}
+ (UIImage*)resizeImageWithRespectToHeight:(UIImage*)originalImage withTargetHeight:(float)targetHeight;
+ (UIImage*)cropImageWRTHeight:(UIImage*)image;
+ (UIImage*)cropImageWRTWidth:(UIImage*)image;
@end
