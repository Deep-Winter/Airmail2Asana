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
#import "AsanaAPI.h"

@interface Airmail2AsanaConfigView()
{
    NSButton *loginButton;
    NSTextField *apiKeyField;
    NSTextView *apiKeyLabel;
    NSTextView *workspacesLabel;
    NSComboBox *workspacesCombobox;
    
    bool loadDataFromApi;
}

@property (strong) NSString *apiKey;
@property (strong) NSArray *workspaces;
@property (strong) NSArray *projectsOfSelectedWorkspace;
@property (strong) NSString *selectedWorkspace;
@property NSInteger selectedWorkspaceIndex;
@property (strong) NSString *userName;
@property (strong) NSString *userId;
@end;

@implementation Airmail2AsanaConfigView

-(id)initWithFrame:(NSRect)frame plugin:(AMPlugin *)pluginIn
{
    self = [super initWithFrame:frame plugin:pluginIn];
    if (self)
    {
        loginButton = [[NSButton alloc] initWithFrame:CGRectMake(95, 30, 150, 30.0f)];
        [loginButton setTitle:@"Connect to Asana"];
        [loginButton setButtonType:NSMomentaryPushInButton];
        [loginButton setBezelStyle:NSRoundedBezelStyle];
        [loginButton setTarget:self];
        [loginButton setAction:@selector(Login:)];
        [self addSubview:loginButton];
    
        apiKeyLabel = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 5, 100, 25)];
        [apiKeyLabel setTextColor:[NSColor secondaryLabelColor]];
        [apiKeyLabel setString:@"API Key:"];
        [apiKeyLabel setDrawsBackground:NO];
        [apiKeyLabel setEditable:NO];
        [apiKeyLabel setSelectable:NO];
        [self addSubview:apiKeyLabel];
        
        apiKeyField = [[NSTextField alloc] initWithFrame:NSMakeRect(100, 0, 250, 25)];
        [apiKeyField setEditable:YES];
        [self addSubview:apiKeyField];

        workspacesLabel = [[NSTextView alloc] initWithFrame:NSMakeRect(0, 68, 100, 25)];
        [workspacesLabel setTextColor:[NSColor secondaryLabelColor]];
        [workspacesLabel setString:@"Workspaces:"];
        [workspacesLabel setDrawsBackground:NO];
        [workspacesLabel setEditable:NO];
        [workspacesLabel setSelectable:NO];
        [self addSubview:workspacesLabel];
        
        workspacesCombobox = [[NSComboBox alloc] initWithFrame:CGRectMake(100, 60, 250, 30.0f)];
        [workspacesCombobox setEnabled:NO];
        workspacesCombobox.usesDataSource = true;
        workspacesCombobox.dataSource = self;
        workspacesCombobox.delegate = self;
        [self addSubview:workspacesCombobox];
        
        [self LoadPreferences];
    }
    
    return self;
}

- (void) LoadPreferences
{
    [self resetProperties];
    
    if(self.plugin.preferences[asana_apiKey])
        self.apiKey = self.plugin.preferences[asana_apiKey];
    
    if(self.plugin.preferences[asana_user])
        self.userName = self.plugin.preferences[asana_user];
    
    if(self.plugin.preferences[asana_userId])
        self.userId = self.plugin.preferences[asana_userId];
    
    if(self.plugin.preferences[asana_workspaces])
        self.workspaces = self.plugin.preferences[asana_workspaces];
    
    if(self.plugin.preferences[asana_selectedWorkspace])
        self.selectedWorkspace = [NSString stringWithFormat:@"%@",self.plugin.preferences[asana_selectedWorkspace]];
    
    if(self.plugin.preferences[asana_selectedWorkspaceIndex])
        self.selectedWorkspaceIndex = [NSString stringWithFormat:@"%@",self.plugin.preferences[asana_selectedWorkspaceIndex]].intValue;
    
    if(self.plugin.preferences[asana_projects])
        self.projectsOfSelectedWorkspace = self.plugin.preferences[asana_projects];
    
    [self updateUI];
}

-(void)resetProperties {
    self.apiKey = @"";
    self.userName = @"";
    self.userId = @"";
    self.workspaces = nil;
    self.selectedWorkspace = @"";
    self.projectsOfSelectedWorkspace = [[NSMutableArray alloc] initWithCapacity:0];
    self.selectedWorkspaceIndex = -1;
}

- (void) SavePreferences
{
    self.plugin.preferences[asana_apiKey] = self.apiKey;
    self.plugin.preferences[asana_userId] = self.userId;
    self.plugin.preferences[asana_user] = self.userName;
    self.plugin.preferences[asana_selectedWorkspace] = self.selectedWorkspace;
    self.plugin.preferences[asana_workspaces] = self.workspaces;
    self.plugin.preferences[asana_projects] = self.projectsOfSelectedWorkspace;
    self.plugin.preferences[asana_selectedWorkspaceIndex] =
        [NSString stringWithFormat:@"%d",(int)self.selectedWorkspaceIndex];
    [self.plugin SavePreferences];
}

- (void) Login:(id)sender
{
    [self.plugin LogTrace:@"Trying to connect to Asana API"];

    [self resetProperties];
    self.apiKey = [apiKeyField stringValue];
    
    [AsanaAPI getUserWithApiKey: self.apiKey andDelegate: self];
}

- (Airmail2Asana*) myPlugin
{
    return (Airmail2Asana*)self.plugin;
}

-(void)finishedCallFor:(NSString *)method withData:(NSDictionary *)dict orError:(NSError *)error {
    [self.plugin LogTrace:[NSString stringWithFormat:@"Asana API call finished: %@", method ]];

    if ([method isEqualToString:@"users/me"]) {
        if (!error && dict) {
            self.userName = [NSString stringWithFormat:@"%@",dict[@"data"][@"name"]];
            self.userId = [NSString stringWithFormat:@"%@",dict[@"data"][@"id"]];
            self.workspaces = dict[@"data"][@"workspaces"];
            [self.plugin LogTrace:[NSString stringWithFormat:@"Connected to Asana user: %@", self.userName]];
        }
        else {
            if (error) {
                [self.plugin LogError:error.description];
                [self.plugin LogError:error.debugDescription];
            }
            [self resetProperties];
        }
        
        [self SavePreferences];
        [self updateUI];
    }
    
    if([method hasPrefix:@"workspaces/"]) {
        if (dict) {
            self.projectsOfSelectedWorkspace = dict[@"data"];
        }
        else {
            self.projectsOfSelectedWorkspace = [[NSMutableArray alloc] initWithCapacity:0];
        }
        [workspacesCombobox setEnabled: YES];
        [self SavePreferences];
    }
}

-(void)updateUI {
    
    [apiKeyField setStringValue: self.apiKey];
    if (self.workspaces) {
        [workspacesCombobox setEnabled: YES];
        [workspacesCombobox reloadData];
        if([self.selectedWorkspace isEqualToString:@""] || self.selectedWorkspaceIndex == -1) {
            [workspacesCombobox selectItemAtIndex:0];
        } else {
            [workspacesCombobox selectItemAtIndex:self.selectedWorkspaceIndex];
        }
    } else {
        [workspacesCombobox setEnabled: NO];
    }
    //loadDataFromApi = YES;
}

- (NSInteger)numberOfItemsInComboBox:(NSComboBox *)aComboBox {
    if (!self.workspaces) return 0;
    return self.workspaces.count;
}

- (id)comboBox:(NSComboBox *)aComboBox objectValueForItemAtIndex:(NSInteger)index {
    return self.workspaces[index][@"name"];
}

- (void)comboBoxSelectionDidChange:(NSNotification *)notification {
    //if (!loadDataFromApi) return;
    
    if(!self.workspaces || workspacesCombobox.numberOfItems == 0 ) return;
    self.selectedWorkspaceIndex =workspacesCombobox.indexOfSelectedItem;
    self.selectedWorkspace = [NSString stringWithFormat:@"%@", self.workspaces[self.selectedWorkspaceIndex][@"id"]];
    //self.projectsOfSelectedWorkspace =
    //[self SavePreferences];
    
    [workspacesCombobox setEnabled:NO];
    [AsanaAPI getProjectsForWorkspace:self.selectedWorkspace withApiKey:self.apiKey andDelegate:self];
    
}
@end