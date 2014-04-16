//
//  GVTextMessage.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVConversation.h"
#import "GVTextMessage.h"

@implementation GVTextMessage

- (GVContact*)contact {
    return self.conversation.contact;
}

- (NSString*)note {
    return self.conversation.note;
}

- (NSArray*)labels {
    return self.conversation.labels;
}

- (BOOL)isSpam {
    return self.conversation.isSpam;
}

- (BOOL)isTrash {
    return self.conversation.isTrash;
}

- (BOOL)isStarred {
    return self.conversation.isStarred;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@> %@", self.date, self.text];
}

@end
