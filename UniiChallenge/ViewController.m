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
    [scc setDelegate:self];
    [scc setStringURLString:urlString];
    [scc sendRequestToServer];
}

- (void)serverResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
}

- (void)serverResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
    [self feedbackUserWithMessage:@"An error occured."];
}

- (void)feedbackUserWithMessage:(NSString*)stringMessage
{
    CGFloat floatDuration = 3.0f;
    stringMessage = [NSString stringWithFormat:@"%@\n%@ %f seconds", stringMessage, @"This view will be dismissed in", floatDuration];
    
    UIView *viewErrorFeedback = [UIView getErrorFeedbackViewWithMessage:stringMessage inSuperview:self.view];
    [[self view] addSubview:viewErrorFeedback];
    [viewErrorFeedback setAlpha:0.0f];
    
    [UIView animateWithDuration:1.0 animations:^{
        [viewErrorFeedback setAlpha:1.0f];
        
    } completion:^(BOOL finished) {

        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 2*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:1.0 animations:^{
                [viewErrorFeedback setAlpha:0.0f];
                
            } completion:^(BOOL finished) {
                
                [viewErrorFeedback removeFromSuperview];
            }];
        });
    }];
}
@end
