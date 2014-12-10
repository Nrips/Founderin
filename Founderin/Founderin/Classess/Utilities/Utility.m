//
//  Utility.m
//  Autism
//
//  Created by Neuron-iPhone on 3/22/14.
//  Copyright (c) 2014 Neurons Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Utility.h"
#import "Constants.h"

@implementation Utility

#pragma mark - Validation

+ (BOOL)isValidateUrl:(NSString *)url {
    
    /*NSString *urlRegEx =
     
     @"(http|https)://((\\w)*|([0-9]*)|([-|_])*)+([\\.|/]((\\w)*|([0-9]*)|([-|_])*))+";
     
     NSPredicate *urlTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", urlRegEx];
     
     return [urlTest evaluateWithObject:url];*/
    
    NSURL *candidateURL = [NSURL URLWithString:url];
    
    // WARNING > "test" is an URL according to RFCs, being just a path
    
    // so you still should check scheme and all other NSURL attributes you need
    if (candidateURL && candidateURL.scheme && candidateURL.host) {
        
        // candidate is a well-formed url with:
        
        //  - a scheme (like http://)
        
        //  - a host (like stackoverflow.com)
        
        return YES;
    }
    return NO;
}

+ (NSString *)getUrlStringWithHttpVerb:(NSString *)url {
    
    [self getValidString:url];
    if (!([url hasPrefix:@"http://"] || [url hasPrefix:@"https://"])) {
        
        url = [NSString stringWithFormat:@"http://%@",url];
    }
    return url;
}

+ (BOOL)isValidString:(NSString *)string

{
    if (string == (id)[NSNull null] || string.length == 0 || [string isEqualToString:@"null"] )
        
        return NO;
    return YES;
}


+ (BOOL)NSStringIsValidEmail:(NSString *)checkString
{
    BOOL stricterFilter = YES;
    NSString *stricterFilterString = @"[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}";
    NSString *laxString = @".+@([A-Za-z0-9]+\\.)+[A-Za-z]{2}[A-Za-z]*";
    NSString *emailRegex = stricterFilter ? stricterFilterString : laxString;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:checkString];
}


+ (BOOL)NSStringIsValidName:(NSString *)checkString
{
    NSString *nameRegex = @"[A-Za-z]+";
    NSPredicate *nameTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", nameRegex];
    return [nameTest evaluateWithObject:checkString];
}

+ (NSString*)getValidString:(NSString *)string
{
    if (string == nil)
        return @"";
    
    if ([string isKindOfClass:[NSNull class]] || [string isEqualToString:@"<null>"] || [string isEqualToString:@"(null)"])
        return @"";
    
    if (string.length > 0) {
        string = [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    } else {
        string = @"";
    }
    return string;
}


#pragma mark - Show Alert 

// Show an alert message
+ (void)showAlertMessage:(NSString *)message withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:message
                               delegate:nil
                      cancelButtonTitle:@"OK"
                      otherButtonTitles:nil] show];
}

// Show an Network alert message

+ (void)showNetWorkAlert {
    
    UIAlertView *alert =[[UIAlertView alloc] initWithTitle:@"No Network Connection" message:@"Please check your connection and try again." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
    
    [alert show];
    
}

+ (NSDate *)getUTCFormateDate:(double)timeInSeconds
{
    NSTimeInterval mytime = timeInSeconds;
    NSLog(@"mytime:%f",mytime);
    NSDate *localDate = [NSDate dateWithTimeIntervalSince1970:mytime];
    NSLog(@"localDate:%@",localDate);
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
    [dateFormatter setTimeZone:timeZone];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *dateString = [dateFormatter stringFromDate:localDate];
    //return dateString;
    return [dateFormatter dateFromString:dateString];
}

//Method for passing null values when intented values are not available.
extern id ObjectOrBlank(id object)
{
    //return object ?: [NSNull null];
    return object ?: @"";

}

//Convert NSDate into NSString (With different components)
+ (NSString *)extractComponentsInString:(NSDate *)date
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // Extract date components into components
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSString *dateInString = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    return dateInString;
}

//Convert NSDate into NSString (With different components)
+ (NSString *)extractTimeComponentsInString:(NSDate *)date
{
    NSCalendar *gregorianCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // Extract date components into components
    NSDateComponents *components = [gregorianCalendar components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay fromDate:date];
    NSInteger year = [components year];
    NSInteger month = [components month];
    NSInteger day = [components day];
    
    NSString *dateInString = [NSString stringWithFormat:@"%ld-%ld-%ld",(long)year,(long)month,(long)day];
    return dateInString;
}



+ (NSString *) appVersion
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: @"CFBundleShortVersionString"];
}

+ (NSString *) build
{
    return [[NSBundle mainBundle] objectForInfoDictionaryKey: (NSString *)kCFBundleVersionKey];
}

//Test methods
+ (NSString *)stringWithoutNilOrNull :(NSString *)checkString
{
       if (!checkString || [checkString isKindOfClass:[NSNull class]])
        {
            return checkString;
        }
    //return (!checkString || [checkString isKindOfClass:[NSNull class]]) ? checkString : @"";
    return 0;
}

#pragma mark - Base64 conversion for image
+ (NSString*)base64forData:(NSData*) theData {
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
}

@end
