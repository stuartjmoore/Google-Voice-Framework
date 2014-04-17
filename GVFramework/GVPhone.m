//
//  GVPhone.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVPhone.h"

@implementation GVPhone

- (NSString*)name {
    return _name ?: @"unknown";
}

- (NSURL*)callURL {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://plus.google.com/hangouts/_/?hip=%@", self.number]];
}

- (BOOL)isEqual:(id)object {
    if (self == object)
        return YES;

    if (![object isKindOfClass:[GVPhone class]])
        return NO;

    return [self isEqualToPhone:(GVPhone*)object];
}

- (BOOL)isEqualToPhone:(GVPhone*)object {
    return [self.number isEqualToString:object.number];
}

- (NSUInteger)hash {
    return self.number.hash;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"%@: %@", self.name, self.number];
}

@end
