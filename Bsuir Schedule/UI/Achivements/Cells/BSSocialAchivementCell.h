//
//  BSSocialAchivementCell.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementCell.h"

@class BSSocialAchivementCell;
@protocol BSSocialAchivementCellDelegate <NSObject>
- (void)socialAchivementCellDidPressTwitter:(BSSocialAchivementCell*)cell;
- (void)socialAchivementCellDidPressFacebook:(BSSocialAchivementCell*)cell;
- (void)socialAchivementCellDidPressEmail:(BSSocialAchivementCell*)cell;
@end
extern NSString * const kSocialAchivementCellID;
@interface BSSocialAchivementCell : BSAchivementCell
@property (weak, nonatomic) id<BSSocialAchivementCellDelegate> delegate;
@end
