//
//  BSSettingsVC.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 20.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BSSettingsVC;
@protocol BSSettingsVCDelegate <NSObject>
- (void)settingsScreen:(BSSettingsVC*)settingsVC dismissWithChanges:(BOOL)changes;
@end

@interface BSSettingsVC : UIViewController
@property (weak, nonatomic) id<BSSettingsVCDelegate> delegate;
@end
