//
//  AppSharedData.m
//  Autism
//
//  Created by Haider on 01/01/14.
//  Copyright (c) 2014 Gaurav. All rights reserved.
//

#import "AppSharedData.h"
#import "MBProgressHUD.h"
#import "Constants.h"
#import "AppDelegate.h"

static AppSharedData *appSharedData_ = nil;

@interface AppSharedData()

@property (nonatomic, strong) MBProgressHUD *loadingView;

@end

@implementation AppSharedData

+ (AppSharedData*)sharedInstance
{
    static dispatch_once_t predicate;
    if(appSharedData_ == nil){
        dispatch_once(&predicate,^{
            appSharedData_ = [[AppSharedData alloc] init];
            appSharedData_.imageCacheDictionary = [[NSMutableDictionary alloc]init];
        });
    }
    return appSharedData_;
}

- (void)showCustomLoaderWithTitle:(NSString *)title
{
    UIWindow *window = [appDelegate window];
    if(self.loadingView)
    {
        [self removeLoadingView];
    }
    self.loadingView = [[MBProgressHUD alloc] initWithWindow:window];
    [self.loadingView setCenter:window.center];
    self.loadingView.color = [UIColor colorWithRed:5/255.0f green:143/255.0f blue:190/255.0f alpha:1.0];
    self.loadingView.labelText = title;
    [window addSubview:self.loadingView];
    [window setUserInteractionEnabled:NO];
    [self.loadingView show:YES];
}

- (void)removeLoadingView
{
    UIWindow *window = [appDelegate window];
    [self.loadingView removeFromSuperview];
    [self.loadingView show:NO];
    [self.loadingView.superview setUserInteractionEnabled:YES];
    [window setUserInteractionEnabled:YES];
    self.loadingView = nil;
}

@end