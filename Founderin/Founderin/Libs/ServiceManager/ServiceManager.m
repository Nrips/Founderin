//
//  ServiceManager.m
//  LetsTalkbusiness
//
//  Created by Neuron-iPhone on August 2014.
//  Copyright (c) 2014 Neuron-iPhone. All rights reserved.
//

#import "ServiceManager.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "ServiceManager.h"
#import "AppSharedData.h"
#import "Utility.h"

static ServiceManager *serviceManagerObj = nil;
@implementation ServiceManager

+ (ServiceManager*)sharedManager
{
    static dispatch_once_t predicate;
    if (serviceManagerObj == nil) {
        dispatch_once(&predicate, ^{
            serviceManagerObj = [[ServiceManager alloc]init];
        });
    }
    return serviceManagerObj;
}

- (void)executeServiceWithURL:(NSString*)urlString forTask:(TaskType)task completionHandler:(void (^)(id response, NSError *error, TaskType task))completionBlock
{
    
    NSURL *URL = [NSURL URLWithString:urlString];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    op.responseSerializer = [AFJSONResponseSerializer serializer];
    [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSDictionary *jsonData) {
        
        completionBlock(jsonData, operation.error, task);
        [appSharedData removeLoadingView];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        DLog(@"Error: %@", [error localizedDescription]);
        completionBlock(nil, error, task);
        DLog(@" %@ PHP Response  Error/Json ",operation.responseString);
        [appSharedData removeLoadingView];
    }];
    [op start];
    if (task == kTaskNearByPlaces) {
        [appSharedData showCustomLoaderWithTitle:@"Searching Nearby Places..."];
    }
    else if (task == kTaskSearchAllPlaces) {
        [appSharedData showCustomLoaderWithTitle:@"Searching Places..."];
    }
    else
    {
    [appSharedData showCustomLoaderWithTitle:@"Loading..."];
    }
    
}


- (void)executeServiceWithURL:(NSString*)urlString andParameters:(NSDictionary *)postParameters forTask:(TaskType)task completionHandler:(void (^)(id response, NSError *error, TaskType task))completionBlock
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    
    if (task == kTaskSignUp){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"%@ success service manager reply Response String",operation.responseString);
            //NSLog(@"Sucess block Operation %@ \n Response string %@ \n request%@, \n operation.response %@",operation,operation.responseString, operation.request,operation.response);
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            //NSLog(@"Sucess block Operation %@ \n Response string %@ \n request%@, \n operation.response %@",operation,operation.responseString, operation.request,operation.response);
            [appSharedData removeLoadingView];
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            NSLog(@"%@ Failure service manager reply",operation.responseString);
            NSLog(@"%@", [error localizedDescription]);
            
        }];
    }
    else if (task == kTaskCreateMeeting){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            NSLog(@"%@ success service manager reply Response String",operation.responseString);
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            NSLog(@"%@ Failure service manager reply",operation.responseString);
            NSLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
            
        }];
    }
    else if (task == kTaskGetMeetingTopic){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@ success service manager reply Response String",operation.responseString);
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            NSLog(@"%@ Failure service manager reply",operation.responseString);
            NSLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskUsersProfileData){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@ success service manager reply Response String",operation.responseString);
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];

            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"Error: %@", error);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            NSLog(@"%@ Failure service manager reply",operation.responseString);
            NSLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskFindPeople){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@ Failure service manager reply",operation.responseString);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskSendInvitation){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@ Failure service manager reply",operation.responseString);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskGetMeetingList){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@ Failure service manager reply",operation.responseString);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskAcceptViewUpdate){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@ Failure service manager reply",operation.responseString);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskRespondToInvitation){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@ Failure service manager reply",operation.responseString);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskSendMessage){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@ Failure service manager reply",operation.responseString);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskGetMessages){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@ Failure service manager reply",operation.responseString);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskDeleteInvitation){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@ Failure service manager reply",operation.responseString);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskLogout){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            DLog(@"%@ Failure service manager reply",operation.responseString);
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskUpdateUserProfile){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@ Failure service manager reply",operation.responseString);
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskBlockMember){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@ Failure service manager reply",operation.responseString);
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    else if (task == kTaskDeleteMeeting){
        [manager POST:urlString parameters:postParameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
            completionBlock(responseObject, operation.error, task);
            [appSharedData removeLoadingView];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [Utility showAlertMessage:@"" withTitle:@"Request Time Out."];
            DLog(@"%@ Failure service manager reply",operation.responseString);
            DLog(@"%@", [error localizedDescription]);
            [appSharedData removeLoadingView];
        }];
    }
    
    
    //************* Start showing loader view *********************************
    if (task == kTaskUpdateUserProfile) {
        [appSharedData showCustomLoaderWithTitle:@"Updating Profile..."];
    }
    else
    {
    [appSharedData showCustomLoaderWithTitle:@"Loading..."];
    }
    
}

@end
