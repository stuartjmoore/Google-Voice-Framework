//
//  GVTextMessage.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVMessage.h"

@class GVConversation;

@interface GVTextMessage : GVMessage

@property (nonatomic, weak) GVConversation *conversation;

@end
