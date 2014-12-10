//
//  LoginVC.m
//  Founderin
//
//  Created by Neuron on 11/22/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "LoginVC.h"

#import "OAuthLoginView.h"
#import "PersonalInfoVC.h"
#import "SignUpVC.h"
#import "FindPeopleVC.h"

@interface LoginVC () <FBLoginViewDelegate, MBProgressHUDDelegate>
{
    BOOL isConnectFacebook;
}

@property (nonatomic, strong) OAuthLoginView            *oAuthLoginView;

@property (nonatomic, strong) IBOutlet FBLoginView      *loginView;

@property (weak, nonatomic) IBOutlet UITextField        *txfEmail;
@property (weak, nonatomic) IBOutlet UITextField        *txfPassword;

@end

@implementation LoginVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //---> Do any additional setup after loading the view, typically from a nib.
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self resignAllResponders];
}

#pragma mark - Custom Methods
- (void)resignAllResponders
{
    if ([self.txfEmail isFirstResponder])
        [self.txfEmail resignFirstResponder];
    if ([self.txfPassword isFirstResponder])
        [self.txfPassword resignFirstResponder];
}

#pragma mark - API Methods
- (void)checkSocialUserExistence
{
    NSDictionary *postParams;
    
    if ([[[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"UserType"] isEqualToString:@"linkedin"])
    {
        postParams = @{     @"m_linkedin_id"         : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail
                                                                      objectForKey:@"id"]),
                            @"u_email"               : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"emailAddress"]),
                      };
    }
    else
    {
        postParams = @{     @"m_fb_id"               : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail
                                                                      objectForKey:@"id"]),
                            @"u_email"               : ObjectOrBlank([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"emailAddress"]),
                      };
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, WEB_URL_CheckSocialMember_Exist];
    
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
                     
                     [userDefaults setObject:[dictUserInfo valueForKey:@"member_id"] forKey:@"member_id"];
                     [userDefaults setObject:[dictUserInfo valueForKey:@"member_image"] forKey:@"member_image"];
                     
                     BOOL isUserExist = [[response valueForKey:@"is_already_register"] intValue];
                     
                     if (isUserExist)
                     {
                         FindPeopleVC *objFindPeople = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FindPeopleVC class])];
                         [self.navigationController pushViewController:objFindPeople animated:YES];
                     }
                     else
                     {
                         PersonalInfoVC *objPersonalInfo = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PersonalInfoVC class])];
                         [self.navigationController pushViewController:objPersonalInfo animated:YES];
                     }
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
- (IBAction)btnSignIn_Action:(id)sender
{
    if ([self.txfEmail.text length] > 0)
    {
        if (![[MySingleton sharedMySingleton] emailValidation:self.txfEmail.text])
        {
            [[MySingleton sharedMySingleton] showAlertMessage:@"Please enter Valid Email id" withTitle:@"Error"];
            return;
        }
    }
    else
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Email field cannot be empty" withTitle:@"Error"];
        return;
    }
    if (self.txfPassword.text.length == 0 || [self.txfPassword.text isEqualToString:@""])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Password field cannot be empty" withTitle:@"Error"];
        return;
    }
    
    [self resignAllResponders];
    
    NSDictionary *postParams = @{     @"u_email"                : ObjectOrBlank(self.txfEmail.text),
                                      @"u_password"             : ObjectOrBlank(self.txfPassword.text),
                                      @"device_id"              : ObjectOrBlank(@"3a76f63450168f9abd76cb1c173ebe21cc80043be30a962d076c98f4ca06b814"),
                                      @"certification_type"     : ObjectOrBlank(@"develpoment"),
                                };
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, WEB_URL_Login];
    
    [serviceManager executeServiceWithURL:urlString andParameters:postParams forTask:kTaskSignUp completionHandler:^(id response, NSError *error, TaskType task)
     {
         if (!error && response)
         {
             NSDictionary *dict = [[NSDictionary alloc]init];
             dict = (NSDictionary *)response;
             if ([[dict valueForKey:@"message"] isEqualToString:@"Login Successfull"])
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                         NSDictionary *dictUserInfo = [response valueForKey:@"data"];
                     
                        [userDefaults setObject:[dictUserInfo valueForKey:@"member_id"] forKey:@"member_id"];
                        [userDefaults setObject:[dictUserInfo valueForKey:@"member_image"] forKey:@"member_image"];
                        [userDefaults setObject:[dictUserInfo valueForKey:@"login_name"] forKey:@"login_name"];
                     
                        FindPeopleVC *objFindPeople = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FindPeopleVC class])];
                        [self.navigationController pushViewController:objFindPeople animated:YES];
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

- (IBAction)btnFacebook_Action:(id)sender
{
    //---> If the session state is any of the two "open" states when the button is clicked
    if (FBSession.activeSession.state == FBSessionStateOpen || FBSession.activeSession.state == FBSessionStateOpenTokenExtended)
    {
        //---> Close the session and remove the access token from the cache
        //---> The session state handler (in the app delegate) will be called automatically
        [FBSession.activeSession closeAndClearTokenInformation];
        
        //---> If the session state is not any of the two "open" states when the button is clicked
    }
    else
    {
        MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.labelText = @"Facebook Logging...";
        hud.color = App_Theme_Color;
        hud.dimBackground = YES;
        
        //---> Open a session showing the user the login UI
        //---> You must ALWAYS ask for public_profile permissions when opening a session
        [FBSession openActiveSessionWithReadPermissions:@[@"public_profile", @"email", @"user_friends"] allowLoginUI:YES completionHandler:
         ^(FBSession *session, FBSessionState state, NSError *error)
        {
             isConnectFacebook = YES;
            
             //---> Call the app delegate's sessionStateChanged:state:error method to handle session state changes
             [appDelegate sessionStateChanged:session state:state error:error];
             [MBProgressHUD hideHUDForView:self.view animated:YES];
        }];
    }
}

- (IBAction)btnLinkedin_Action:(id)sender
{
    _oAuthLoginView = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([OAuthLoginView class])];
    
    // register to be told when the login is finished
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(loginViewDidFinish:) name:@"loginViewDidFinish" object:_oAuthLoginView];
    
    [self presentViewController:_oAuthLoginView animated:YES completion:nil];
}

- (IBAction)btnCreateAccount_Action:(id)sender
{
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:@"simple" forKey:@"UserType"];

    SignUpVC *objSignUp = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SignUpVC class])];
    [self.navigationController pushViewController:objSignUp animated:YES];
}

#pragma mark - Linkedin Methods
-(void) loginViewDidFinish:(NSNotification*)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self profileApiCall];
}

- (void)profileApiCall
{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = @"Linkedin Logging...";
    hud.color = App_Theme_Color;
    hud.dimBackground = YES;
    
    NSString *urlString = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(id,first-name,last-name,email-address,headline,industry,summary,positions,picture-url,skills,languages,educations,phone-numbers,main-address,api-standard-profile-request)"];
    
    NSURL *url = [NSURL URLWithString:urlString];
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:_oAuthLoginView.consumer token:_oAuthLoginView.accessToken callback:nil signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(profileApiCallResult:didFinish:) didFailSelector:@selector(profileApiCallResult:didFail:)];
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *profile = [responseBody objectFromJSONString];
    
    if (profile)
    {
        NSLog(@"%@", profile);
        
        if ([profile objectForKey:@"firstName"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[profile objectForKey:@"firstName"] forKey:@"firstName"];
        }
        if ([profile objectForKey:@"lastName"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[profile objectForKey:@"lastName"] forKey:@"lastName"];
        }
        if ([profile objectForKey:@"id"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[profile objectForKey:@"id"] forKey:@"id"];
        }
        if ([profile objectForKey:@"headline"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[profile objectForKey:@"headline"] forKey:@"headline"];
        }
        if ([profile objectForKey:@"pictureUrl"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[profile objectForKey:@"pictureUrl"] forKey:@"pictureUrl"];
        }
        if ([[[[profile objectForKey:@"phoneNumbers"] objectForKey:@"values"] objectAtIndex:0] valueForKey:@"phoneNumber"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[[[[profile objectForKey:@"phoneNumbers"] objectForKey:@"values"] objectAtIndex:0] valueForKey:@"phoneNumber"] forKey:@"phoneNumbers"];
        }
        if ([profile objectForKey:@"industry"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[profile objectForKey:@"industry"] forKey:@"industry"];
        }
        if ([profile objectForKeyedSubscript:@"emailAddress"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[profile objectForKey:@"emailAddress"] forKey:@"emailAddress"];
        }
        
        NSArray *companyArray = [[[[profile objectForKey:@"positions"] objectForKey:@"values"]valueForKey:@"company"]valueForKey:@"name"];

        if (companyArray != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[NSString stringWithFormat:@"%@",[companyArray componentsJoinedByString:@""]] forKey:@"company"];
        }

        NSArray *designationArray = [[[profile objectForKey:@"positions"] objectForKey:@"values"]valueForKey:@"title"];
        
        if (designationArray != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[NSString stringWithFormat:@"%@",[designationArray componentsJoinedByString:@""]] forKey:@"title"];
        }
    }
    // The next thing we want to do is call the network updates
    [self networkApiCall];
}

- (void)profileApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@", [error description]);
}

- (void)networkApiCall
{
    NSURL *url = [NSURL URLWithString:@"http://api.linkedin.com/v1/people/~/network/updates?scope=self&count=1&type=STAT"];
    
    OAMutableURLRequest *request = [[OAMutableURLRequest alloc] initWithURL:url consumer:_oAuthLoginView.consumer token:_oAuthLoginView.accessToken callback:nil signatureProvider:nil];
    
    [request setValue:@"json" forHTTPHeaderField:@"x-li-format"];
    
    OADataFetcher *fetcher = [[OADataFetcher alloc] init];
    [fetcher fetchDataWithRequest:request delegate:self didFinishSelector:@selector(networkApiCallResult:didFinish:) didFailSelector:@selector(networkApiCallResult:didFail:)];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFinish:(NSData *)data
{
    NSString *responseBody = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSDictionary *person = [[[[[responseBody objectFromJSONString] objectForKey:@"values"] objectAtIndex:0] objectForKey:@"updateContent"] objectForKey:@"person"];
    NSLog(@"%@", person);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
    
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:@"linkedin" forKey:@"UserType"];
    
    [self checkSocialUserExistence];
}

- (void)networkApiCallResult:(OAServiceTicket *)ticket didFail:(NSData *)error
{
    NSLog(@"%@", [error description]);
}

#pragma mark - Facebook Delegate
- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView user:(id<FBGraphUser>)user
{
    if (isConnectFacebook == YES)
    {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
         
        if ([user objectForKey:@"email"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[user objectForKey:@"email"] forKey:@"emailAddress"];
        }
        if ([user objectForKey:@"first_name"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[user objectForKey:@"first_name"] forKey:@"firstName"];
        }
        if ([user objectForKey:@"last_name"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[user objectForKey:@"last_name"] forKey:@"lastName"];
        }
        if ([user objectForKey:@"id"] != nil)
        {
            [[MySingleton sharedMySingleton].mDictUserDetail setObject:[user objectForKey:@"id"] forKey:@"id"];
        }
        [[MySingleton sharedMySingleton].mDictUserDetail setObject:@"facebook" forKey:@"UserType"];
        
        PersonalInfoVC *objPersonalInfo = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PersonalInfoVC class])];
        [self.navigationController pushViewController:objPersonalInfo animated:YES];
    }
}

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{

}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error
{
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    NSString *alertMessage, *alertTitle;
    
    if ([FBErrorUtility shouldNotifyUserForError:error])
    {
        alertTitle = @"Facebook error";
        alertMessage = [FBErrorUtility userMessageForError:error];
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession)
    {
        alertTitle = @"Session Error";
        alertMessage = @"Your current session is no longer valid. Please log in again.";
    }
    else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled)
    {
        NSLog(@"user cancelled login");
    }
    else
    {
        alertTitle  = @"Something went wrong";
        alertMessage = @"Please try again later.";
        NSLog(@"Unexpected error:%@", error);
    }
    
    if (alertMessage)
    {
        [[[UIAlertView alloc] initWithTitle:alertTitle message:alertMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
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