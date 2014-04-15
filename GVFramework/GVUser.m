//
//  GVUser.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVUser.h"

@interface GVUser ()

@property (nonatomic, strong) NSString *auth, *sid, *lsid, *r, *rnr_se;

@end

#pragma mark -

@implementation GVUser

- (instancetype)init
{
    if (self = [super init]) {
    }

    return self;
}

- (BOOL)login
{
    NSString *postString = [NSString stringWithFormat:@"service=grandcentral&Email=%@&Passwd=%@&accountType=GOOGLE",
                            self.username,
                            self.password];
    NSData *postData = [postString dataUsingEncoding:NSUTF8StringEncoding];

    NSURL *url = [NSURL URLWithString:@"https://www.google.com:443/accounts/ClientLogin"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setHTTPBody:postData];
    [request setAllHTTPHeaderFields:@{
        @"User-Agent" : @"Mozilla/5.0",
        @"Authorization" : @"GoogleLogin ",
        @"Content-Type" : @"application/x-www-form-urlencoded"
    }];

    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if(error) {
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
        NSLog(@"sid: %@", self.sid);
        NSLog(@"lsid: %@", self.lsid);
        NSLog(@"auth: %@", self.auth);
    }

    return YES;
}

- (void)unreadCounts {
    NSURL *url = [NSURL URLWithString:@"https://www.google.com:443/voice/b/0/request/unread/"];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:@{
        @"User-Agent" : @"Mozilla/5.0",
        @"Authorization" : [NSString stringWithFormat:@"GoogleLogin %@", self.auth]
    }];

    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    if(error) {
        NSLog(@"error: %@", error);
        return;
    } else {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        if(error) {
            NSLog(@"error: %@", error);
            return;
        }

        self.r = dictionary[@"r"];

        NSLog(@"dictionary: %@", dictionary);
    }
}

- (void)messages {
    NSURL *url = [NSURL URLWithString:@"https://www.google.com:443/voice/b/0/request/messages/?page="];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setAllHTTPHeaderFields:@{
        @"User-Agent" : @"Mozilla/5.0",
        @"Authorization" : [NSString stringWithFormat:@"GoogleLogin %@", self.auth]
    }];

    NSURLResponse *response;
    NSError *error;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

    if(error) {
        NSLog(@"error: %@", error);
        return;
    } else {
        NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];

        if(error) {
            NSLog(@"error: %@", error);
            return;
        }
        
        self.r = dictionary[@"r"];
        
        NSLog(@"dictionary: %@", dictionary);
    }

}

@end
