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

#import "BSSettingsVC.h"



static NSString * const kCellID = @"Pair cell id";


@interface BSScheduleVC () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate>
@property (strong, nonatomic) IBOutlet UITableView *tableView;
//@property (strong, nonatomic) NSArray *days;
@property (strong, nonatomic) NSFetchedResultsController *frc;
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
    
    UIBarButtonItem *settingsButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tools"] style:UIBarButtonItemStylePlain target:self action:@selector(showSettingsScreen)];
    settingsButton.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = settingsButton;
    
    NSString *groupNumber = @"151004";
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSPairCell class]) bundle:nil] forCellReuseIdentifier:kCellID];
    NSFetchRequest *pairRequest = [[NSFetchRequest alloc] initWithEntityName:@"BSPair"];
    BSWeekNumber *curentWeek = [[BSDataManager sharedInstance] currentWeek];
    pairRequest.predicate = [NSPredicate predicateWithFormat:@"weeks contains[c] %@", curentWeek];
    pairRequest.sortDescriptors = @[[[NSSortDescriptor alloc] initWithKey:@"day" ascending:YES]];
    [pairRequest setReturnsObjectsAsFaults:NO];
    [pairRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObjects:@"lecturer", @"subject", nil]];
    self.frc = [[NSFetchedResultsController alloc] initWithFetchRequest:pairRequest managedObjectContext:[BSDataManager sharedInstance].context sectionNameKeyPath:@"day" cacheName:nil];
    self.frc.delegate = self;
    if ([[BSDataManager sharedInstance]scheduleNeedUpdateForGroup:groupNumber]) {
        [[BSDataManager sharedInstance] scheduleForGroupNumber:groupNumber withComplitionHandler:^{
            [self.frc performFetch:nil];
//            [self.tableView reloadData];
        }];
    } else {
        [self.frc performFetch:nil];
    }

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
    return [[self.frc sections] count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    BSWeekNumber *weekNumber = [[BSDataManager sharedInstance] currentWeek];
    return [[[[self.frc sections] objectAtIndex:section] objects] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSPairCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    BSPair *pair = [self.frc objectAtIndexPath:indexPath];
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

#define HEADER_HEIGHT 30.0
#define HEADER_LABEL_FONT_SIZE 17.0
#define HEADER_LABEL_OFFSET_X 10.0
#define HEADER_LABEL_OFFSET_Y 5.0

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(HEADER_LABEL_OFFSET_X, HEADER_LABEL_OFFSET_Y,
                                                               tableView.frame.size.width, HEADER_HEIGHT)];
    [label setFont:[UIFont fontWithName:@"OpenSans" size:HEADER_LABEL_FONT_SIZE]];
    NSString *string = [[[self.frc sections] objectAtIndex:section] name];
    [label setText:string];
    [label setTextColor:BS_GRAY];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor clearColor]];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return HEADER_HEIGHT+5.0;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView reloadData];
}

//===============================================UI===========================================
#pragma mark - UI

#define SETTINGS_SCREEN_ANIMATION_DURATION 0.4
- (void)showSettingsScreen {
    BSSettingsVC *settingsVC = [[BSSettingsVC alloc] init];
    [self.navigationController addChildViewController:settingsVC];
    [self.navigationController.view addSubview:settingsVC.view];
    settingsVC.view.frame = self.navigationController.view.bounds;
    [settingsVC viewDidAppear:YES];

}

@end
