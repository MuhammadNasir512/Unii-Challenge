//
//  PostsTableViewController.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostsTableViewController : UIViewController
{
    
}
@property (nonatomic, strong) NSMutableArray *mutableArrayPosts;

- (void)reloadTableViewData;
@end
