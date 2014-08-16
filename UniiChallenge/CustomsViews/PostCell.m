//
//  PostCell.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "PostCell.h"
#import "UNIIPostModel.h"
#import "UNIIPostUserInfoModel.h"

#pragma mark - Private Interface
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
@end

#pragma mark - Implementation
@implementation PostCell

#pragma mark - Synthesized Properties
@synthesize uniiPostModel;

#pragma mark - Initializations
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}
- (void)awakeFromNib
{
    padding = 20.0f;
}
- (void)layoutSubviews
{
    [super layoutSubviews];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

#pragma mark - Cell Setup
- (void)setupCell
{
    [[[self viewMainView] layer] setCornerRadius:3.0f];
    [self resetViews];
    [self setupPostTextLabel];
    [self adjustSizeForMainView];
    [self setupNameLikesAndCommentsInfo];
    [self setupPhoto];
}
- (void)resetViews
{
    NSArray *nib = [self getPostCellFromNib];
    PostCell *cellTemp = (PostCell*)[nib objectAtIndex:0];
    [[self labelPostText] setFrame:[[cellTemp labelPostText] frame]];
    [[self viewMainView] setFrame:[[cellTemp viewMainView] frame]];
    [[self imageViewPhoto] setImage:[UIImage imageNamed:@"avataar.png"]];
    [[[self imageViewPhoto] superview] setFrame:[[[cellTemp imageViewPhoto] superview] frame]];
    
    if (![[[self imageViewPhoto] layer] cornerRadius])
    {
        [[[self imageViewPhoto] layer] setCornerRadius:3.0f];
    }
}
- (void)setupPostTextLabel
{
    NSString *stringPostText = [uniiPostModel stringPostText];
    stringPostText = [stringPostText length] ? stringPostText : @"";
    [[self labelPostText] setText:stringPostText];
    
    CGSize sizeRecommended = [UtilityMethods getRecommendedSizeForLabel:[self labelPostText]];
    [UtilityMethods createFrameForView:[self labelPostText] withSize:sizeRecommended];
    [UtilityMethods adjustFrameVerticallyForView:[[self imageViewPhoto] superview] toShowBelowView:[self labelPostText] withPadding:padding];
}
- (void)adjustSizeForMainView
{
    float hh = [self imageViewPhoto].superview.frame.origin.y + [self imageViewPhoto].superview.frame.size.height + [self labelPostText].frame.origin.y;
    CGRect rect = [[self viewMainView] frame];
    rect.size.height = hh;
    [[self viewMainView] setFrame:rect];
}
- (void)setupNameLikesAndCommentsInfo
{
    [[self labelComments] setText:[NSString stringWithFormat:@"%ld", (long)[uniiPostModel intCommentsCount]]];
    [[self labelLikes] setText:[NSString stringWithFormat:@"%ld", (long)[uniiPostModel intLikesCount]]];
    
    UNIIPostUserInfoModel *uniPostUserInfo = (UNIIPostUserInfoModel*)[uniiPostModel uniPostUserInfo];
    NSString *stringFName = [uniPostUserInfo stringFirstName];
    
    NSString *stringLName = [uniPostUserInfo stringLastName];
    stringLName = ([stringLName length])?[[stringLName substringToIndex:1] uppercaseString]:stringLName;
    
    NSString *stringFullName = [NSString stringWithFormat:@"%@ %@", stringFName, stringLName];
    [[self labelName] setText:stringFullName];
}
- (void)setupPhoto
{
    UNIIPostUserInfoModel *uniPostUserInfo = (UNIIPostUserInfoModel*)[uniiPostModel uniPostUserInfo];
    UIImage *imageAvataar = [uniPostUserInfo imagePhoto];
    if (imageAvataar)
    {
        [self removeActivityViewFromView:[self imageViewPhoto]];
        [[self imageViewPhoto] setImage:imageAvataar];
    }
    else
    {
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [aiv setFrame:[[self imageViewPhoto] frame]];
        [aiv setTag:313131];
        [aiv startAnimating];
        [[[self imageViewPhoto] superview] addSubview:aiv];
    }
}

#pragma mark - Other methods
- (id)getPostCellFromNib
{
    if (!cellFromNib)
    {
        NSString *nibName = @"PostCell";
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
    NSString *stringPostText = [uniiPostModel stringPostText];
    stringPostText = [stringPostText length] ? stringPostText : @"";
    [[self labelPostText] setText:stringPostText];
    
    CGSize sizeRecommended = [UtilityMethods getRecommendedSizeForLabel:[self labelPostText]];
    CGFloat heightToReturn = [self labelPostText].frame.origin.y*3 + sizeRecommended.height + [self imageViewPhoto].superview.frame.size.height + padding;
    return heightToReturn;
}

- (void)removeActivityViewFromView:(UIView*)view
{
    UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)[view viewWithTag:313131];
    [aiv stopAnimating];
    [aiv removeFromSuperview];
}

@end
