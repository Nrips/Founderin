//
//  PersonalInfoVC.m
//  Founderin
//
//  Created by Neuron on 12/1/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "PersonalInfoVC.h"

#import "SelectLocationVC.h"
#import "ProfessionalInfoVC.h"

@interface PersonalInfoVC () <SelectLocationVCDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,UIImagePickerControllerDelegate>
{
    UIImagePickerController *imagePickerController;
}

@property (weak, nonatomic) IBOutlet UITextField    *txfFirstName;
@property (weak, nonatomic) IBOutlet UITextField    *txfLastName;

@property (weak, nonatomic) IBOutlet UIImageView    *imgViewUser;
@property (weak, nonatomic) IBOutlet UIButton       *btnSelecteLocation;

@end

@implementation PersonalInfoVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.btnSelecteLocation.titleLabel.numberOfLines = 0;
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    [self.view addGestureRecognizer:gesture];
    
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
    if ([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"firstName"] != nil)
    {
        self.txfFirstName.text = [[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"firstName"];
    }
    if ([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"lastName"] != nil)
    {
        self.txfLastName.text = [[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"lastName"];
    }
    if ([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"pictureUrl"] != nil)
    {
        NSString *strImageUrl = [[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"pictureUrl"];
        
        NSURL *imageUrl = [NSURL URLWithString:strImageUrl];
        
        self.imgViewUser.clipsToBounds = YES;
        
        [[MySingleton sharedMySingleton] setRoundedImage:self.imgViewUser toDiameter:80.0];
        
        if (imageUrl)
        {
            __block UIActivityIndicatorView *activityIndicator;
            [self.imgViewUser sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 if (!activityIndicator)
                 {
                     [self.imgViewUser addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                     activityIndicator.center = self.imgViewUser.center;
                     [activityIndicator startAnimating];
                 }
             }
             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 self.imgViewUser.image = image;
                 
                 [MySingleton sharedMySingleton].imageUser = image;
                 
                 [activityIndicator removeFromSuperview];
                 activityIndicator = nil;
             }];
        }
    }
}

- (void)takeFromLibrary
{
    imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self;
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)takeFromCamera
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW,  0ul);
    dispatch_async(queue, ^{
        @autoreleasepool
        {
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
                {
                    imagePickerController= [[UIImagePickerController alloc]init];
                    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
                    imagePickerController.showsCameraControls = YES;
                    imagePickerController.delegate = self;
                    [self presentViewController:imagePickerController animated:YES completion:nil];
                }
            });
        }
    });
}

- (void)resignAllResponders
{
    if ([self.txfFirstName isFirstResponder])
        [self.txfFirstName resignFirstResponder];
    if ([self.txfLastName isFirstResponder])
        [self.txfLastName resignFirstResponder];
}

#pragma mark - Action Methods
- (IBAction)btnSelectLocation_Action:(id)sender
{
    SelectLocationVC *selectLocation = [self.storyboard instantiateViewControllerWithIdentifier:@"SelectLocationVC"];
    [selectLocation setDelegate:self];
    [self.navigationController pushViewController:selectLocation animated:YES];
}

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
    else if ([self.btnSelecteLocation.titleLabel.text isEqualToString:@""] || [self.btnSelecteLocation.titleLabel.text isEqualToString:@"Select"])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Location field cannot be empty" withTitle:@"Error"];
        return;
    }
    else if (self.imgViewUser.image == nil)
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"Image field cannot be empty" withTitle:@"Error"];
        return;
    }
    
    ProfessionalInfoVC *objProfessionalInfo = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([ProfessionalInfoVC class])];
    [self.navigationController pushViewController:objProfessionalInfo animated:YES];
}

- (IBAction)btnSelectImage_Action:(id)sender
{
    [[[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Photo library", @"Camera", nil] showInView:self.view];
}

#pragma mark - UIAction sheet Deledate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            [self takeFromLibrary]; break;
        case 1:
            [self takeFromCamera];break;
    }
}

#pragma mark - UIImagePickerController Delegate Methods
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo
{
    self.imgViewUser.clipsToBounds = YES;
    
    [[MySingleton sharedMySingleton] setRoundedImage:self.imgViewUser toDiameter:80.0];

    [picker dismissViewControllerAnimated:YES completion:nil];
    self.imgViewUser.image = image;
    
    [MySingleton sharedMySingleton].imageUser = image;

    imagePickerController = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    imagePickerController = nil;
}

#pragma mark - custom delegates
- (void)didSelectLocation:(NSString *)location
{
    [self.btnSelecteLocation setTitle:location forState:UIControlStateNormal];
    [self.btnSelecteLocation setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    if (![self.btnSelecteLocation.titleLabel.text isEqualToString:@""] || [self.btnSelecteLocation.titleLabel.text isEqualToString:@"Select"])
    {
        [[MySingleton sharedMySingleton].mDictUserDetail setObject:location forKey:@"location"];
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
        scrollPoint = CGPointMake(0.0, txtFieldOrigin.y - 215);
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