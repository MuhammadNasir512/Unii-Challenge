//
//  UNIIPostModel.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 15/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UNIIPostUserInfoModel;
@interface UNIIPostModel : NSObject <NSCoding>

@property (nonatomic, readonly, copy) UNIIPostUserInfoModel *uniPostUserInfo;
@property (nonatomic, readonly, copy) NSString *stringPostText;
@property (nonatomic, readonly, assign) NSInteger intCommentsCount;
@property (nonatomic, readonly, assign) NSInteger intLikesCount;

- (id)initWithPostText:(NSString*)stringPostText
          commentCount:(NSInteger)intCommentsCount
            likesCount:(NSInteger)intLikesCount
              userInfo:(UNIIPostUserInfoModel*)uniPostUserInfo;

@end
