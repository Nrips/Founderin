//
//  BusinessContactVC.m
//  Founderin
//
//  Created by Neuron on 12/1/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "BusinessContactVC.h"
#import "FindPeopleVC.h"

@interface BusinessContactVC ()

@property (weak, nonatomic) IBOutlet UIView         *viewRounded;

@property (weak, nonatomic) IBOutlet UITextField    *txfPhone;
@property (weak, nonatomic) IBOutlet UITextField    *txfBusinessEmail;
@property (weak, nonatomic) IBOutlet UITextField    *txfSkipeId;

@end

@implementation BusinessContactVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.viewRounded.clipsToBounds = YES;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    [self.view addGestureRecognizer:gesture];
    
    [[MySingleton sharedMySingleton] setRoundedImage:self.viewRounded toDiameter:80.0];
    
    [self fillUserInfo];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self resignAllResponders];
}

#pragma mark - Custom Methods
- (void)fillUserInfo
{
    if ([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"phoneNumbers"] != nil)
    {
        self.txfPhone.text = [[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"phoneNumbers"];
    }
}

- (void)resignAllResponders
{
    if ([self.txfPhone isFirstResponder])
        [self.txfPhone resignFirstResponder];
    if ([self.txfBusinessEmail isFirstResponder])
        [self.txfBusinessEmail resignFirstResponder];
    if ([self.txfSkipeId isFirstResponder])
        [self.txfSkipeId resignFirstResponder];
}

#pragma mark - API Methods
- (void)callSignUpService
{
    NSString *strBase;
    
    if ([MySingleton sharedMySingleton].imageUser != nil)
    {
        strBase = [[MySingleton sharedMySingleton] imageToNSString:[MySingleton sharedMySingleton].imageUser];
    }
    
    NSString *strIdKey;
    
    if ([[[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"UserType"] isEqualToString:@"linkedin"])
    {
        strIdKey = @"m_linkedin_id";
    }
    else
    {
        if ([[[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"UserType"] isEqualToString:@"facebook"])
        {
            strIdKey = @"m_fb_id";
        }
    }
    
    NSDictionary *postParams;
    
    if ([[[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"UserType"] isEqualToString:@"simple"])
    {
        postParams = @{     @"m_first_name"         : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail
                                                                     objectForKey:@"firstName"]),
                            @"m_last_name"          : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"lastName"]),
                            @"m_picture"            : ObjectOrBlank(strBase),
                            @"m_location"           : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"location"]),
                            @"m_from_user"          : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"UserType"]),
                            @"m_phone"              : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"phoneNumbers"]),
                            @"u_email"              : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"emailAddress"]),
                            @"me_company_name"      : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"company"]),
                            @"me_title"             : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"title"]),
                            @"me_start_date"        : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"start_date"]),
                            @"me_fk_mi_id"          : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"industryId"]),
                            @"device_id"            : ObjectOrBlank(@"3a76f63450168f9abd76cb1c173ebe21cc80043be30a962d076c98f4ca06b814"),
                            @"certification_type"   : ObjectOrBlank(@"develpoment"),
                            @"m_skype_id"           : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"skipeid"]),
                            @"m_business_email"     : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"emailAddress"]),
                            @"u_password"     : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"password"]),
                            };
    }
    else
    {
        postParams = @{     @"m_first_name"         : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail
                                                                     objectForKey:@"firstName"]),
                            @"m_last_name"          : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"lastName"]),
                            @"m_picture"            : ObjectOrBlank(strBase),
                            @"m_location"           : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"location"]),
                            @"m_from_user"          : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"UserType"]),
                            @"m_phone"              : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"phoneNumbers"]),
                            @"u_email"              : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"emailAddress"]),
                            @"me_company_name"      : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"company"]),
                            @"me_title"             : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"title"]),
                            @"me_start_date"        : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"start_date"]),
                            @"me_fk_mi_id"          : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"industryId"]),
                            @"device_id"            : ObjectOrBlank(@"3a76f63450168f9abd76cb1c173ebe21cc80043be30a962d076c98f4ca06b814"),
                            @"certification_type"   : ObjectOrBlank(@"develpoment"),
                            strIdKey                : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"id"]),
                            @"m_skype_id"           : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"skipeid"]),
                            @"m_business_email"     : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"emailAddress"]),
                            };
    }
    
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, WEB_URL_SignUp];
    
    [serviceManager executeServiceWithURL:urlString andParameters:postParams forTask:kTaskSignUp completionHandler:^(id response, NSError *error, TaskType task)
     {
         DLog(@"%s %@ api \n with response %@",__FUNCTION__,urlString,response);
         if (!error && response)
         {
             NSDictionary *dict = [[NSDictionary alloc]init];
             dict = (NSDictionary *)response;
             if ([[response valueForKey:@"response_code"] isEqualToString:@"RC0000"])
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     NSDictionary *dictUserInfo = [response valueForKey:@"data"];
                     
                     [userDefaults setObject:[[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"firstName"] forKey:@"firstName"];
                     [userDefaults setObject:[[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"lastName"] forKey:@"lastName"];
                     [userDefaults setObject:[dictUserInfo valueForKey:@"member_id"] forKey:@"member_id"];
                     [userDefaults setObject:[dictUserInfo valueForKey:@"member_image"] forKey:@"member_image"];
                     
                     UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Sign Up" message:@"User registered sucessfully" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                     alert.tag = 101;
                     [alert show];
                 });
             }
             else if ([[dict valueForKey:@"response_code"] isEqualToString:@"RC0004"])
             {
                 [Utility showAlertMessage:@"Internal error" withTitle:@"Error"];
             }
             else if ([[dict valueForKey:@"response_code"] isEqualToString:@"RC0003"])
             {
                 [Utility showAlertMessage:@"Required feilds cannot be empty." withTitle:@"Error"];
             }
         }
         else
         {
             [Utility showAlertMessage:[error localizedDescription] withTitle:@"Sorry something went wrong."];
         }
     }];    
}

#pragma mark - Action Methods
- (IBAction)btnDone_Action:(id)sender
{
    if (self.txfPhone.text.length == 0 || [self.txfPhone.text isEqualToString:@""])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Phone number field cannot be empty" withTitle:@"Error"];
        return;
    }
    else if (self.txfBusinessEmail.text.length == 0 || [self.txfBusinessEmail.text isEqualToString:@""])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Business email field cannot be empty" withTitle:@"Error"];
        return;
    }
    else if (self.txfSkipeId.text.length == 0 || [self.txfSkipeId.text isEqualToString:@""])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Skipe email field cannot be empty" withTitle:@"Error"];
        return;
    }

    [[MySingleton sharedMySingleton].mDictUserDetail setObject:self.txfBusinessEmail.text forKey:@"emailAddress"];
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:self.txfPhone.text forKey:@"phoneNumbers"];
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:self.txfSkipeId.text forKey:@"skipeid"];

    [self callSignUpService];
}

- (IBAction)btnBack_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIAlertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 101)
    {
        FindPeopleVC *objFindPeople = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FindPeopleVC class])];
        [self.navigationController pushViewController:objFindPeople animated:YES];
    }
}

#pragma mark - UITextField Delegates
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField
{
    CGSize keyboardSize = CGSizeMake(deviceWidth, 260.0);
    CGPoint txtFieldOrigin = textField.frame.origin;
    
    CGFloat txtFieldHeight = textField.frame.size.height;
    CGRect visibleRect = self.view.frame;
    
    visibleRect.size.height -= keyboardSize.height + txtFieldHeight;
    
    CGPoint scrollPoint;
    
    if (!CGRectContainsPoint(visibleRect, txtFieldOrigin))
    {
        scrollPoint = CGPointMake(0.0, txtFieldOrigin.y - 185);
        float moveUp = scrollPoint.y;
        [[MySingleton sharedMySingleton] moveUp:moveUp view:self.view];
    }
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    [[MySingleton sharedMySingleton] moveDown:self.view];
    return YES;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end