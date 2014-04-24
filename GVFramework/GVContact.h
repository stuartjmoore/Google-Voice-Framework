//
//  GVContact.h
//  GVFramework
//
//  Created by Stuart Moore on 4/15/14.
//  Copyright (c) 2014 Stuart J. Moore. All rights reserved.
//

#import <Foundation/Foundation.h>

@class GVPhone;

@interface GVContact : NSObject <NSCoding>

@property (nonatomic, strong) NSString *identifier, *name;
@property (nonatomic, strong) NSURL *photoURL;

@property (nonatomic, strong) NSSet *phones, *emails;

- (instancetype)initWithJSON:(NSDictionary*)dictionary;

- (GVPhone*)phoneWithNumber:(NSString*)number;

@end
