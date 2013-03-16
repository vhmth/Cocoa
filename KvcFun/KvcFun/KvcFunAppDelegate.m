//
//  KvcFunAppDelegate.m
//  KvcFun
//
//  Created by Vinay Siddharam Hiremath on 3/16/13.
//  Copyright (c) 2013 Underpull. All rights reserved.
//

#import "KvcFunAppDelegate.h"

@implementation KvcFunAppDelegate
@synthesize fido;

- (id)init {
    self = [super init];
    if (self) {
        [self setValue:[NSNumber numberWithInt:5]
                forKey:@"fido"];
        NSNumber *n = [self valueForKey:@"fido"];
        NSLog(@"fido = %@", n);
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
}

- (IBAction)incrementFido:(id)sender {
    [self setFido:[self fido] + 1];
}

@end
