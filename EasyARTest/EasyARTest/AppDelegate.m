//
//  AppDelegate.m
//  EasyARTest
//
//  Created by anyongxue on 2017/8/24.
//  Copyright © 2017年 cc. All rights reserved.
//

#import "AppDelegate.h"
#import <easyar/engine.oc.h>

NSString * key = @"mkunE5X1Sg5BfyLFwhBlwUZOrBUfGiOhNmwZ3aI2LWN5WrQj2GyIxPTQrsV1UeepHpd7v7de2DBOyidazFfcgilgEaWOIbOQftZ3UvLjRiLybAlvbepOFLOGbHj3fBAfUfR0K2Dk8NuKU8K7dPH3hDkcsyWjILzO979VCh1YOEQ5o8zbvHwXU4A1JyRkbkl0Xl1CkAdV";

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    if (![easyar_Engine initialize:key]) {
        NSLog(@"Initialization Failed.");
    }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    
    [easyar_Engine onPause];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.

    [easyar_Engine onResume];
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
