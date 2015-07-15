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
#import "AsanaAPI.h"

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
    return @"Integrate Asana into AirMail 2, for easy creating tasks from emails.";
}

-(NSString *)authortext
{
    return @"DeepWinter";
}

-(NSString *)supportlink
{
    return @"https://github.com/Deep-Winter/Airmail2Asana/wiki";
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
    NSMenuItem *sendToAsanaMenu = [[NSMenuItem alloc] initWithTitle:@"Send to Asana Inbox" action:nil keyEquivalent:@""];
    
    NSString *apikey = self.preferences[asana_apiKey];
    if(apikey && apikey.length > 0) {
      
            NSMenu *menu    = [[NSMenu alloc] initWithTitle:@"Projects"];
            NSArray *lists = self.preferences[asana_projects];
        
            for(NSDictionary *item in lists)
            {
                NSMenuItem *listItem = [[NSMenuItem alloc] initWithTitle:[NSString stringWithFormat:@"%@",item[@"name"]] action:nil keyEquivalent:@""];
                [listItem setRepresentedObject:item];
                [listItem setAction:@selector(sendToAsana:)];
                [listItem setTarget:self];
                [menu addItem:listItem];
            
            }
        
            [sendToAsanaMenu setSubmenu:menu];
    }
    
    [sendToAsanaMenu setRepresentedObject:@""];
    
    return sendToAsanaMenu;
}


-(void) sendToAsana:(NSMenuItem *)item
{
    @try
    {
        NSString *apiKey = self.preferences[asana_apiKey];
        if(apiKey.length == 0)
            return;
        
        NSString *workspaceId = self.preferences[asana_selectedWorkspace];
        if (workspaceId.length == 0)
            return;
        
        AMPMenuAction *action = item.representedObject;
        NSDictionary *project    = (NSDictionary*)action.representedObject;
        NSString* projectId = project[@"id"];
        
        if(action && [action isKindOfClass:[AMPMenuAction class]])
        {
            for ( int i = 0; i < action.messages.count; i ++ )
            {
                AMPMessage *msg = (AMPMessage *)[action.messages objectAtIndex:i];
                
                //NSString *url   = [msg callSelector:@selector(urlformessage)];
                //if(!url || url.length == 0)
                 //   url = @"";
                
                NSString *subject = msg.subject;
                if(!subject || subject.length == 0)
                    subject = @"";
                
                NSString *body = msg.htmlBody;
                if (!body || body.length == 0)
                    body = @"";
                
                [AsanaAPI createTaskWithApiKey:apiKey andTitle:subject andNotes:body inWorkspace:workspaceId andProject:projectId resultHandler:^(NSDictionary *dict, NSError *err) {
                    
                    if(err)
                    {
                        [self PostError:err];
                        return;
                    }
                    
                    [[NSSound soundNamed:@"Hero"] play];
                }];
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Exception sendToAsana %@",exception);
    }
}

- (void) PostError:(NSError*)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        NSAlert *anAlert = [NSAlert alertWithError:error];
        [anAlert runModal];
    });
}

@end