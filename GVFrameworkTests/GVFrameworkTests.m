//
//  GVFrameworkTests.m
//  GVFrameworkTests
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GVFramework/GVUser.h>

@interface GVFrameworkTests : XCTestCase

@end

@implementation GVFrameworkTests

- (void)setUp
{
    [super setUp];

    NSString *credsFilepath = [[NSBundle bundleForClass:self.class] pathForResource:@"Creds" ofType:@"plist"];
    NSDictionary *creds = [NSDictionary dictionaryWithContentsOfFile:credsFilepath];

    GVUser *user = [GVUser new];
    user.username = creds[@"username"];
    user.password = creds[@"password"];
    [user login];
//    [user unreadCounts];
    [user messages];
}

- (void)testExample
{
}

- (void)tearDown
{
    [super tearDown];
}

@end
