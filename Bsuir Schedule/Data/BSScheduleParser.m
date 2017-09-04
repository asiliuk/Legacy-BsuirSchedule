//
//  BSScheduleParser.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 27.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSScheduleParser.h"
#import "BSConstants.h"
#import "AppDelegate.h"
#import "XMLDictionary.h"
#import "BSDataManager.h"
#import "NSUserDefaults+Share.h"
#import "NSData+MD5.h"

NSString * const kGroupName = @"name";
NSString * const kGroupID = @"id";


@implementation BSScheduleParser


//===============================================SCHEDULE PARSING===========================================
#pragma mark - Schedule parsing
#define UPDATE_INTERVAL 7*24*3600


+ (BOOL)scheduleExpiresForGroup:(BSGroup*)group {
    NSDate *lastUpdate = group.lastUpdate;
    NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdate];
    return  !(lastUpdate && timeInterval <= UPDATE_INTERVAL);
}
//+ (void)employeesWithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        NSData *data;
//        NSURL *url = [NSURL URLWithString:@"http://www.bsuir.by/schedule/rest/employee"];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//        data = [NSData dataWithContentsOfURL:url];
//        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
//        if (dict) {
//            NSArray *employee = dict[@"employee"];
//            for (NSDictionary *lecturerData in employee) {
//                BSLecturer *lecturer;
//                if (lecturerData) {
//                    lecturer = [[BSDataManager sharedInstance] lecturerWithID:[lecturerData[kLecturerID] integerValue]];
//                    if (!lecturer) {
//                        lecturer = [[BSDataManager sharedInstance] addLecturerWithFirstName:lecturerData[kLecturerFirstName]
//                                                                                  midleName:lecturerData[kLecturerMiddleName]
//                                                                                   lastName:lecturerData[kLecturerLastName]
//                                                                                 department:@""//lecturerData[kLecturerDepartment]
//                                                                                 lecturerID:[lecturerData[kLecturerID] integerValue]];
//                        
//                    }
//                }
//            }
//        } else if (failure) {
//            dispatch_async(dispatch_get_main_queue(), failure);
//        }
//    });
//}

+ (void)parseScheduleData:(NSArray*)scheduleData forGroup:(BSGroup*)group {
    if (![scheduleData isKindOfClass:[NSArray class]]) {
        scheduleData = @[scheduleData];
    }
    for (NSDictionary *dayData in scheduleData) {
        NSString *dayName = dayData[kDayName];
        id subjects = dayData[kDaySchedule];
        if (![subjects isKindOfClass:[NSArray class]]) {
            subjects = @[subjects];
        }
        for (NSDictionary *subjectData in subjects) {
            
            NSDate *startTime;
            NSDate *endTime;
            [BSScheduleParser getStartTime:&startTime endTime:&endTime fromTimeString:subjectData[kSubjectTime]];
            NSInteger subgroupNumber = [BSScheduleParser subgroupNumberFromString:[subjectData[kSubjectNumSubgroup] stringValue]];
            NSString *pairType = subjectData[kSubjectType];
            NSArray *auditories = [BSScheduleParser auditoriesFromAuditoriesData:subjectData[kSubjectAuditory]];
            BSDayOfWeek *day = [[BSDataManager sharedInstance] dayWithName:dayName createIfNotExists:YES];
            NSString *subjectName = subjectData[kSubjectName];
            BSSubject *subject = [[BSDataManager sharedInstance] subjectWithName:subjectName createIfNotExists:YES];
            NSArray *lecturers = [BSScheduleParser lecturersFromLecturersData:subjectData[kLecturer]];
            NSSet *weekNumbers = [BSScheduleParser weekNumbersFromData:subjectData[kSubjectWeeks]];
            
            [[BSDataManager sharedInstance] pairWithStartTime:startTime
                                                      endTime:endTime
                                               subgroupNumber:subgroupNumber
                                                 pairTypeName:pairType
                                                 inAuditories:auditories
                                                        atDay:day
                                                      subject:subject
                                                    lecturers:lecturers
                                                        weeks:weekNumbers
                                                        group:group
                                            createIfNotExists:YES];
        }
    }

}

+ (void)scheduleForGroup:(BSGroup *)group withSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    [BSScheduleParser scheduleDicitonaryForGroup:group completion:^(NSDictionary *dict, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (dict && [dict[kScheduleModel] count] > 0) {
                NSString *loadedScheduleStamp = [[NSKeyedArchiver archivedDataWithRootObject:dict] MD5];
                NSString *savedScheduleStamp = group.scheduleStamp;
                if (![loadedScheduleStamp isEqual:savedScheduleStamp]) {
                    //reset if group exist and loaded schedule is newer
                    [[BSDataManager sharedInstance] resetSceduleForGroup:group];

                    //parse schedule
                    NSArray *scheduleData = dict[kScheduleModel];
                    [BSScheduleParser parseScheduleData:scheduleData forGroup:group];

                    //update stamps
                    group.lastUpdate = [NSDate date];
                    group.scheduleStamp = loadedScheduleStamp;
                    [[BSDataManager sharedInstance] saveContext];
                    if (success) success();
                } else {
                    if (success) success();
                }
            } else if (failure) {
                failure();
            }
        });
    }];
}

+ (void)allGroupsWithSuccess:(void (^)(NSArray *))success failure:(void (^)(NSError *))failure {
    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingPathComponent:GROUPS_PATH]];
    [self loadDataFromURL:url completion:^(id data, NSError *error) {
        NSArray *groups = data;
        if (!error && groups) {
            if (success) success(groups);
        } else {
            if (failure) failure(error);
        }
    }];
}

//===============================================HELPERS===========================================
#pragma mark - Helpers

+ (void)groupIDForGroup:(BSGroup*)group completion:(void(^)(NSString *groupID, NSError *error))completion {

    NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingPathComponent:GROUPS_PATH]];
    [self loadDataFromURL:url completion:^(id data, NSError *error) {
        if (error) {
            return completion(nil, error);
        }

        NSString *groupID;
        NSArray *groups = data;
        if ([groups isKindOfClass:[NSArray class]]) {
            NSPredicate *groupPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
                BOOL keep = NO;
                if ([evaluatedObject isKindOfClass:[NSDictionary class]]) {
                    NSDictionary *groupData = evaluatedObject;
                    NSString *groupName = [groupData objectForKey:kGroupName];
                    keep = [groupName isEqual:group.groupNumber];
                }
                return keep;
            }];
            NSArray *groupsWithGroupName = [groups filteredArrayUsingPredicate:groupPredicate];
            groupID = [[[groupsWithGroupName firstObject] objectForKey:kGroupID] stringValue];
        }

        completion(groupID, nil);
    }];
}

+ (void)scheduleDicitonaryForGroup:(BSGroup*)group completion:(void(^)(NSDictionary *group, NSError *error))completion {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?studentGroup=%@", BASE_URL, SCHEDULE_PATH, group.groupNumber]];
    [self loadDataFromURL:url completion:completion];
}

+ (void)loadDataFromURL:(NSURL*)url completion:(void(^)(id data, NSError *error))completion {

    [[[NSURLSession sharedSession] dataTaskWithURL:url completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (!error) {
            NSError *jsonError;
            id result = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
            completion(result, jsonError);
        } else {
            completion(nil, error);
        }
    }] resume];
}

+ (NSArray*)lecturersFromLecturersData:(NSArray*)lecturersData {
    if ([lecturersData isKindOfClass:[NSDictionary class]]) {
        lecturersData = @[lecturersData];
    }
    NSMutableArray *lecturers = [NSMutableArray array];
    for (NSDictionary *lecturerData in lecturersData) {
        BSLecturer *lecturer;
        if (lecturerData) {
            lecturer = [[BSDataManager sharedInstance] lecturerWithID:[lecturerData[kLecturerID] integerValue]];
            if (!lecturer) {
                lecturer = [[BSDataManager sharedInstance] addLecturerWithFirstName:lecturerData[kLecturerFirstName]
                                                                          midleName:lecturerData[kLecturerMiddleName]
                                                                           lastName:lecturerData[kLecturerLastName]
                                                                         department:@""//lecturerData[kLecturerDepartment]
                                                                         lecturerID:[lecturerData[kLecturerID] integerValue]
                                                                          avatarURL:lecturerData[kLecturerAvatarURL]];
                
            }
        }
        [lecturers addObject:lecturer];
    }
    return [NSArray arrayWithArray:lecturers];
}

+ (NSArray*)auditoriesFromAuditoriesData:(NSArray*)auditoriesData {
    NSMutableArray *auditories = [NSMutableArray array];
    if (auditoriesData && ![auditoriesData isKindOfClass:[NSArray class]]) {
        auditoriesData = @[auditoriesData];
    }
    for (NSString *auditoryAddress in auditoriesData) {
        BSAuditory *auditory = [[BSDataManager sharedInstance] auditoryWithAddress:auditoryAddress createIfNotExists:YES];
        [auditories addObject:auditory];
    }
    return [NSArray arrayWithArray:auditories];
}

+ (NSInteger)subgroupNumberFromString:(NSString*)subgroupNumberString {
    NSInteger subgroupNumber = 0;
    if (subgroupNumberString && ![subgroupNumberString isEqualToString:@""]) {
        subgroupNumber = [subgroupNumberString integerValue];
    }
    return subgroupNumber;
}

+ (NSSet *)weekNumbersFromData:(id)weekNumbersData {
    NSMutableSet *weekNumbers = [NSMutableSet set];
    if ([weekNumbersData isKindOfClass:[NSString class]]) {
        weekNumbersData = @[weekNumbersData];
    }
    for (NSString *weekNumberData in weekNumbersData) {
        [weekNumbers addObject:[[BSDataManager sharedInstance] weekNumberWithNumber:[weekNumberData integerValue] createIfNotExists:YES]];
    }
    return [NSSet setWithSet:weekNumbers];
}

+ (void)getStartTime:(NSDate**)startTime endTime:(NSDate**)endTime fromTimeString:(NSString*)timeString {
    timeString = [timeString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSArray *pairTime = [timeString componentsSeparatedByString:@"-"];
    NSString *startTimeString = [pairTime firstObject];
    NSString *endTimeString = [pairTime lastObject];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSLocale *ru = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
    [formatter setLocale:ru];
    [formatter setDateFormat:@"HH:mm"];
    
    *startTime = [formatter dateFromString:startTimeString];
    *endTime = [formatter dateFromString:endTimeString];
}


@end
