//
//  ViewController.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "ViewController.h"
#import "XMLDictionary.h"
#import <CoreData/CoreData.h>
#import "AppDelegate.h"

static NSString * const kScheduleModel = @"scheduleModel";

static NSString * const kDayName = @"weekDay";
static NSString * const kDaySchedule = @"schedule";

static NSString * const kSubjectType = @"lessonType";
static NSString * const kSubjectTime = @"lessonTime";
static NSString * const kSubjectName = @"subject";
static NSString * const kSubjectNumSubgroup = @"subject";

static NSString * const kLecturer = @"employee";
static NSString * const kLecturerID = @"id";
static NSString * const kLecturerLastName = @"lastName";
static NSString * const kLecturerMiddleName = @"middleName";
static NSString * const kLecturerFirstName = @"firstName";

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSManagedObjectContext *context =  [(AppDelegate*)[UIApplication sharedApplication].delegate managedObjectContext];
    NSEntityDescription *sub = [NSEntityDescription insertNewObjectForEntityForName:@"Subject" inManagedObjectContext:context];
    sub.name = @"test";
    
    NSFetchRequest *r = [NSFetchRequest fetchRequestWithEntityName:@"Subject"];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"name == %@",@"test"];
    r.predicate = p;
    NSArray *a = [context executeFetchRequest:r error:nil];
    
    NSURL *url = [NSURL URLWithString:@"http://www.bsuir.by/schedule/rest/schedule/151004"];
    NSData *data = [NSData dataWithContentsOfURL:url];
    NSDictionary *dict = [NSDictionary dictionaryWithXMLData:data];
    NSArray *schedule = dict[kScheduleModel];
    for (NSDictionary *day in schedule) {
        NSString *dayName = day[kDayName];
        NSArray *subjects = day[kDaySchedule];
        for (NSDictionary *subject in subjects) {
            NSString *lessonType = subject[kSubjectType];
            NSDictionary *lecturer = subject[kLecturer];
            NSLog(@"%@ %@ %@", lecturer[kLecturerLastName], lecturer[kLecturerMiddleName], lecturer[kLecturerFirstName]);

        }
    }
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
