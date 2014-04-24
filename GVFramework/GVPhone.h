//
//  GVPhone.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVContact;

@interface GVPhone : NSObject <NSCoding>

@property (nonatomic, weak) GVContact *contact;

@property (nonatomic, strong) NSString *number, *name;

- (NSURL*)callURL;

@end
