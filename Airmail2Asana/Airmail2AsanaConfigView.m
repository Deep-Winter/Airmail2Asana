//
//  Airmail2AsanaConfigView.m
//  Airmail2Asana
//
//  Created by Lars Winter on 08.07.15.
//  Copyright (c) 2015 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Airmail2AsanaConfigView.h"
#import "Airmail2Asana.h"

@interface Airmail2AsanaConfigView ()
{
    NSButton *loginButton;
    NSTextField *apiKeyField;
    NSTextField *apiKeyLabel;
}

@property (strong) NSString *apiKey;
@end;

@implementation Airmail2AsanaConfigView

-(id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self)
    {
        loginButton = [[NSButton alloc] initWithFrame:CGRectMake(20, 55, 350, 30.0f)];
        [loginButton setTitle:@"Connect to Asana"];
        [loginButton setButtonType:NSMomentaryPushInButton];
        //[loginButton setBezelStyle:NSRoundedBezelStyle];
        [loginButton setTarget:self];
        [loginButton setAction:@selector(Login:)];
        [self addSubview:loginButton];
    
        apiKeyLabel = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 0, 350, 25)];
        [apiKeyLabel setStringValue:@"API Key:"];
        [apiKeyLabel setBordered:NO];
        [apiKeyLabel setFont:[NSFont systemFontOfSize:11]];
        [apiKeyLabel setBezeled:NO];
        [apiKeyLabel setDrawsBackground:NO];//deprecated
        [apiKeyLabel setEditable:NO];
        [apiKeyLabel setSelectable:NO];
        [apiKeyLabel setFont:[NSFont systemFontOfSize:13]];
        [[apiKeyLabel cell] setBackgroundStyle:NSBackgroundStyleRaised];
        [self addSubview:apiKeyLabel];
        
        apiKeyField = [[NSTextField alloc] initWithFrame:NSMakeRect(20, 25, 350, 25)];
        [apiKeyField setStringValue:@""];
        [apiKeyField setFont:[NSFont systemFontOfSize:11]];
        [apiKeyField setEditable:YES];
        [apiKeyField setSelectable:YES];
        [apiKeyField setFont:[NSFont systemFontOfSize:13]];
        [[apiKeyField cell] setBackgroundStyle:NSBackgroundStyleRaised];
        [self addSubview:apiKeyField];

        [self LoadApiKey];

    }
    
    return self;
}

- (void) LoadApiKey
{
    self.apiKey = @"";
    if(self.plugin.preferences[asana_apiKey])
        self.apiKey = self.plugin.preferences[asana_apiKey];
    
    [apiKeyField setStringValue: self.apiKey];
}

- (void) SaveApiKey
{
    self.plugin.preferences[asana_apiKey] = self.apiKey;
    [self.plugin SavePreferences];
}

- (void) Login:(id)sender
{
    self.apiKey = [apiKeyField stringValue];
    [self SaveApiKey];
}

- (Airmail2Asana*) myPlugin
{
    return (Airmail2Asana*)self.plugin;
}

@end