//
//  BSAchivementOnce.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementOnce.h"
#import "FXKeychain.h"

@implementation BSAchivementOnce

- (BOOL)trigger {
    BOOL getTriggered = NO;
    if (![self unlocked]) {
        getTriggered = YES;
        [[FXKeychain defaultKeychain] setObject:@(YES) forKey:self.achivementKey];
    }
    return getTriggered;
}

- (BOOL)unlocked {
    return [[[FXKeychain defaultKeychain] objectForKey:self.achivementKey] boolValue];
}
@end
