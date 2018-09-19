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
#import "BSConstants.h"
#import "NSDate+Compare.h"
#import "NSUserDefaults+Share.h"
#import "BSDayOfWeek+Number.h"
#import <NotificationCenter/NotificationCenter.h>

@interface BSDataManager()
@property (strong, nonatomic) NSArray *weekDays;
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

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.weekDays = @[@"Воскресенье", @"Понедельник", @"Вторник", @"Среда", @"Четверг", @"Пятница", @"Суббота"];
    }
    return self;
}

#define MAX_INTERVAL_TO_HIGHLIGHT 20
- (BSDayWithWeekNum*)dayToHighlightInSchedule:(BSSchedule *)schedule weekMode:(BOOL)weekMode {
    BSDayWithWeekNum *dayToHighlight;
    NSDate *now = [NSDate date];
    for (NSInteger dayIndex = 0; dayIndex < MAX_INTERVAL_TO_HIGHLIGHT; dayIndex++) {
        NSDate *dayDate = [now dateByAddingTimeInterval:DAY_IN_SECONDS*dayIndex];
        BSDayWithWeekNum *dayWithWeekNum = [[BSDayWithWeekNum alloc] initWithDate:dayDate];
        if (dayWithWeekNum && [[dayWithWeekNum pairsForSchedule:schedule weekFormat:weekMode] count] > 0) {
            BOOL today = [now isEqual:dayDate];
            NSArray *pairs = [dayWithWeekNum pairsForSchedule:schedule weekFormat:weekMode];
            NSDate *todayLastPairEnd = [[pairs lastObject] endTime]; //need pairs of 'today' to highlight tomorrow section header
            BOOL todayPairsEnded = [todayLastPairEnd compareTime:now] == NSOrderedAscending || [dayWithWeekNum.pairs count] == 0;
            if (!(today && (todayPairsEnded || dayWithWeekNum.dayOfWeek == nil))) {
                dayToHighlight = dayWithWeekNum;
                break;
            }
        }
    }
    return dayToHighlight;
}

//===============================================SCHEDULE===========================================
#pragma mark - Schedule

- (NSArray*)schelules {
    NSSortDescriptor *creationSort = [NSSortDescriptor sortDescriptorWithKey:@"createdAt" ascending:YES];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"group.groupNumber" ascending:YES];
    NSFetchRequest *schedulesRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSSchedule class])];
    schedulesRequest.sortDescriptors = @[creationSort, nameSort];
    return [self.managedObjectContext executeFetchRequest:schedulesRequest error:nil];
}

- (void)deleteSchedule:(BSSchedule *)schedule {
    BSGroup *group = schedule.group;
    if ([self.currentWidgetSchedule isEqual:schedule]) {
        self.currentWidgetSchedule = [[self schelules] firstObject];
    }
    [self.managedObjectContext deleteObject:schedule];

    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([BSSchedule class])];
    NSPredicate *schedulePredicate = [NSPredicate predicateWithFormat:@"group.groupNumber == %@",schedule.group.groupNumber];
    request.predicate = schedulePredicate;
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in schedule fetch: %@", error.localizedDescription);
    } else if (!results || [results count] == 0) {
        [self resetSceduleForGroup:group];
        [self.managedObjectContext deleteObject:group];
    }

    [[NSNotificationCenter defaultCenter] postNotificationName:kSchedulesGetUpdated object:nil];
}

- (BSSchedule*)scheduleWithGroupNumber:(NSString*)groupNumber andSubgroup:(NSInteger)subgroup createIfNotExists:(BOOL)createIfNotExists {
    BSGroup *group = [self groupWithNumber:groupNumber createIfNotExists:YES];
    return  [self scheduleWithGroup:group andSubgroup:subgroup createIfNotExists:createIfNotExists];
}
- (BSSchedule*)scheduleWithGroup:(BSGroup*)group andSubgroup:(NSInteger)subgroup createIfNotExists:(BOOL)createIfNotExists {
    BSSchedule *schedule;
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:NSStringFromClass([BSSchedule class])];
    NSPredicate *schedulePredicate = [NSPredicate predicateWithFormat:@"group.groupNumber == %@ AND subgroup == %@",group.groupNumber, @(subgroup)];
    request.predicate = schedulePredicate;
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in schedule fetch: %@", error.localizedDescription);
    }else if ([results count] > 0) {
        schedule = [results lastObject];
    } else if (createIfNotExists) {
        schedule = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSSchedule class]) inManagedObjectContext:self.managedObjectContext];
        schedule.group = group;
        schedule.subgroup = @(subgroup);
        schedule.createdAt = [NSDate date];
        [[NSNotificationCenter defaultCenter] postNotificationName:kSchedulesGetUpdated object:nil];
    }
    return schedule;
}
@dynamic currentWidgetSchedule;
- (BSSchedule*)currentWidgetSchedule {
    NSString *widgetGroup = [[NSUserDefaults sharedDefaults] objectForKey:kWidgetGroup];
    NSNumber *widgetSubgroup = [[NSUserDefaults sharedDefaults] objectForKey:kWidgetSubgroup];
    return [self scheduleWithGroupNumber:widgetGroup andSubgroup:[widgetSubgroup integerValue] createIfNotExists:NO];
}

- (void)setCurrentWidgetSchedule:(BSSchedule *)currentWidgetSchedule {
    if ([currentWidgetSchedule.group.pairs count] > 0) {
        NCWidgetController *widgetController = [[NCWidgetController alloc] init];
        [widgetController setHasContent:YES forWidgetWithBundleIdentifier:kWidgetID];
    }
    [[NSUserDefaults sharedDefaults] setObject:(currentWidgetSchedule.group.groupNumber) ?
                                                currentWidgetSchedule.group.groupNumber :
                                                @""
                                        forKey:kWidgetGroup];
    [[NSUserDefaults sharedDefaults] setObject:(currentWidgetSchedule.subgroup) ?
                                                currentWidgetSchedule.subgroup :
                                                @""
                                        forKey:kWidgetSubgroup];
    
}
//===============================================GROUP===========================================
#pragma mark - Group

- (NSArray*)groups {
    NSFetchRequest *groupsRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSGroup class])];
    return [self.managedObjectContext executeFetchRequest:groupsRequest error:nil];
}

- (BSGroup*)groupWithNumber:(NSString *)number createIfNotExists:(BOOL)createIfNotExists {
    BSGroup *group;
    if (number && [number isKindOfClass:[NSString class]]) {
        NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSGroup class])];
        NSPredicate *numberPredicate = [NSPredicate predicateWithFormat:@"groupNumber == %@", number];
        request.predicate = numberPredicate;
        NSError *error;
        NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
        if (error) {
            NSLog(@"Error in group fetch: %@", error.localizedDescription);
        }else if ([results count] > 0) {
            group = [results lastObject];
        } else if (createIfNotExists) {
            group = [self addGroupWithNumber:number];
        }
    }
    return group;
}

- (BSGroup*)addGroupWithNumber:(NSString*)number {
    BSGroup *group = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSGroup class]) inManagedObjectContext:self.managedObjectContext];
    group.groupNumber = number;
    return group;
}

//===============================================SUBJECT===========================================
#pragma mark - Subject

- (NSArray*)subjects {
    NSFetchRequest *subjectsRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSSubject class])];
    return [self.managedObjectContext executeFetchRequest:subjectsRequest error:nil];
}

- (BSSubject*)subjectWithName:(NSString *)name createIfNotExists:(BOOL)createIfNotExists{
    BSSubject *subject;
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSSubject class])];
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    request.predicate = namePredicate;
    NSError *error;
    NSArray *results = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    BSSubject *subject = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSSubject class]) inManagedObjectContext:self.managedObjectContext];
    subject.name = name;
    return subject;
}

//===============================================LECTURER===========================================
#pragma mark - Lecturer

- (NSArray*)lectures {
    NSFetchRequest *lecturesRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSLecturer class])];
    return [self.managedObjectContext executeFetchRequest:lecturesRequest error:nil];
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
    NSArray *lecturers = [self.managedObjectContext executeFetchRequest:request error:&error];
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
                              avatarURL:(NSString *)avatarURL
{
    BSLecturer *lecturer = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSLecturer class]) inManagedObjectContext:self.managedObjectContext];
    lecturer.firstName = firstName;
    lecturer.middleName = middleName;
    lecturer.lastName = lastName;
    lecturer.lecturerID = @(lecturerID);
    lecturer.academicDepartment = department;
    lecturer.avatarURL = ([avatarURL isKindOfClass:[NSNull class]]) ? nil : avatarURL;
    return lecturer;
}

//===============================================DAY===========================================
#pragma mark - Day

- (NSArray*)days {
    NSFetchRequest *daysRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSDayOfWeek class])];
    [daysRequest setReturnsObjectsAsFaults:NO];
    [daysRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"pairs", nil]];
    NSArray *days = [self.managedObjectContext executeFetchRequest:daysRequest error:nil];
    NSArray *sortedDays = [days sortedArrayUsingComparator:^NSComparisonResult(BSDayOfWeek* obj1, BSDayOfWeek* obj2) {
        return [[self dayNumberForDay:obj1] compare:[self dayNumberForDay:obj2]];
    }];
    return sortedDays;
}

- (NSNumber*)dayNumberForDay:(BSDayOfWeek*)dayOfWeek {
    NSArray *dayOrder = @[@"Понедельник", @"Вторник", @"Среда", @"Четверг", @"Пятница", @"Суббота", @"Воскресенье"];
    return @([dayOrder indexOfObject:dayOfWeek.name]);

}

- (BSDayOfWeek*)dayWithIndex:(NSInteger)dayIndex createIfNotExists:(BOOL)createIfNotExists {
    return [self dayWithName:[self.weekDays objectAtIndex:dayIndex] createIfNotExists:createIfNotExists];
}

- (BSDayOfWeek*)dayWithDate:(NSDate*)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnits = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday;
    NSDateComponents *dateComponents = [gregorian components:calendarUnits fromDate:date];
    return [self dayWithIndex:([dateComponents weekday]-1) createIfNotExists:NO];
}

- (BSDayOfWeek*)dayWithName:(NSString *)dayName createIfNotExists:(BOOL)createIfNotExists{
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSDayOfWeek class])];
    request.predicate = [NSPredicate predicateWithFormat:@"name == %@", dayName];
    BSDayOfWeek *day;
    NSError *error;
    NSArray *days = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    BSDayOfWeek *day = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSDayOfWeek class]) inManagedObjectContext:self.managedObjectContext];
    day.name = dayName;
    return day;
}

- (NSInteger)indexForDayName:(NSString *)dayName {
    return [self.weekDays indexOfObject:dayName];
}

//===============================================AUDITORY===========================================
#pragma mark - Auditory

- (NSArray*)auditories {
    NSFetchRequest *auditoriesRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSAuditory class])];
    return [self.managedObjectContext executeFetchRequest:auditoriesRequest error:nil];
}

- (BSAuditory*)auditoryWithAddress:(NSString *)address createIfNotExists:(BOOL)createIfNotExists {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSAuditory class])];
    request.predicate = [NSPredicate predicateWithFormat:@"address == %@", address];
    BSAuditory *auditory;
    NSError *error;
    NSArray *auditories = [self.managedObjectContext executeFetchRequest:request error:&error];
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
    BSAuditory *auditory = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSAuditory class]) inManagedObjectContext:self.managedObjectContext];
    auditory.address = address;
    return auditory;
}

//===============================================PAIR===========================================
#pragma mark - Pair

- (NSArray*)pairs {
    NSFetchRequest *pairsRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSPair class])];
    return [self.managedObjectContext executeFetchRequest:pairsRequest error:nil];
}

- (NSArray*)sortPairs:(NSArray *)pairs {
    NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
    NSSortDescriptor *nameSort = [NSSortDescriptor sortDescriptorWithKey:@"subject.name" ascending:YES];
    NSSortDescriptor *weekSort = [NSSortDescriptor sortDescriptorWithKey:@"weeks" ascending:YES comparator:^NSComparisonResult(id obj1, id obj2) {
        NSComparisonResult compRes = NSOrderedSame;
        if ([obj1 isKindOfClass:[NSSet class]] && [obj2 isKindOfClass:[NSSet class]]) {
            NSSet *weeks1 = obj1;
            NSSet *weeks2 = obj2;
            NSSortDescriptor *weekNumSort = [NSSortDescriptor sortDescriptorWithKey:@"weekNumber" ascending:YES];
            BSWeekNumber *week1 = [[weeks1 sortedArrayUsingDescriptors:@[weekNumSort]] firstObject];
            BSWeekNumber *week2 = [[weeks2 sortedArrayUsingDescriptors:@[weekNumSort]] firstObject];
            compRes = [week1.weekNumber compare:week2.weekNumber];
        }
        return compRes;
    }];
    return [pairs sortedArrayUsingDescriptors:@[sortD, weekSort, nameSort]];
}

- (BSPair*)pairWithStartTime:(NSDate *)startTime
                     endTime:(NSDate *)endTime
              subgroupNumber:(NSInteger)subgroupNumber
                pairTypeName:(NSString *)pairTypeName
                inAuditories:(NSArray *)auditories
                       atDay:(BSDayOfWeek *)day
                     subject:(BSSubject *)subject
                   lecturers:(NSArray *)lecturers
                       weeks:(NSSet *)weeks
                       group:(BSGroup *)group
           createIfNotExists:(BOOL)createIfNotExists
{
    BSPair *pair;
    PairType pairType = [BSPair pairTypeWithName:pairTypeName];
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSPair class])];
    NSPredicate *pairPredicate = [NSPredicate predicateWithFormat:@"startTime == %@ AND endTime == %@ \
                                  AND subgroupNumber == %@ AND pairType == %d \
                                  AND auditories contains[c] %@ AND day == %@ \
                                  AND subject == %@ AND weeks contains[c] %@",
                                  startTime, endTime,
                                  @(subgroupNumber), pairType,
                                  auditories, day,
                                  subject, weeks];
    request.predicate = pairPredicate;
    
    NSError *error;
    NSArray *pairs = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in pairs fetch: %@", error.localizedDescription);
    } else if (pairs && [pairs count] > 0) {
        pair = [pairs lastObject];
    } else if (createIfNotExists) {
        pair = [self addPairWithStartTime:startTime
                                  endTime:endTime
                           subgroupNumber:subgroupNumber
                             pairTypeName:pairTypeName
                             inAuditories:auditories
                                    atDay:day
                                  subject:subject
                                lecturers:lecturers
                                    weeks:weeks
                                    group:group];
    }
    return pair;
}

- (BSPair*)addPairWithStartTime:(NSDate *)startTime
                        endTime:(NSDate *)endTime
                 subgroupNumber:(NSInteger)subgroupNumber
                   pairTypeName:(NSString*)pairTypeName
                   inAuditories:(NSArray *)auditories
                          atDay:(BSDayOfWeek *)day
                        subject:(BSSubject *)subject
                      lecturers:(NSArray *)lecturers
                          weeks:(NSSet *)weeks
                          group:(BSGroup *)group
{
    BSPair *pair;
    PairType pairType = [BSPair pairTypeWithName:pairTypeName];
    pair = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSPair class]) inManagedObjectContext:self.managedObjectContext];
    pair.startTime = startTime;
    pair.endTime = endTime;
    pair.subgroupNumber = @(subgroupNumber);
    pair.pairType = @(pairType);
    [pair addAuditories:[NSSet setWithArray:auditories]];
    pair.day = day;
    pair.subject = subject;
    pair.lecturers = [NSSet setWithArray:lecturers];
    [pair addWeeks:weeks];
    [pair addGroupsObject:group];
    return pair;
}

- (NSArray*)filterPairs:(NSArray*)pairs forSchedule:(BSSchedule*)schedule forWekFormat:(BOOL)weekFormat {
    BSGroup *group = schedule.group;
    NSNumber *subgroup = schedule.subgroup;
    NSPredicate *pairPredicate = [NSPredicate predicateWithBlock:^BOOL(BSPair* evaluatedObject, NSDictionary *bindings) {
        BOOL filter = [evaluatedObject.groups containsObject:group];
        if (!weekFormat) {
            filter = filter && ([evaluatedObject.subgroupNumber isEqual:@(0)] || [evaluatedObject.subgroupNumber isEqual:subgroup]);
        }
        return filter;
    }];
    
    
    return [pairs filteredArrayUsingPredicate:pairPredicate];
}

//===============================================WEEKNUMBERS===========================================
#pragma mark - Week Numbers

- (NSArray*)weekNumbers {
    NSFetchRequest *weekNumbersRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSWeekNumber class])];
    NSError *error;
    NSArray *weekNumbers = [self.managedObjectContext executeFetchRequest:weekNumbersRequest error:&error];
    if (error) {
        NSLog(@"Error in fetch week numbers %@", error.localizedDescription);
    }
    return weekNumbers;
}

- (BSWeekNumber*)weekNumberWithNumber:(NSInteger)weekNumber createIfNotExists:(BOOL)createIfNotExists {
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSWeekNumber class])];
    request.predicate = [NSPredicate predicateWithFormat:@"weekNumber == %@", @(weekNumber)];
    BSWeekNumber *weekNumberObj;
    NSError *error;
    NSArray *weekNumbers = [self.managedObjectContext executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error in auditory fetch: %@", error.localizedDescription);
    } else if ([weekNumbers count] > 0) {
        weekNumberObj = [weekNumbers lastObject];
    } else if (createIfNotExists) {
        weekNumberObj = [self addWeekNumberWithNumber:weekNumber];
    }
    return weekNumberObj;
}

- (BSWeekNumber*)addWeekNumberWithNumber:(NSInteger)weekNumber {
    BSWeekNumber *weekNumberObj = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([BSWeekNumber class]) inManagedObjectContext:self.managedObjectContext];
    weekNumberObj.weekNumber = @(weekNumber);
    return weekNumberObj;
}

- (BSWeekNumber*)currentWeek {
    return [self weekNumberWithDate:[NSDate date]];
}

#define START_DAY 1
#define START_MONTH 9

#define END_DAY 1
#define END_MONTH 7


- (BSWeekNumber*)weekNumberWithDate:(NSDate *)date {
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSCalendarUnit calendarUnits = NSCalendarUnitDay | NSCalendarUnitMonth | NSCalendarUnitYear | NSCalendarUnitWeekday;
    NSDateComponents *dateComponents = [gregorian components:calendarUnits fromDate:date];
    dateComponents.day -= [dateComponents weekday];
    
    NSDateComponents *lastDay = [gregorian components:calendarUnits  fromDate:[NSDate date]];
    lastDay.day =  END_DAY;
    lastDay.month = END_MONTH;
    NSDate *lastDayDate = [gregorian dateFromComponents:lastDay];
    
    NSDateComponents *firstDay = [gregorian components:calendarUnits  fromDate:[NSDate date]];
    firstDay.day =  START_DAY;
    firstDay.month = START_MONTH;
    NSDate *firstDayDate = [gregorian dateFromComponents:firstDay];
    firstDay = [gregorian components:calendarUnits fromDate:firstDayDate]; // to reload weekDay unit
    firstDay.day -= [firstDay weekday];
    
    NSTimeInterval timePased = [[gregorian dateFromComponents:dateComponents] timeIntervalSinceDate:[gregorian dateFromComponents:firstDay]];
    if (timePased < 0 && [[NSDate date] compare:lastDayDate] == NSOrderedAscending) {
        firstDay.year -= 1;
    }
    timePased = fabs([[gregorian dateFromComponents:dateComponents] timeIntervalSinceDate:[gregorian dateFromComponents:firstDay]]);
    NSInteger weeksPast = timePased / (7*24*3600);
    NSInteger weekNum = (weeksPast % 4) + 1;
    return [self weekNumberWithNumber:weekNum createIfNotExists:YES];
}
//===============================================CORE DATA STACK===========================================
#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory
{
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [searchPaths lastObject];
    
    return [NSURL fileURLWithPath:documentPath];
}

- (NSURL *)storeURLBase {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.saute.Bsuir_Schedule" in the application's documents directory.
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:kAppGroup];
    } else {
        return [self applicationDocumentsDirectory];
    }
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"ScheduleData" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [self storeURLBase];
    storeURL = [storeURL URLByAppendingPathComponent:@"ScheduleData.sqlite"];
    
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    NSDictionary *pragmaOptions = [NSDictionary dictionaryWithObject:@"MEMORY" forKey:@"journal_mode"];
    
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption,
                             pragmaOptions, NSSQLitePragmasOption, nil];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

- (void)resetSceduleForGroup:(BSGroup*)group {
//    NSArray *persistentStores = [self.persistentStoreCoordinator persistentStores];
//    for (NSPersistentStore *store in persistentStores) {
//        NSError *error;
//        NSURL *storeURL = store.URL;
//        [_persistentStoreCoordinator removePersistentStore:store error:&error];
//        [[NSFileManager defaultManager] removeItemAtPath:storeURL.path error:&error];
//        if (error) {
//            NSLog(@"Error: %@",error.localizedDescription);
//        }
//    }
//    _persistentStoreCoordinator = nil;
//    _managedObjectModel = nil;
//    _managedObjectContext = nil;
    group.scheduleStamp = nil;
    group.lastUpdate = nil;
    NSFetchRequest *pairsRequest = [NSFetchRequest fetchRequestWithEntityName:NSStringFromClass([BSPair class])];
    NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"groups contains[c] %@", group];
    pairsRequest.predicate = groupPredicate;
    NSError *error;
    NSArray *items = [_managedObjectContext executeFetchRequest:pairsRequest error:&error];
    
    for (NSManagedObject *managedObject in items) {
        [_managedObjectContext deleteObject:managedObject];
    }
    if (![_managedObjectContext save:&error]) {
        NSLog(@"Error deleting pair - error:%@",error);
    }
}

@end
