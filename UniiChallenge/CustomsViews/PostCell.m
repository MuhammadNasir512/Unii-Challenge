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
    [[viewMainViewWeak layer] setCornerRadius:5.0f];
    [self resetViews];
    [self setupPostTextLabel];
    [self adjustSizeForMainView];
    [self setupNameLikesAndCommentsInfo];
}
- (void)resetViews
{
    NSArray *nib = [self getPostCellFromNib];
    PostCell *cellTemp = (PostCell*)[nib objectAtIndex:0];
    [labelPostTextWeak setFrame:[[cellTemp labelPostText] frame]];
    [viewMainViewWeak setFrame:[[cellTemp viewMainView] frame]];
    [imageViewPhotoWeak setImage:nil];
    [[imageViewPhotoWeak superview] setFrame:[[[cellTemp imageViewPhoto] superview] frame]];
}
- (void)setupPostTextLabel
{
    NSString *stringPostText = [mutableDictionaryPost objectForKey:@"content"];
    stringPostText = [stringPostText length] ? stringPostText : @"";
    [labelPostTextWeak setText:stringPostText];
    
    CGSize sizeRecommended = [UtilityMethods getRecommendedSizeForLabel:labelPostTextWeak];
    [UtilityMethods createFrameForView:labelPostTextWeak withSize:sizeRecommended];
    [UtilityMethods adjustFrameVerticallyForView:[imageViewPhotoWeak superview] toShowBelowView:labelPostTextWeak withPadding:padding];
}
- (void)adjustSizeForMainView
{
    float hh = imageViewPhotoWeak.superview.frame.origin.y + imageViewPhotoWeak.superview.frame.size.height + labelPostTextWeak.frame.origin.y;
    CGRect rect = [viewMainViewWeak frame];
    rect.size.height = hh;
    [viewMainViewWeak setFrame:rect];
}
- (void)setupNameLikesAndCommentsInfo
{
    NSInteger intComments = [[mutableDictionaryPost objectForKey:@"comment_count"] integerValue];
    intComments = intComments ? intComments : 0;
    [labelCommentsWeak setText:[NSString stringWithFormat:@"%d", intComments]];
    
    NSInteger intLikes = [[mutableDictionaryPost objectForKey:@"like_count"] integerValue];
    intLikes = intLikes ? intLikes : 0;
    [labelLikesWeak setText:[NSString stringWithFormat:@"%d", intLikes]];
    
    NSMutableDictionary *mdUser = [mutableDictionaryPost objectForKey:@"user"];
    NSString *stringFName = mdUser[@"first_name"];
    stringFName = stringFName ? stringFName : @"";
    
    NSString *stringLName = mdUser[@"last_name"];
    stringLName = stringLName ? stringLName : @"";
    stringLName = ([stringLName length])?[[stringLName substringToIndex:1] uppercaseString]:stringLName;
    
    NSString *stringFullName = [NSString stringWithFormat:@"%@ %@", stringFName, stringLName];
    [labelNameWeak setText:stringFullName];
    
    UIImage *imageAvataar = (UIImage*)[mdUser objectForKey:@"scaledImage"];
    if (imageAvataar)
    {
        [imageViewPhotoWeak setImage:imageAvataar];
    }
    else
    {
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [aiv setFrame:[imageViewPhotoWeak frame]];
        [aiv setTag:313131];
        [aiv startAnimating];
        [[imageViewPhotoWeak superview] addSubview:aiv];
        
        NSString *stringPhotoUrl = [mdUser objectForKey:@"avatar"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringPhotoUrl]];
            UIImage *image = [[UIImage alloc] initWithData:urlData];
            image = (image.size.width > image.size.height)?[UIImage cropImageWRTHeight:image]:image;
            image = (image.size.height > image.size.width)?[UIImage cropImageWRTWidth:image]:image;
            
            image = [UIImage resizeImageWithRespectToHeight:image withTargetHeight:imageViewPhotoWeak.frame.size.height*1.2];
            [mdUser setObject:image forKey:@"scaledImage"];

            dispatch_async(dispatch_get_main_queue(), ^{
                
                [imageViewPhotoWeak setImage:image];
                UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)[[imageViewPhotoWeak superview] viewWithTag:313131];
                [aiv stopAnimating];
                [aiv removeFromSuperview];
            });
        });
    }
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
