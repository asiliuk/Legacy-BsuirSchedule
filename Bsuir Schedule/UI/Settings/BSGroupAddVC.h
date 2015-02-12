//
//  BSSettingsVC.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 20.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSGroupAddVC;
@protocol BSGroupAddVCDelegate <NSObject>
- (void)groupAddingScreen:(BSGroupAddVC*)groupAddVC
   dismissWithGroupNumber:(NSString*)group
              andSubgroup:(NSString*)subgroup;
@end

@interface BSGroupAddVC : UIViewController
@property (weak, nonatomic) id<BSGroupAddVCDelegate> delegate;
@end
