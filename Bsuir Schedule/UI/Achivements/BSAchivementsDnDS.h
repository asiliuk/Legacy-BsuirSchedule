//
//  BSAchivementsDnDS.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BSAchivementsDnDS : NSObject  <UITableViewDataSource, UITableViewDelegate>
- (instancetype)initWithAchivements:(NSArray*)achivements;
@end
