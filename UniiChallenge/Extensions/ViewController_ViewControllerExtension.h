//
//  ViewController_ViewControllerExtension.h
//  UniiChallenge
//
//  Created by Muhammad Nasir on 10/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
{
    
}
@property (nonatomic, weak) IBOutlet UIView *viewPlaceHoler;
@property (nonatomic, strong) NSString *stringFirstPageUrl;
@property (nonatomic, strong) NSMutableDictionary *mutableDictionaryNextPageInfo;

- (void)startLoadingDataFromUrl:(NSString*)stringUrlString;
- (void)initObjects;
@end
