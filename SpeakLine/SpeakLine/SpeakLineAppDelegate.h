//
//  SpeakLineAppDelegate.h
//  SpeakLine
//
//  Created by Vinay Siddharam Hiremath on 3/15/13.
//  Copyright (c) 2013 Underpull. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpeakLineAppDelegate : NSObject <NSApplicationDelegate> {
    NSSpeechSynthesizer *_speechSynth;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;

- (IBAction)stopIt:(id)sender;
- (IBAction)sayIt:(id)sender;

@end
