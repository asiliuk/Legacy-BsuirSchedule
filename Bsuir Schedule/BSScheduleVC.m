//
//  ViewController.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSScheduleVC.h"
#import "BSDataManager.h"
#import "BSPairCell.h"
#import "BSColors.h"

#import "BSLecturer+Thumbnail.h"
#import "NSString+Transiterate.h"



static NSString * const kCellID = @"Pair cell id";


@interface BSScheduleVC () <UITableViewDataSource, UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSArray *days;
@end

@implementation BSScheduleVC

- (instancetype)init
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Расписание";
    
    [self.navigationController.navigationBar setBarTintColor:BS_BLUE];
    UIFont *titleFont = [UIFont fontWithName:@"OpenSans" size:20.0f];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],
                                                                      NSFontAttributeName: titleFont}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;

    NSString *groupNumber = @"151004";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSPairCell class]) bundle:nil] forCellReuseIdentifier:kCellID];

    [[BSDataManager sharedInstance] scheduleForGroupNumber:groupNumber withComplitionHandler:^{
        self.days = [[BSDataManager sharedInstance] days];
        [self.tableView reloadData];
    }];
    
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
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
//===============================================TABLE VIEW===========================================
#pragma mark - Table View

- (NSArray*)pairsInDay:(BSDayOfWeek*)day forWeekNum:(BSWeekNumber *)weekNum {
    NSSortDescriptor *sortD = [NSSortDescriptor sortDescriptorWithKey:@"startTime" ascending:YES];
    NSArray *pairs = [day.pairs sortedArrayUsingDescriptors:@[sortD]];
    NSMutableArray *weekPairs = [NSMutableArray array];
    for (BSPair *pair in pairs) {
        if ([pair.weeks containsObject:weekNum]) {
            [weekPairs addObject:pair];
        }
    }
    return weekPairs;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.days count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    BSWeekNumber *weekNumber = [[BSDataManager sharedInstance] currentWeek];
    return [[self pairsInDay:self.days[section] forWeekNum:weekNumber] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSPairCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    BSWeekNumber *weekNumber = [[BSDataManager sharedInstance] currentWeek];
    BSPair *pair = [[self pairsInDay:self.days[indexPath.section] forWeekNum:weekNumber] objectAtIndex:indexPath.row];
    BSLecturer *lecturer = pair.lecturer;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"hh:mm"];
    NSString *timeString = [NSString stringWithFormat:@"%@\n-\n%@", [formatter stringFromDate:pair.startTime],[formatter stringFromDate:pair.endTime]];
    [cell setTimeText:timeString];
    [cell.subjectNameLabel setText:pair.subject.name];
    [cell.auditoryLabel setText:pair.auditory.address];
    UIImage *thumbnail = [lecturer thumbnail];
    [cell.lecturerIV setImage:thumbnail];
    cell.lecturerIV.hidden = thumbnail == nil;
    cell.lecturerNameLabel.hidden = lecturer == nil;

    if (lecturer) {
        [cell.lecturerNameLabel setText:[NSString stringWithFormat:@"%@ %@.%@.",
                                         lecturer.lastName,
                                         [lecturer.firstName substringToIndex:1],
                                         [lecturer.middleName substringToIndex:1]]];
    }     cell.pairTypeIndicator.backgroundColor = [pair colorForPairType];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    BSPairCell *pairCell = (BSPairCell*)[tableView cellForRowAtIndexPath:indexPath];
    if (pairCell) {
        if (!pairCell.showingLecturerName) {
            [self deselectVisibleCells];
        }
        [pairCell makeSelected:!pairCell.showingLecturerName];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self deselectVisibleCells];
}

- (void)deselectVisibleCells {
    for (BSPairCell *pairCell in [self.tableView visibleCells]) {
        if (pairCell.showingLecturerName) {
            [pairCell makeSelected:NO];
        }
    }
}

@end
