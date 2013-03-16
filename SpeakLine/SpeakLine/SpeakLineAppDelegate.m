//
//  SpeakLineAppDelegate.m
//  SpeakLine
//
//  Created by Vinay Siddharam Hiremath on 3/15/13.
//  Copyright (c) 2013 Underpull. All rights reserved.
//

#import "SpeakLineAppDelegate.h"

@implementation SpeakLineAppDelegate
@synthesize window, textField, speakButton, stopButton, voicesTableView;

- (id)init {
    self = [super init];
    if (self) {
        _speechSynth = [[NSSpeechSynthesizer alloc] initWithVoice:nil];
        [_speechSynth setDelegate:self];
        voices = [NSSpeechSynthesizer availableVoices];
    }
    return self;
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [stopButton setEnabled:NO];
    [speakButton setEnabled:YES];
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
    
    [stopButton setEnabled:YES];
    [speakButton setEnabled:NO];
    [voicesTableView setEnabled:NO];
}

- (void)speechSynthesizer:(NSSpeechSynthesizer *)sender
        didFinishSpeaking:(BOOL)finishedSpeaking {
    [stopButton setEnabled:NO];
    [speakButton setEnabled:YES];
    [voicesTableView setEnabled:YES];
}

- (NSInteger)numberOfRowsInTableView:(NSTableView *)tv {
    return (NSInteger)[voices count];
}

- (id)tableView:(NSTableView *)tv
        objectValueForTableColumn:(NSTableColumn *)tableColumn
            row:(NSInteger)row {
    NSString *voice = [voices objectAtIndex:row];
    NSDictionary *voiceDict = [NSSpeechSynthesizer attributesForVoice:voice];
    return [voiceDict objectForKey:NSVoiceName];
}

- (void)tableViewSelectionDidChange:(NSNotification *)notification {
    NSInteger row = [voicesTableView selectedRow];
    if (row == -1) {
        return;
    }
    NSString *selectedVoice = [voices objectAtIndex:row];
    [_speechSynth setVoice:selectedVoice];
    NSLog(@"new voice = %@", selectedVoice);
}

// set the default voice when the table view appears
- (void)awakeFromNib {
    NSString *defaultVoice = [NSSpeechSynthesizer defaultVoice];
    NSInteger defaultRow = [voices indexOfObject:defaultVoice];
    NSIndexSet *voiceIndices = [NSIndexSet indexSetWithIndex:defaultRow];
    [voicesTableView selectRowIndexes:voiceIndices byExtendingSelection:NO];
    [voicesTableView scrollRowToVisible:defaultRow];
}

@end
