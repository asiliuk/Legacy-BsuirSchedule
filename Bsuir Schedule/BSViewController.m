//
//  ViewController.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSViewController.h"
#import "BSDataManager.h"


@interface BSViewController ()

@end

@implementation BSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *groupNumber = @"151004";
    [[BSDataManager sharedInstance] scheduleForGroupNumber:groupNumber withComplitionHandler:^{
        NSArray *l = [[BSDataManager sharedInstance] lectures];
        NSArray *s = [[BSDataManager sharedInstance] subjects];
        NSArray *d = [[BSDataManager sharedInstance] days];
        NSArray *aud = [[BSDataManager sharedInstance] auditories];
        NSArray *pairs = [[BSDataManager sharedInstance] pairs];
        NSArray *weeks = [[BSDataManager sharedInstance] weekNumbers];
        BSDayOfWeek *day = d[0];
        NSInteger weekNum = 4;
        for (BSDayOfWeek *day in d) {
            NSLog(@"---------------");
            NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
            NSArray *pairs = [day.pairs sortedArrayUsingDescriptors:@[sortD]];
            for (BSPair *p in pairs) {
                NSString *weeks = @"";
                for (BSWeekNumber *weekNumber in p.weeks) {
                    weeks = [weeks stringByAppendingString:[NSString stringWithFormat:@" %ld",[weekNumber.weekNumber integerValue]]];
                }
                NSLog(@"%@ %@ %@ %@", p.subject.name, p.subjectType, p.lecturer.lastName, weeks);
            }
        }

    }];
    
    NSLog(@"%d",[[BSDataManager sharedInstance] scheduleNeedUpdate]);
    // Do any additional setup after loading the view, typically from a nib.
}

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "com.saute.Bsuir_Schedule" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
