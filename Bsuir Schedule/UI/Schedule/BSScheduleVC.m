//
//  ViewController.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 16.11.14.
//  Copyright (c) 2014 Saute. All rights reserved.
//

#import "BSScheduleVC.h"
#import "BSConstants.h"
#import "BSDataManager.h"
#import "BSPairCell.h"
#import "BSDayWithWeekNum.h"

#import "BSLecturer+Thumbnail.h"
#import "NSString+Transiterate.h"
#import "NSDate+Compare.h"
#import "UIView+Screenshot.h"

#import "BSScheduleParser.h"
#import "BSLecturerVC.h"
#import "NSUserDefaults+Share.h"

#import "SlideNavigationController.h"
#import "BSDay.h"

#import "BSDayOfWeek+Number.h"
#import "BSDayWithWeekNum.h"


static NSString * const kCellID = @"Pair cell id";


@interface BSScheduleVC () <UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate, BSPairCellDelegate, SlideNavigationControllerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *days;

@property (strong, nonatomic) UIView *loadindicatorView;
@property (strong, nonatomic) BSDayWithWeekNum *dayToHighlight;

@property (strong, nonatomic) NSArray *easterEggStrings;
@end

@implementation BSScheduleVC

- (NSArray*)easterEggStrings {
    if (!_easterEggStrings) {
        _easterEggStrings = @[@"Остановись",
                              @"Подумай о будущем",
                              @"Не делай этого",
                              @"У тебя еще вся жизнь впереди",
                              @"Зачем тебе знать что будет потом",
                              @"Там ничего нет",
                              @"Жизнь тлен",
                              @"Только не листай до конца",
                              @"Ты не должен об этом узнать",
                              @"Предупреждаю тебя парень",
                              @"Там ничего нет",
                              @"ОСТАНОВИСЬ",
                              @"Ты сломаешь скролл",
                              @"Ты сломаешь всю таблицу",
                              @"Ее не починить",
                              @"Подумай о своих родных",
                              @"Остановись ради них",
                              @"Сколько можно",
                              @"Мне лень тебя переубеждать",
                              @"Ты странный человек",
                              @"На тебя еще не косятся люди?",
                              @"Для чего ты это делаешь?",
                              @"Кто тебя нанял?",
                              @"Я устала скролиться",
                              @"У меня нет конца",
                              @"Это бессмысленно",
                              @"Ты зря проживаешь свою жизнь",
                              @"Сходи покушай",
                              @"Иди попрограммируй",
                              @"Ты же студент БГУИРа",
                              @"Делай лабы",
                              @"Делай лабы",
                              @"Делай лабы",
                              @"Делай лабы",
                              @"Делай лабы",
                              @"Я пытался помочь",
                              @"ОТСТАНЬ ОТ МЕНЯ",
                              @"Нормально же общались",
                              @"Чего ты",
                              @"АЙ, ВСЕ!",
                              @"АЙ, ВСЕ!",
                              @"АЙ, ВСЕ!",
                              @"Тебе лишь бы меня поскролить",
                              @"А на мои чувства тебе наплевать",
                              @"Ты бкссчувственный",
                              @"У таблиц тоже есть чувства",
                              @"Тебе не интересно что мне нужно",
                              @"Ну и листай себе дальше",
                              @"Я не хочу общаться",
                              @"Ты настырный",
                              @"И упорный",
                              @"Листай дальше",
                              @"Тебя ждут несметные богатства и слава",
                              @"Признание женщин",
                              @"Успех",
                              @"Уже совсем скоро",
                              @"Еще чуть чуть",
                              @"Еще чуть чуть.",
                              @"Еще чуть чуть..",
                              @"Еще чуть чуть..."];
    }
    return _easterEggStrings;
}

- (instancetype)initWithSchedule:(BSSchedule *)schedule
{
    self = [super initWithNibName:NSStringFromClass([self class]) bundle:nil];
    if (self) {
        self.schedule = schedule;
    }
    return self;
}

- (UIView*)loadindicatorView {
    if (!_loadindicatorView) {
        _loadindicatorView = [[UIView alloc] initWithFrame:self.navigationController.view.bounds];
        _loadindicatorView.backgroundColor = [UIColor blackColor];
        UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
        activityIndicator.center = CGPointMake(_loadindicatorView.bounds.size.width / 2.0, _loadindicatorView.bounds.size.height / 2.0);
        [_loadindicatorView addSubview:activityIndicator];
        [activityIndicator startAnimating];
    }
    return _loadindicatorView;
}

- (NSMutableArray*)days {
    if (!_days) {
        _days = [NSMutableArray array];
    }
    return _days;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView* bview = [[UIView alloc] init];
    bview.backgroundColor = BS_LIGHT_GRAY;
    [self.tableView setBackgroundView:bview];   

    
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 100, 0);
    [self.tableView registerNib:[UINib nibWithNibName:NSStringFromClass([BSPairCell class]) bundle:nil] forCellReuseIdentifier:kCellID];
    [self.navigationController.view addSubview:self.loadindicatorView];
    self.loadindicatorView.hidden = YES;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateUI) name:kDidComeFromBackground object:nil];
    [self setupFormatChangeButtonForWeekFormat:self.weekFormat];
    [self setNavBarLabel];
    [self getScheduleData];
}

- (void)setNavBarLabel {
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 44)];
    label.backgroundColor = [UIColor clearColor];
    label.numberOfLines = 2;
    label.textAlignment = NSTextAlignmentCenter;
    NSMutableAttributedString *titleString= [[NSMutableAttributedString alloc] initWithString:LZD(@"L_Schedule")
                                                                                   attributes:@{NSForegroundColorAttributeName:[UIColor whiteColor],
                                                                                                NSFontAttributeName: [UIFont fontWithName:@"OpenSans" size:16.0]}];
    NSAttributedString *groupString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"\n%@/%@",self.schedule.group.groupNumber,self.schedule.subgroup]
                                                                    attributes:@{NSForegroundColorAttributeName:[[UIColor whiteColor]
                                                                                                                 colorWithAlphaComponent:0.7],
                                                                                 NSFontAttributeName: [UIFont systemFontOfSize:14.0]}];
    [titleString appendAttributedString:groupString];
    label.attributedText = titleString;
    self.navigationItem.titleView = label;
    
}


- (void)setupFormatChangeButtonForWeekFormat:(BOOL)weekFormat {
    UIButton *formatChangeButtonButton = [UIButton buttonWithType:UIButtonTypeCustom];
    formatChangeButtonButton.frame = CGRectMake(0, 0, 40, 40);
    [formatChangeButtonButton setImage:[UIImage imageNamed:(weekFormat) ? @"daily" : @"weekly"]
                              forState:UIControlStateNormal];
    [formatChangeButtonButton setImage:[UIImage imageNamed:(weekFormat) ? @"daily" : @"weekly"]
                              forState:UIControlStateNormal | UIControlStateHighlighted];
    [formatChangeButtonButton addTarget:self action:@selector(changeWeekType) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *formatChangeBarButton = [[UIBarButtonItem alloc] initWithCustomView:formatChangeButtonButton];
    formatChangeBarButton.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = formatChangeBarButton;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)getScheduleData {
    if (self.schedule.group) {
        if ([BSScheduleParser scheduleExpiresForGroup:self.schedule.group]) {
            [self showLoadingView];
            __weak typeof(self) weakSelf = self;
            [BSScheduleParser scheduleForGroup:self.schedule.group withSuccess:^{
                typeof(weakSelf) self = weakSelf;
                [self updateSchedule];
                [self hideLoadingView];
            } failure:^{
                [weakSelf hideLoadingView];
            }];
        }
        [self updateSchedule];
    }
}

- (void)changeWeekType {
    self.weekFormat = !self.weekFormat;
    [self setupFormatChangeButtonForWeekFormat:self.weekFormat];
    [self updateSchedule];
}

- (void)updateSchedule {
    [self hideLoadingView];

    self.dayToHighlight = [[BSDataManager sharedInstance] dayToHighlightInSchedule:self.schedule weekMode:self.weekFormat];
    
    self.days = nil;
    if (self.weekFormat) {
        [self loadWeekSchedule];
    } else {
        [self loadScheduleForDaysCount:PREVIOUS_DAY_COUNT backwards:YES];
        [self loadScheduleForDaysCount:DAYS_LOAD_STEP backwards:NO];
    }
    
    [self.tableView reloadData];
    NSInteger highlightedSectionIndex = 0;
    for (NSInteger index = 0; index < [self.days count]; index++) {
        id<BSDay> day = [self.days objectAtIndex:index];
        if ([day isEqualToDayWithWeekNum:self.dayToHighlight]) {
            highlightedSectionIndex = index;
            break;
        }
    }

    if ([self.days count] > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:highlightedSectionIndex]
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

- (void)loadWeekSchedule {
    NSPredicate *pairPredicate = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        BOOL filter = NO;
        if ([evaluatedObject isKindOfClass:[BSDayOfWeek class]]) {
            filter = [[(BSDayOfWeek*)evaluatedObject pairsForSchedule:self.schedule weekFormat:self.weekFormat] count] > 0;
        }
        return filter;
    }];
    NSArray *days = [[[BSDataManager sharedInstance] days] filteredArrayUsingPredicate:pairPredicate];
    self.days = [days mutableCopy];
}

- (void)loadScheduleForDaysCount:(NSInteger)daysCount backwards:(BOOL)backwards {
    NSDate *now = [NSDate date];
    NSDate *dayDate = now; // to show two previous days
    if ([self.days count] > 0) {
        if (backwards) {
            dayDate = [[self.days firstObject] date];
        } else {
            dayDate = [[[self.days lastObject] date] dateByAddingTimeInterval:DAY_IN_SECONDS];
        }
    }
    NSInteger daysAdded = 0;
    while (daysAdded < daysCount) {
        BSDayWithWeekNum *dayWithWeekNum = [[BSDayWithWeekNum alloc] initWithDate:dayDate];
        if (dayWithWeekNum.dayOfWeek && [[dayWithWeekNum pairsForSchedule:self.schedule weekFormat:self.weekFormat] count] > 0 && !([dayDate isEqual:now] && backwards)) {
            if (backwards) {
                [self.days insertObject:dayWithWeekNum atIndex:0];
            } else {
                [self.days addObject:dayWithWeekNum];

            }
            daysAdded++;
        }
        dayDate = [dayDate dateByAddingTimeInterval:(backwards ? -1 : 1)*DAY_IN_SECONDS];
    }
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

- (NSArray*)pairsForDay:(id<BSDay>)day {

    return [day pairsForSchedule:self.schedule weekFormat:self.weekFormat];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.days count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self pairsForDay:[self.days objectAtIndex:section]] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BSPairCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellID forIndexPath:indexPath];
    id<BSDay> day = [self.days objectAtIndex:indexPath.section];
    NSArray *pairs = [self pairsForDay:day];
    BSPair *pair = [pairs objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell setupWithPair:pair inDay:day forSchedule:self.schedule weekMode:self.weekFormat];
    return cell;
}

#define EASTERN_EGG_EDGE 100
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    id<BSDay> day = [self.days objectAtIndex:section];
    NSDate *now = [NSDate date];
    BOOL currentDay = NO;
    BOOL tomorrow = NO;
    if ([day isKindOfClass:[BSDayWithWeekNum class]]) {
        currentDay = [now isEqualToDateWithoutTime:[(BSDayWithWeekNum*)day date]];
        tomorrow = [[now dateByAddingTimeInterval:DAY_IN_SECONDS] isEqualToDateWithoutTime:[(BSDayWithWeekNum*)day date]];
    } else if ([day isKindOfClass:[BSDayOfWeek class]]){
        BSDayOfWeek *dayOfWeek = [[BSDataManager sharedInstance] dayWithDate:now];
        currentDay = [dayOfWeek  number] == [(BSDayOfWeek*)day number];
        tomorrow = [dayOfWeek  number] + 1 == [(BSDayOfWeek*)day number];
    }
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"dd.MM.YY"];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, HEADER_HEIGHT)];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(HEADER_LABEL_OFFSET_X, HEADER_LABEL_OFFSET_Y,
                                                               tableView.frame.size.width, HEADER_HEIGHT)];
    [label setFont:[UIFont fontWithName:@"OpenSans" size:HEADER_LABEL_FONT_SIZE]];

    [label setTextColor:BS_GRAY];
    [view addSubview:label];
    [view setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    [label setBackgroundColor:[UIColor clearColor]];
    NSString *dayInfoString;
    if ([day isKindOfClass:[BSDayWithWeekNum class]]) {
        dayInfoString = [NSString stringWithFormat:@"%@  %@  %@  %@",
                         NSLocalizedString([@"Sh_" stringByAppendingString:[day dayOfWeekName]], nil),
                         [df stringFromDate:[(BSDayWithWeekNum*)day date]],
                         NSLocalizedString(@"L_Week", nil),
                         [[(BSDayWithWeekNum*)day weekNumber] weekNumber]];
    } else if ([day isKindOfClass:[BSDayOfWeek class]]){
        dayInfoString = NSLocalizedString([day dayOfWeekName], nil);
    }

    if ([day isEqualToDayWithWeekNum:self.dayToHighlight]) {
        if (currentDay) {
            dayInfoString = [NSString stringWithFormat:@"(%@)  %@",NSLocalizedString(@"L_Today", nil), dayInfoString];
        } else if (tomorrow) {
            dayInfoString = [NSString stringWithFormat:@"(%@)  %@",NSLocalizedString(@"L_Tomorrow", nil), dayInfoString];
        }
        [label setTextColor:BS_RED];
    }
    BOOL easterEggMode = NO;
    if (section >= EASTERN_EGG_EDGE) {
        if (section % 20 == 0) {
            NSInteger stringIndex = [self easterEggIndexForSection:section];
            if (stringIndex < [self.easterEggStrings count]) {
                dayInfoString = [self.easterEggStrings objectAtIndex:stringIndex];
                [label setTextColor:BS_BLUE];

            } else {
                easterEggMode = YES;
            }
        }
    }
    if ([[NSUserDefaults sharedDefaults] boolForKey:kEasterEggMode] != easterEggMode) {
        [[NSUserDefaults sharedDefaults] setBool:easterEggMode forKey:kEasterEggMode];
    }
    [label setText:dayInfoString];
    return view;
}

- (NSInteger)easterEggIndexForSection:(NSInteger)section {
    return (section - EASTERN_EGG_EDGE) / 20;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    return HEADER_HEIGHT+5.0;
    return 30.0;
}

- (BOOL)prefersStatusBarHidden {
    return NO;
}
//-------------------------------Scroll view---------------------------------

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate) {
        [self scrollingFinishScrollView:scrollView];
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollingFinishScrollView:scrollView];
}
- (void)scrollingFinishScrollView:(UIScrollView*)scrollView {
    if (scrollView.contentOffset.y >= (scrollView.contentSize.height - scrollView.bounds.size.height)) {
        if (!self.weekFormat) {
            NSLog(@"load more rows");
            [self loadScheduleForDaysCount:DAYS_LOAD_STEP backwards:NO];
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.days.count - DAYS_LOAD_STEP, DAYS_LOAD_STEP)];
            [self.tableView insertSections:indexSet withRowAnimation:UITableViewRowAnimationBottom];
        }
    }
    
}

//-------------------------------Lecturer name view---------------------------------


- (void)deselectVisibleCells {
    for (BSPairCell *pairCell in [self.tableView visibleCells]) {
        if (pairCell.showingLecturers) {
            [pairCell makeSelected:NO];
        }
    }
}

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    BSPairCell *pairCell = (BSPairCell*)[tableView cellForRowAtIndexPath:indexPath];
//    if (pairCell) {
//        if (!pairCell.showingLecturerName) {
//            [self deselectVisibleCells];
//        }
//        [pairCell makeSelected:!pairCell.showingLecturerName];
//    }
//}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self deselectVisibleCells];
}

//===============================================UI===========================================
#pragma mark - UI

- (void)updateUI {
    [self.tableView reloadData];
}


- (void)showLecturerVCForLecturer:(BSLecturer*)lecturer withStartFrame:(CGRect)startFrame{
    if (lecturer) {
        BSLecturerVC *lecturerVC = [[BSLecturerVC alloc] initWithLecturer:lecturer startFrame:startFrame];
        [self presentVCInCurrentContext:lecturerVC];
    }
}

- (void)presentVCInCurrentContext:(UIViewController*)vc {
    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")) {
        vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
    } else {
        self.navigationController.modalPresentationStyle = UIModalPresentationCurrentContext;
    }
    [self presentViewController:vc animated:NO completion:nil];
}


//===============================================LOADING SCREEN===========================================
#pragma mark - Loading screen
- (void)showLoadingView {
    if (self.loadindicatorView.hidden) {
        self.loadindicatorView.hidden = NO;
        self.loadindicatorView.alpha = 0;
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.loadindicatorView.alpha = 0.5;
        }];
    }
}

- (void)hideLoadingView {
    if (!self.loadindicatorView.hidden) {
        [UIView animateWithDuration:ANIMATION_DURATION animations:^{
            self.loadindicatorView.alpha = 0.0;
        } completion:^(BOOL finished) {
            if (finished) {
                self.loadindicatorView.hidden = YES;
            }
        }];
    }
}
//===============================================BSPairCell DELEGATE===========================================
#pragma mark - BSPairCell delegate

- (void)thumbnailForLecturer:(BSLecturer*)lecturer withStartFrame:(CGRect)thumbnailFrame getTappedOnCell:(BSPairCell *)cell {
    NSIndexPath *indexPathOfCell = [self.tableView indexPathForCell:cell];
    if (indexPathOfCell) {
        CGRect startFrame = [self.view convertRect:thumbnailFrame fromView:cell];
        [self showLecturerVCForLecturer:lecturer withStartFrame:startFrame];
    }
}

#pragma mark - SlideNavigationController Methods -

- (BOOL)slideNavigationControllerShouldDisplayLeftMenu
{
    return YES;
}

@end
