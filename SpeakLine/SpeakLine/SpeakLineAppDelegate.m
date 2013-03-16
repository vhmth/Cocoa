//
//  SpeakLineAppDelegate.m
//  SpeakLine
//
//  Created by Vinay Siddharam Hiremath on 3/15/13.
//  Copyright (c) 2013 Underpull. All rights reserved.
//

#import "SpeakLineAppDelegate.h"

@implementation SpeakLineAppDelegate
@synthesize window, textField;

- (id)init {
    self = [super init];
    if (self) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)stopIt:(id)sender {
    NSLog(@"stopping");
    [_speechSynth stopSpeaking];
}

- (IBAction)sayIt:(id)sender {
    NSString *script = [textField stringValue];
    if ([script length] == 0) {
        NSLog(@"string from %@ is of zero-length", textField);
        return;
    }
    [_speechSynth startSpeakingString:script];
    NSLog(@"Have started to say: %@", script);
}
@end
