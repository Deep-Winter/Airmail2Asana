//
//  AsanaAPI.m
//  Airmail2Asana
//
//  Created by Lars Winter on 12.07.15.
//  Copyright (c) 2015 Lars Winter. All rights reserved.
//

#import "AsanaAPI.h"
#import "AsanaAPIProtocol.h"

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

+(void)getProjectsForWorkspace: (NSString *)workspaceId withApiKey: (NSString *)apiKey andDelegate: (id<AsanaAPIProtocol>)delegate {
    NSString* apiCommand = [NSString stringWithFormat: @"workspaces/%@/projects", workspaceId];
    [self getDataFromAsanaApiCommand:apiCommand withApiKey:apiKey andDelegate:delegate];

}

+(void)getUserWithApiKey: (NSString *)apiKey andDelegate: (id<AsanaAPIProtocol>)delegate {
    
    NSString* apiCommand = @"users/me";
    [self getDataFromAsanaApiCommand:apiCommand withApiKey:apiKey andDelegate:delegate];
    

    // ApiKey
    //NSString *apiKey = @"2InC01WY.rqcEIQ84eqYJarArQpaXURU";
    }

+ (void)getDataFromAsanaApiCommand:(NSString *)apiCommand withApiKey:(NSString *)apiKey
                       andDelegate: (id<AsanaAPIProtocol>)delegate {
    
    NSURL *apiUrl = [self createUrlForApiCommand:apiCommand];
    
    NSMutableURLRequest *request = [self createRequestWithUrl:apiUrl andAPIKey:apiKey];
    [request setHTTPMethod:@"GET"];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[self operationQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
                               
                               if (connectionError || !data) {
                                   NSLog(@"%@", connectionError.description);
                                   [delegate finishedCallFor:apiCommand withData:nil orError:connectionError];
                               }
                               else {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                                   [delegate finishedCallFor:apiCommand withData:dict orError:nil];
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
