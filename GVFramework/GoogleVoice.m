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

- (void)login {
    NSDictionary *dictionary = [GVConnection loginWithUsername:self.username andPassword:self.password];
    self.sid = dictionary[@"SID"];
    self.lsid = dictionary[@"LSID"];
    self.auth = dictionary[@"Auth"];
}

- (BOOL)isLoggedIn {
    return !!self.auth;
}

- (void)updateUnreadCounts {
    NSDictionary *dictionary = [GVConnection requestJSONForUnreadCountsWithAuth:self.auth];
    self.r = dictionary[@"r"];
}

- (void)updateMessages {
    NSDictionary *dictionary = [GVConnection requestJSONForMessagesWithAuth:self.auth];
    self.r = dictionary[@"r"];

    NSArray *messageList = dictionary[@"messageList"];
    NSMutableOrderedSet *messages = [NSMutableOrderedSet new];

    for(NSDictionary *messageDict in messageList) {
        GVMessageType type = [messageDict[@"type"] integerValue];
        NSString *identifier = messageDict[@"id"];

        GVMessage *message;

        if(type == GVMessageTypeTextReceived || type == GVMessageTypeTextSent)
        {
            message = [self messageWithId:identifier] ?: [GVConversation new];

            NSArray *children = messageDict[@"children"];
            NSMutableOrderedSet *textMessages = [NSMutableOrderedSet new];

            for(NSDictionary *textMessageDict in children) {
                GVTextMessage *textMessage = [GVTextMessage new];
                textMessage.identifier = textMessageDict[@"id"];
                textMessage.text = textMessageDict[@"message"];
                textMessage.read = [textMessageDict[@"isRead"] boolValue];

                NSInteger milliseconds = [textMessageDict[@"startTime"] integerValue] ?: 0;
                NSTimeInterval seconds = (NSTimeInterval)(milliseconds / 1000.0);
                textMessage.date = [NSDate dateWithTimeIntervalSince1970:seconds];

                textMessage.conversation = (GVConversation*)message;
                [textMessages addObject:textMessage];
            }

            [textMessages unionOrderedSet:((GVConversation*)message).textMessages];
            [textMessages sortUsingComparator:^NSComparisonResult(GVMessage *obj1, GVMessage *obj2) {
                return obj2.date == [obj1.date earlierDate:obj2.date];
            }];

            ((GVConversation*)message).textMessages = [NSOrderedSet orderedSetWithOrderedSet:textMessages];
        }
        else if(type == GVMessageTypeMissedCall)
        {
            message = [self messageWithId:identifier] ?: [GVMissedCall new];
            message.read = [messageDict[@"isRead"] boolValue];

            NSInteger milliseconds = [messageDict[@"startTime"] integerValue] ?: 0;
            NSTimeInterval seconds = (NSTimeInterval)(milliseconds / 1000.0);
            message.date = [NSDate dateWithTimeIntervalSince1970:seconds];

        }
        else if(type == GVMessageTypeVoicemail)
        {
            message = [self messageWithId:identifier] ?: [GVVoicemail new];
            message.text = messageDict[@"messageText"];
            message.read = [messageDict[@"isRead"] boolValue];
            ((GVVoicemail*)message).duration = [messageDict[@"duration"] integerValue];

            NSInteger milliseconds = [messageDict[@"startTime"] integerValue] ?: 0;
            NSTimeInterval seconds = (NSTimeInterval)(milliseconds / 1000.0);
            message.date = [NSDate dateWithTimeIntervalSince1970:seconds];
        }

        message.identifier = identifier;
        message.note = messageDict[@"note"];
        message.labels = messageDict[@"labels"];
        message.spam = [messageDict[@"isSpam"] boolValue];
        message.trash = [messageDict[@"isTrash"] boolValue];
        message.starred = [messageDict[@"star"] boolValue];

        [messages addObject:message];

        NSLog(@"message: %@", message);
        NSLog(@"-------");
    }

    [messages unionOrderedSet:self.inbox];
    [messages sortUsingComparator:^NSComparisonResult(GVMessage *obj1, GVMessage *obj2) {
        return obj1.date == [obj1.date earlierDate:obj2.date];
    }];

    self.inbox = [NSOrderedSet orderedSetWithOrderedSet:messages];

    NSLog(@"self.inbox: %@", self.inbox);
}

- (GVMessage*)messageWithId:(NSString*)identifier {
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"identifier == %@", identifier];
    NSOrderedSet *filteredOrderedSet = [self.inbox filteredOrderedSetUsingPredicate:pred];

    return filteredOrderedSet.set.anyObject;
}

@end
