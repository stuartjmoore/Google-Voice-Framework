//
//  GVUser.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVUser.h"
#import "GVConnection.h"

@interface GVUser ()

@property (nonatomic, strong) NSString *auth, *sid, *lsid, *r;

@end

#pragma mark -

@implementation GVUser

- (void)login {
    NSDictionary *dictionary = [GVConnection loginWithUsername:self.username andPassword:self.password];
    self.sid = dictionary[@"SID"];
    self.lsid = dictionary[@"LSID"];
    self.auth = dictionary[@"Auth"];

    NSLog(@"login: %@", dictionary);
}

- (BOOL)isLoggedIn {
    return !!self.auth;
}

- (void)unreadCounts {
    NSDictionary *dictionary = [GVConnection requestJSONForUnreadCountsWithAuth:self.auth];
    self.r = dictionary[@"r"];

    NSLog(@"unreadCounts: %@", dictionary);
}

- (void)messages {
    NSDictionary *dictionary = [GVConnection requestJSONForMessagesWithAuth:self.auth];
    self.r = dictionary[@"r"];

    NSLog(@"messages: %@", dictionary);
}

@end
