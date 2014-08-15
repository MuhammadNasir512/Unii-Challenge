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
@end

@implementation PostCell

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
    NSString *stringPostText = [mutableDictionaryPost objectForKey:@"content"];
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
    NSInteger intComments = [[mutableDictionaryPost objectForKey:@"comment_count"] integerValue];
    intComments = intComments ? intComments : 0;
    [[self labelComments] setText:[NSString stringWithFormat:@"%ld", (long)intComments]];
    
    NSInteger intLikes = [[mutableDictionaryPost objectForKey:@"like_count"] integerValue];
    intLikes = intLikes ? intLikes : 0;
    [[self labelLikes] setText:[NSString stringWithFormat:@"%ld", (long)intLikes]];
    
    NSMutableDictionary *mdUser = [mutableDictionaryPost objectForKey:@"user"];
    NSString *stringFName = mdUser[@"first_name"];
    stringFName = stringFName ? stringFName : @"";
    
    NSString *stringLName = mdUser[@"last_name"];
    stringLName = stringLName ? stringLName : @"";
    stringLName = ([stringLName length])?[[stringLName substringToIndex:1] uppercaseString]:stringLName;
    
    NSString *stringFullName = [NSString stringWithFormat:@"%@ %@", stringFName, stringLName];
    [[self labelName] setText:stringFullName];
}
- (void)setupPhoto
{
    NSMutableDictionary *mdUser = [mutableDictionaryPost objectForKey:@"user"];
    UIImage *imageAvataar = (UIImage*)[mdUser objectForKey:@"scaledImage"];
    if (imageAvataar)
    {
        [[self imageViewPhoto] setImage:imageAvataar];
    }
    else
    {
        UIActivityIndicatorView *aiv = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        [aiv setFrame:[[self imageViewPhoto] frame]];
        [aiv setTag:313131];
        [aiv startAnimating];
        [[[self imageViewPhoto] superview] addSubview:aiv];
        
        NSString *stringPhotoUrl = [mdUser objectForKey:@"avatar"];
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0), ^{
            
            NSData *urlData = [NSData dataWithContentsOfURL:[NSURL URLWithString:stringPhotoUrl]];
            UIImage *image = [[UIImage alloc] initWithData:urlData];
            image = (image.size.width > image.size.height)?[UIImage cropImageWRTHeight:image]:image;
            image = (image.size.height > image.size.width)?[UIImage cropImageWRTWidth:image]:image;
            
            image = [UIImage resizeImageWithRespectToHeight:image withTargetHeight:[self imageViewPhoto].frame.size.height*1.2];
            [mdUser setObject:image forKey:@"scaledImage"];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [[self delegate] postsCellDidFinishDownloadingPicture:self];

                UIActivityIndicatorView *aiv = (UIActivityIndicatorView*)[[[self imageViewPhoto] superview] viewWithTag:313131];
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
    [[self labelPostText] setText:stringPostText];
    
    CGSize sizeRecommended = [UtilityMethods getRecommendedSizeForLabel:[self labelPostText]];
    CGFloat heightToReturn = [self labelPostText].frame.origin.y*3 + sizeRecommended.height + [self imageViewPhoto].superview.frame.size.height + padding;
    return heightToReturn;
}

@end
