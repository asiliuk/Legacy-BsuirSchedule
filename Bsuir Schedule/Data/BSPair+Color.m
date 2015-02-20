//
//  BSPair+Color.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 19.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSPair+Color.h"
#import "BSConstants.h"

@implementation BSPair (Color)
- (UIColor*)colorForPairType {
    return [BSPair colorForPairType:(PairType)[self.pairType integerValue]];
}
+ (UIColor*)colorForPairType:(PairType)pairType {
    UIColor *pairTypeColor;
    switch (pairType) {
        case BSPairTypeLaboratory:
            pairTypeColor = BS_YELLOW;
            break;
        case BSPairTypeLecture:
            pairTypeColor = BS_GREEN;
            break;
        case BSPairTypePractical:
            pairTypeColor = BS_RED;
            break;
        default:
            pairTypeColor = BS_BLUE;
            break;
    }
    return pairTypeColor;
}
@end
