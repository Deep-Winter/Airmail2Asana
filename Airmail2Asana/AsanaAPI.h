//
//  AsanaAPI.h
//  Airmail2Asana
//
//  Created by Lars Winter on 12.07.15.
//  Copyright (c) 2015 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AsanaAPI : NSObject

+(void)getUserWithApiKey: (NSString *)apiKey resultHandler:(void (^)(NSDictionary *dic, NSError*err))resultHandler;

+(void)getProjectsForWorkspace: (NSString *)workspaceId withApiKey: (NSString*)apiKey resultHandler:(void (^)(NSArray *arr, NSError*err))resultHandler;

+(void)createTaskWithApiKey: (NSString *)apiKey andTitle: (NSString*)title andNotes: (NSString*)notes inWorkspace: (NSString*)workspace andProject: (NSString*) project resultHandler:(void (^)(NSDictionary *dict, NSError* err))resultHandler;

@end
