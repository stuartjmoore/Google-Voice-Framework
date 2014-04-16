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

@end

@implementation GVFrameworkTests

- (void)setUp
{
    [super setUp];

    NSString *credsFilepath = [[NSBundle bundleForClass:self.class] pathForResource:@"Creds" ofType:@"plist"];
    NSDictionary *creds = [NSDictionary dictionaryWithContentsOfFile:credsFilepath];

    self.googleVoice = [GoogleVoice new];
    self.googleVoice.username = creds[@"username"];
    self.googleVoice.password = creds[@"password"];
}

- (void)testUnreadCounts
{
    [self.googleVoice updateUnreadCounts];
}

- (void)testMessages
{
    [self.googleVoice updateMessages];
}

- (void)tearDown
{
    [super tearDown];
}

@end
