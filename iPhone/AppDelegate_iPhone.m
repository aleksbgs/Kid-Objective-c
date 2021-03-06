//
//  AppDelegate_iPhone.m
//  PreSchool
//
//  Created by Acai on 30/11/10.
//  Copyright 2010 Aca Technologies. All rights reserved.
//

#import "AppDelegate_iPhone.h"

@implementation AppDelegate_iPhone
@synthesize navigationController;

- (void) CreateDatabaseIfNeeded
{
	[super CreateDatabaseIfNeeded];
}
-(NSMutableArray *)getAllCategories
{
	return [super getAllCategories];
}
-(NSMutableArray *)getAllObjects
{
	return [super getAllObjects];
}
-(NSMutableArray *)getObjectsByCategoryID:(int)ID
{
	return [super getObjectsByCategoryID:ID];
}
#pragma mark -
#pragma mark Application lifecycle

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {    
	self.bChangedLanguage= TRUE;
	self.bFirstTimeLoaded= TRUE;
    // Override point for customization after application launch.
	window.idleTimeInterval = IDLE_TIME;
	[self CreateDatabaseIfNeeded];
	[window addSubview:navigationController.view];
    [window makeKeyAndVisible];
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    /*
     Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
     Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
     */
	[super applicationWillResignActive:application];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
     If your application supports background execution, called instead of applicationWillTerminate: when the user quits.
	 
     Superclass implementation saves changes in the application's managed object context before the application terminates.
     */
	[super applicationDidEnterBackground:application];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    /*
     Called as part of the transition from the background to the inactive state: here you can undo many of the changes made on entering the background.
     */
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
}


/**
 Superclass implementation saves changes in the application's managed object context before the application terminates.
 */
- (void)applicationWillTerminate:(UIApplication *)application {
	[super applicationWillTerminate:application];
}

#pragma mark -
#pragma mark Memory management

- (void)applicationDidReceiveMemoryWarning:(UIApplication *)application {
    /*
     Free up as much memory as possible by purging cached data objects that can be recreated (or reloaded from disk) later.
     */
	[UIImage clearThumbnailCache];
    [super applicationDidReceiveMemoryWarning:application];
}


- (void)dealloc {
	
	[super dealloc];
}


@end

