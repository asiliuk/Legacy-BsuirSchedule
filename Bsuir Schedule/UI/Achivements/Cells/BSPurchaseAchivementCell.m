//
//  BSSocialAchivementCell.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSPurchaseAchivementCell.h"
#import "BSConstants.h"

NSString * const kPurchaseAchivementCellID = @"kPurchaseAchivementCellID";
@implementation BSPurchaseAchivementCell

- (void)setupWithAchivement:(BSAchivement *)achivement {
    [super setupWithAchivement:achivement];
    self.buyButton.hidden = achivement.unlocked;
}

- (void)awakeFromNib {
    self.buyButton.layer.masksToBounds = YES;
    self.buyButton.layer.cornerRadius = 5.0;
    
    self.buyButton.layer.borderWidth = 1.0;
    self.buyButton.layer.borderColor = self.buyButton.tintColor.CGColor;
    
    [self.buyButton setTitle:LZD(@"L_Buy") forState:UIControlStateNormal];
    [self.buyButton setTitle:LZD(@"L_Buy") forState:UIControlStateNormal | UIControlStateHighlighted];
}

- (IBAction)buyPressed:(id)sender {
    [self.delegate purchaseAchivementCellBuyPressed:self];
}
@end
