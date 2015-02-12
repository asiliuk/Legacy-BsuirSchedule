//
//  BSScheduleAddVC.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 12.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSScheduleAddVC;
@protocol BSScheduleAddVCDelegate <NSObject>
- (void)scheduleAddVC:(BSScheduleAddVC*)scheduleAddVC saveGroupWithGroupNumber:(NSString*)groupNumber subgroupNumber:(NSInteger)subgroupNumber;
@end

@interface BSScheduleAddVC : UIViewController
@property (weak, nonatomic) id<BSScheduleAddVCDelegate> delegate;
@end
