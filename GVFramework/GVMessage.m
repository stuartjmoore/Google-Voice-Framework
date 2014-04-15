//
//  GVMessage.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVMessage.h"

@implementation GVMessage

- (instancetype)init {
    if (self = [super init]) {
        NSAssert(YES, @"You must only implement a sublass!");
    }
    return self;
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;

    if (![object isKindOfClass:[GVMessage class]])
        return NO;

    return [self isEqualToMessage:(GVMessage*)object];
}

- (BOOL)isEqualToMessage:(GVMessage*)object {
    return [self.identifier isEqualToString:object.identifier];
}

- (NSUInteger)hash {
    return self.identifier.hash;
}

- (NSString*)description {
    return super.description;
}

@end
