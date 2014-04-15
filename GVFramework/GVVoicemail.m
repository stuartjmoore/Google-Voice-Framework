//
//  GVVoicemail.m
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVVoicemail.h"

@implementation GVVoicemail

- (GVMessageType)type {
    return GVMessageTypeVoicemail;
}

- (NSString*)description {
    return [NSString stringWithFormat:@"<%@> %@: \"%@\" [voicemail]", self.identifier, self.contact.name, self.text];
}

@end
