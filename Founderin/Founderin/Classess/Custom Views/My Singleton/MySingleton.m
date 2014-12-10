//
//  MySingleton.m
//  Founderin
//
//  Created by Neuron on 11/27/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "MySingleton.h"
#import "Constants.h"

@implementation MySingleton

static MySingleton * _sharedMySingleton = nil;

+ (MySingleton *)sharedMySingleton
{
    static dispatch_once_t predicate;
    if (_sharedMySingleton == nil)
    {
        dispatch_once(&predicate, ^{
            _sharedMySingleton = [MySingleton new];
        });
    }
    return _sharedMySingleton;
}

+ (id)alloc
{
    @synchronized([MySingleton class])
    {
        NSAssert(_sharedMySingleton == nil,
                 @"Attempted to allocate a second instance of a singleton.");
        _sharedMySingleton = [super alloc];
        return _sharedMySingleton;
    }
    
    return nil;
}

- (id)init
{
    self = [super init];
    if (self != nil)
    {
        // initialize stuff here
    }
    return self;
}

#pragma mark - Allocate All varaibles
- (void)declerationAllInstanceVAriable
{
    self.mDictUserDetail = [[NSMutableDictionary alloc] init];
    self.imageUser = [[UIImage alloc] init];
}

#pragma mark - Show Alert
- (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
}

#pragma mark - Email validations
-(BOOL)emailValidation:(NSString *)string
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:string];
}

#pragma mark - Convert UIImage to Base64
- (NSString *)imageToNSString:(UIImage *)image
{
    NSData *data = UIImagePNGRepresentation(image);
    return [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}

#pragma mark - Uiimageview with Rounded corner
- (void)setRoundedImage:(id)roundedView toDiameter:(float)newSize
{
    if ([roundedView isKindOfClass:[UIImageView class]])
    {
        UIImageView *imgview = (UIImageView *)roundedView;
        
        CGPoint saveCenter = imgview.center;
        CGRect newFrame = CGRectMake(imgview.frame.origin.x, imgview.frame.origin.y, newSize, newSize);
        imgview.frame = newFrame;
        imgview.layer.cornerRadius = newSize / 2.0;
        imgview.layer.borderWidth = 2.0;
        imgview.layer.borderColor = [App_Theme_Color CGColor];
        imgview.center = saveCenter;
    }
    else if ([roundedView isKindOfClass:[UIView class]])
    {
        UIView *view = (UIView *)roundedView;
        
        CGPoint saveCenter = view.center;
        CGRect newFrame = CGRectMake(view.frame.origin.x, view.frame.origin.y, newSize, newSize);
        view.frame = newFrame;
        view.layer.cornerRadius = newSize / 2.0;
        view.layer.borderWidth = 2.0;
        view.layer.borderColor = [App_Theme_Color CGColor];
        view.center = saveCenter;
    }
}

#pragma mark - Move view Up And Down
- (void)moveUp:(float)yAxis view:(UIView *)viewSuper
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [viewSuper setFrame:CGRectMake(0, -yAxis, deviceWidth, deviceHeight)];
    [UIView commitAnimations];
}

- (void)moveDown:(UIView *)viewSuper
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.5];
    [viewSuper setFrame:CGRectMake(0, 0, deviceWidth, deviceHeight)];
    [UIView commitAnimations];
}

@end