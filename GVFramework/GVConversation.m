//
//  GVConversation.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVConversation.h"

@implementation GVConversation

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.textMessages = [NSOrderedSet new];
    }
    return self;
}

- (GVMessageType)type {
    GVTextMessage *textMessage = self.textMessages.firstObject;
    return textMessage? textMessage.type : GVMessageTypeUnknown;
}

- (NSString*)text {
    GVTextMessage *textMessage = self.textMessages.firstObject;
    return textMessage? textMessage.text : @"";
}

- (NSDate*)date {
    GVTextMessage *textMessage = self.textMessages.firstObject;
    return textMessage? textMessage.date : nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@> %@: %@", self.date, self.contact.name, self.textMessages];
}

@end
