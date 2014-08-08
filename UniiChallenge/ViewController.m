//
//  ViewController.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "ViewController.h"
#import "ServerCommunicationController.h"

@interface ViewController ()
<
ServerCommunicationControllerDelegate
>
{
    
}
@end

@implementation ViewController

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self startLoadingDataFromServer];
}

- (void)startLoadingDataFromServer
{
    NSString *urlString = @"http://unii-interview.herokuapp.com/api/v1/posts";
    ServerCommunicationController *scc = [[ServerCommunicationController alloc] init];
    [scc setStringURLString:urlString];
    [scc sendRequestToServer];
}

- (void)serverResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
}

- (void)serverResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
}

- (void)feedbackUserWithMessage:(NSString*)stringMessage
{
    
}
@end
