//
//  MySingleton.h
//  Founderin
//
//  Created by Neuron on 11/27/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MySingleton : NSObject
{
    
}

@property (nonatomic, strong) UIImage *imageUser;

@property (nonatomic, strong) NSMutableDictionary *mDictUserDetail;

+ (MySingleton *)sharedMySingleton;

- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title;
- (void)setRoundedImage:(id)roundedView toDiameter:(float)newSize;
- (NSString *)imageToNSString:(UIImage *)image;
- (void)declerationAllInstanceVAriable;
- (BOOL)emailValidation:(NSString *)string;

- (void)moveUp:(float)yAxis view:(UIView *)viewSuper;
- (void)moveDown:(UIView *)viewSuper;

@end