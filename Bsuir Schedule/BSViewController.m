//
//  ViewController.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSViewController.h"
#import "BSDataManager.h"
#import "BSLecturer+Thumbnail.h"
#import "NSString+Transiterate.h"


@interface BSViewController () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *days;
@end

@implementation BSViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    NSString *groupNumber = @"151004";
    [[BSDataManager sharedInstance] scheduleForGroupNumber:groupNumber withComplitionHandler:^{
        self.days = [[BSDataManager sharedInstance] days];
        [self.tableView reloadData];
    }];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"CellID"];
    
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

//===============================================TABLE VIEW===========================================
#pragma mark - Table View

- (NSArray*)pairsInDay:(BSDayOfWeek*)day forWeekNum:(NSInteger)weekNum {
    BSWeekNumber *wn = [[BSDataManager sharedInstance] weekNumberWithNumber:weekNum createIfNotExists:YES];
    NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
    NSArray *pairs = [day.pairs sortedArrayUsingDescriptors:@[sortD]];
    NSMutableArray *weekPairs = [NSMutableArray array];
    for (BSPair *pair in pairs) {
        if ([pair.weeks containsObject:wn]) {
            [weekPairs addObject:pair];
        }
    }
    return weekPairs;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.days count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self pairsInDay:self.days[section] forWeekNum:4] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *c = [tableView dequeueReusableCellWithIdentifier:@"CellID" forIndexPath:indexPath];
    BSPair *pair = [[self pairsInDay:self.days[indexPath.section] forWeekNum:4] objectAtIndex:indexPath.row];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"HH:mm"];
    
    NSString *dataString = [NSString stringWithFormat:@"%ld %@-%@ %@ (%@)", indexPath.section,[formatter stringFromDate:pair.startTime],[formatter stringFromDate:pair.endTime],pair.subject.name, pair.subjectType];
    [c.textLabel setText:dataString];
    c.imageView.image = [pair.lecturer thumbnail];
    return c;
}

@end
