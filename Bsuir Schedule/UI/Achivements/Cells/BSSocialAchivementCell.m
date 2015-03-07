//
//  BSSocialAchivementCell.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSSocialAchivementCell.h"


NSString * const kSocialAchivementCellID = @"kSocialAchivementCellID";
@interface BSSocialAchivementCell()

@end
@implementation BSSocialAchivementCell


- (IBAction)showMail:(id)sender {
    [self.delegate socialAchivementCellDidPressEmail:self];
}

- (IBAction)showTwitter:(id)sender {
    [self.delegate socialAchivementCellDidPressTwitter:self];
}

- (IBAction)showFacebook:(id)sender {
    [self.delegate socialAchivementCellDidPressFacebook:self];
}


@end
