//
//  Airmail2AsanaConfigView.h
//  Airmail2Asana
//
//  Created by Lars Winter on 08.07.15.
//  Copyright (c) 2015 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>
#import "AsanaAPIProtocol.h"


static NSString *const asana_apiKey             = @"asana_apiKey";
static NSString *const asana_userId             = @"asana_userId";
static NSString *const asana_user               = @"asana_user";
static NSString *const asana_workspaces         = @"asana_workspaces";
static NSString *const asana_selectedWorkspace  = @"asana_selectedWorkspace";

@interface Airmail2AsanaConfigView : AMPView<AsanaAPIProtocol,NSComboBoxDataSource, NSComboBoxDelegate>

@end
