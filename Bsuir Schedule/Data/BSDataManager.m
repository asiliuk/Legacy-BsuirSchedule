//
//  DataManager.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSDataManager.h"
#import "AppDelegate.h"
#import "XMLDictionary.h"

@interface BSDataManager()
@property (strong, nonatomic) NSManagedObjectContext *context;
@end
@implementation BSDataManager

+ (instancetype)sharedInstance {
    
    static id sharedObject = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedObject = [[super allocWithZone:NULL] init];
    });
    return sharedObject;
}

+ (id)allocWithZone:(struct _NSZone *)zone {
    
    return [[self class] sharedInstance];
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.context = [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    }
    return self;
}

//==============================================APP DELEGATE METHODS===========================================
#pragma mark - App Delegate methods
- (void)saveContext {
    [(AppDelegate*)[UIApplication sharedApplication].delegate saveContext];
 }

- (NSURL*)applicationDocumentsDirectory {
    return [(AppDelegate*)[UIApplication sharedApplication].delegate applicationDocumentsDirectory];
}

//===============================================SCHEDULE PARSING===========================================
#pragma mark - Schedule parsing

- (void)scheduleForGroupNumber:(NSString *)groupNumber withComplitionHandler:(void (^)(void))complitionHandler {
    NSData *data;
    NSURL *scheduleLocalURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:[groupNumber stringByAppendingString:@".schedule"]];
    
    if ([[NSFileManager defaultManager] fileExistsAtPath:[scheduleLocalURL path]]) {
        data = [NSData dataWithContentsOfURL:scheduleLocalURL];
    } else {
        NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:groupNumber]];
        data = [NSData dataWithContentsOfURL:url];
        [data writeToURL:scheduleLocalURL atomically:YES];
    }
    NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
    
    
    NSArray *scheduleData = dict[kScheduleModel];
    for (NSDictionary *dayData in scheduleData) {
        NSString *dayName = dayData[kDayName];
        BSDayOfWeek *day = [[BSDataManager sharedInstance] dayWithName:dayName createIfNotExists:YES];
        NSArray *subjects = dayData[kDaySchedule];
        for (NSDictionary *subjectData in subjects) {
            NSString *subjectName = subjectData[kSubjectName];
            NSString *subjectType = subjectData[kSubjectType];
            NSInteger subgroupNumber = [subjectData[kSubjectNumSubgroup] integerValue];
            NSString *subjectAuditoryAddress = subjectData[kSubjectAuditory];
            BSAuditory *auditory = [[BSDataManager sharedInstance] auditoryWithAddress:subjectAuditoryAddress createIfNotExists:YES];
            BSSubject *subject = [[BSDataManager sharedInstance] subjectWithName:subjectName createIfNotExists:YES];
            NSDictionary *lecturerData = subjectData[kLecturer];
            BSLecturer *lecturer;
            if (lecturerData) {
                lecturer = [[BSDataManager sharedInstance] lecturerWithID:[lecturerData[kLecturerID] integerValue]];
                if (!lecturer) {
                    lecturer = [[BSDataManager sharedInstance] addLecturerWithFirstName:lecturerData[kLecturerFirstName]
                                                                              midleName:lecturerData[kLecturerMiddleName]
                                                                               lastName:lecturerData[kLecturerLastName]
                                                                             department:@""//lecturerData[kLecturerDepartment]
                                                                             lecturerID:[lecturerData[kLecturerID] integerValue]];
                    
                }
            }
            NSString *startEndTime = subjectData[kSubjectTime];
            startEndTime = [startEndTime stringByReplacingOccurrencesOfString:@" " withString:@""];
            NSArray *pairTime = [startEndTime componentsSeparatedByString:@"-"];
            NSString *startTime = [pairTime firstObject];
            NSString *endTime = [pairTime lastObject];
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSLog(@"Time %@ %@ %@ %@", startTime, endTime, [formatter dateFromString:startTime],[formatter dateFromString:endTime]);

            [[BSDataManager sharedInstance] addPairWithStartTime:[formatter dateFromString:startTime]
                                                         endTime:[formatter dateFromString:endTime]
                                                  subgroupNumber:subgroupNumber
                                                     subjectType:subjectType
                                                      inAuditory:auditory
                                                           atDay:day
                                                         subject:subject
                                                        lecturer:lecturer];
        }
    }
    complitionHandler();
}

//===============================================SUBJECT===========================================
#pragma mark - Subject

- (NSArray*)subjects {
    NSFetchRequest *subjectsRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSSubject class])];
    return [self.context executeFetchRequest:subjectsRequest error:nil];
}

- (BSSubject*)subjectWithName:(NSString *)name createIfNotExists:(BOOL)createIfNotExists{
    BSSubject *subject;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSSubject class])];
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    request.predicate = namePredicate;
    NSError *error;
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in subject fetch: %@", error.localizedDescription);
    }else if ([results count] > 0) {
        subject = [results lastObject];
    } else if (createIfNotExists) {
        subject = [self addSubjectWithName:name];
    }
    return subject;
}

- (BSSubject*)addSubjectWithName:(NSString *)name {
    BSSubject *subject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSSubject class]) inManagedObjectContext:self.context];
    subject.name = name;
    return subject;
}

//===============================================LECTURER===========================================
#pragma mark - Lecturer

- (NSArray*)lectures {
    NSFetchRequest *lecturesRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSLecturer class])];
    return [self.context executeFetchRequest:lecturesRequest error:nil];
}

- (BSLecturer*)lecturerWithID:(NSInteger)lecturerID {
    NSPredicate *idPredicate = [NSPredicate predicateWithFormat:@"lecturerID == %@", @(lecturerID)];
    return [self lecturerWithPredicate:idPredicate];
}

- (BSLecturer*)lecturerWithFirstName:(NSString *)firstName
                         midleName:(NSString *)middleName
                          lastName:(NSString *)lastName{
    NSPredicate *lecturerPredicate = [NSPredicate predicateWithFormat:@"firstName == %@ AND middleName == %@ AND lastName == %@", firstName, middleName, lastName];
    return [self lecturerWithPredicate:lecturerPredicate];
}

- (BSLecturer*)lecturerWithPredicate:(NSPredicate*)predicate {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSLecturer class])];
    request.predicate = predicate;
    BSLecturer *lecturer;
    NSError *error;
    NSArray *lecturers = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in lectures fetch: %@", error.localizedDescription);
    } else if ([lecturers count] > 0) {
        lecturer = [lecturers lastObject];
    }
    return lecturer;
}


- (BSLecturer*)addLecturerWithFirstName:(NSString *)firstName
                            midleName:(NSString *)middleName
                             lastName:(NSString *)lastName
                           department:(NSString *)department
                           lecturerID:(NSInteger)lecturerID
{
    BSLecturer *lecturer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSLecturer class]) inManagedObjectContext:self.context];
    lecturer.firstName = firstName;
    lecturer.middleName = middleName;
    lecturer.lastName = lastName;
    lecturer.lecturerID = @(lecturerID);
    lecturer.academicDepartment = department;
    return lecturer;
}

//===============================================DAY===========================================
#pragma mark - Day

- (NSArray*)days {
    NSFetchRequest *daysRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSDayOfWeek class])];
    return [self.context executeFetchRequest:daysRequest error:nil];
}

- (BSDayOfWeek*)dayWithName:(NSString *)dayName createIfNotExists:(BOOL)createIfNotExists{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSDayOfWeek class])];
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", dayName];
    BSDayOfWeek *day;
    NSError *error;
    NSArray *days = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in days fetch: %@", error.localizedDescription);
    } else if ([days count] > 0) {
        day = [days lastObject];
    } else if (createIfNotExists) {
        day = [self addDayWithName:dayName];
    }
    return day;
}

- (BSDayOfWeek*)addDayWithName:(NSString *)dayName {
    BSDayOfWeek *day = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSDayOfWeek class]) inManagedObjectContext:self.context];
    day.name = dayName;
    return day;
}

//===============================================AUDITORY===========================================
#pragma mark - Auditory

- (NSArray*)auditories {
    NSFetchRequest *auditoriesRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSAuditory class])];
    return [self.context executeFetchRequest:auditoriesRequest error:nil];
}

- (BSAuditory*)auditoryWithAddress:(NSString *)address createIfNotExists:(BOOL)createIfNotExists {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSAuditory class])];
    request.predicate = [NSPredicate predicateWithFormat:@"address == %@", address];
    BSAuditory *auditory;
    NSError *error;
    NSArray *auditories = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in auditory fetch: %@", error.localizedDescription);
    } else if ([auditories count] > 0) {
        auditory = [auditories lastObject];
    } else if (createIfNotExists) {
        auditory = [self addAuditoryWithAddress:address];
    }
    return auditory;
}

- (BSAuditory*)addAuditoryWithAddress:(NSString *)address {
    BSAuditory *auditory = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSAuditory class]) inManagedObjectContext:self.context];
    auditory.address = address;
    return auditory;
}

//===============================================PAIR===========================================
#pragma mark - Pair

- (NSArray*)pairs {
    NSFetchRequest *pairsRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSPair class])];
    return [self.context executeFetchRequest:pairsRequest error:nil];
}

- (BSPair*)addPairWithStartTime:(NSDate *)startTime
                        endTime:(NSDate *)endTime
                 subgroupNumber:(NSInteger)subgroupNumber
                    subjectType:(NSString *)subjectType
                     inAuditory:(BSAuditory *)auditory
                          atDay:(BSDayOfWeek *)day
                        subject:(BSSubject *)subject
                       lecturer:(BSLecturer *)lecturer
{
    BSPair *pair;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSPair class])];
    NSPredicate *pairPredicate = [NSPredicate predicateWithFormat:@"startTime == %@ AND endTime == %@ \
                                      AND subgroupNumber == %@ AND subjectType == %@ \
                                      AND auditory == %@ AND day == %@ \
                                      AND subject == %@ AND lecturer == %@",
                                      startTime, endTime,
                                      @(subgroupNumber), subjectType,
                                      auditory, day,
                                      subject, lecturer];
    request.predicate = pairPredicate;
    NSError *error;
    NSArray *pairs = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in pairs fetch: %@", error.localizedDescription);
    } else if (pairs && [pairs count] > 0) {
        pair = [pairs lastObject];
    } else {
        pair = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSPair class]) inManagedObjectContext:self.context];
        pair.startTime = startTime;
        pair.endTime = endTime;
        pair.subgroupNumber = @(subgroupNumber);
        pair.subjectType = subjectType;
        pair.auditory = auditory;
        pair.day = day;
        pair.subject = subject;
        pair.lecturer = lecturer;
    }
    [self.context save:nil];
    return pair;
}

@end
