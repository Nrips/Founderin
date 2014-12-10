//
//  AppDelegate.h
//  Founderin
//
//  Created by Neuron on 11/22/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow    *window;
@property (nonatomic, assign) BOOL        isNetworkAvailable;

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end