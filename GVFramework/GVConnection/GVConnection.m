//
//  GVConnection.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVConnection.h"

NSString *const kGVScheme = @"https";
NSString *const kGVHost = @"www.google.com";
NSUInteger const kGVPort = 443;

NSString *const kGVHTTPMethod = @"POST";
NSString *const kGVHTTPHeaderUserAgent = @"Mozilla/5.0";
NSString *const kGVHTTPHeaderAuthorizationPrefix = @"GoogleLogin ";
NSString *const kGVHTTPHeaderContentType = @"application/x-www-form-urlencoded";

NSString *const kGVLoginPath = @"accounts/ClientLogin";
NSString *const kGVLoginService = @"grandcentral";
NSString *const kGVLoginAccountType = @"GOOGLE";

NSString *const kGVRequestPath = @"voice/b/0/request";
NSString *const kGVRequestUnreadCountsPath = @"unread";
NSString *const kGVRequestMessagesPath = @"messages/?page=";

@interface GVConnection ()

+ (NSDictionary*)requestJSONForPath:(NSString*)path withAuth:(NSString*)auth error:(NSError**)error;

@end

@implementation GVConnection

+ (NSDictionary*)loginWithUsername:(NSString*)username andPassword:(NSString*)password error:(NSError**)error {
    if(!username || !password)
        return nil;

    NSString *postString = [NSString stringWithFormat:@"service=%@&Email=%@&Passwd=%@&accountType=%@",
                            kGVLoginService, username, password, kGVLoginAccountType];

    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];

    NSString *urlString = [NSString stringWithFormat:@"%@://%@:%zd/%@", kGVScheme, kGVHost, kGVPort, kGVLoginPath];
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:kGVHTTPMethod];
    [request setHTTPBody:postData];
    [request setAllHTTPHeaderFields:@{
        @"User-Agent"    : kGVHTTPHeaderUserAgent,
        @"Authorization" : kGVHTTPHeaderAuthorizationPrefix,
        @"Content-Type"  : kGVHTTPHeaderContentType
    }];

    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];

    if(error || !data || response.statusCode != 200) {
        NSLog(@"error: %@", *error);
        return nil;
    } else {
        NSMutableDictionary *dictionary = [NSMutableDictionary new];

        NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSArray *dataArray = [dataString componentsSeparatedByString:@"\n"];

        for(NSUInteger i = 0; i < dataArray.count; i++) {
            NSArray *keyValueArray = [dataArray[i] componentsSeparatedByString:@"="];

            if(keyValueArray.count == 2)
                dictionary[keyValueArray.firstObject] = keyValueArray.lastObject;
        }

        return dictionary;
    }
}

#pragma mark -

+ (NSDictionary*)requestJSONForUnreadCountsWithAuth:(NSString*)auth error:(NSError**)error {
    return [GVConnection requestJSONForPath:kGVRequestUnreadCountsPath withAuth:auth error:error];
}

+ (NSDictionary*)requestJSONForMessagesWithAuth:(NSString*)auth error:(NSError**)error {
    return [GVConnection requestJSONForPath:kGVRequestMessagesPath withAuth:auth error:error];
}

+ (NSDictionary*)requestJSONForPath:(NSString*)path withAuth:(NSString*)auth error:(NSError**)error {
    if(!auth)
        return nil;

    NSString *urlString = [NSString stringWithFormat:@"%@://%@:%zd/%@/%@", kGVScheme, kGVHost, kGVPort, kGVRequestPath, path];
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:@{
        @"User-Agent"    : kGVHTTPHeaderUserAgent,
        @"Authorization" : [kGVHTTPHeaderAuthorizationPrefix stringByAppendingString:auth]
    }];

    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:error];

    if(error || !data || response.statusCode != 200) {
        NSLog(@"error: %@", *error);
        return nil;
    } else {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:error];

        if(error || !dictionary) {
            NSLog(@"error: %@", *error);
            return nil;
        }
        
        return dictionary;
    }
}

@end
