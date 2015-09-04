//
//  BSGroupSelectVC.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 04.09.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSScheduleAddVC.h"

@interface BSGroupSelectVC : UIViewController
@property (weak, nonatomic) id<BSScheduleAddVCDelegate> delegate;
@end
