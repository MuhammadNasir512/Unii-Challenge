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
ServerCommunicationControllerDelegate
>
{
    PostsTableViewController *postsTableVC;
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
    [self initNavigationBar];
    [self startLoadingDataFromServer];
}

- (void)initNavigationBar
{
    UINavigationBar *nBar = [[self navigationController] navigationBar];
    if ([nBar respondsToSelector:@selector(setBarTintColor:)])
    {
        [nBar setBarTintColor:[UIColor blueColor]];
        return;
    }
    if ([nBar respondsToSelector:@selector(setTintColor:)])
    {
        [nBar setTintColor:[UIColor blueColor]];
        return;
    }
}
- (void)startLoadingDataFromServer
{
    [self showActivityViewOnView:[self view]];
    NSString *urlString = @"http://unii-interview.herokuapp.com/api/v1/posts";
    ServerCommunicationController *scc = [[ServerCommunicationController alloc] init];
    [scc setDelegate:self];
    [scc setStringURLString:urlString];
    [scc sendRequestToServer];
}
- (void)showActivityViewOnView:(UIView*)viewSuperview
{
    [viewSuperview addSubview:[UIView getActivityViewWithMessage:@"Loading! Please Wait." inSuperview:viewSuperview]];
}
- (void)serverResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
    [UtilityMethods removeActivityViewOnView:[self view]];
    [UtilityMethods feedbackUserWithMessage:@"An error occured." inSuperview:[self view]];
}

- (void)serverResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
    [UtilityMethods removeActivityViewOnView:[self view]];
    NSMutableDictionary *mdResponse = [mutableDictionaryResponse objectForKey:@"Response"];
    NSMutableDictionary *mdPosts = [mdResponse objectForKey:@"posts"];
    NSMutableArray *mutableArrayPosts = (NSMutableArray*)[mdPosts objectForKey:@"data"];
    [self initPostsTableViewControllerWithData:mutableArrayPosts];
}

- (void)initPostsTableViewControllerWithData:(NSMutableArray*)mutableArrayPosts
{
    if (!postsTableVC)
    {
        postsTableVC = [[PostsTableViewController alloc] init];
    }
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
    }
}
@end
