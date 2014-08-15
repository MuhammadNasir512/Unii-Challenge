//
//  UNIIPostUserInfoModel.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 15/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "UNIIPostUserInfoModel.h"

@implementation UNIIPostUserInfoModel

@synthesize stringFirstName = stringFirstNameSynthesize;
@synthesize stringLastName = stringLastNameSynthesize;
@synthesize stringImageUrl = stringImageUrlSynthesize;
@synthesize imagePhoto = imagePhotoSynthesize;

- (id)initWithFirstName:(NSString*)stringFirstName
               lastName:(NSString*)stringLastName
               imageUrl:(NSString*)stringImageUrl
{
    if (self == [super init])
    {
        stringFirstNameSynthesize = stringFirstName;
        stringLastNameSynthesize = stringLastName;
        stringImageUrlSynthesize = stringImageUrl;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self)
    {
        stringFirstNameSynthesize = [aDecoder decodeObjectForKey:@"KeyFirstName"];
        stringLastNameSynthesize = [aDecoder decodeObjectForKey:@"KeyLastName"];
        stringImageUrlSynthesize = [aDecoder decodeObjectForKey:@"KeyImageUrl"];
    }
    return self;
}
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:[self stringFirstName] forKey:@"KeyFirstName"];
    [aCoder encodeObject:[self stringLastName] forKey:@"KeyLastName"];
    [aCoder encodeObject:[self stringImageUrl] forKey:@"KeyImageUrl"];
}

@end
