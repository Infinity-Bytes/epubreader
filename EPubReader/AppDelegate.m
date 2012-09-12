//
//  AppDelegate.m
//  EPubReader
//
//  Created by David Díaz on 08/08/12.
//  Copyright (c) 2012 David Díaz. All rights reserved.
//

#import "AppDelegate.h"
#import "EPubViewController.h"
#import "EPubService.h"
#import "SideMenuViewController.h"
#import "MFSideMenuManager.h"
#import "MFSideMenu.h"
#import "MainViewController.h"
#import "SearchResultsViewController.h"
#import "HomeViewController.h"
@implementation AppDelegate

- (void)dealloc
{
    [masterController release];
    [_window release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    
    MainViewController *mainView = [[MainViewController alloc] initWithNibName:@"MainView" bundle:nil];
    
    HomeViewController *homeViewController = [[HomeViewController alloc] initWithNibName:@"HomeViewController" bundle:nil];
    masterController = [[MasterController alloc] init];
    
    EPubService* epubService = [[EPubService alloc]init];
        
    EPubViewController *epubViewController = [[EPubViewController alloc] initWithNibName:@"EPubViewController" bundle:nil];

    
    [epubViewController setEpubDelegate: masterController];
    
    
    [masterController setEpubService:epubService];
    
    
    [masterController setWebViewDelegate:epubViewController];
    
    
    
    
    [masterController obtainEPub:@"Chapters"];
    

    SideMenuViewController *sideMenuViewController = [[SideMenuViewController alloc] initWithSpineArray:[epubService getSpineArray]];
    [sideMenuViewController setSpineArrayManagerDelegate:epubViewController];
    
    [epubViewController setSpineArray:[epubService getSpineArray]];
    
     mainView.title = @"Epub Reader";
    
    
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:mainView];
    self.window.rootViewController = navigationController;
    
    
     [[mainView view] addSubview:[homeViewController view]];
   
    
    [[self window] makeKeyAndVisible];
    
    
    // make sure to display the navigation controller before calling this
    [MFSideMenuManager configureWithNavigationController:navigationController
                                      sideMenuController:sideMenuViewController];
    
    SearchResultsViewController *searchResViewController = [[SearchResultsViewController alloc] initWithNibName:@"SearchResultsViewController" bundle:[NSBundle mainBundle]];
	
  [searchResViewController setSpineArrayManagerDelegate:epubViewController];
    [epubViewController setSearchResViewController:searchResViewController];

    
  
    [mainView release];
    [epubService release];
    [epubViewController release];
    [sideMenuViewController release];
    [navigationController release];

    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
