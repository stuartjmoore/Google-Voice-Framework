//
//  GVMessage.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVMessage.h"

#import "GVContact.h"
#import "GVPhone.h"

@implementation GVMessage

- (instancetype)initWithJSON:(NSDictionary*)dictionary {
    self = [super init];
    if (self) {
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
    return [NSString stringWithFormat:@"<%@> %@: \"%@\"", self.date, self.phone.contact.name, self.text];
}

@end
