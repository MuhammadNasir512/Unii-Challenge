//
//  UNIIJsonParser.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 16/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UNIIJsonParser : NSObject

@property (nonatomic, strong) NSData *dataToParse;
- (NSMutableDictionary*)parseJson;
@end
