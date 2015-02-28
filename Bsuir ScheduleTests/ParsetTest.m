//
//  ParsetTest.m
//  Bsuir Schedule
//
//  Created by Anton Siliuk on 28.02.15.
//  Copyright (c) 2015 Saute. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>
#import "BSDataManager.h"
#import "BSScheduleParser.h"

@interface ParsetTest : XCTestCase

@end

@implementation ParsetTest

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}


- (void)testParser1 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"112601",@"113201",@"113202",@"110901",@"110902",@"111801",@"110201",@"171501",@"141301",@"112501",@"112502",@"172301",@"160801",@"172303",@"172302",@"141201",@"110701",@"130801",@"130802",@"162901",@"171502",@"171503",@"111101",@"140101",@"122401",@"122402",@"122403",@"162101",@"163401",@"163001"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testParser2 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"163101",@"161401",@"161402",@"163011",@"140102",@"142801",@"131201",@"140301",@"121901",@"121902",@"142701",@"150501",@"150502",@"150503",@"143301",@"153501",@"153502",@"153503",@"151001",@"151002",@"151003",@"151004",@"151005",@"120601",@"120604",@"120603",@"120602",@"410701",@"411801",@"410901"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testParser3 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"411101",@"410101",@"414301",@"414302",@"412601",@"413301",@"413302",@"413801",@"413802",@"410201",@"253501",@"210701",@"211801",@"253505",@"253503",@"253504",@"253502",@"121701",@"211101",@"213501",@"121702",@"210901",@"463001",@"210201",@"210202",@"422401",@"263001",@"212601",@"213201",@"213202"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testParser4 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"212501",@"463101",@"310701",@"461401",@"310901",@"460801",@"313501",@"433701",@"433702",@"462901",@"462101",@"441501",@"310201",@"312601",@"353501",@"313201",@"313202",@"453501",@"313801",@"313802",@"353502",@"353503",@"363001",@"440401",@"353504",@"311801",@"353505",@"311101",@"363101",@"441201"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testParser5 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"361401",@"361402",@"360801",@"333701",@"333702",@"362901",@"362101",@"363401",@"263101",@"261401",@"260801",@"230801",@"230802",@"442801",@"441301",@"444101",@"453502",@"422403",@"422402",@"453503",@"453504",@"453505",@"421901",@"351001",@"434201",@"440301",@"420601",@"420602",@"420603",@"420604"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testParser6 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"262901",@"351002",@"351003",@"351004",@"421701",@"421702",@"421703",@"351005",@"322401",@"322402",@"322403",@"351006",@"251001",@"262101",@"263401",@"463011",@"420611",@"363011",@"320611",@"263011",@"261411",@"443201",@"251005",@"251006",@"251003",@"251004",@"251002",@"442701",@"222401",@"222402"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testParser7 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"222403",@"440302",@"221901",@"221902",@"221903",@"221701",@"221702",@"341501",@"340401",@"220601",@"220602",@"220603",@"220604",@"451001",@"451002",@"451003",@"451004",@"451005",@"451006",@"220611",@"150531",@"320601",@"342801",@"341301",@"341201",@"344101",@"250501",@"250502",@"250503",@"250504"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

- (void)testParser8 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"344102",@"350501",@"350502",@"350503",@"350504",@"350505",@"334201",@"340301",@"340302",@"342701",@"450501",@"450502",@"450503",@"450504",@"450505",@"343201",@"372301",@"372302",@"372303",@"372304",@"322404",@"321901",@"241301",@"241302",@"241201",@"373601",@"373602",@"240101",@"240102",@"272301"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testParser9 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"272302",@"272303",@"242801",@"273601",@"273602",@"321902",@"320602",@"320603",@"320604",@"320605",@"472301",@"472302",@"472303",@"271501",@"473601",@"271502",@"473602",@"231201",@"272201",@"272202",@"272203",@"373901",@"473901",@"240301",@"474001",@"474002",@"474003",@"240302",@"373902",@"373903"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}
- (void)testParser10 {
    XCTestExpectation *expectation = [self expectationWithDescription:@"group expectation"];
    __block NSInteger passed = 0;
    NSArray *groups = @[@"473902",@"473903",@"473904",@"242701",@"374001",@"374002",@"374003",@"243301",@"321701",@"321702",@"321703",@"450531",@"250531",@"350531",@"322431",@"340303",@"222431"];
    for (NSString *groupStr in groups) {
        NSInteger groupIndex = [groups indexOfObject:groupStr];
        BSGroup *group = [[BSDataManager sharedInstance] groupWithNumber:groupStr createIfNotExists:YES];
        [BSScheduleParser scheduleForGroup:group withSuccess:^{
            NSLog(@"Schedule loaded for %ld", (long) groupIndex);
            passed += 1;
            if (passed == [groups count]) {
                [expectation fulfill];
            }
        } failure:^{
            NSLog(@"FAILED TO LOAD Schedule loaded for %ld", (long) groupIndex);
            XCTFail(@"!!!!!!!!! FAIL %@",groupStr);
        }];
    }
    [self waitForExpectationsWithTimeout:15.0 handler:nil];
}

@end
