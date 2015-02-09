//
//  BSPairCell.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 18.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDataManager.h"
#import "BSDay.h"

@class BSPairCell;
@protocol BSPairCellDelegate <NSObject>
- (void)thumbnailForLecturer:(BSLecturer*)lecturer withStartFrame:(CGRect)thumbnailFrame getTappedOnCell:(BSPairCell *)cell;
@end

@interface BSPairCell : UITableViewCell
@property (strong, nonatomic) UIColor *pairTypeIndicatorColor;

@property (weak, nonatomic) id<BSPairCellDelegate> delegate;
@property (nonatomic) BOOL showingLecturers;
- (void)makeSelected:(BOOL)selected;

- (void)setupWithPair:(BSPair*)pair inDay:(id<BSDay>)day weekMode:(BOOL)weekMode;
- (void)setupWithPair:(BSPair*)pair inDay:(id<BSDay>)day;
- (void)updateUIForWidget;
@end
