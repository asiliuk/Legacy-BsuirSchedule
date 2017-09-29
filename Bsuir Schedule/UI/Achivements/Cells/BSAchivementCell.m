//
//  BSAchivementCell.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementCell.h"

NSString * const kAchivementCellID = @"kAchivementCellID";

@interface BSAchivementCell()
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageIV;
@end

@implementation BSAchivementCell

- (void)setupWithAchivement:(BSAchivement *)achivement {
    [self.nameLabel setText:achivement.name];
    [self.descriptionLabel setText:achivement.achivementDescription];
    [self.imageIV setImage:[achivement image]];
    _achivement = achivement;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
