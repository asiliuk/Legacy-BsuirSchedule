//
//  UIViewController+Achivements.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSAchivementManager.h"
#import "UIViewController+Presentation.h"

@interface UIViewController (Achivements)
- (void)triggerAchivementWithType:(BSAchivementType)achivementType;
@end
