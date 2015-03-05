//
//  BSAchivementNumeric.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 05.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivement.h"

@interface BSAchivementNumeric : BSAchivement
- (instancetype)initWithName:(NSString*)name
                 description:(NSString*)description
                   imageName:(NSString*)imageName
               achivementKey:(NSString*)achivementKey
                triggerCount:(NSInteger)triggerCount;
@end
