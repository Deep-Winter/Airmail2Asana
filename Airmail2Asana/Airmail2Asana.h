//
//  Airmail2Asana.h
//  Airmail2Asana
//
//  Created by Lars Winter on 08.07.15.
//  Copyright (c) 2015 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AMPluginFramework/AMPluginFramework.h>

@interface Airmail2Asana : AMPlugin {
    
}
- (void) PostError:(NSError*)error;
@end