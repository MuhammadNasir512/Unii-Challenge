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

@implementation ServerCommunicationController

@synthesize delegate = _delegate;
@synthesize stringURLString;
@synthesize dataFromServerAsResponse;

- (void)dealloc
{
    dataFromServerAsResponse = nil;
    delegate = nil;
}

- (void)sendRequestToServer
{
    if (!dataFromServerAsResponse)
    {
        dataFromServerAsResponse = [[NSMutableData alloc] init];
    }
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:stringURLString]];
    NSURLConnection *urlConnection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    [urlConnection start];
}


/********************************************************************/
/**************** NSURLConnection Delegate Methods ******************/
/********************************************************************/

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
    [mdError setObject:stringURLString forKey:@"stringURLString"];
    [self dispatchServerResponseFailedWithError:mdError];
}
-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    dataFromServerAsResponse = [[NSMutableData alloc] init];
}
-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [dataFromServerAsResponse appendData:data];
}
- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
//    NSString *string = [[NSString alloc] initWithData:dataFromServerAsResponse encoding:NSUTF8StringEncoding];
    
    NSError *jsonParserError = nil;
    NSDictionary *dictionaryJsonResponseObject =
    [NSJSONSerialization JSONObjectWithData:dataFromServerAsResponse
                                    options:NSJSONReadingMutableContainers
                                      error:&jsonParserError];
    
    
    
    if (jsonParserError == nil || jsonParserError == NULL)
    {
        // Got response from server successfully
        NSMutableDictionary *mdResponseData = [[NSMutableDictionary alloc] init];
        [mdResponseData setObject:dictionaryJsonResponseObject forKey:@"Response"];
        [mdResponseData setObject:stringURLString forKey:@"stringURLString"];
        [self dispatchServerResponseSuccessfulWithData:mdResponseData];
    }
    else
    {
        // server response success but not a valid json response
        NSMutableDictionary *mdError = [[NSMutableDictionary alloc] init];
        [mdError setObject:jsonParserError forKey:@"Error"];
        [mdError setObject:stringURLString forKey:@"stringURLString"];
        [self dispatchServerResponseFailedWithError:mdError];
    }
}

/********************************************************************/
/********************** Delegate Dispatches *************************/
/********************************************************************/

- (void)dispatchServerResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
    [[self delegate] serverResponseSuccessfulWithData:mutableDictionaryResponse];
}
- (void)dispatchServerResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
    [[self delegate] serverResponseFailedWithError:mutableDictionaryError];
}

@end
