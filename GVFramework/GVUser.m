//
//  GVUser.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVUser.h"

#import "GVMissedCall.h"
#import "GVVoicemail.h"
#import "GVConversation.h"
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

    for(NSDictionary *messageDict in messageList) {
        GVMessageType type = [messageDict[@"type"] integerValue];
        GVMessage *message;

        if(type == GVMessageTypeTextReceived || type == GVMessageTypeTextSent)
        {
            NSLog(@"GVMessageTypeConversation");
            message = [GVConversation new];

            NSArray *children = messageDict[@"children"];
            NSMutableArray *textMessages = [NSMutableArray new];

            for(NSDictionary *textMessageDict in children) {
                GVTextMessage *textMessage = [GVTextMessage new];
                textMessage.identifier = textMessageDict[@"id"];
                textMessage.date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)([textMessageDict[@"startTime"] longLongValue] / 1000.0f)];
                textMessage.text = textMessageDict[@"message"];

                textMessage.conversation = (GVConversation*)message;
                [textMessages addObject:textMessage];
            }

            ((GVConversation*)message).textMessages = textMessages;
        }
        else if(type == GVMessageTypeMissedCall)
        {
            NSLog(@"GVMessageTypeMissedCall");
            message = [GVMissedCall new];

        }
        else if(type == GVMessageTypeVoicemail)
        {
            NSLog(@"GVMessageTypeVoicemail");
            message = [GVVoicemail new];
            message.text = messageDict[@"messageText"];
            ((GVVoicemail*)message).duration = [messageDict[@"duration"] integerValue];
        }

        message.identifier = messageDict[@"id"];
        message.date = [NSDate dateWithTimeIntervalSince1970:(NSTimeInterval)([messageDict[@"startTime"] longLongValue] / 1000.0f)];
        message.note = messageDict[@"note"];
        message.labels = messageDict[@"labels"];
        message.read = [messageDict[@"isRead"] boolValue];
        message.spam = [messageDict[@"isSpam"] boolValue];
        message.trash = [messageDict[@"isTrash"] boolValue];
        message.starred = [messageDict[@"star"] boolValue];

        NSLog(@"message: %@", message);
        NSLog(@"-------");
    }

    NSLog(@"messages: %@", dictionary);
}

@end
