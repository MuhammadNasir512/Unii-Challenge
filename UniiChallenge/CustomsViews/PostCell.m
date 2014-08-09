//
//  PostCell.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "PostCell.h"

@interface PostCell ()
{
    float padding;
    id cellFromNib;
}
@property (nonatomic, weak) IBOutlet UIView *viewMainView;
@property (nonatomic, weak) IBOutlet UILabel *labelPostText;
@property (nonatomic, weak) IBOutlet UILabel *labelName;
@property (nonatomic, weak) IBOutlet UILabel *labelLikes;
@property (nonatomic, weak) IBOutlet UILabel *labelComments;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewPhoto;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewLikes;
@property (nonatomic, weak) IBOutlet UIImageView *imageViewComments;
@end

@implementation PostCell

@synthesize viewMainView = viewMainViewWeak;
@synthesize labelPostText = labelPostTextWeak;
@synthesize labelName = labelNameWeak;
@synthesize labelLikes = labelLikesWeak;
@synthesize labelComments = labelCommentsWeak;
@synthesize imageViewPhoto = imageViewPhotoWeak;
@synthesize imageViewLikes = imageViewLikesWeak;
@synthesize imageViewComments = imageViewCommentsWeak;

@synthesize mutableDictionaryPost;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)awakeFromNib
{
    padding = 5.0f;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setupCell
{
    [self resetViews];
    [[viewMainViewWeak layer] setCornerRadius:5.0f];
    [self setupPostTextLabel];
}

- (void)setupPostTextLabel
{
    NSString *stringPostText = [mutableDictionaryPost objectForKey:@"content"];
    stringPostText = [stringPostText length] ? stringPostText : @"";
    [labelPostTextWeak setText:stringPostText];
    
    CGSize sizeRecommended = [UtilityMethods getRecommendedSizeForLabel:labelPostTextWeak];
    [UtilityMethods createFrameForView:labelPostTextWeak withSize:sizeRecommended];
    [UtilityMethods adjustFrameVerticallyForView:[imageViewPhotoWeak superview] toShowBelowView:labelPostTextWeak withPadding:padding];
    
    float hh = imageViewPhotoWeak.superview.frame.origin.y + imageViewPhotoWeak.superview.frame.size.height + labelPostTextWeak.frame.origin.y;
    CGRect rect = [viewMainViewWeak frame];
    rect.size.height = hh;
    [viewMainViewWeak setFrame:rect];
}

- (void)resetViews
{
    NSArray *nib = [self getPostCellFromNib];
    PostCell *cellTemp = (PostCell*)[nib objectAtIndex:0];
    [labelPostTextWeak setFrame:[[cellTemp labelPostText] frame]];
    [viewMainViewWeak setFrame:[[cellTemp viewMainView] frame]];
    [[imageViewPhotoWeak superview] setFrame:[[[cellTemp imageViewPhoto] superview] frame]];
    
}
- (id)getPostCellFromNib
{
    static NSString *nibName = @"PostCell";
    
    if (!cellFromNib)
    {
        Class aClass = NSClassFromString(@"UINib");
        if ([aClass respondsToSelector:@selector(nibWithNibName:bundle:)])
        {
            // faster than loadNibNamed
            cellFromNib = [aClass nibWithNibName:nibName bundle:nil];
            cellFromNib = [cellFromNib instantiateWithOwner:self options:nil];
        }
        else
        {
            cellFromNib = [[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil];
        }
    }
    return cellFromNib;
}

- (CGFloat)getHeightForRow
{
    NSString *stringPostText = [mutableDictionaryPost objectForKey:@"content"];
    stringPostText = [stringPostText length] ? stringPostText : @"";
    [labelPostTextWeak setText:stringPostText];
    
    CGSize sizeRecommended = [UtilityMethods getRecommendedSizeForLabel:labelPostTextWeak];
    CGFloat heightToReturn = labelPostTextWeak.frame.origin.y*3 + sizeRecommended.height + imageViewPhotoWeak.superview.frame.size.height + padding;
    return heightToReturn;
}

@end
