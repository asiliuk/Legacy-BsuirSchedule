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

#import "SlideNavigationController.h"
#import "BSMenuVC.h"
#import "BSScheduleVC.h"
#import "BSSettingsVC.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    [self updateOldDatabaseForMultipleGroups];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    // Override point for customization after application launch.
    self.window.backgroundColor = [UIColor whiteColor];
    
    UIViewController *mainVC;
    BSSchedule *sch = [[[BSDataManager sharedInstance] schelules] firstObject];
    if (sch) {
        mainVC = [[BSScheduleVC alloc] initWithSchedule:sch];
    } else {
        mainVC = [[BSSettingsVC alloc] init];
    }
    SlideNavigationController *slideNavController = [[SlideNavigationController alloc] initWithRootViewController:mainVC];
    [self customizeSlideNavigationController:slideNavController];
    self.window.rootViewController = slideNavController;
    [self.window makeKeyAndVisible];
    
    [[NSUserDefaults sharedDefaults] setBool:NO forKey:kEasterEggMode];
    return YES;
}

- (void)customizeSlideNavigationController:(SlideNavigationController*)slideNavController {
    slideNavController.avoidSwitchingToSameClassViewController = NO;
    slideNavController.leftMenu = [[BSMenuVC alloc] init];
    
    slideNavController.navigationBar.barStyle = UIBarStyleBlack;
    
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [[UINavigationBar appearance] setBarTintColor:BS_BLUE];
        [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
        [[UINavigationBar appearance] setBarStyle:UIBarStyleBlack];
    } else {
        [[UINavigationBar appearance] setTintColor:BS_BLUE];
    }
    UIFont *titleFont = [UIFont fontWithName:@"OpenSans" size:20.0f];
    [slideNavController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                               NSFontAttributeName: titleFont}];
    
    
    UIButton *button  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
    [button setImage:[UIImage imageNamed:@"menu_burger"] forState:UIControlStateNormal];
    [button addTarget:slideNavController action:@selector(toggleLeftMenu) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    slideNavController.leftBarButtonItem = leftBarButtonItem;
    slideNavController.enableShadow = NO;
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
