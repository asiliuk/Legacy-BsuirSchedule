//
//  BSAchivementsDnDS.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementsDnDS.h"
#import "BSAchivementCell.h"

@interface BSAchivementsDnDS()
@property (strong, nonatomic) NSArray *achivements;
@end
@implementation BSAchivementsDnDS
- (instancetype)initWithAchivements:(NSArray *)achivements
{
    self = [super init];
    if (self) {
        self.achivements = [NSArray arrayWithArray:achivements];
    }
    return self;
}

//===============================================TABLE VIEW===========================================
#pragma mark - TableView

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.achivements count];
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BSAchivementCell *cell = [tableView dequeueReusableCellWithIdentifier:kAchivementCellID forIndexPath:indexPath];
    [cell setupWithAchivement:[self.achivements objectAtIndex:indexPath.row]];
    return cell;
}
static CGFloat const achivementCellHeight = 130.0f;
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return achivementCellHeight;
}
@end
