//
//  KvcFunAppDelegate.h
//  KvcFun
//
//  Created by Vinay Siddharam Hiremath on 3/16/13.
//  Copyright (c) 2013 Underpull. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface KvcFunAppDelegate : NSObject <NSApplicationDelegate> {
    int fido;
}

@property (assign) IBOutlet NSWindow *window;
@property (readwrite, assign) int fido;

- (IBAction)incrementFido:(id)sender;

@end
