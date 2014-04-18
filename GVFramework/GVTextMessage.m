//
//  GVTextMessage.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVConversation.h"
#import "GVTextMessage.h"

#import "GVContact.h"
#import "GVPhone.h"

@implementation GVTextMessage

- (instancetype)initWithJSON:(NSDictionary*)dictionary {
    if (self = [super init]) {
        self.identifier = dictionary[@"id"];
        self.text = dictionary[@"message"];
        self.read = [dictionary[@"isRead"] boolValue];

        NSInteger milliseconds = [dictionary[@"startTime"] integerValue] ?: 0;
        NSTimeInterval seconds = (NSTimeInterval)(milliseconds / 1000.0);
        self.date = [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return self;
}

- (GVPhone*)phone {
    return self.conversation.phone;
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
    return [NSString stringWithFormat:@"<%@> %@ “%@”", self.date, self.isRead?@"✓":@"✘", self.text];
}

@end
