Unii-Challenge
==============

Project created to attempt the programming challenge given by Unii.

This project uses XIBs instead of storyboard. Thats intentional, Please click following link to see another app that was created using storyboards
https://github.com/MuhammadNasir512/Bill-Manager.git

To load more posts in table view you need to scroll at the bottom of the list.
More posts are loaded either automatically or by tapping the last cell depending upon the boolean variable value set in "PostsTableViewController.m" -> "- (void)viewDidLoad" method. Please change its value to see the difference.

App reloads posts when app state changes to "applicationDidBecomeActive". Please see "AppDelegate.m" -> "- (void)applicationDidBecomeActive:(UIApplication *)application"

Tested on iPhone 4 Device and various simulators
