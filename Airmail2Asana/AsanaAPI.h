//
//  AsanaAPI.h
//  Airmail2Asana
//
//  Created by Lars Winter on 12.07.15.
//  Copyright (c) 2015 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsanaAPI : NSObject

+(void)getUserWithApiKey: (NSString *)apiKey andDelegate: (id)delegate;

@end