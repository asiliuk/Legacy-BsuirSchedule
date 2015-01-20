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

+ (BOOL)scheduleNeedUpdateForGroup:(NSString *)groupNumber {
    NSUserDefaults *sharedDefaults = [NSUserDefaults sharedDefaults];
    NSString *currentScheduleGroup = [sharedDefaults objectForKey:kCurrentScheduleGroup];
    return  ![currentScheduleGroup isEqual:groupNumber];
}

+ (BOOL)scheduleExpires {
    NSUserDefaults *sharedDefaults = [NSUserDefaults sharedDefaults];
    NSDate *lastUpdate = [sharedDefaults objectForKey:kLastUpdate];
    NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdate];
    return  !(lastUpdate && timeInterval <= UPDATE_INTERVAL);
}

+ (void)scheduleForGroupNumber:(NSString *)groupNumber withSuccess:(void (^)(void))success failure:(void (^)(void))failure {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSData *data;
        NSURL *url = [NSURL URLWithString:[BASE_URL stringByAppendingString:groupNumber]];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
        data = [NSData dataWithContentsOfURL:url];
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
        NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
        if (dict) {
            NSString *databaseStamp = [[NSKeyedArchiver archivedDataWithRootObject:dict] MD5];
            NSString *savedDatabaseStamp = [[NSUserDefaults sharedDefaults] objectForKey:kDatabaseStamp];
            if (![databaseStamp isEqual:savedDatabaseStamp]) {
                [[NSUserDefaults sharedDefaults] setObject:databaseStamp forKey:kDatabaseStamp];
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [[BSDataManager sharedInstance] resetDatabase];
                });
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
                        NSString *subjectAuditoryAddress = subjectData[kSubjectAuditory];
                        BSAuditory *auditory = [[BSDataManager sharedInstance] auditoryWithAddress:subjectAuditoryAddress createIfNotExists:YES];
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
                        [[BSDataManager sharedInstance] addPairWithStartTime:[formatter dateFromString:startTime]
                                                                     endTime:[formatter dateFromString:endTime]
                                                              subgroupNumber:subgroupNumber
                                                                pairTypeName:pairType
                                                                  inAuditory:auditory
                                                                       atDay:day
                                                                     subject:subject
                                                                   lecturers:lecturers
                                                                       weeks:weekNumbers];
                    }
                }
                [[BSDataManager sharedInstance] saveContext];
                NSUserDefaults *sharedDefaults = [NSUserDefaults sharedDefaults];
                [sharedDefaults setObject:[NSDate date] forKey:kLastUpdate];
                [sharedDefaults setObject:groupNumber forKey:kCurrentScheduleGroup];
                if (success) dispatch_async(dispatch_get_main_queue(), success);
            }
        } else if (failure) {
            dispatch_async(dispatch_get_main_queue(), failure);
        }
    });
}

@end
