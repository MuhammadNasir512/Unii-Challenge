//
//  UNIIPostModel.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 15/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "UNIIPostModel.h"
#import "UNIIPostUserInfoModel.h"

@implementation UNIIPostModel

@synthesize stringPostText = stringPostTextSynthesize;
@synthesize intCommentsCount = intCommentCountSynthesize;
@synthesize intLikesCount = intLikesCountSynthesize;
@synthesize uniPostUserInfo = uniPostUserInfoSynthesize;

- (id)initWithPostText:(NSString*)stringPostText
          commentCount:(NSInteger)intCommentsCount
            likesCount:(NSInteger)intLikesCount
              userInfo:(UNIIPostUserInfoModel*)uniPostUserInfo
{
    if (self == [super init])
    {
        stringPostTextSynthesize = stringPostText;
        intCommentCountSynthesize = intCommentsCount;
        intLikesCountSynthesize = intLikesCount;
        uniPostUserInfoSynthesize = uniPostUserInfo;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        stringPostTextSynthesize = [aDecoder decodeObjectForKey:@"KeyPostText"];
        intCommentCountSynthesize = [aDecoder decodeIntegerForKey:@"KeyCommentsCount"];
        intLikesCountSynthesize = [aDecoder decodeIntegerForKey:@"KeyLikesCount"];
        uniPostUserInfoSynthesize = [aDecoder decodeObjectForKey:@"KeyMDUserInfo"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self stringPostText] forKey:@"KeyPostText"];
    [aCoder encodeInteger:[self intCommentsCount] forKey:@"KeyCommentsCount"];
    [aCoder encodeInteger:[self intLikesCount] forKey:@"KeyLikesCount"];
    [aCoder encodeObject:[self uniPostUserInfo] forKey:@"KeyMDUserInfo"];
}


@end
