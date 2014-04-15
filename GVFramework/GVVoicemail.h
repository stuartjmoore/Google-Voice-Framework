//
//  GVVoicemail.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import "GVMessage.h"

@interface GVVoicemail : GVMessage

@property (nonatomic) NSInteger duration;
@property (nonatomic, strong) NSURL *mp3URL, *oggURL;

@property (nonatomic) BOOL hasTranscript;

@end
