//
//  Airmail2Asana.m
//  Airmail2Asana
//
//  Created by Lars Winter on 08.07.15.
//  Copyright (c) 2015 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Airmail2Asana.h"
#import "Airmail2AsanaConfigView.h"

@implementation Airmail2Asana

-(id)initWithbundle:(NSBundle *)bundleIn path:(NSString *)pathIn
{
    self = [super initWithbundle:bundleIn path:pathIn];
    if (self)
    {
        
    }
    return self;
}

-(BOOL)Load
{
    if (![super Load])
        return NO;
    
    return YES;
}

-(void)Enable
{
    
}

-(void)Disable
{
    
}

-(void)Invalid
{
    
}

-(NSString *)nametext
{
    return @"Airmail2Asana";
}

-(NSString *)description
{
    return self.nametext;
}

-(NSString *)descriptiontext
{
    return @"Integrate Asana and AirMail, for easy creating tasks in Ansana.";
}

-(NSString *)authortext
{
    return @"Lars Winter";
}

-(NSString *)supportlink
{
    return @"http://www.deep-winter.com";
}

-(AMPView *)pluginview
{
    if (self.myView == nil)
        self.myView = [[Airmail2AsanaConfigView alloc] initWithFrame:NSZeroRect plugin:self];
    
    return self.myView;
}

-(void)Reload
{
    [self.myView ReloadView];
}

- (NSImage*) icon
{
    return [self.bundle imageForResource:@"plugins-Airmail2Asana"];
}

-(id)ampMenuActionItem:(NSArray *)messages
{
    NSMenuItem *sendToInbox = [[NSMenuItem alloc] initWithTitle:@"Send to Asana Inbox" action:nil keyEquivalent:@""];
    [sendToInbox setRepresentedObject:@""];
    return sendToInbox;
}


- (void) PostError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert *anAlert = [NSAlert alertWithError:error];
        [anAlert runModal];
    });
}

@end