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
}
@end;

@implementation Airmail2AsanaConfigView

-(id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self)
    {
        loginButton = [[NSButton alloc] initWithFrame:CGRectMake(20, 20, 120.0f, 30.0f)];
        [loginButton setTitle:@"Login"];
        [loginButton setButtonType:NSMomentaryPushInButton];
        [loginButton setBezelStyle:NSRoundedBezelStyle];
        [loginButton setTarget:self];
        [loginButton setAction:@selector(Login:)];
        [self addSubview:loginButton];

    }
    
    return self;
}

- (void) Login:(id)sender
{
    [[self myPlugin] LogTrace:@"ICH HABE AUF DEN KNOPF GEDRÜCKT!"];
}

- (Airmail2Asana*) myPlugin
{
    return (Airmail2Asana*)self.plugin;
}

@end