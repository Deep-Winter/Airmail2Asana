//
//  AsanaAPIProtocol.h
//  Airmail2Asana
//
//  Created by Lars Winter on 12.07.15.
//  Copyright (c) 2015 Lars Winter. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AsanaAPIProtocol <NSObject>

-(void)finishedCallFor: (NSString *)method withData: (NSDictionary*)dict orError:(NSError*)error;

@end
