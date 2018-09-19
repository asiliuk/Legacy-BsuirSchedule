//
//  BSAchivementManager.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
@class BSAchivement;
typedef NS_ENUM(NSInteger, BSAchivementType) {
    BSAchivementTypeScroller,
    BSAchivementTypeSocial,
    BSAchivementTypeWatcher,
    BSAchivementTypeWerewolf,
//    BSAchivementTypeSupporter,
//    BSAchivementTypeSuperSupporter
};


@interface BSAchivementManager : NSObject
@property (strong, nonatomic) NSArray *achivements;

+ (instancetype)sharedInstance;

- (BSAchivement*)achivementWithType:(BSAchivementType)achivementType;
- (BOOL)triggerAchivementWithType:(BSAchivementType)achivementType;

- (void)dismissAllAchivements;
@end
