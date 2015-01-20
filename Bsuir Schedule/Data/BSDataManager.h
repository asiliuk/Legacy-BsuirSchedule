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
#import "BSDayOfWeek.h"
#import "BSAuditory.h"
#import "BSPair+Type.h"
#import "BSPair+Color.h"
#import "BSWeekNumber.h"
#import "BSDayWithWeekNum.h"

@interface BSDataManager : NSObject
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (void)resetDatabase;
- (NSURL *)storeURLBase;
//-------------------------------Methods---------------------------------
+ (instancetype)sharedInstance;
- (BSDayWithWeekNum*)dayToHighlight;
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
- (BSPair*)addPairWithStartTime:(NSDate*)startTime
                        endTime:(NSDate*)endTime
                 subgroupNumber:(NSInteger)subgroupNumber
                   pairTypeName:(NSString*)pairTypeName
                     inAuditory:(BSAuditory*)auditory
                          atDay:(BSDayOfWeek*)day
                        subject:(BSSubject*)subject
                      lecturers:(NSArray *)lecturers
                          weeks:(NSSet*)weeks;

//-------------------------------Week---------------------------------
- (NSArray*)weekNumbers;
- (BSWeekNumber*)weekNumberWithNumber:(NSInteger)weekNumber createIfNotExists:(BOOL)createIfNotExists;
- (BSWeekNumber*)addWeekNumberWithNumber:(NSInteger)weekNumber;
- (BSWeekNumber*)currentWeek;
- (BSWeekNumber*)weekNumberWithDate:(NSDate*)date;

@end
