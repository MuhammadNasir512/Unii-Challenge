//
//  PostCell.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PostCell;
@class UNIIPostModel;
@protocol PostCellDelegate <NSObject>
- (void)postsCellDidFinishDownloadingPicture:(PostCell*)postCell;
@end

@interface PostCell : UITableViewCell
{
}
@property (nonatomic, weak) id <PostCellDelegate> delegate;
@property (nonatomic, strong) UNIIPostModel *uniiPostModel;
- (CGFloat)getHeightForRow;
- (void)setupCell;
- (void)setupPhoto;
@end
