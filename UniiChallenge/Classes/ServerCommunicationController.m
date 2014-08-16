//
//  ServerCommunicationController.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "ServerCommunicationController.h"

@interface ServerCommunicationController ()
{
    
}
@property (nonatomic, strong) NSMutableData *dataFromServerAsResponse;
@end

#pragma mark - Implementation
@implementation ServerCommunicationController

#pragma mark - Synthesized Properties
@synthesize stringURLString;
@synthesize dataFromServerAsResponse;

- (void)dealloc
{
    [self setDataFromServerAsResponse:nil];
    [self setDelegate:nil];
}

/**
 *  This methods invokes url connection to load data asynchronously and dispatches delegate upon success or failure
 */
- (void)sendRequestToServer
{
    if (![self dataFromServerAsResponse])
    {
        self.dataFromServerAsResponse = [[NSMutableData alloc] init];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:[self stringURLString]]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
}


/********************************************************************/
/**************** NSURLConnection Delegate Methods ******************/
/********************************************************************/

#pragma mark - NSURLConnection Delegate Methods

- (NSURLRequest *)connection: (NSURLConnection *)inConnection
             willSendRequest: (NSURLRequest *)inRequest
            redirectResponse: (NSURLResponse *)inRedirectResponse
{
    if (inRedirectResponse)
    {
        NSMutableURLRequest *mutableRequestCopy = [inRequest mutableCopy];
        [mutableRequestCopy setURL: [inRequest URL]];
        return mutableRequestCopy;
    }
    else
    {
        return inRequest;
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSMutableDictionary *mdError = [[NSMutableDictionary alloc] init];
    [mdError setObject:error forKey:@"Error"];
    [mdError setObject:[self stringURLString] forKey:@"stringURLString"];
    [self dispatchServerResponseFailedWithError:mdError];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self dataFromServerAsResponse] appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSString *string = [[NSString alloc] initWithData:dataFromServerAsResponse encoding:NSUTF8StringEncoding];
    
    NSMutableDictionary *mdResponseData = [[NSMutableDictionary alloc] init];
    [mdResponseData setObject:[self dataFromServerAsResponse] forKey:@"Response"];
    [mdResponseData setObject:[self stringURLString] forKey:@"stringURLString"];
    [self dispatchServerResponseSuccessfulWithData:mdResponseData];
}

/********************************************************************/
/********************** Delegate Dispatches *************************/
/********************************************************************/
#pragma mark - Delegate Dispatches

/**
 *  If data was retrieved from provided URL successfully then this delegate message will be dispatched
 *
 *  @param mutableDictionaryResponse contain actual response and some metadata
 */
- (void)dispatchServerResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
    [[self delegate] serverResponseSuccessfulWithData:mutableDictionaryResponse];
}
/**
 *  If data was failed retrieved from provided URL then this delegate message will be dispatched
 *
 *  @param mutableDictionaryResponse contain error info and some metadata
 */
- (void)dispatchServerResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
    [[self delegate] serverResponseFailedWithError:mutableDictionaryError];
}

@end
