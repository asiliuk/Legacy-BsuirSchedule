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
#import "BSLecturer+Thumbnail.h"
#import "BSDayOfWeek+Number.h"
#import "BSAuditory.h"
#import "BSPair+Type.h"
#import "BSPair+Color.h"
#import "BSWeekNumber.h"
#import "BSDayWithWeekNum.h"
#import "BSGroup.h"
#import "BSSchedule.h"

@interface BSDataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)resetSceduleForGroup:(BSGroup*)group;
- (NSURL *)storeURLBase;
//-------------------------------Methods---------------------------------
+ (instancetype)sharedInstance;
- (BSDayWithWeekNum*)dayToHighlightInSchedule:(BSSchedule*)schedule weekMode:(BOOL)weekMode;

//-------------------------------Schedule---------------------------------
- (NSArray*)schelules;
- (void)deleteSchedule:(BSSchedule*)schedule;
- (BSSchedule*)scheduleWithGroupNumber:(NSString*)groupNumber andSubgroup:(NSInteger)subgroup createIfNotExists:(BOOL)createIfNotExists;
- (BSSchedule*)scheduleWithGroup:(BSGroup*)group andSubgroup:(NSInteger)subgroup createIfNotExists:(BOOL)createIfNotExists;

//-------------------------------Groups---------------------------------
- (NSArray*)groups;
- (BSGroup*)groupWithNumber:(NSString*)number createIfNotExists:(BOOL)createIfNotExists;
- (BSGroup*)addGroupWithNumber:(NSString*)number;
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
- (BSDayOfWeek*)dayWithDate:(NSDate*)date;
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
- (NSArray*)sortPairs:(NSArray*)pairs;
- (BSPair*)pairWithStartTime:(NSDate*)startTime
                     endTime:(NSDate*)endTime
              subgroupNumber:(NSInteger)subgroupNumber
                pairTypeName:(NSString*)pairTypeName
                  inAuditory:(BSAuditory*)auditory
                       atDay:(BSDayOfWeek*)day
                     subject:(BSSubject*)subject
                   lecturers:(NSArray *)lecturers
                       weeks:(NSSet*)weeks
                       group:(BSGroup*)group
           createIfNotExists:(BOOL)createIfNotExists;

- (BSPair*)addPairWithStartTime:(NSDate*)startTime
                        endTime:(NSDate*)endTime
                 subgroupNumber:(NSInteger)subgroupNumber
                   pairTypeName:(NSString*)pairTypeName
                     inAuditory:(BSAuditory*)auditory
                          atDay:(BSDayOfWeek*)day
                        subject:(BSSubject*)subject
                      lecturers:(NSArray *)lecturers
                          weeks:(NSSet*)weeks
                          group:(BSGroup*)group;

- (NSArray*)filterPairs:(NSArray*)pairs forSchedule:(BSSchedule*)schedule forWekFormat:(BOOL)weekFormat;

//-------------------------------Week---------------------------------
- (NSArray*)weekNumbers;
- (BSWeekNumber*)weekNumberWithNumber:(NSInteger)weekNumber createIfNotExists:(BOOL)createIfNotExists;
- (BSWeekNumber*)addWeekNumberWithNumber:(NSInteger)weekNumber;
- (BSWeekNumber*)currentWeek;
- (BSWeekNumber*)weekNumberWithDate:(NSDate*)date;

@end
