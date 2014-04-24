//
//  GVConnection.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GVConnection : NSObject

+ (NSDictionary*)loginWithUsername:(NSString*)username andPassword:(NSString*)password error:(NSError**)error;

+ (NSDictionary*)requestJSONForUnreadCountsWithAuth:(NSString*)auth error:(NSError**)error;
+ (NSDictionary*)requestJSONInboxForPage:(NSUInteger)pageNum withAuth:(NSString*)auth error:(NSError**)error;

+ (BOOL)sendSMSToNumber:(NSString*)phoneNumer WithText:(NSString*)text AndRNR:(NSString*)rnr error:(NSError**)error;

+ (BOOL)markMessageIds:(NSArray*)identifiers withBool:(BOOL)value forKey:(NSString*)mark usingRNR:(NSString*)rnr error:(NSError**)error;

@end

@interface NSString (encode)

- (NSString*)percentEncode;

@end
