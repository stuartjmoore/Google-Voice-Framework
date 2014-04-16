//
//  GVMissedCall.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVMissedCall.h"

@implementation GVMissedCall

- (instancetype)initWithJSON:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
        self.identifier = dictionary[@"id"];
        self.note = dictionary[@"note"];
        self.labels = dictionary[@"labels"];
        self.spam = [dictionary[@"isSpam"] boolValue];
        self.trash = [dictionary[@"isTrash"] boolValue];
        self.starred = [dictionary[@"star"] boolValue];
        self.read = [dictionary[@"isRead"] boolValue];

        NSInteger milliseconds = [dictionary[@"startTime"] integerValue] ?: 0;
        NSTimeInterval seconds = (NSTimeInterval)(milliseconds / 1000.0);
        self.date = [NSDate dateWithTimeIntervalSince1970:seconds];
    }
    return self;
}

- (GVMessageType)type {
    return GVMessageTypeMissedCall;
}

- (NSString*)text {
    return nil;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@> %@: missed call", self.date, self.contact.name];
}

@end
