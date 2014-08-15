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
    
    NSError *jsonParserError = nil;
    NSDictionary *dictionaryJsonResponseObject =
    [NSJSONSerialization JSONObjectWithData:[self dataFromServerAsResponse]
                                    options:NSJSONReadingMutableContainers
                                      error:&jsonParserError];
    
    if (jsonParserError == nil || jsonParserError == NULL)
    {
        // Got response from server successfully
        NSMutableDictionary *mdResponseData = [[NSMutableDictionary alloc] init];
        [mdResponseData setObject:dictionaryJsonResponseObject forKey:@"Response"];
        [mdResponseData setObject:[self stringURLString] forKey:@"stringURLString"];
        [self dispatchServerResponseSuccessfulWithData:mdResponseData];
    }
    else
    {
        // server response success but not a valid json response
        NSMutableDictionary *mdError = [[NSMutableDictionary alloc] init];
        [mdError setObject:jsonParserError forKey:@"Error"];
        [mdError setObject:[self stringURLString] forKey:@"stringURLString"];
        [self dispatchServerResponseFailedWithError:mdError];
    }
}

/********************************************************************/
/********************** Delegate Dispatches *************************/
/********************************************************************/
#pragma mark - Delegate Dispatches

- (void)dispatchServerResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
    [[self delegate] serverResponseSuccessfulWithData:mutableDictionaryResponse];
}
- (void)dispatchServerResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
    [[self delegate] serverResponseFailedWithError:mutableDictionaryError];
}

@end
