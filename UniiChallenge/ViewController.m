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

@interface ViewController ()
<
ServerCommunicationControllerDelegate,
PostsTableViewControllerDelegate
>
{
    PostsTableViewController *postsTableVC;
    NSMutableDictionary *mutableDictionaryNextPageInfo;
    NSString *stringFirstPageUrl;
    BOOL shouldAppendResults;
}
@property (nonatomic, weak) IBOutlet UIView *viewPlaceHoler;
@end

@implementation ViewController

@synthesize viewPlaceHoler = viewPlaceHolerWeak;

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

    float xx = viewPlaceHolerWeak.frame.origin.x;
    float yy = statusBarHeight + navigationBarHeight;
    yy = (systemVersion >= 7.0)?yy:0.0f;
    float ww = viewPlaceHolerWeak.frame.size.width;
    float hh = self.view.frame.size.height - yy;
    [viewPlaceHolerWeak setFrame:CGRectMake(xx, yy, ww, hh)];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    mutableDictionaryNextPageInfo = [NSMutableDictionary dictionary];
    stringFirstPageUrl = @"http://unii-interview.herokuapp.com/api/v1/posts";
    [self initNavigationBar];
    
    [self showActivityViewOnView:[self view]];
    [self startLoadingDataFromUrl:stringFirstPageUrl];
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
- (void)serverResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
    [UtilityMethods removeActivityViewFromView:[self view]];
    [UtilityMethods feedbackUserWithMessage:@"An error occured." inSuperview:[self view]];
}

- (void)serverResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
    [UtilityMethods removeActivityViewFromView:[self view]];
    NSMutableDictionary *mdResponse = [mutableDictionaryResponse objectForKey:@"Response"];
    NSMutableDictionary *mdPosts = [mdResponse objectForKey:@"posts"];
    
    mutableDictionaryNextPageInfo = [mdPosts objectForKey:@"pagination"];
    NSMutableArray *mutableArrayPosts = (NSMutableArray*)[mdPosts objectForKey:@"data"];
    [self initPostsTableViewControllerWithData:mutableArrayPosts];
}

- (void)initPostsTableViewControllerWithData:(NSMutableArray*)mutableArrayPosts
{
    if (!postsTableVC)
    {
        postsTableVC = [[PostsTableViewController alloc] init];
        [postsTableVC setDelegate:self];
    }
    NSMutableArray *maCurrentArray = [postsTableVC mutableArrayPosts];
    if (shouldAppendResults)
    {
        shouldAppendResults = NO;
        [maCurrentArray addObjectsFromArray:mutableArrayPosts];
        mutableArrayPosts = maCurrentArray;
    }
    else
    {
        [maCurrentArray removeAllObjects];
        [maCurrentArray addObjectsFromArray:mutableArrayPosts];
    }
    
    [postsTableVC setMutableArrayPosts:mutableArrayPosts];
    UIView *postsView = [viewPlaceHolerWeak viewWithTag:1212];
    if (!postsView)
    {
        float xx = 0.0f;
        float yy = 0.0f;
        float ww = viewPlaceHolerWeak.frame.size.width;
        float hh = viewPlaceHolerWeak.frame.size.height;
        postsView = [postsTableVC view];
        [postsView setTag:1212];
        [postsView setFrame:CGRectMake(xx, yy, ww, hh)];
        [viewPlaceHolerWeak addSubview:postsView];
        return;
    }
    [postsTableVC reloadTableViewData];
}

- (void)postsTableViewControllerDidRequestRefresh
{
    [self showActivityViewOnView:[self view]];
    [self startLoadingDataFromUrl:stringFirstPageUrl];
}
- (void)postsTableViewControllerDidScrollToEndOfList
{
    NSInteger intCurrentPage = [mutableDictionaryNextPageInfo[@"current_page"] integerValue];
    NSInteger intTotalPages = [mutableDictionaryNextPageInfo[@"total_pages"] integerValue];
//    intTotalPages = 2;
    if (intCurrentPage == intTotalPages)
    {
        [postsTableVC handleThatNoMorePagesToDisplay];
        return;
    }
    
    NSString *stringUrl = @"";
    if ([[mutableDictionaryNextPageInfo allKeys] count])
    {
        stringUrl = [mutableDictionaryNextPageInfo objectForKey:@"next_page"];
        stringUrl = stringUrl ? stringUrl : @"";
        stringUrl = (![stringUrl isEqual:[NSNull null]]) ? stringUrl : @"";
    }
    
    if ([stringUrl length])
    {
        shouldAppendResults = YES;
        [self startLoadingDataFromUrl:stringUrl];
    }
    
}

@end
