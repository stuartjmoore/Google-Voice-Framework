//
//  GVConversation.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVConversation.h"

@implementation GVConversation

- (GVMessageType)type {
    GVTextMessage *textMessage = self.textMessages.firstObject;
    return textMessage? textMessage.type : GVMessageTypeUnknown;
}

- (NSString*)text {
    GVTextMessage *textMessage = self.textMessages.firstObject;
    return textMessage? textMessage.text : @"";
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@> %@: %@", self.identifier, self.contact.name, self.textMessages];
}

@end
