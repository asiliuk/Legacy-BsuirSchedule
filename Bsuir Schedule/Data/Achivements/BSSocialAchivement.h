//
//  BSSocialAchivement.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 06.03.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import "BSAchivementOnce.h"

@interface BSSocialAchivement : BSAchivementOnce
@property (strong, nonatomic, readonly) NSString *shareText;
- (instancetype)initWithName:(NSString*)name
                 description:(NSString*)description
                   imageName:(NSString*)imageName
               achivementKey:(NSString*)achivementKey
                   shareText:(NSString*)shareText;
@end
