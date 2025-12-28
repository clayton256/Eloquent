//
//  SessionManagerTest.m
//  Eloquent
//
//  Created by Manfred Bergmann on 08/19/12.
//Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SessionManagerTest.h"
#import "SessionManager.h"

@implementation SessionManagerTest {
    SessionManager *manager;
}

- (void)setUp {
    [super setUp];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testLoadSession {
    manager = [[SessionManager alloc] init];

    XCTAssertTrue(1 == 1);
}

@end
