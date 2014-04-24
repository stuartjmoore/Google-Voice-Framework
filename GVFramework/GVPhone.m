//
//  GVPhone.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVPhone.h"

@implementation GVPhone

+ (NSURL*)callURLWithNumber:(NSString*)number {
    return [NSURL URLWithString:[NSString stringWithFormat:@"https://plus.google.com/hangouts/_/?hip=%@", number]];
}

- (instancetype)initWithCoder:(NSCoder*)coder {
    self = [super init];

    if (!self)
        return nil;

    _contact = [coder decodeObjectForKey:@"contact"];
    _number = [coder decodeObjectForKey:@"number"];
    _name = [coder decodeObjectForKey:@"name"];

    return self;
}

- (NSString*)name {
    return _name ?: @"unknown";
}

- (NSURL*)callURL {
    return [GVPhone callURLWithNumber:self.number];
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

- (void)encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:self.contact forKey:@"contact"];
    [coder encodeObject:self.number forKey:@"number"];
    [coder encodeObject:self.name forKey:@"name"];
}

@end
