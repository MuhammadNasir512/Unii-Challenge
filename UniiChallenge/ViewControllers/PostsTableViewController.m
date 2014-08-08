//
//  PostsTableViewController.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "PostsTableViewController.h"

@interface PostsTableViewController ()
{
    
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
}

@end
