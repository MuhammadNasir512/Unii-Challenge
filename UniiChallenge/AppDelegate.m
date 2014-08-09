//
//  AppDelegate.m
//  UniiChallenge
//
//  Created by Muhammad Nasir on 08/08/2014.
//  Copyright (c) 2014 Muhammad Nasir. All rights reserved.
//

#import "AppDelegate.h"
#import "ViewController.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[self window] setBackgroundColor:[UIColor whiteColor]];

    ViewController *viewController = [[ViewController alloc] init];
    UINavigationController *navigationController = [[UINavigationController alloc]  initWithRootViewController:viewController];
    [[self window] setRootViewController:navigationController];
    [[self window] makeKeyAndVisible];
    
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    id anId1 = [[self window] rootViewController];
    UINavigationController *nc = nil;
    if ([anId1 isKindOfClass:[UINavigationController class]])
    {
        nc = (UINavigationController*)anId1;
    }
    if (nc)
    {
        NSArray *arrayVCs = [nc viewControllers];
        id anId2 = [arrayVCs lastObject];
        if ([anId2 respondsToSelector:@selector(applicationBecameActive)])
        {
            [anId2 applicationBecameActive];
        }
    }
    else
    {
        if ([anId1 respondsToSelector:@selector(applicationBecameActive)])
        {
            [anId1 applicationBecameActive];
        }
    }
}

- (void)applicationWillTerminate:(UIApplication *)application
{
}

@end
