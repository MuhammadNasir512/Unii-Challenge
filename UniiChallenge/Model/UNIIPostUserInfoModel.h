//
//  UNIIPostUserInfoModel.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 15/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNIIPostUserInfoModel : NSObject <NSCoding>

@property (nonatomic, readonly, copy) NSString *stringFirstName;
@property (nonatomic, readonly, copy) NSString *stringLastName;
@property (nonatomic, readonly, copy) NSString *stringImageUrl;
@property (nonatomic, readwrite) UIImage *imagePhoto;

- (id)initWithFirstName:(NSString*)stringFirstName
               lastName:(NSString*)stringLastName
               imageUrl:(NSString*)stringImageUrl;

@end
