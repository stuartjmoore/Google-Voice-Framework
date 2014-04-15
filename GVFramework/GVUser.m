//
//  GVUser.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVUser.h"

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

@interface GVUser ()

@property (nonatomic, strong) NSString *auth, *sid, *lsid, *r;

- (NSDictionary*)requestJSONForPath:(NSString*)path;

@end

#pragma mark -

@implementation GVUser

- (BOOL)login
{
    NSString *postString = [NSString stringWithFormat:@"service=%@&Email=%@&Passwd=%@&accountType=%@",
                            kGVLoginService, self.username, self.password, kGVLoginAccountType];

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

    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if(error || !data) {
        NSLog(@"error: %@", error);
    } else {
        NSString *dataString = [NSString stringWithUTF8String:data.bytes];
        NSArray *dataArray = [dataString componentsSeparatedByString:@"\n"];

        for(NSUInteger i = 0; i < dataArray.count; i++) {
            NSArray *keyValueArray = [dataArray[i] componentsSeparatedByString:@"="];

            if(keyValueArray.count == 2) {
                if([keyValueArray.firstObject isEqualToString:@"SID"])
                    self.sid = keyValueArray.lastObject;
                else if([keyValueArray.firstObject isEqualToString:@"LSID"])
                    self.lsid = keyValueArray.lastObject;
                else if([keyValueArray.firstObject isEqualToString:@"Auth"])
                    self.auth = keyValueArray.lastObject;
            }
        }

        NSLog(@"dataString: %@", dataString);
        NSLog(@"auth: %@", self.auth);
    }

    return YES;
}

- (void)unreadCounts {
    NSDictionary *dictionary = [self requestJSONForPath:kGVRequestUnreadCountsPath];
    self.r = dictionary[@"r"];

    NSLog(@"dictionary: %@", dictionary);
}

- (void)messages {
    NSDictionary *dictionary = [self requestJSONForPath:kGVRequestMessagesPath];
    self.r = dictionary[@"r"];

    NSLog(@"dictionary: %@", dictionary);
}

- (NSDictionary*)requestJSONForPath:(NSString*)path {
    NSString *urlString = [NSString stringWithFormat:@"%@://%@:%zd/%@/%@", kGVScheme, kGVHost, kGVPort, kGVRequestPath, path];
    NSURL *url = [NSURL URLWithString:urlString];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:@{
        @"User-Agent" : kGVHTTPHeaderUserAgent,
        @"Authorization" : [kGVHTTPHeaderAuthorizationPrefix stringByAppendingString:self.auth]
    }];

    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    NSLog(@"request: %@", request);

    if(error || !data) {
        NSLog(@"error: %@", error);
        return nil;
    } else {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        if(error || !dictionary) {
            NSLog(@"error: %@", error);
            return nil;
        }

        return dictionary;
    }

    return nil;
}

@end
