//
//  GVUser.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVUser : NSObject

@property (nonatomic, strong) NSString *username, *password;

- (BOOL)login;

- (void)unreadCounts;
- (void)messages;

@end
