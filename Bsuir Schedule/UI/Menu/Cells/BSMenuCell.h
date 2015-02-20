//
//  BMWMenuCell.h
//  BMW club
//
//  Created by Anton Siliuk on 12.12.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSMenuCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UIImageView *iconIV;
@property (strong, nonatomic) IBOutlet UILabel *cellLabel;
@property (strong, nonatomic) UIView *separator;

@end
