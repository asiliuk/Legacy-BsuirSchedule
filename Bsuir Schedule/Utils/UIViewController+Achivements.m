//
//  UIViewController+Achivements.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "UIViewController+Achivements.h"
#import "BSAchivementUnlockedVC.h"
#import "UIView+Screenshot.h"

@implementation UIViewController (Achivements)
- (void)triggerAchivementWithType:(BSAchivementType)achivementType {
    if ([[BSAchivementManager sharedInstance] triggerAchivementWithType:achivementType]) {
        BSAchivementUnlockedVC *avc = [[BSAchivementUnlockedVC alloc] initWithAchivement:[[BSAchivementManager sharedInstance] achivementWithType:achivementType]];
        [self presentVCInCurrentContext:avc animated:NO];
    }
}
@end
