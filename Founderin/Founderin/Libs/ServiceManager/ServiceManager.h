//
//  ServiceManager.h
//  1800-Spatogo
//
//  Created by Neuron-iPhone on 5/7/14.
//  Copyright (c) 2014 Neuron-iPhone. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

@interface ServiceManager : NSObject

+ (ServiceManager*)sharedManager;

//Method which doesnt take any post parameter
- (void)executeServiceWithURL:(NSString*)urlString forTask:(TaskType)task completionHandler:(void (^)(id response, NSError *error, TaskType task))completionBlock;

//Method which takes post parameter
- (void)executeServiceWithURL:(NSString*)urlString andParameters:(NSDictionary *)postParameters forTask:(TaskType)task completionHandler:(void (^)(id response, NSError *error, TaskType task))completionBlock;

//// Method which take string parameter
//- (void)executeServiceWithURL:(NSString*)urlString andParameters:(NSString *)postParameters forTask:(TaskType)task completionHandler:(void (^)(id response, NSError *error, TaskType task))completionBlock;

@end
