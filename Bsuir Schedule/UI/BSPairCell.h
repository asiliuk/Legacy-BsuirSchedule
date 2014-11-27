//
//  BSPairCell.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 18.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BSDataManager.h"

@interface BSPairCell : UITableViewCell
@property (strong, nonatomic) NSString *timeText;
@property (strong, nonatomic) IBOutlet UILabel *subjectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *auditoryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lecturerIV;
@property (strong, nonatomic) IBOutlet UIView *pairView;
@property (strong, nonatomic) IBOutlet UILabel *lecturerNameLabel;

@property (strong, nonatomic) UIColor *pairTypeIndicatorColor;

@property (nonatomic) BOOL showingLecturerName;
- (void)makeSelected:(BOOL)selected;
- (void)makeCurrentPairCell:(BOOL)isCurrent;

- (void)setupWithPair:(BSPair*)pair cellForCurrentDay:(BOOL)cellForCurrentDay;
- (void)updateUIForWidget;
@end
