//
//  UNIIJsonParser.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 16/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "UNIIJsonParser.h"

@implementation UNIIJsonParser

@synthesize dataToParse;

- (NSMutableDictionary*)parseJson
{
    NSError *jsonParserError = nil;
    NSMutableDictionary *mdParsedJson =
    [NSJSONSerialization JSONObjectWithData:[self dataToParse]
                                    options:NSJSONReadingMutableContainers
                                      error:&jsonParserError];
    
    
    NSMutableDictionary *mdDataToReturn = [NSMutableDictionary dictionary];
    if (jsonParserError == nil || jsonParserError == NULL)
    {
        // Got response from server successfully
        [mdDataToReturn setObject:mdParsedJson forKey:@"ParsedData"];
    }
    else
    {
        // server response success but not a valid json response
        [mdDataToReturn setObject:jsonParserError forKey:@"Error"];
    }
    return mdDataToReturn;
}
@end
