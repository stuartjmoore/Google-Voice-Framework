//
//  GVFrameworkTests.m
//  GVFrameworkTests
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <GVFramework/GoogleVoice.h>

@interface GVFrameworkTests : XCTestCase

@property (nonatomic, strong) GoogleVoice *googleVoice;
@property (nonatomic, strong) NSDictionary *creds;

@end

@implementation GVFrameworkTests

- (void)setUp
{
    [super setUp];

    NSString *credsFilepath = [[NSBundle bundleForClass:self.class] pathForResource:@"Creds" ofType:@"plist"];
    self.creds = [NSDictionary dictionaryWithContentsOfFile:credsFilepath];

    XCTAssertTrue(self.creds, @"You need to create GVFrameworkTests/Creds.plist to test via your account (it’s gitignored).");

    self.googleVoice = [GoogleVoice new];
    self.googleVoice.username = self.creds[@"username"];
    self.googleVoice.password = self.creds[@"password"];
}

- (void)testUnreadCounts
{
    [self.googleVoice updateUnreadCounts];
}

- (void)testMessages
{
    [self.googleVoice updateMessages];
}

- (void)testSendSMS
{
    [self.googleVoice sendTestMessageTo:self.creds[@"phoneNumber"]];
}

- (void)tearDown
{
    [super tearDown];
}

@end
