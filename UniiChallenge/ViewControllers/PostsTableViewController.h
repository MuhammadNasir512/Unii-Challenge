//
//  PostsTableViewController.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PostsTableViewControllerDelegate <NSObject>
- (void)postsTableViewControllerDidRequestRefresh;
- (void)postsTableViewControllerDidScrollToEndOfList;
@end

@interface PostsTableViewController : UIViewController
{
}
@property (nonatomic, weak) id <PostsTableViewControllerDelegate> delegate;
@property (nonatomic, strong) NSMutableArray *mutableArrayPosts;

- (void)reloadTableViewData;
- (void)handleThatNoMorePagesToDisplay;
@end
