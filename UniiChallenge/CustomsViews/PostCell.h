//
//  PostCell.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostCell : UITableViewCell
{
    
}
@property (nonatomic, strong) NSMutableDictionary *mutableDictionaryPost;
- (CGFloat)getHeightForRow;
- (void)setupCell;
@end
