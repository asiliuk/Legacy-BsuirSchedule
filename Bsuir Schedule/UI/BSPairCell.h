//
//  BSPairCell.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 18.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BSPairCell : UITableViewCell
@property (strong, nonatomic) NSString *timeText;
@property (strong, nonatomic) IBOutlet UILabel *subjectNameLabel;
@property (strong, nonatomic) IBOutlet UILabel *auditoryLabel;
@property (strong, nonatomic) IBOutlet UIImageView *lecturerIV;
@property (strong, nonatomic) IBOutlet UIView *pairView;
@property (strong, nonatomic) IBOutlet UIView *pairTypeIndicator;
@property (strong, nonatomic) IBOutlet UILabel *lecturerNameLabel;

@property (nonatomic) BOOL showingLecturerName;
- (void)makeSelected:(BOOL)selected;

@end
