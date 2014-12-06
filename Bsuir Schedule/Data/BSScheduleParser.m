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

@implementation BSScheduleParser


//===============================================SCHEDULE PARSING===========================================
#pragma mark - Schedule parsing
#define UPDATE_INTERVAL 7*24*3600

+ (BOOL)scheduleNeedUpdateForGroup:(NSString *)groupNumber {
    NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroup];
    NSDate *lastUpdate = [sharedDefaults objectForKey:kLastUpdate];
    NSString *currentScheduleGroup = [sharedDefaults objectForKey:kCurrentScheduleGroup];
    NSInteger timeInterval = [[NSDate date] timeIntervalSinceDate:lastUpdate];
    return  !(lastUpdate && timeInterval <= UPDATE_INTERVAL && [currentScheduleGroup isEqual:groupNumber]);
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
                                                                lecturer:lecturer
                                                                   weeks:weekNumbers];
                }
            }
            [[BSDataManager sharedInstance] saveContext];
            NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:kAppGroup];
            [sharedDefaults setObject:[NSDate date] forKey:kLastUpdate];
            [sharedDefaults setObject:groupNumber forKey:kCurrentScheduleGroup];
            if (success) dispatch_async(dispatch_get_main_queue(), success);
        } else if (failure) {
            dispatch_async(dispatch_get_main_queue(), failure);
        }
    });
}

@end
