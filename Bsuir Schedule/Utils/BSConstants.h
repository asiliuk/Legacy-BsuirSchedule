//
//  BSColors.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 20.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#ifndef Bsuir_Schedule_BSConstants_h
#define Bsuir_Schedule_BSConstants_h

#define DAYS_LOAD_STEP 10
#define DAY_IN_SECONDS 24*3600
#define PREVIOUS_DAY_COUNT 2

#define OFFSET 10.0

#define ANIMATION_DURATION 0.3
#define SETTINGS_SCREEN_ANIMATION_DURATION 0.4

#define HEADER_HEIGHT 25.0
#define HEADER_LABEL_FONT_SIZE 17.0
#define HEADER_LABEL_OFFSET_X 10.0
#define HEADER_LABEL_OFFSET_Y 2.0

#define CELL_HEIGHT 72.0

//-------------------------------UTIILS---------------------------------
#define LZD(str) NSLocalizedString(str,nil)
//-------------------------------COLORS---------------------------------
#define UIColor(r,g,b,a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define BS_RED UIColor(241, 90, 90, 1.0)
#define BS_GREEN UIColor(78, 186, 111, 1.0)
#define BS_YELLOW UIColor(240, 197, 78, 1.0)
#define BS_BLUE UIColor(50, 149, 191, 1.0)
#define BS_PURPLE UIColor(149, 91, 165, 1.0)

#define BS_GRAY UIColor(130, 138, 151, 1.0)
#define BS_LIGHT_GRAY UIColor(240, 240, 240, 1.0)
#define BS_TABLE_VIEW_GRAY UIColor(239, 239, 244, 1.0)

#define BS_BLUE_GRAY UIColor(69, 101, 152, 1.0)

#define BS_LIGHT_BLUE UIColor(229, 235, 251, 1.0)
#define BS_LIGHT_RED UIColor(255, 139, 139, 1.0)
#define BS_DARK UIColor(38, 39, 46, 1.0)

#define BS_MENU_COLOR UIColor(37.0, 37.0, 37.0, 1.0)
#define BS_MENU_DARK_CLOR UIColor(27.0, 27.0, 27.0, 1.0)

//-------------------------------SYSTEM VERSIONS---------------------------------
#define SYSTEM_VERSION_EQUAL_TO(v)                  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedSame)
#define SYSTEM_VERSION_GREATER_THAN(v)              ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN_OR_EQUAL_TO(v)     ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedDescending)

//-------------------------------SCHEDULE KEYS---------------------------------

static NSString * const kAppURL = @"http://itunes.apple.com/app/id944151090";

static NSString * const kAchivementUnlocked = @"kAchivementUnlocked";

static NSString * const kSupporterAchivementID = @"com.saute.BsuirSchedule.supporter";
static NSString * const kSuperSupporterAchivementID = @"com.saute.BsuirSchedule.supersupporter";

static NSString * const kMenuDidClose = @"kMenuDidClose";

static NSString * const BASE_URL = @"http://www.bsuir.by/schedule/rest/";
static NSString * const SCHEDULE_PATH = @"schedule";
static NSString * const GROUPS_PATH = @"studentGroup";

static NSString * const kWidgetID = @"com.saute.Bsuir-Schedule.Schedule";
static NSString * const kWidgetGroup = @"kWidgetGroup";
static NSString * const kWidgetSubgroup = @"kWidgetSubgroup";

static NSString * const kEasterEggMode = @"kEasterEggMode";

static NSString * const kAppGroup = @"group.schedule_container";

static NSString * const kLastUpdate = @"last update";
static NSString * const kDatabaseStamp = @"kDatabaseStamp";
static NSString * const kCurrentScheduleGroup = @"Current schedule group";
static NSString * const kUserGroup = @"user group number";
static NSString * const kUserSubgroup = @"user subgroup number";

static NSString * const kScheduleModel = @"scheduleModel";

static NSString * const kDayName = @"weekDay";
static NSString * const kDaySchedule = @"schedule";

static NSString * const kSubjectType = @"lessonType";
static NSString * const kSubjectTime = @"lessonTime";
static NSString * const kSubjectName = @"subject";
static NSString * const kSubjectNumSubgroup = @"numSubgroup";
static NSString * const kSubjectAuditory = @"auditory";
static NSString * const kSubjectWeeks = @"weekNumber";

static NSString * const kLecturer = @"employee";
static NSString * const kLecturerID = @"id";
static NSString * const kLecturerDepartment = @"academicDepartment";

static NSString * const kLecturerLastName = @"lastName";
static NSString * const kLecturerMiddleName = @"middleName";
static NSString * const kLecturerFirstName = @"firstName";

static NSString * const kSchedulesGetUpdated = @"kSchedulesGetUpdated";

static NSString * const kParseApplicationID = @"NSKMaa9xOL2Loav0Eaj1KtvmwBEWpR2AN3ZcwWzo";
static NSString * const kParseClientKey = @"1Lv4keabSCqMmhDSOQWeOsfvKi7zsegPxs2pxRpE";


#endif
