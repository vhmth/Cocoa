//
//  SpeakLineAppDelegate.h
//  SpeakLine
//
//  Created by Vinay Siddharam Hiremath on 3/15/13.
//  Copyright (c) 2013 Underpull. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SpeakLineAppDelegate : NSObject
    <NSApplicationDelegate, NSSpeechSynthesizerDelegate> {
    NSSpeechSynthesizer *_speechSynth;
    NSArray *voices;
}

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *textField;
@property (weak) IBOutlet NSButton *stopButton;
@property (weak) IBOutlet NSButton *speakButton;
@property (weak) IBOutlet NSTableView *voicesTableView;

- (IBAction)stopIt:(id)sender;
- (IBAction)sayIt:(id)sender;

@end
