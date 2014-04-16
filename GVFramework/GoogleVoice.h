//
//  GoogleVoice.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GoogleVoice : NSObject

@property (nonatomic, strong) NSString *username, *password;

- (void)login;
- (BOOL)isLoggedIn;

- (void)updateUnreadCounts;
- (void)updateMessages;

@end
