//
//  BSAchivementManager.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementManager.h"
#import "BSAchivementOnce.h"
#import "BSAchivementNumeric.h"

#import "BSConstants.h"
#import "FXKeychain.h"

@interface BSAchivementManager()
@property (strong, nonatomic) NSDictionary *achivementsData;
@end
@implementation BSAchivementManager

+ (instancetype)sharedInstance {
    
    static id sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[super allocWithZone:NULL] init];
    });
    return sharedObject;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [[self class] sharedInstance];
}

//===============================================GETTERS===========================================
#pragma mark - Getters

- (NSDictionary*)achivementsData {
    if (!_achivementsData) {
        NSMutableDictionary *achivementsData = [NSMutableDictionary dictionary];
        
        BSAchivementOnce *scroller = [[BSAchivementOnce alloc] initWithName:LZD(@"L_ScrollerAchivement")
                                                                description:LZD(@"L_ScrollerAchivementDescription")
                                                                  imageName:@"scroller"
                                                              achivementKey:[self keyForAchivementType:BSAchivementTypeScroller]];
        achivementsData[@(BSAchivementTypeScroller)] = scroller;
        
        BSAchivementOnce *social = [[BSAchivementOnce alloc] initWithName:LZD(@"L_SocialAchivement")
                                                              description:LZD(@"L_SocialAchivementDescription")
                                                                imageName:@"social"
                                                            achivementKey:[self keyForAchivementType:BSAchivementTypeSocial]];
        achivementsData[@(BSAchivementTypeSocial)] = social;
        
        NSInteger watcherPhotoCount = 10;
        BSAchivementNumeric *watcher = [[BSAchivementNumeric alloc] initWithName:LZD(@"L_WatcherAchivement")
                                                                     description:[NSString stringWithFormat:LZD(@"L_WatcherAchivementDescription"),
                                                                                  (long)watcherPhotoCount]
                                                                       imageName:@"watcher"
                                                                   achivementKey:[self keyForAchivementType:BSAchivementTypeWatcher]
                                                                        triggerCount:watcherPhotoCount];
        achivementsData[@(BSAchivementTypeWatcher)] = watcher;
        
        BSAchivementOnce *werewolf = [[BSAchivementOnce alloc] initWithName:LZD(@"L_WerewolfAchivement")
                                                                 description:LZD(@"L_WerewolfAchivementDescription")
                                                                   imageName:@"werewolf"
                                                               achivementKey:[self keyForAchivementType:BSAchivementTypeWerewolf]];
        achivementsData[@(BSAchivementTypeWerewolf)] = werewolf;
        
        BSAchivementOnce *supporter = [[BSAchivementOnce alloc] initWithName:LZD(@"L_SupporterAchivement")
                                                                 description:LZD(@"L_SupporterAchivementDescription")
                                                                   imageName:@"supporter"
                                                               achivementKey:[self keyForAchivementType:BSAchivementTypeSupporter]];
        achivementsData[@(BSAchivementTypeSupporter)] = supporter;
        
        BSAchivementOnce *superSupporter = [[BSAchivementOnce alloc] initWithName:LZD(@"L_SuperSupporterAchivement")
                                                                      description:LZD(@"L_SuperSupporterAchivementDescription")
                                                                        imageName:@"super_supporter"
                                                                    achivementKey:[self keyForAchivementType:BSAchivementTypeSuperSupporter]];
        achivementsData[@(BSAchivementTypeSuperSupporter)] = superSupporter;
        
        _achivementsData = [NSDictionary dictionaryWithDictionary:achivementsData];
    }
    return _achivementsData;
}
- (NSArray*)achivements {
    if (!_achivements) {
        NSMutableArray *achivements = [NSMutableArray array];
        NSArray *achivementsTypes = @[@(BSAchivementTypeScroller), @(BSAchivementTypeWatcher),
                                      @(BSAchivementTypeWerewolf), @(BSAchivementTypeSocial),
                                      @(BSAchivementTypeSupporter), @(BSAchivementTypeSuperSupporter)];
        for (NSNumber *achivementType in achivementsTypes) {
            [achivements addObject:self.achivementsData[achivementType]];
        }
        _achivements = [NSArray arrayWithArray:achivements];
    }
    return _achivements;
}

//===============================================METHODS===========================================
#pragma mark - Methods

- (BSAchivement*)achivementWithType:(BSAchivementType)achivementType {
    return [self.achivementsData objectForKey:@(achivementType)];
}

- (BOOL)triggerAchivementWithType:(BSAchivementType)achivementType {
    BSAchivement *achivement = [self achivementWithType:achivementType];
    return [achivement trigger];
}

- (NSString*)keyForAchivementType:(BSAchivementType)achivementType {
    NSString *achivementKey;
    switch (achivementType) {
        case BSAchivementTypeScroller:
            achivementKey = @"BSAchivementTypeScroller";
            break;
        case BSAchivementTypeSocial:
            achivementKey = @"BSAchivementTypeSocial";
            break;
        case BSAchivementTypeWatcher:
            achivementKey = @"BSAchivementTypeWatcher";
            break;
        case BSAchivementTypeWerewolf:
            achivementKey = @"BSAchivementTypeWherewolf";
            break;
        case BSAchivementTypeSupporter:
            achivementKey = @"BSAchivementTypeSupporter";
            break;
        case BSAchivementTypeSuperSupporter:
            achivementKey = @"BSAchivementTypeSuperSupporter";
            break;
        default:
            achivementKey = @"unknown";
            break;
    }
    return achivementKey;
}

- (void)dismissAllAchivements {
    for (NSNumber *ach in @[@(BSAchivementTypeScroller), @(BSAchivementTypeWatcher),
                            @(BSAchivementTypeWerewolf), @(BSAchivementTypeSocial),
                            @(BSAchivementTypeSupporter), @(BSAchivementTypeSuperSupporter)]) {
        [[FXKeychain defaultKeychain] setObject:@(0) forKey:[self keyForAchivementType:[ach integerValue]]];
    }
}

@end
