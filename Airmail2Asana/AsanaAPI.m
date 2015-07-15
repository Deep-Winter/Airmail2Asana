//
//  AsanaAPI.m
//  Airmail2Asana
//
//  Created by Lars Winter on 12.07.15.
//  Copyright (c) 2015 Lars Winter. All rights reserved.
//

#import "AsanaAPI.h"

static NSOperationQueue *operationQueue = nil;
static NSString *apiBaseUrl = @"https://app.asana.com/api/1.0/";

@implementation AsanaAPI

+(NSOperationQueue *)operationQueue
{
    if (operationQueue == nil)
    {
        operationQueue = [NSOperationQueue new];
        [operationQueue setMaxConcurrentOperationCount:1];
    }
    
    return operationQueue;
}

+(void)getProjectsForWorkspace:(NSString *)workspaceId withApiKey:(NSString *)apiKey resultHandler:(void (^)(NSArray *arr, NSError*err))resultHandler {
    NSString* apiCommand = [NSString stringWithFormat: @"workspaces/%@/projects", workspaceId];
    [self getDataFromAsanaApiCommand:apiCommand withApiKey:apiKey resultHandler:^(NSDictionary *dict, NSError *err) {
        if (dict) {
            resultHandler(dict[@"data"],err);
        } else {
            resultHandler(nil,err);
        }
    }];
}

+(void)getUserWithApiKey: (NSString *)apiKey resultHandler:(void (^)(NSDictionary *dict, NSError* err))resultHandler {
    
    NSString* apiCommand = @"users/me";
    [self getDataFromAsanaApiCommand:apiCommand withApiKey:apiKey resultHandler:^(NSDictionary *data, NSError* error) {
        resultHandler(data, error);
    }];
}

+(void)createTaskWithApiKey: (NSString *)apiKey andTitle: (NSString*)title andNotes: (NSString*)notes inWorkspace: (NSString*)workspace andProject: (NSString*) project resultHandler:(void (^)(NSDictionary *dict, NSError* err))resultHandler{
    
    NSURL *apiUrl = [self createUrlForApiCommand:@"tasks"];
    
    NSMutableURLRequest *request = [self createRequestWithUrl:apiUrl andAPIKey:apiKey];
    [request setHTTPMethod:@"POST"];
    NSString *postBody = [NSString stringWithFormat:@"projects=%@&workspace=%@&name=%@&notes=%@", project, workspace, [self URLEncodedString_ch:title],[self URLEncodedString_ch:notes]];
    [request setHTTPBody:[postBody dataUsingEncoding:NSUTF8StringEncoding]];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[self operationQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (connectionError || !data) {
                                   resultHandler(nil,connectionError);
                               } else {
                                   NSError *parseError;
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &parseError];
                                   
                                   if(parseError) {
                                       resultHandler(nil, parseError);
                                   }
                                   else {
                                       resultHandler(dict, nil);
                                   }
                                   
                               }
                           }];
}

+ (NSString *) URLEncodedString_ch: (NSString *)input {
    NSMutableString * output = [NSMutableString string];
    const unsigned char * source = (const unsigned char *)[input UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for (int i = 0; i < sourceLen; ++i) {
        const unsigned char thisChar = source[i];
        if (thisChar == ' '){
            [output appendString:@"+"];
        } else if (thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' ||
                   (thisChar >= 'a' && thisChar <= 'z') ||
                   (thisChar >= 'A' && thisChar <= 'Z') ||
                   (thisChar >= '0' && thisChar <= '9')) {
                    [output appendFormat:@"%c", thisChar];
        } else {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    return output;
}

+ (void)getDataFromAsanaApiCommand:(NSString *)apiCommand withApiKey:(NSString *)apiKey
                     resultHandler:(void (^)(NSDictionary *data,
                                             NSError *connectionError))resultHandler {
    
    NSURL *apiUrl = [self createUrlForApiCommand:apiCommand];
    
    NSMutableURLRequest *request = [self createRequestWithUrl:apiUrl andAPIKey:apiKey];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[self operationQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (connectionError || !data) {
                                   resultHandler(nil,connectionError);
                               } else {
                                   NSError *parseError;
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error: &parseError];
                                   
                                   if(parseError) {
                                       resultHandler(nil, parseError);
                                   }
                                   else {
                                       resultHandler(dict, nil);
                                   }
                                   
                               }
                           }];
}

+ (NSURL *)createUrlForApiCommand:(NSString *)apiCommand {
    return [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", apiBaseUrl, apiCommand]];
}

+(NSMutableURLRequest *)createRequestWithUrl: (NSURL *)url andAPIKey: (NSString *)apiKey {
    
    // Auth
    NSString *authStr = [NSString stringWithFormat:@"%@:%@", apiKey, @"nopassreqiured"];
    NSData *authData = [authStr dataUsingEncoding:NSASCIIStringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [authData base64EncodedStringWithOptions:0]];

    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url
                                                            cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                            timeoutInterval:20];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
    
    return request;
}

@end
