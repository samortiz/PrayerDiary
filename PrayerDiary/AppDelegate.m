//
//  AppDelegate.m
//  PrayerDiary
//
//  Created by Sam O on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
#import "DataManager.h"
#import "NameViewController.h"
#import "MiscTableViewController.h"

@implementation AppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  // -- Data setup ---
  [DataManager loadDataFromFile];
  
  UITabBarController *tabController = (UITabBarController *)self.window.rootViewController;
  tabController.delegate = self;
 
  // Indicate that we handle email data imports
  // If this returns YES then openURL will be called 
  // Since I return YES all the time, this isn't really needed
  //NSURL *url = (NSURL *) [launchOptions valueForKey:UIApplicationLaunchOptionsURLKey];
  //if ((url != nil) && [url isFileURL]) {
  //  return YES;
  //}
  
  return YES;
}


// Handle opening a URL, from an email (indicated by the mime-type)
// If the app is in the background this will be called but didFinishLaunchingWithOptions won't be called
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
  UIViewController *rootViewController = self.window.rootViewController;
  
  // Handle opening the URL (update the data)
  MiscTableViewController *miscVC = (MiscTableViewController *) [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"miscTableViewController"];
  Boolean handledOK = [miscVC handleOpenURL:url];

  if (handledOK) {
    // Go to the first tab
    UITabBarController *tabBarController = (UITabBarController *) rootViewController;
    [tabBarController setSelectedIndex:0];
  
    // Go to the first screen in the tab (pop to the root of the tree)
    UINavigationController *navVC = (UINavigationController *)tabBarController.selectedViewController;  
    [navVC popToRootViewControllerAnimated:YES];
  
    // Show the root screen
    [self.window addSubview:rootViewController.view];
    [self.window makeKeyAndVisible];
  }
  
  return handledOK;
}



# pragma UITabBarControllerDelegate
- (void) tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {

  if ([viewController isKindOfClass:[UINavigationController class]]) {
    UINavigationController *nav = (UINavigationController *)viewController;
    for (UIViewController *vc in nav.viewControllers) {
      if ([vc isKindOfClass:[NameViewController class]]) {
        NameViewController *nameViewController = (NameViewController *)vc;
        nameViewController.showAnswered = ((tabBarController.selectedIndex == 1) ? YES : NO);
      }
      
      // This will reload all the tableviews throughout the hierarchy (names,items)
      if ([vc isKindOfClass:[UITableViewController class]]) {
        UITableViewController *tvc = (UITableViewController *)vc;
        // Reload the table view, because the data may have changed while working in the other tab
        [tvc.tableView reloadData];
      }
    } // for
  }
  
  // When a tab is clicked we will save the data to the file
  // I get nervous if the data on disk gets too stale...
  [DataManager saveData];
}


- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
  [DataManager saveData];
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */

  [DataManager saveData];
}



@end
