//
//  ViewControllerTests.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 10/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ViewController_ViewControllerExtension.h"
#import "ServerCommunicationController.h"
#import "UNIIJsonParser.h"

@interface ViewControllerTests : XCTestCase
<
ServerCommunicationControllerDelegate
>
{
    BOOL isCompleted;
    ViewController *viewController;
}
@end

@implementation ViewControllerTests

- (void)setUp
{
    [super setUp];
    viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    viewController = nil;
    [super tearDown];
}

- (void)testIfIBOutletConnectionForContainerViewExist
{
    [viewController performSelectorOnMainThread:@selector(loadView) withObject:nil waitUntilDone:YES];
    XCTAssertNotNil([viewController viewPlaceHoler], @"Place holder view cannot be nil");
}
- (void)testIfSelectorExistsToHandleForegroundState
{
    BOOL isSelectorThere = [viewController respondsToSelector:@selector(applicationBecameActive)];
    XCTAssertTrue(isSelectorThere, @"Method missing to handle background to foreground app state");
}
- (void)testInitsDoneProperly
{
    [viewController initObjects];
    
    // Testing url string initialization
    
    NSString *stringActual = [viewController stringFirstPageUrl];
    XCTAssertNotNil(stringActual, @"Url string cannot be nil");
    XCTAssertTrue([stringActual length], @"Url string cannot be empty string");
    
    NSString *stringExpected = @"http://unii-interview.herokuapp.com/api/v1/posts";
    XCTAssertTrue([stringActual isEqualToString:stringExpected], @"Url string is incorrect");
    
    
    // Testing navigations bar initialization
    
    UINavigationItem *navigationItem = [viewController navigationItem];
    UILabel *labelTitleView = (UILabel*)[navigationItem titleView];
    XCTAssertNotNil(labelTitleView, @"Navigation bar title not set");
    
    NSString *stringTitle = [labelTitleView text];
    XCTAssertTrue([stringTitle length], @"Title text cannot be empty");
    
    NSString *stringExpectedTitle = @"POSTS"; // Case sensitive
    XCTAssertTrue([stringTitle isEqualToString:stringExpectedTitle], @"Navigation bar title is incorrect");
    
}
- (void)testUrlIsWorking
{
    
    isCompleted = NO;
    NSString *stringFirstPageUrl = @"http://unii-interview.herokuapp.com/api/v1/posts";
    
    ServerCommunicationController *scc = [[ServerCommunicationController alloc] init];
    [scc setDelegate:self];
    [scc setStringURLString:stringFirstPageUrl];
    [scc sendRequestToServer];
    
    NSRunLoop *runLoop = [NSRunLoop currentRunLoop];
    while (!isCompleted && [runLoop runMode:NSDefaultRunLoopMode beforeDate:[NSDate distantFuture]]);
}

- (void)serverResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
    isCompleted = YES;
    XCTFail(@"Failed to get server response");
}

- (void)serverResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
    isCompleted = YES;
//    mutableDictionaryResponse = nil;
    XCTAssertNotNil(mutableDictionaryResponse, @"Failed to get response");
    
    NSData *data = [mutableDictionaryResponse objectForKey:@"Response"];
//    mdResponse = nil;
    XCTAssertNotNil(data, @"Failed to get response object");
    
    UNIIJsonParser *jsonParser = [[UNIIJsonParser alloc] init];
    [jsonParser setDataToParse:data];
    
    NSMutableDictionary *mdParserResponse = [jsonParser parseJson];
//    mdParserResponse = nil;
    XCTAssertNotNil(mdParserResponse, @"Failed to get Parsers Response");
    
    NSMutableDictionary *mdParsedData = [mdParserResponse objectForKey:@"ParsedData"];
//    mdParsedData = nil;
    XCTAssertNotNil(mdParsedData, @"Failed to get Parsed Data");

    NSMutableDictionary *mdPosts = [mdParsedData objectForKey:@"posts"];
//    mdPosts = nil;
    XCTAssertNotNil(mdPosts, @"Failed to get posts object");
    
    NSMutableArray *mutableArrayData = (NSMutableArray*)[mdPosts objectForKey:@"data"];
//    mutableArrayData = nil;
    XCTAssertNotNil(mutableArrayData, @"Failed to get posts array");
    
    jsonParser = nil;
}

@end
