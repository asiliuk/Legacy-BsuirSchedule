//
//  AppDelegate.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "AppDelegate.h"

#import "BSDataManager.h"
#import "NSUserDefaults+Share.h"

#import "BSConstants.h"

#import "BSMainVC.h"
#import "BSScheduleVC.h"
#import "BSSettingsVC.h"

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import <Parse/Parse.h>


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self updateOldDatabaseForMultipleGroups];
    [Fabric with:@[CrashlyticsKit]];
    
    [Parse enableLocalDatastore];
    
    [Parse setApplicationId:@"NSKMaa9xOL2Loav0Eaj1KtvmwBEWpR2AN3ZcwWzo"
                  clientKey:@"1Lv4keabSCqMmhDSOQWeOsfvKi7zsegPxs2pxRpE"];
    

    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[BSMainVC alloc] init]];
    [self.window makeKeyAndVisible];
    
    [[NSUserDefaults sharedDefaults] setBool:NO forKey:kEasterEggMode];

    [[UINavigationBar appearance] setBarTintColor:BS_BLUE];
    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    [[UINavigationBar appearance] setBarStyle:UIBarStyleBlackTranslucent];
    UIFont *titleFont = [UIFont fontWithName:@"OpenSans" size:20.0f];
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],
                                                                      NSFontAttributeName: titleFont}];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    return YES;
}

//- (void)updateOldDatabaseForMultipleGroups {
//    NSUserDefaults *shared = [NSUserDefaults sharedDefaults];
//    NSString *groupNumber = [shared objectForKey:kCurrentScheduleGroup];
//    NSInteger subgroup = [shared integerForKey:kUserSubgroup];
//    if (groupNumber) {
//        NSDate *lastUpdate = [shared objectForKey:kLastUpdate];
//        NSString *scheduleStamp = [shared objectForKey:kDatabaseStamp];
//        BSSchedule *schedule = [[BSDataManager sharedInstance] scheduleWithGroupNumber:groupNumber andSubgroup:subgroup createIfNotExists:YES];
//        schedule.group.lastUpdate = lastUpdate;
//        schedule.group.scheduleStamp = scheduleStamp;
//        NSArray *pairs = [[BSDataManager sharedInstance] pairs];
//        for (BSPair *pair in pairs) {
//            if (![pair.groups containsObject:schedule.group]) {
//                [pair addGroupsObject:schedule.group];
//            }
//        }
//        
//        [shared setObject:nil forKey:kCurrentScheduleGroup];
//        [shared setObject:nil forKey:kUserSubgroup];
//        [shared setObject:nil forKey:kUserGroup];
//        
//        [shared setObject:nil forKey:kLastUpdate];
//        [shared setObject:nil forKey:kDatabaseStamp];
//        
//        [shared setObject:groupNumber forKey:kWidgetGroup];
//        [shared setInteger:subgroup forKey:kWidgetSubgroup];
//        
//        [[BSDataManager sharedInstance] saveContext];
//    }
//}

- (void)applicationWillResignActive:(UIApplication *)application {
    [[BSDataManager sharedInstance] saveContext];
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    [[NSNotificationCenter defaultCenter] postNotificationName:kDidComeFromBackground object:nil];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    // Saves changes in the application's managed object context before the application terminates.
    [[BSDataManager sharedInstance] saveContext];
}



@end
