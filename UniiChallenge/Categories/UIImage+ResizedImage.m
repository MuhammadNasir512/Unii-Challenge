//
//  UIImage+ResizedImage.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 09/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "UIImage+ResizedImage.h"

@implementation UIImage (ResizedImage)

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

+ (UIImage*)cropImageWRTHeight:(UIImage*)image
{
    float hh = image.size.height;
    float ww = hh;
    float xx = (image.size.width - hh)/2;
    float yy = 0;
    CGRect rectCrop = CGRectMake(xx, yy, ww, hh);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rectCrop);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

+ (UIImage*)cropImageWRTWidth:(UIImage*)image
{
    float ww = image.size.width;
    float hh = ww;
    float xx = 0.0f;
    float yy = (image.size.height - ww)/2;
    CGRect rectCrop = CGRectMake(xx, yy, ww, hh);
    CGImageRef imageRef = CGImageCreateWithImageInRect([image CGImage], rectCrop);
    image = [UIImage imageWithCGImage:imageRef];
    CGImageRelease(imageRef);
    return image;
}

@end
