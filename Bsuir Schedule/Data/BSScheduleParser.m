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
@implementation BSScheduleParser


//===============================================SCHEDULE PARSING===========================================
#pragma mark - Schedule parsing
#define UPDATE_INTERVAL 7*24*3600


+ (BOOL)scheduleExpiresForGroup:(BSGroup*)group {
    NSDate *lastUpdate = group.lastUpdate;
    NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdate];
    return  !(lastUpdate && timeInterval <= UPDATE_INTERVAL);
}
+ (void)employeesWithSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data;
        NSURL *url = [NSURL URLWithString:@"http://www.bsuir.by/schedule/rest/employee"];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        data = [NSData dataWithContentsOfURL:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
        if (dict) {
            NSArray *employee = dict[@"employee"];
            for (NSDictionary *lecturerData in employee) {
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
            }
        } else if (failure) {
            dispatch_async(dispatch_get_main_queue(), failure);
        }
    });
}
+ (void)scheduleForGroup:(BSGroup *)group withSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data;
        NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:group.groupNumber]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        data = [NSData dataWithContentsOfURL:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
        if (dict) {
            NSString *loadedScheduleStamp = [[NSKeyedArchiver archivedDataWithRootObject:dict] MD5];
            NSString *savedScheduleStamp = group.scheduleStamp;
            if (![loadedScheduleStamp isEqual:savedScheduleStamp]) {
                [[BSDataManager sharedInstance] resetSceduleForGroup:group];
                NSArray *scheduleData = dict[kScheduleModel];
                for (NSDictionary *dayData in scheduleData) {
                    NSString *dayName = dayData[kDayName];
                    BSDayOfWeek *day = [[BSDataManager sharedInstance] dayWithName:dayName createIfNotExists:YES];
                    id subjects = dayData[kDaySchedule];
                    if (![subjects isKindOfClass:[NSArray class]]) {
                        subjects = @[subjects];
                    }
                    for (NSDictionary *subjectData in subjects) {
                        NSString *subjectName = subjectData[kSubjectName];
                        NSString *pairType = subjectData[kSubjectType];
                        NSString *subgroupNumberString = subjectData[kSubjectNumSubgroup];
                        NSInteger subgroupNumber = 0;
                        if (subgroupNumberString && ![subgroupNumberString isEqualToString:@""]) {
                            subgroupNumber = [subgroupNumberString integerValue];
                        }
                        NSArray *subjectAuditoryAddresses = subjectData[kSubjectAuditory];
                        NSMutableArray *auditories = [NSMutableArray array];
                        if (subjectAuditoryAddresses && ![subjectAuditoryAddresses isKindOfClass:[NSArray class]]) {
                            subjectAuditoryAddresses = @[subjectAuditoryAddresses];
                        }
                        for (NSString *auditoryAddress in subjectAuditoryAddresses) {
                            BSAuditory *auditory = [[BSDataManager sharedInstance] auditoryWithAddress:auditoryAddress createIfNotExists:YES];
                            [auditories addObject:auditory];
                        }

                        BSSubject *subject = [[BSDataManager sharedInstance] subjectWithName:subjectName createIfNotExists:YES];
                        NSArray *lecturersData = subjectData[kLecturer];
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
                                                                                             lecturerID:[lecturerData[kLecturerID] integerValue]];
                                    
                                }
                            }
                            [lecturers addObject:lecturer];
                        }
                        NSString *startEndTime = subjectData[kSubjectTime];
                        startEndTime = [startEndTime stringByReplacingOccurrencesOfString:@" " withString:@""];
                        NSArray *pairTime = [startEndTime componentsSeparatedByString:@"-"];
                        NSString *startTime = [pairTime firstObject];
                        NSString *endTime = [pairTime lastObject];
                        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
                        NSLocale *ru = [[NSLocale alloc] initWithLocaleIdentifier:@"ru_RU"];
                        [formatter setLocale:ru];
                        [formatter setDateFormat:@"HH:mm"];
                        NSMutableSet *weekNumbers = [NSMutableSet set];
                        id weekNumbersData = subjectData[kSubjectWeeks];
                        if ([weekNumbersData isKindOfClass:[NSString class]]) {
                            weekNumbersData = @[weekNumbersData];
                        }
                        for (NSString *weekNumberData in weekNumbersData) {
                            [weekNumbers addObject:[[BSDataManager sharedInstance] weekNumberWithNumber:[weekNumberData integerValue] createIfNotExists:YES]];
                        }
                        [[BSDataManager sharedInstance] pairWithStartTime:[formatter dateFromString:startTime]
                                                                     endTime:[formatter dateFromString:endTime]
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
                group.lastUpdate = [NSDate date];
                group.scheduleStamp = loadedScheduleStamp;
                [[BSDataManager sharedInstance] saveContext];
                if (success) dispatch_async(dispatch_get_main_queue(), success);
            } else {
                if (success) dispatch_async(dispatch_get_main_queue(), success);
            }
        } else if (failure) {
            dispatch_async(dispatch_get_main_queue(), failure);
        }
    });
}

@end
