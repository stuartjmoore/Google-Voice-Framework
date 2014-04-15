//
//  GVConnection.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVConnection : NSObject

+ (NSDictionary*)loginWithUsername:(NSString*)username andPassword:(NSString*)password;

+ (NSDictionary*)requestJSONForUnreadCountsWithAuth:(NSString*)auth;
+ (NSDictionary*)requestJSONForMessagesWithAuth:(NSString*)auth;
+ (NSDictionary*)requestJSONForPath:(NSString*)path withAuth:(NSString*)auth;

@end
