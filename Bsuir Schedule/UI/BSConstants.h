//
//  BSColors.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 20.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#ifndef Bsuir_Schedule_BSConstants_h
#define Bsuir_Schedule_BSConstants_h

//-------------------------------COLORS---------------------------------
#define UIColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define BS_RED UIColor(241, 90, 90, 1.0)
#define BS_GREEN UIColor(78, 186, 111, 1.0)
#define BS_YELLOW UIColor(240, 197, 78, 1.0)
#define BS_BLUE UIColor(50, 149, 191, 1.0)
#define BS_PURPLE UIColor(149, 91, 165, 1.0)
#define BS_GRAY UIColor(130, 138, 151, 1.0)
#define BS_BLUE_GRAY UIColor(69, 101, 152, 1.0)
#define BS_LIGHT_BLUE UIColor(229, 235, 251, 1.0)
#define BS_LIGHT_RED UIColor(255, 139, 139, 1.0)

//-------------------------------SYSTEM VERSIONS---------------------------------
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

#endif