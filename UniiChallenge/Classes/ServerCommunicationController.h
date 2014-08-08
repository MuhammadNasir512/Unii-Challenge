//
//  ServerCommunicationController.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ServerCommunicationControllerDelegate <NSObject>

- (void)serverResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse;
- (void)serverResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError;

@end

@interface ServerCommunicationController : NSObject
<
NSURLConnectionDelegate
>
{
    id <ServerCommunicationControllerDelegate> delegate;
}

@property (nonatomic, weak) id <ServerCommunicationControllerDelegate> delegate;
@property (nonatomic, strong) NSString *stringURLString;
@property (nonatomic, strong) NSMutableData *dataFromServerAsResponse;

- (void)sendRequestToServer;

@end
