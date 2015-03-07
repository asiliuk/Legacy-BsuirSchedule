//
//  BSSocialAchivementCell.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementCell.h"

extern NSString * const kPurchaseAchivementCellID;
@class BSPurchaseAchivementCell;
@protocol BSPurchaseAchivementCellDelegate <NSObject>
- (void)purchaseAchivementCellBuyPressed:(BSPurchaseAchivementCell*)cell;
@end
@interface BSPurchaseAchivementCell : BSAchivementCell
@property (weak, nonatomic) id<BSPurchaseAchivementCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIButton *buyButton;
@end
