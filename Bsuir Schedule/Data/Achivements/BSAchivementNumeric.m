//
//  BSAchivementNumeric.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementNumeric.h"
#import "FXKeychain.h"


@interface BSAchivementNumeric()
@property (nonatomic) NSInteger triggerCount;
@end

@implementation BSAchivementNumeric
- (instancetype)initWithName:(NSString *)name
                 description:(NSString *)description
                   imageName:(NSString *)imageName
               achivementKey:(NSString *)achivementKey
                triggerCount:(NSInteger)triggerCount
{
    self = [super initWithName:name description:description imageName:imageName achivementKey:achivementKey];
    if (self) {
        _triggerCount = triggerCount;
    }
    return self;
}

- (NSString*)achivementDescription {
    NSString *descr = [super achivementDescription];
    if (![self unlocked]) {
        NSString *triggersStr = [NSString stringWithFormat:@" (%ld/%ld)", (long)[self currentTriggerCount], (long)self.triggerCount];
        descr = [descr stringByAppendingString:triggersStr];
    }
    return descr;
}
- (NSInteger)currentTriggerCount {
    return [[[FXKeychain defaultKeychain] objectForKey:self.achivementKey] integerValue];
}
- (BOOL)trigger {
    BOOL getTriggered = NO;
    if (![self unlocked]) {
        NSInteger currentTriggerCount = [self currentTriggerCount];
        currentTriggerCount++;
        [[FXKeychain defaultKeychain] setObject:@(currentTriggerCount) forKey:self.achivementKey];
        getTriggered = currentTriggerCount >= self.triggerCount;
    }
    return getTriggered;
}
- (BOOL)unlocked {
    return [self currentTriggerCount] >= self.triggerCount;
}
@end
