//
//  DataManager.h
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "BSSubject.h"
#import "BSLecturer.h"
#import "BSDayOfWeek.h"
#import "BSAuditory.h"
#import "BSPair.h"
#import "BSWeekNumber.h"

static NSString * const BASE_URL = @"http://www.bsuir.by/schedule/rest/schedule/";

static NSString * const kLastUpdate = @"last update";
static NSString * const kScheduleModel = @"scheduleModel";

static NSString * const kDayName = @"weekDay";
static NSString * const kDaySchedule = @"schedule";

static NSString * const kSubjectType = @"lessonType";
static NSString * const kSubjectTime = @"lessonTime";
static NSString * const kSubjectName = @"subject";
static NSString * const kSubjectNumSubgroup = @"subject";
static NSString * const kSubjectAuditory = @"auditory";
static NSString * const kSubjectWeeks = @"weekNumber";

static NSString * const kLecturer = @"employee";
static NSString * const kLecturerID = @"id";
static NSString * const kLecturerDepartment = @"academicDepartment";

static NSString * const kLecturerLastName = @"lastName";
static NSString * const kLecturerMiddleName = @"middleName";
static NSString * const kLecturerFirstName = @"firstName";

@interface BSDataManager : NSObject
//-------------------------------Methods---------------------------------
+ (instancetype)sharedInstance;
- (BOOL)scheduleNeedUpdate;
- (void)scheduleForGroupNumber:(NSString*)groupNumber withComplitionHandler:(void(^)(void))complitionHandler;

//-------------------------------Subject---------------------------------
- (NSArray*)subjects;
- (BSSubject*)subjectWithName:(NSString *)name createIfNotExists:(BOOL)createIfNotExists;
- (BSSubject*)addSubjectWithName:(NSString*)name;
//-------------------------------Lecturer---------------------------------
- (NSArray*)lectures;
- (BSLecturer*)lecturerWithID:(NSInteger)lecturerID;
- (BSLecturer*)lecturerWithFirstName:(NSString*)firstName
                         midleName:(NSString*)middleName
                          lastName:(NSString*)lastName;

- (BSLecturer*)addLecturerWithFirstName:(NSString*)firstName
                            midleName:(NSString*)middleName
                             lastName:(NSString*)lastName
                           department:(NSString*)department
                           lecturerID:(NSInteger)lecturerID;
//-------------------------------Day---------------------------------
- (NSArray*)days;
- (BSDayOfWeek*)dayWithName:(NSString*)dayName createIfNotExists:(BOOL)createIfNotExists;
- (BSDayOfWeek*)dayWithIndex:(NSInteger)dayIndex createIfNotExists:(BOOL)createIfNotExists;
- (BSDayOfWeek*)addDayWithName:(NSString*)dayName;
- (NSInteger)indexForDayName:(NSString*)dayName;
//-------------------------------Auditory---------------------------------
- (NSArray*)auditories;
- (BSAuditory*)auditoryWithAddress:(NSString*)address createIfNotExists:(BOOL)createIfNotExists;
- (BSAuditory*)addAuditoryWithAddress:(NSString*)address;
//-------------------------------Pair---------------------------------
- (NSArray*)pairs;
- (BSPair*)addPairWithStartTime:(NSDate*)startTime
                        endTime:(NSDate*)endTime
                 subgroupNumber:(NSInteger)subgroupNumber
                    subjectType:(NSString*)subjectType
                     inAuditory:(BSAuditory*)auditory
                          atDay:(BSDayOfWeek*)day
                        subject:(BSSubject*)subject
                       lecturer:(BSLecturer*)lecturer
                          weeks:(NSSet*)weeks;

//-------------------------------Week---------------------------------
- (NSArray*)weekNumbers;
- (BSWeekNumber*)weekNumberWithNumber:(NSInteger)weekNumber createIfNotExists:(BOOL)createIfNotExists;
- (BSWeekNumber*)addWeekNumberWithNumber:(NSInteger)weekNumber;
- (BSWeekNumber*)currentWeek;

@end
