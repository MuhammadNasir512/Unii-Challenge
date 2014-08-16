//
//  ViewController.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "ViewController.h"
#import "ServerCommunicationController.h"
#import "PostsTableViewController.h"
#import "UNIIPostUserInfoModel.h"
#import "UNIIJsonParser.h"
#import "UNIIPostModel.h"

#pragma mark - Private Interface
@interface ViewController ()
<
ServerCommunicationControllerDelegate,
PostsTableViewControllerDelegate
>
{
}
@property (nonatomic, weak) IBOutlet UIView *viewPlaceHoler;
@property (nonatomic, assign, setter = setThisVCAlreadyLoaded:) BOOL isThisVCAlreadyLoaded;
@property (nonatomic, assign) BOOL shouldAppendResults;
@property (nonatomic, strong) NSString *stringFirstPageUrl;
@property (nonatomic, strong) NSMutableDictionary *mutableDictionaryNextPageInfo;
@property (nonatomic, strong) PostsTableViewController *postsTableVC;
@end

#pragma mark - Implementation
@implementation ViewController

#pragma mark - Synthesized Properties
@synthesize stringFirstPageUrl;
@synthesize postsTableVC;

#pragma mark - UIViewController Delegate and Inits
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    float systemVersion = [[UIDevice currentDevice].systemVersion floatValue];
    float statusBarHeight = [[UIApplication sharedApplication] statusBarFrame].size.height;
    float navigationBarHeight = self.navigationController.navigationBar.frame.size.height;

    float xx = self.viewPlaceHoler.frame.origin.x;
    float yy = statusBarHeight + navigationBarHeight;
    yy = (systemVersion >= 7.0)?yy:0.0f;
    float ww = self.viewPlaceHoler.frame.size.width;
    float hh = self.view.frame.size.height - yy;
    [self.viewPlaceHoler setFrame:CGRectMake(xx, yy, ww, hh)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initObjects];
    [self showActivityViewOnView:[self view]];
    [self startLoadingDataFromUrl:[self stringFirstPageUrl]];
}

- (void)initObjects
{
    [self setStringFirstPageUrl:@"http://unii-interview.herokuapp.com/api/v1/posts"];
    [self initNavigationBar];
}
- (void)initNavigationBar
{
    UINavigationBar *nBar = [[self navigationController] navigationBar];
    [UtilityMethods createNavigationBarTitleLabelWithText:@"POSTS" withNavigationBar:nBar withNavigationItem:[self navigationItem]];

    UIColor *colorBarTint = [UIColor colorWithRed:41.0f/256.0f green:122.0f/256.0f blue:204.0f/256.0f alpha:1.0f];
    if ([nBar respondsToSelector:@selector(setBarTintColor:)])
    {
        [nBar setBarTintColor:colorBarTint];
        return;
    }
    if ([nBar respondsToSelector:@selector(setTintColor:)])
    {
        [nBar setTintColor:colorBarTint];
        return;
    }
}
#pragma mark - ServerCommunication Stuff

- (void)showActivityViewOnView:(UIView*)viewSuperview
{
    [viewSuperview addSubview:[UIView getActivityViewWithMessage:@"Loading! Please Wait." inSuperview:viewSuperview]];
}
- (void)startLoadingDataFromUrl:(NSString*)stringUrlString
{
    NSString *urlString = stringUrlString;
    ServerCommunicationController *scc = [[ServerCommunicationController alloc] init];
    [scc setDelegate:self];
    [scc setStringURLString:urlString];
    [scc sendRequestToServer];
}

#pragma mark - JSON Parsing, Error Handling

- (void)serverResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
    [UtilityMethods removeActivityViewFromView:[self view]];
    [UtilityMethods feedbackUserWithMessage:@"An error occured." inSuperview:[self view]];
}

- (void)serverResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
    [UtilityMethods removeActivityViewFromView:[self view]];
    NSData *data = (NSData*)[mutableDictionaryResponse objectForKey:@"Response"];

    NSMutableArray *mutableArrayPosts = [NSMutableArray array];
    NSMutableArray *mutableArrayPostsModel = [NSMutableArray array];

    UNIIJsonParser *jsonParser = [[UNIIJsonParser alloc] init];
    [jsonParser setDataToParse:data];
    NSMutableDictionary *mdParserResponse = [jsonParser parseJson];
    NSMutableDictionary *mdParsedData = [mdParserResponse objectForKey:@"ParsedData"];
    if (mdParsedData)
    {
        NSMutableDictionary *mdPosts = [mdParsedData objectForKey:@"posts"];
        [self setMutableDictionaryNextPageInfo:[mdPosts objectForKey:@"pagination"]];
        mutableArrayPosts = (NSMutableArray*)[mdPosts objectForKey:@"data"];
        mutableArrayPostsModel = [self createPostsModelArrayWithData:mutableArrayPosts];
    }
    else
    {
        [UtilityMethods feedbackUserWithMessage:@"An error occured while loading posts.\nYou may try again later." inSuperview:[self view]];
    }
    [self initPostsTableViewControllerWithData:mutableArrayPostsModel];
    [self setThisVCAlreadyLoaded:YES];
}

#pragma mark - Initializing Posts TableVC

- (void)initPostsTableViewControllerWithData:(NSMutableArray*)mutableArrayPosts
{
    if (![self postsTableVC])
    {
        self.postsTableVC = [[PostsTableViewController alloc] init];
        [[self postsTableVC] setDelegate:self];
    }
    NSMutableArray *maCurrentArray = [[self postsTableVC] mutableArrayPosts];
    if ([self shouldAppendResults])
    {
        [self setShouldAppendResults:YES];
        [maCurrentArray addObjectsFromArray:mutableArrayPosts];
        mutableArrayPosts = maCurrentArray;
    }
    else
    {
        [maCurrentArray removeAllObjects];
        [maCurrentArray addObjectsFromArray:mutableArrayPosts];
    }
    
    [[self postsTableVC] setMutableArrayPosts:mutableArrayPosts];
    UIView *postsView = [self.viewPlaceHoler viewWithTag:1212];
    if (!postsView)
    {
        float xx = 0.0f;
        float yy = 0.0f;
        float ww = self.viewPlaceHoler.frame.size.width;
        float hh = self.viewPlaceHoler.frame.size.height;
        postsView = [[self postsTableVC] view];
        [postsView setTag:1212];
        [postsView setFrame:CGRectMake(xx, yy, ww, hh)];
        [self.viewPlaceHoler addSubview:postsView];
        return;
    }
    [[self postsTableVC] reloadTableViewData];
}

#pragma mark - PostsTableViewControllerDelegate

- (void)postsTableViewControllerDidRequestRefresh
{
    [self showActivityViewOnView:[self view]];
    [self startLoadingDataFromUrl:stringFirstPageUrl];
}
- (void)postsTableViewControllerDidScrollToEndOfList
{
    NSInteger intCurrentPage = [[self mutableDictionaryNextPageInfo][@"current_page"] integerValue];
    NSInteger intTotalPages = [[self mutableDictionaryNextPageInfo][@"total_pages"] integerValue];
//    intTotalPages = 2;
    if (intCurrentPage == intTotalPages)
    {
        [[self postsTableVC] handleThatNoMorePagesToDisplay];
        return;
    }
    
    NSString *stringUrl = @"";
    if ([[[self mutableDictionaryNextPageInfo] allKeys] count])
    {
        stringUrl = [[self mutableDictionaryNextPageInfo] objectForKey:@"next_page"];
        stringUrl = stringUrl ? stringUrl : @"";
        stringUrl = (![stringUrl isEqual:[NSNull null]]) ? stringUrl : @"";
    }
    
    if ([stringUrl length])
    {
        [self setShouldAppendResults:YES];
        [self startLoadingDataFromUrl:stringUrl];
    }
    
}

#pragma mark - DataModelling

- (NSMutableArray*)createPostsModelArrayWithData:(NSMutableArray*)mutableArrayPosts
{
    NSMutableArray *maDataToRetun = [NSMutableArray array];
    [mutableArrayPosts enumerateObjectsUsingBlock:^(NSMutableDictionary *mdOneItem, NSUInteger index, BOOL *stop) {
        
        // Post text contents
        NSString *stringPostText = [mdOneItem objectForKey:@"content"];
        stringPostText = (stringPostText && ![stringPostText isEqual:[NSNull null]])? stringPostText : @"";
        
        // Comments and likes count
        NSInteger intCommentsCount = [[mdOneItem objectForKey:@"comment_count"] integerValue];
        NSInteger intLikesCount = [[mdOneItem objectForKey:@"like_count"] integerValue];

        // User Info Dictionary
        NSMutableDictionary *mdUserInfo = [mdOneItem objectForKey:@"user"];
        mdUserInfo = (mdUserInfo && ![mdUserInfo isEqual:[NSNull null]])? mdUserInfo : [NSMutableDictionary dictionary];
        
        // First NAme
        NSString *stringFirstName = [mdUserInfo objectForKey:@"first_name"];
        stringFirstName = (stringFirstName && ![stringFirstName isEqual:[NSNull null]])? stringFirstName : @"";
        
        // Last Name
        NSString *stringLastName = [mdUserInfo objectForKey:@"last_name"];
        stringLastName = (stringLastName && ![stringLastName isEqual:[NSNull null]])? stringLastName : @"";
        
        // Image url string
        NSString *stringImageUrl = [mdUserInfo objectForKey:@"avatar"];
        stringImageUrl = (stringImageUrl && ![stringImageUrl isEqual:[NSNull null]])? stringImageUrl : @"";
        
        // Creating user info model object
        UNIIPostUserInfoModel *postModelUserInfo = [[UNIIPostUserInfoModel alloc] initWithFirstName:stringFirstName lastName:stringLastName imageUrl:stringImageUrl];
        
        // Creating post model object
        UNIIPostModel *postModel = [[UNIIPostModel alloc] initWithPostText:stringPostText
                                                              commentCount:intCommentsCount
                                                                likesCount:intLikesCount
                                                                  userInfo:postModelUserInfo];
        [maDataToRetun addObject:postModel];
    }];
    return maDataToRetun;
}

#pragma mark - App state Notification

/**
 *  When app state changes to active state then we need to reload posts through this method.
 */
- (void)applicationBecameActive
{
    if ([self isThisVCAlreadyLoaded])
    {
        [self showActivityViewOnView:[self view]];
        [self startLoadingDataFromUrl:[self stringFirstPageUrl]];
    }
}
@end
