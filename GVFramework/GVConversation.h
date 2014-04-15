//
//  GVConversation.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVMessage.h"
#import "GVTextMessage.h"

@interface GVConversation : GVMessage

@property (nonatomic, strong) NSArray *textMessages;

@end
