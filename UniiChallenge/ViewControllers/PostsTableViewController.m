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
UITableViewDelegate
>
{
    PostCell *postCellFromNib;
}
@property (nonatomic, weak) IBOutlet UITableView *tableViewPosts;
@end

@implementation PostsTableViewController

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
    [self initTableView];
}

- (void)initTableView
{
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"PostCell" owner:self options:nil];
    postCellFromNib = (PostCell*)[nib objectAtIndex:0];
    if (![tableViewPostsWeak delegate])
    {
        [tableViewPostsWeak setDelegate:self];
    }
    if (![tableViewPostsWeak dataSource])
    {
        [tableViewPostsWeak setDataSource:self];
    }
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
    NSMutableDictionary *mdOnePost = mutableArrayPosts[[indexPath row]];
    [postCellFromNib setMutableDictionaryPost:mdOnePost];
    CGFloat height = [postCellFromNib getHeightForRow];
    return height;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger intRowsToReturn = [mutableArrayPosts count];
    return intRowsToReturn;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *StringPostCell = @"PostCell";
    
    PostCell *cell = (PostCell*)[tableView cellForRowAtIndexPath:indexPath];
    cell = (cell)?cell:(PostCell*)[tableView dequeueReusableCellWithIdentifier:StringPostCell];
    
    if (!cell)
    {
        [tableView registerNib:[UINib nibWithNibName:@"PostCell" bundle:nil] forCellReuseIdentifier:StringPostCell];
        cell = [tableView dequeueReusableCellWithIdentifier:StringPostCell];
        
    }

    NSMutableDictionary *mdOnePost = mutableArrayPosts[[indexPath row]];
    [cell setMutableDictionaryPost:mdOnePost];
    [cell setupCell];
    return cell;
}
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
}

@end
