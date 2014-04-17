//
//  GVMessage.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GVContact.h"

typedef NS_ENUM(NSInteger, GVMessageType) {
    GVMessageTypeUnknown       = -1,
    GVMessageTypeMissedCall    =  0,
    GVMessageTypeReceivedTCall =  1,
    GVMessageTypeVoicemail     =  2,
    GVMessageTypeRecordedCall  =  4,
    GVMessageTypePlacedCall    =  8,
    GVMessageTypeTextReceived  = 10,
    GVMessageTypeTextSent      = 11
};

@interface GVMessage : NSObject

@property (nonatomic, strong) GVContact *contact;

@property (nonatomic, strong) NSString *identifier;
@property (nonatomic, strong) NSDate *date;

@property (nonatomic) GVMessageType type;

@property (nonatomic, strong) NSString *text, *note;

@property (nonatomic, strong) NSArray *labels;

@property (nonatomic, getter = isRead) BOOL read;
@property (nonatomic, getter = isSpam) BOOL spam;
@property (nonatomic, getter = isTrash) BOOL trash;
@property (nonatomic, getter = isStarred) BOOL starred;

- (instancetype)initWithJSON:(NSDictionary*)dictionary;

@end
