//
//  Person.m
//  RaiseMan
//
//  Created by Vinay Siddharam Hiremath on 3/16/13.
//  Copyright (c) 2013 Underpull. All rights reserved.
//

#import "Person.h"

@implementation Person
@synthesize name, expectedRaise;

- (id)init {
    self = [super init];
    if (self) {
        expectedRaise = 0.05;
        name = @"New Person";
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        name = [coder decodeObjectForKey:@"name"];
        expectedRaise = [coder decodeFloatForKey:@"expectedRaise"];
    }
    return self;
}

- (void)setNilValueForKey:(NSString *)key {
    if ([key isEqual:@"expectedRaise"]) {
        [self setExpectedRaise:0.0];
    } else {
        [super setNilValueForKey:key];
    }
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:name forKey:@"name"];
    [coder encodeFloat:expectedRaise forKey:@"expectedRaise"];
}

@end
