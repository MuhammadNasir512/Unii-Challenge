//
//  PostsTableViewController.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "PostsTableViewController.h"
#import "ServerCommunicationController.h"
#import "UNIIPostUserInfoModel.h"
#import "UNIIPostModel.h"
#import "PostCell.h"

#pragma mark - Private Interface

@interface PostsTableViewController ()
<
ServerCommunicationControllerDelegate,
UITableViewDataSource,
UITableViewDelegate,
PostCellDelegate
>
@property (nonatomic, weak) IBOutlet UITableView *tableViewPosts;
@property (nonatomic, assign) BOOL disallowLoadingMorePosts;
@property (nonatomic, assign) BOOL loadMoreVenuesAutomatically;
@property (nonatomic, assign) CGFloat loadingCellHeight;
@property (nonatomic, strong) PostCell *postCellFromNib;
@end

#pragma mark - Implementation
@implementation PostsTableViewController

#pragma mark - Synthesized Properties
@synthesize mutableArrayPosts;

#pragma mark - UIViewController Delegate and Inits
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    float padding = 0.0f;
    float xx = [self tableViewPosts].frame.origin.x;
    float yy = padding;
    float ww = [self tableViewPosts].frame.size.width;
    float hh = self.view.frame.size.height - yy - padding;
    [[self tableViewPosts] setFrame:CGRectMake(xx, yy, ww, hh)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // following variable switches whether to load more posts automatically when reach the end of the list
    // or like to tap last cell to load more post
    [self setLoadMoreVenuesAutomatically:NO];
    [self startDownloadingImages];
    [self initTableView];
}
/**
 *  This method adds pull to refresh controll, set data source and delegate to table view
 and setup properties to calculate cell height dynamically
 */
- (void)initTableView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
    [self setPostCellFromNib:(PostCell*)[nib objectAtIndex:0]];
    [self setLoadingCellHeight:100.0f];
    if (![[self tableViewPosts] delegate])
    {
        [[self tableViewPosts] setDelegate:self];
    }
    if (![[self tableViewPosts] dataSource])
    {
        [[self tableViewPosts] setDataSource:self];
    }
    [self addPullToRefreshControll];
}

#pragma mark - Added Pull To Refresh Control

- (void)addPullToRefreshControll
{
    UIRefreshControl *refreshControlPull = [[UIRefreshControl alloc] init];
    [refreshControlPull addTarget:self action:@selector(refreshControlActionSelector:) forControlEvents:UIControlEventValueChanged];
    [[self tableViewPosts] addSubview:refreshControlPull];
}
- (void)refreshControlActionSelector:(UIRefreshControl*)refreshControl
{
    [[self delegate] postsTableViewControllerDidRequestRefresh];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       
        [refreshControl endRefreshing];
    });
}

#pragma mark - UITableViewDataSource and UITableViewDelegate

/**
 *  Reloads the table view. Its required when a more posts are loaded or when app state changes to foreground etc
 */
- (void)reloadTableViewData
{
    [[self tableViewPosts] reloadData];
    [self startDownloadingImages];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = [self loadingCellHeight];
    if ([indexPath row] >= [mutableArrayPosts count])
    {
        return height;
    }

    UNIIPostModel *postModel = (UNIIPostModel*)mutableArrayPosts[[indexPath row]];
    [[self postCellFromNib] setUniiPostModel:postModel];
    height = [[self postCellFromNib] getHeightForRow];
    
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger intRowsToReturn = [mutableArrayPosts count]+1;
    return intRowsToReturn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *StringPostCell = @"PostCell";
    static NSString *StringLoadingCell = @"LoadingCell";
    
    if ([indexPath row] >= [mutableArrayPosts count])
    {
        [self setDisallowLoadingMorePosts:NO];
        NSString *stringLoadingCellText = @"";
        
        if ([self loadMoreVenuesAutomatically])
        {
            stringLoadingCellText = @"Loading more posts!\nPlease Wait...";
        }
        else
        {
            stringLoadingCellText = @"Tap here to load more posts!";
        }
        
        UITableViewCell *cellLoading = [tableView dequeueReusableCellWithIdentifier:StringLoadingCell];
        if (!cellLoading)
        {
            cellLoading = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StringLoadingCell];
            [cellLoading setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cellLoading setBackgroundColor:[UIColor clearColor]];
            
            CGFloat padding = 10.0f;
            CGRect rect = [cellLoading frame];
            rect.origin.x = padding;
            rect.origin.y = padding;
            rect.size.height = [self loadingCellHeight]-2*padding;
            rect.size.width = tableView.frame.size.width-2*padding;
            
            UILabel *labelLoadingText = [[UILabel alloc] init];
            [labelLoadingText setFrame:rect];
            [labelLoadingText setTag:9292];
            [labelLoadingText setFont:[UIFont fontWithName:@"Avenir-Heavy" size:18.0f]];
            [labelLoadingText setBackgroundColor:[UIColor whiteColor]];
            [labelLoadingText setTextColor:[UIColor blackColor]];
            [labelLoadingText setTextAlignment:NSTextAlignmentCenter];
            [labelLoadingText setNumberOfLines:0];
            [labelLoadingText setText:stringLoadingCellText];
            [labelLoadingText setClipsToBounds:YES];
            [[labelLoadingText layer] setCornerRadius:3.0f];
            [cellLoading addSubview:labelLoadingText];
        }
        return cellLoading;
        
    }
    
    PostCell *cell = (PostCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell = (cell)?cell:(PostCell*)[tableView dequeueReusableCellWithIdentifier:StringPostCell];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"PostCell" bundle:nil] forCellReuseIdentifier:StringPostCell];
        cell = [tableView dequeueReusableCellWithIdentifier:StringPostCell];
    }

    if (![cell delegate])
    {
        [cell setDelegate:self];
    }

    UNIIPostModel *postModel = (UNIIPostModel*)mutableArrayPosts[[indexPath row]];
    [cell setUniiPostModel:postModel];
    [cell setupCell];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self loadMoreVenuesAutomatically])
    {
        return;
    }
    if (!mutableArrayPosts || ![mutableArrayPosts count])
    {
        return;
    }
    if ([indexPath row] >= [mutableArrayPosts count])
    {
        if ([self disallowLoadingMorePosts])
        {
            return;
        }
        [self setDisallowLoadingMorePosts:YES];
        [[self delegate] postsTableViewControllerDidScrollToEndOfList];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] >= [mutableArrayPosts count])
    {
        if (![self loadMoreVenuesAutomatically])
        {
            [self setDisallowLoadingMorePosts:YES];
            [[self delegate] postsTableViewControllerDidScrollToEndOfList];
        }
    }
}

#pragma mark - TableView Action Handlers

- (void)postsCellDidFinishDownloadingPicture:(PostCell*)postCell
{
    NSIndexPath *indexPath = [[self tableViewPosts] indexPathForCell:postCell];
    if ([[[self tableViewPosts] indexPathsForVisibleRows] containsObject:indexPath])
    {
        [postCell setupPhoto];
    }
}

/**
 *  If no more posts are there to load then following methods feed backs user.
 */
- (void)handleThatNoMorePagesToDisplay
{
    UILabel *labelLoadingText = (UILabel*)[[self tableViewPosts] viewWithTag:9292];
    if (labelLoadingText)
    {
        [labelLoadingText setText:@"That's it for now!"];
    }
}

#pragma mark - Images downloader

- (void)startDownloadingImages
{
    NSMutableArray *maUrls = [NSMutableArray array];
    [mutableArrayPosts enumerateObjectsUsingBlock:^(UNIIPostModel *postModel, NSUInteger index, BOOL *stop) {
        UNIIPostUserInfoModel *postUserInfo = (UNIIPostUserInfoModel*)[postModel uniPostUserInfo];
        if (![postUserInfo imagePhoto])
        {
            [maUrls addObject:[postUserInfo stringImageUrl]];
        }
    }];
    
    NSSet *setUniqueUrls = [NSSet setWithArray:maUrls];
    for (NSString *stringUrl in setUniqueUrls)
    {
        ServerCommunicationController *scc = [[ServerCommunicationController alloc] init];
        [scc setDelegate:self];
        [scc setStringURLString:stringUrl];
        [scc sendRequestToServer];
    }
}

#pragma mark - ServerCommunicationControllerDelegate

- (void)serverResponseFailedWithError:(NSMutableDictionary*)mutableDictionaryError
{
}
- (void)serverResponseSuccessfulWithData:(NSMutableDictionary*)mutableDictionaryResponse
{
    NSData *data = (NSData*)[mutableDictionaryResponse objectForKey:@"Response"];
    __block UIImage *image = [[UIImage alloc] initWithData:data];
    image = (image.size.width > image.size.height)?[UIImage cropImageWRTHeight:image]:image;
    image = (image.size.height > image.size.width)?[UIImage cropImageWRTWidth:image]:image;
    
    [mutableArrayPosts enumerateObjectsUsingBlock:^(UNIIPostModel *postModel, NSUInteger index, BOOL *stop) {
        UNIIPostUserInfoModel *postUserInfo = (UNIIPostUserInfoModel*)[postModel uniPostUserInfo];
        NSString *stringUrl1 = [postUserInfo stringImageUrl];
        NSString *stringUrl2 = [mutableDictionaryResponse objectForKey:@"stringURLString"];
        stringUrl2 = ![stringUrl2 isEqual:[NSNull null]] ? stringUrl2 : @"";
        if ([stringUrl1 isEqualToString:stringUrl2])
        {
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
                
                UIImage *imageResized = [[UIImage alloc] init];
                imageResized = [UIImage resizeImageWithRespectToHeight:image withTargetHeight:40*1.2];
                [postUserInfo setImagePhoto:imageResized];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:index inSection:0];
                    PostCell *postCell = (PostCell*)[[self tableViewPosts] cellForRowAtIndexPath:indexPath];
                    if (postCell)
                    {
                        if ([[[self tableViewPosts] indexPathsForVisibleRows] containsObject:indexPath])
                        {
                            [postCell setupPhoto];
                        }
                    }
                });
            });
        }
        
    }];
}

@end
