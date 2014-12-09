//
//  NSUserDefaults+Share.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 09.12.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "NSUserDefaults+Share.h"
#import "BSConstants.h"
#import <UIKit/UIDevice.h>

@implementation NSUserDefaults (Share)
+ (NSUserDefaults*)sharedDefaults {
    NSUserDefaults *sharedDefaults;
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroup];
    } else {
        sharedDefaults = [self standardUserDefaults];
    }
    return sharedDefaults;
}
@end
