//
//  SignUpVC.m
//  Founderin
//
//  Created by Neuron on 11/22/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "SignUpVC.h"
#import "PersonalInfoVC.h"

@interface SignUpVC ()

@property (weak, nonatomic) IBOutlet UITextField *txfEmail;
@property (weak, nonatomic) IBOutlet UITextField *txfPassword;
@property (weak, nonatomic) IBOutlet UITextField *txfFirstName;
@property (weak, nonatomic) IBOutlet UITextField *txfLastName;

@end

@implementation SignUpVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    [self.view addGestureRecognizer:gesture];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self resignAllResponders];
}

#pragma mark - Custom Method
- (void)resignAllResponders
{
    if ([self.txfFirstName isFirstResponder])
        [self.txfFirstName resignFirstResponder];
    if ([self.txfLastName isFirstResponder])
        [self.txfLastName resignFirstResponder];
    if ([self.txfEmail isFirstResponder])
        [self.txfEmail resignFirstResponder];
    if ([self.txfPassword isFirstResponder])
        [self.txfPassword resignFirstResponder];
}

#pragma mark - Action Methods
- (IBAction)btnNext_Action:(id)sender
{
    if (self.txfFirstName.text.length == 0 || [self.txfFirstName.text isEqualToString:@""])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The First name field cannot be empty" withTitle:@"Error"];
        return;
    }
    else if (self.txfLastName.text.length == 0 || [self.txfLastName.text isEqualToString:@""])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Last name field cannot be empty" withTitle:@"Error"];
        return;
    }
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
    
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:self.txfFirstName.text forKey:@"firstName"];
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:self.txfLastName.text forKey:@"lastName"];
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:self.txfEmail.text forKey:@"emailAddress"];
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:self.txfPassword.text forKey:@"password"];

    PersonalInfoVC *objPersonalInfo = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([PersonalInfoVC class])];
    [self.navigationController pushViewController:objPersonalInfo animated:YES];
}

- (IBAction)btnBack_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
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