//
//  GoogleVoice.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GoogleVoice.h"

#import "GVMissedCall.h"
#import "GVVoicemail.h"
#import "GVConversation.h"
#import "GVConnection.h"

@interface GoogleVoice ()

@property (nonatomic, strong) NSString *auth, *sid, *lsid, *r;
@property (nonatomic, strong) NSOrderedSet *inbox;

- (GVMessage*)messageWithId:(NSString*)identifier;
- (GVContact*)contactWithId:(NSString*)identifier;
- (GVContact*)contactWithId:(NSString*)identifier inSet:(NSOrderedSet*)set;

@end

#pragma mark -

@implementation GoogleVoice

- (instancetype)init {
    self = [super init];
    if (self) {
        self.inbox = [NSOrderedSet new];
    }
    return self;
}

#pragma mark - Login

- (void)login {
    NSError *error;
    NSDictionary *dictionary = [GVConnection loginWithUsername:self.username andPassword:self.password error:&error];

    if(error) {
        NSLog(@"error: %@", error);
        return;
    }

    self.sid = dictionary[@"SID"];
    self.lsid = dictionary[@"LSID"];
    self.auth = dictionary[@"Auth"];
}

- (BOOL)isLoggedIn {
    return !!self.auth;
}

#pragma mark - Update

- (void)updateUnreadCounts {
    if(!self.isLoggedIn)
        [self login];

    NSError *error;
    NSDictionary *dictionary = [GVConnection requestJSONForUnreadCountsWithAuth:self.auth error:&error];

    if(error) {
        NSLog(@"error: %@", error);
        return;
    }

    self.r = dictionary[@"r"];
}

- (void)updateMessages {
    if(!self.isLoggedIn)
        [self login];

    NSError *error;
    NSDictionary *dictionary = [GVConnection requestJSONForMessagesWithAuth:self.auth error:&error];

    if(error) {
        NSLog(@"error: %@", error);
        return;
    }

    NSLog(@"dictionary: %@", dictionary);

    self.r = dictionary[@"r"];

    NSArray *messageList = dictionary[@"messageList"];
    NSMutableOrderedSet *messages = [NSMutableOrderedSet new];

    for(NSDictionary *messageDict in messageList) {
        GVMessageType type = [messageDict[@"type"] integerValue];
        NSString *identifier = messageDict[@"id"];

        GVMessage *message;

        if(type == GVMessageTypeTextReceived || type == GVMessageTypeTextSent)
        {
            message = [self messageWithId:identifier] ?: [[GVConversation alloc] initWithJSON:messageDict];
            // TODO: add text messages even if conversation exists.
        }
        else if(type == GVMessageTypeMissedCall)
        {
            message = [self messageWithId:identifier] ?: [[GVMissedCall alloc] initWithJSON:messageDict];
        }
        else if(type == GVMessageTypeVoicemail)
        {
            message = [self messageWithId:identifier] ?: [[GVVoicemail alloc] initWithJSON:messageDict];
        }

        NSString *phoneNumber = messageDict[@"phoneNumber"];
        NSString *contactId = dictionary[@"contacts"][@"contactPhoneMap"][phoneNumber][@"contactId"];

        GVContact *contact = [self contactWithId:contactId]
                          ?: [self contactWithId:contactId inSet:messages]
                          ?: [[GVContact alloc] initWithJSON:dictionary[@"contacts"][@"contactMap"][contactId]];

        message.contact = contact;
        [messages addObject:message];
    }

    [messages unionOrderedSet:self.inbox];
    [messages sortUsingComparator:^NSComparisonResult(GVMessage *obj1, GVMessage *obj2) {
        return obj1.date == [obj1.date earlierDate:obj2.date];
    }];

    self.inbox = [NSOrderedSet orderedSetWithOrderedSet:messages];

    NSLog(@"inbox: %@", self.inbox);
}

#pragma mark -

- (GVMessage*)messageWithId:(NSString*)identifier {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    NSOrderedSet *filteredOrderedSet = [self.inbox filteredOrderedSetUsingPredicate:pred];

    return filteredOrderedSet.set.anyObject;
}

- (GVContact*)contactWithId:(NSString*)identifier {
    return [self contactWithId:identifier inSet:self.inbox];
}

- (GVContact*)contactWithId:(NSString*)identifier inSet:(NSOrderedSet*)set {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"contact.identifier == %@", identifier];
    NSOrderedSet *filteredOrderedSet = [set filteredOrderedSetUsingPredicate:pred];

    return [filteredOrderedSet.set.anyObject contact];
}

@end
