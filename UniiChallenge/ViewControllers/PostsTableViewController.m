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
@property (nonatomic, weak) IBOutlet UITableView *tableViewPosts;
@property (nonatomic, assign) BOOL disallowLoadingMorePosts;
@property (nonatomic, assign) BOOL loadMoreVenuesAutomatically;
@property (nonatomic, assign) CGFloat loadingCellHeight;
@property (nonatomic, strong) PostCell *postCellFromNib;
@end

@implementation PostsTableViewController

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
    [self initTableView];
}

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
- (void)reloadTableViewData
{
    [[self tableViewPosts] reloadData];
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

    NSMutableDictionary *mdOnePost = mutableArrayPosts[[indexPath row]];
    [[self postCellFromNib] setMutableDictionaryPost:mdOnePost];
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

    NSMutableDictionary *mdOnePost = mutableArrayPosts[[indexPath row]];
    [cell setMutableDictionaryPost:mdOnePost];
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
- (void)postsCellDidFinishDownloadingPicture:(PostCell*)postCell
{
    NSIndexPath *indexPath = [[self tableViewPosts] indexPathForCell:postCell];
    if ([[[self tableViewPosts] indexPathsForVisibleRows] containsObject:indexPath])
    {
        [postCell setupPhoto];
    }
}

- (void)handleThatNoMorePagesToDisplay
{
    UILabel *labelLoadingText = (UILabel*)[[self tableViewPosts] viewWithTag:9292];
    if (labelLoadingText)
    {
        [labelLoadingText setText:@"That's it for now!"];
    }
}

@end
