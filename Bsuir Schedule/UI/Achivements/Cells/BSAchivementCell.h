//
//  BSAchivementCell.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSAchivement.h"

extern NSString * const kAchivementCellID;
@interface BSAchivementCell : UITableViewCell
@property (strong, readonly, nonatomic) BSAchivement *achivement;
- (void)setupWithAchivement:(BSAchivement*)achivement;
@end
