//
//  PostsTableViewController.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "PostsTableViewController.h"
#import "PostCell.h"

@interface PostsTableViewController ()
<
UITableViewDataSource,
UITableViewDelegate,
PostCellDelegate
>
{
    PostCell *postCellFromNib;
    CGFloat loadingCellHeight;
    BOOL disallowLoadingMorePosts;
    BOOL loadMoreVenuesAutomatically;
}
@property (nonatomic, weak) IBOutlet UITableView *tableViewPosts;
@end

@implementation PostsTableViewController

@synthesize delegate = _delegate;
@synthesize tableViewPosts = tableViewPostsWeak;
@synthesize mutableArrayPosts;

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
    
    float padding = 10.0f;
    float xx = tableViewPostsWeak.frame.origin.x;
    float yy = padding;
    float ww = tableViewPostsWeak.frame.size.width;
    float hh = self.view.frame.size.height - yy - padding;
    [tableViewPostsWeak setFrame:CGRectMake(xx, yy, ww, hh)];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // following variable switches whether to load more posts automatically when reach the end of the list
    // or like to tap last cell to load more post
    loadMoreVenuesAutomatically = YES;

    [self initTableView];
}

- (void)initTableView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
    postCellFromNib = (PostCell*)[nib objectAtIndex:0];
    loadingCellHeight = 100.0f;
    if (![tableViewPostsWeak delegate])
    {
        [tableViewPostsWeak setDelegate:self];
    }
    if (![tableViewPostsWeak dataSource])
    {
        [tableViewPostsWeak setDataSource:self];
    }
    [self addPullToRefreshControll];
}
- (void)addPullToRefreshControll
{
    UIRefreshControl *refreshControlPull = [[UIRefreshControl alloc] init];
    [refreshControlPull addTarget:self action:@selector(refreshControlActionSelector:) forControlEvents:UIControlEventValueChanged];
    [tableViewPostsWeak addSubview:refreshControlPull];
}
- (void)refreshControlActionSelector:(UIRefreshControl*)refreshControl
{
    [[self delegate] postsTableViewControllerDidRequestRefresh];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, 1*NSEC_PER_SEC), dispatch_get_main_queue(), ^{
       
        [refreshControl endRefreshing];
    });
}
- (void)reloadTableViewData
{
    [tableViewPostsWeak reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = loadingCellHeight;
    if ([indexPath row] >= [mutableArrayPosts count])
    {
        return height;
    }

    NSMutableDictionary *mdOnePost = mutableArrayPosts[[indexPath row]];
    [postCellFromNib setMutableDictionaryPost:mdOnePost];
    height = [postCellFromNib getHeightForRow];
    
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
        disallowLoadingMorePosts = NO;
        NSString *stringLoadingCellText = @"";
        
        if (loadMoreVenuesAutomatically)
        {
            stringLoadingCellText = @"Loading more posts!\nPlease Wait...";
        }
        else
        {
            stringLoadingCellText = @"Tap here to load more posts.";
        }
        
        UITableViewCell *cellLoading = [tableView dequeueReusableCellWithIdentifier:StringLoadingCell];
        if (!cellLoading)
        {
            cellLoading = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:StringLoadingCell];
            [cellLoading setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cellLoading setBackgroundColor:[UIColor clearColor]];
            
            CGRect rect = [cellLoading frame];
            rect.size.height = loadingCellHeight;
            
            UILabel *labelLoadingText = [[UILabel alloc] init];
            [labelLoadingText setFrame:rect];
            [labelLoadingText setTag:9292];
            [labelLoadingText setBackgroundColor:[UIColor clearColor]];
            [labelLoadingText setTextColor:[UIColor whiteColor]];
            [labelLoadingText setTextAlignment:NSTextAlignmentCenter];
            [labelLoadingText setNumberOfLines:0];
            [labelLoadingText setText:stringLoadingCellText];
            [cellLoading addSubview:labelLoadingText];
        }
        [[cellLoading contentView] setBackgroundColor:[UIColor blackColor]];
        [[cellLoading contentView] setAlpha:0.75];
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

    NSMutableDictionary *mdOnePost = mutableArrayPosts[[indexPath row]];
    [cell setMutableDictionaryPost:mdOnePost];
    [cell setupCell];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (!loadMoreVenuesAutomatically)
    {
        return;
    }
    if (!mutableArrayPosts || ![mutableArrayPosts count])
    {
        return;
    }
    if ([indexPath row] >= [mutableArrayPosts count])
    {
        if (disallowLoadingMorePosts)
        {
            return;
        }
        disallowLoadingMorePosts = YES;
        [[self delegate] postsTableViewControllerDidScrollToEndOfList];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([indexPath row] >= [mutableArrayPosts count])
    {
        if (!loadMoreVenuesAutomatically)
        {
            disallowLoadingMorePosts = YES;
            [[self delegate] postsTableViewControllerDidScrollToEndOfList];
        }
    }
}
- (void)postsCellDidFinishDownloadingPicture:(PostCell*)postCell
{
    NSIndexPath *indexPath = [tableViewPostsWeak indexPathForCell:postCell];
    if ([[tableViewPostsWeak indexPathsForVisibleRows] containsObject:indexPath])
    {
        NSLog(@"Dowloaded:%@", indexPath);
        [postCell setupPhoto];
    }
}

- (void)handleThatNoMorePagesToDisplay
{
    UILabel *labelLoadingText = (UILabel*)[tableViewPostsWeak viewWithTag:9292];
    if (labelLoadingText)
    {
        [labelLoadingText setText:@"That's it for now!"];
    }
}

@end
