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
}
@property (nonatomic, weak) IBOutlet UIView *viewPlaceHoler;
@property (nonatomic, assign, setter = setThisVCAlreadyLoaded:) BOOL isThisVCAlreadyLoaded;
@property (nonatomic, assign) BOOL shouldAppendResults;
@property (nonatomic, strong) NSString *stringFirstPageUrl;
@property (nonatomic, strong) NSMutableDictionary *mutableDictionaryNextPageInfo;
@property (nonatomic, strong) PostsTableViewController *postsTableVC;
@end

@implementation ViewController

@synthesize stringFirstPageUrl;
@synthesize postsTableVC;

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
    
    [self setMutableDictionaryNextPageInfo:[mdPosts objectForKey:@"pagination"]];
    NSMutableArray *mutableArrayPosts = (NSMutableArray*)[mdPosts objectForKey:@"data"];
    [self initPostsTableViewControllerWithData:mutableArrayPosts];
    [self setThisVCAlreadyLoaded:YES];
}

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
- (void)applicationBecameActive
{
    if ([self isThisVCAlreadyLoaded])
    {
        [self showActivityViewOnView:[self view]];
        [self startLoadingDataFromUrl:[self stringFirstPageUrl]];
    }
}
@end
