//
//  ProfessionalInfoVC.m
//  Founderin
//
//  Created by Neuron on 12/1/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "ProfessionalInfoVC.h"
#import "LPPopupListView.h"
#import "NTMonthYearPicker.h"
#import "BusinessContactVC.h"

@interface ProfessionalInfoVC () <LPPopupListViewDelegate>

@property (weak, nonatomic) IBOutlet UIView         *viewRounded;

@property (weak, nonatomic) IBOutlet UITextField    *txfCompanyName;
@property (weak, nonatomic) IBOutlet UITextField    *txfTitle;

@property (weak, nonatomic) IBOutlet UIButton       *btnSince;
@property (weak, nonatomic) IBOutlet UIButton       *btnIndustry;

@property (strong, nonatomic) UIToolbar             *toolBarPickerHeader;

@property (strong, nonatomic) NSMutableArray        *mArrayIndustryList;

@property (strong, nonatomic) NSMutableIndexSet     *selectedIndexes;

@end

@implementation ProfessionalInfoVC

NTMonthYearPicker       *picker;
UIPopoverController     *popupCtrl;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(resignAllResponders)];
    [self.view addGestureRecognizer:gesture];
    
    self.mArrayIndustryList = [[NSMutableArray alloc] init];
    
    self.viewRounded.clipsToBounds = YES;
    
    [[MySingleton sharedMySingleton] setRoundedImage:self.viewRounded toDiameter:80.0];
    
    [self fillUserInfo];
}

// Add picker to view once it has appeared.
// We do not do this in viewDidLoad because at that time the view may not yet be part of a window, and UIPopoverController requires it to be.
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        // iPhone: show picker at the bottom of the screen
        if(![picker isDescendantOfView:self.view])
        {
            picker.frame = CGRectMake( 0, [[UIScreen mainScreen] bounds].size.height - pickerSize.height, pickerSize.width, pickerSize.height);
            picker.hidden = YES;
            [self.view addSubview:picker];
        }
    }
    else
    {
        // iPad: show picker in a popover
        if(!popupCtrl.isPopoverVisible)
        {
            UIView *container = [[UIView alloc] init];
            [container addSubview:picker];
            
            UIViewController* popupVC = [[UIViewController alloc] init];
            popupVC.view = container;
            
            popupCtrl = [[UIPopoverController alloc] initWithContentViewController:popupVC];
            [popupCtrl setPopoverContentSize:picker.frame.size animated:NO];
        }
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    
    [self resignAllResponders];
}

#pragma mark - Custom Methods
- (void)fillUserInfo
{
    if ([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"company"] != nil)
    {
        self.txfCompanyName.text = [[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"company"];
    }
    if ([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"title"] != nil)
    {
        self.txfTitle.text = [[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"title"];
    }
    if ([[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"industry"] != nil)
    {
        [self.btnIndustry setTitle:[[MySingleton sharedMySingleton].mDictUserDetail objectForKey:@"industry"] forState:UIControlStateNormal];
        [self.btnIndustry setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    }
}

- (void)showIndustryList
{
    float paddingTopBottom = 20.0f;
    float paddingLeftRight = 20.0f;
    
    self.view.userInteractionEnabled = NO;
    
    CGPoint point = CGPointMake(paddingLeftRight, (self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + paddingTopBottom);
    CGSize size = CGSizeMake((self.view.frame.size.width - (paddingLeftRight * 2)), self.view.frame.size.height - ((self.navigationController.navigationBar.frame.size.height + paddingTopBottom) + (paddingTopBottom * 2)));
    
    LPPopupListView *listView = [[LPPopupListView alloc] initWithTitle:@"Industry" list:_mArrayIndustryList selectedIndexes:self.selectedIndexes point:point size:size multipleSelection:NO];
    listView.delegate = self;
    
    [listView showInView:self.navigationController.view animated:YES];
}

- (void)resignAllResponders
{
    if ([self.txfCompanyName isFirstResponder])
        [self.txfCompanyName resignFirstResponder];
    if ([self.txfTitle isFirstResponder])
        [self.txfTitle resignFirstResponder];
}

#pragma mark - API Methods
- (void)callIndustrySelectionService
{
    if (![appDelegate isNetworkAvailable])
    {
        [Utility showNetWorkAlert];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@%@",BASE_URL, WEB_URL_GetIndustry];
    DLog(@"%s Performing :%@ Api",__FUNCTION__,urlString);
    
    [serviceManager executeServiceWithURL:urlString forTask:kTaskGetIndustry completionHandler:^(id response, NSError *error, TaskType task)
    {
        DLog(@"%s Performing :%@ Api \n Response : %@",__FUNCTION__,urlString,response);
        if (!error && response) {
            dispatch_async(dispatch_get_main_queue(), ^{
                self.mArrayIndustryList = [response valueForKey:@"data"];
                
                [self showIndustryList];
            });
        }
    }];
}

#pragma mark - Action Methods
- (IBAction)btnSince_Action:(id)sender
{
    // Initialize the picker
    picker = [[NTMonthYearPicker alloc] init];
    
    CGSize pickerSize = [picker sizeThatFits:CGSizeZero];

    picker.frame = CGRectMake( 0, [[UIScreen mainScreen] bounds].size.height - pickerSize.height, pickerSize.width, pickerSize.height );

    picker.hidden = NO;

    [picker addTarget:self action:@selector(onDatePicked:) forControlEvents:UIControlEventValueChanged];
    [picker setBackgroundColor:[UIColor whiteColor]];
    
    _toolBarPickerHeader = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height-260, 320, 44)];
    // pickerToolbar.barStyle = UIBarStyleDefault;
    [_toolBarPickerHeader setBackgroundColor:[UIColor whiteColor]];
    [_toolBarPickerHeader sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancel_Action:)];
    
    [cancel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    UILabel *lblSince = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, 120, 21)];
    lblSince.text = @"SINCE";
    lblSince.textAlignment = NSTextAlignmentCenter;
    lblSince.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(btnDone_Action:)];
    [done setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:App_Theme_Color, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [barItems addObject:cancel];
    [barItems addObject:flexSpace];
    [barItems addObject:done];
    
    [_toolBarPickerHeader setItems:barItems animated:YES];
    
    [_toolBarPickerHeader addSubview:lblSince];
    
    NSDateComponents *comps = [[NSDateComponents alloc] init];
    NSCalendar *cal = [NSCalendar currentCalendar];
    
    // Set mode to month + year
    // This is optional; default is month + year
    picker.datePickerMode = NTMonthYearPickerModeMonthAndYear;
    
    // Set minimum date to January 2000
    // This is optional; default is no min date
    [comps setDay:1];
    [comps setMonth:1];
    [comps setYear:2000];
    picker.minimumDate = [cal dateFromComponents:comps];
    
    // Set maximum date to next month
    // This is optional; default is no max date
    [comps setDay:0];
    [comps setMonth:1];
    [comps setYear:0];
    picker.maximumDate = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    // Set initial date to last month
    // This is optional; default is current month/year
    [comps setDay:0];
    [comps setMonth:-1];
    [comps setYear:0];
    picker.date = [cal dateByAddingComponents:comps toDate:[NSDate date] options:0];
    
    [self.view addSubview:_toolBarPickerHeader];
    [self.view addSubview:picker];
    
    [self.view bringSubviewToFront:picker];
    
    //[self setSelectedTime];
}

- (IBAction)btnCancel_Action:(id)sender
{
    [_toolBarPickerHeader removeFromSuperview];
    [picker removeFromSuperview];
}

- (IBAction)btnDone_Action:(id)sender
{
    [_toolBarPickerHeader removeFromSuperview];
    [picker removeFromSuperview];
}

- (IBAction)btnSelectIndustry_Action:(id)sender
{
    if (self.mArrayIndustryList.count == 0)
    {
        [self callIndustrySelectionService];
    }
    else
    {
        [self showIndustryList];
    }
}

- (IBAction)btnNext_Action:(id)sender
{
    if (self.txfCompanyName.text.length == 0 || [self.txfCompanyName.text isEqualToString:@""])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Company name field cannot be empty" withTitle:@"Error"];
        return;
    }
    else if (self.txfTitle.text.length == 0 || [self.txfTitle.text isEqualToString:@""])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Title field cannot be empty" withTitle:@"Error"];
        return;
    }
    else if ([self.btnSince.titleLabel.text isEqualToString:@""] || [self.btnSince.titleLabel.text isEqualToString:@"Select"])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"Since field cannot be empty" withTitle:@"Error"];
        return;
    }
    else if ([self.btnIndustry.titleLabel.text isEqualToString:@""] || [self.btnIndustry.titleLabel.text isEqualToString:@"Select"])
    {
        [[MySingleton sharedMySingleton] showAlertMessage:@"The Industry field cannot be empty" withTitle:@"Error"];
        return;
    }
    
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:self.txfCompanyName.text forKey:@"company"];
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:self.txfTitle.text forKey:@"title"];

    BusinessContactVC *objBusinessContact = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([BusinessContactVC class])];
    [self.navigationController pushViewController:objBusinessContact animated:YES];
}

- (IBAction)btnBack_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UIDatepicker Methods
- (void)onDatePicked:(UITapGestureRecognizer *)gestureRecognizer
{
    [self setSelectedTime];
}

- (void)setSelectedTime
{
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    
    if(picker.datePickerMode == NTMonthYearPickerModeMonthAndYear)
    {
        [df setDateFormat:@"MMMM yyyy"];
    }
    else
    {
        [df setDateFormat:@"yyyy"];
    }
    
    NSString *dateStr = [df stringFromDate:picker.date];
    
    [self.btnSince setTitle:dateStr forState:UIControlStateNormal];
    [self.btnSince setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [[MySingleton sharedMySingleton].mDictUserDetail setObject:dateStr forKey:@"start_date"];
}

#pragma mark - LPPopupListViewDelegate
- (void)popupListView:(LPPopupListView *)popUpListView didSelectIndex:(NSInteger)index
{
    NSInteger inde = -1;
    if (index == inde)
    {
        self.view.userInteractionEnabled = YES;
    }
    else
    {
        [self.btnIndustry setTitle:[[_mArrayIndustryList objectAtIndex:index] valueForKey:@"mi_name"] forState:UIControlStateNormal];
        [self.btnIndustry setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
        [[MySingleton sharedMySingleton].mDictUserDetail setObject:[[_mArrayIndustryList objectAtIndex:index] valueForKey:@"mi_name"] forKey:@"industry"];
        [[MySingleton sharedMySingleton].mDictUserDetail setObject:[[_mArrayIndustryList objectAtIndex:index] valueForKey:@"mi_id"] forKey:@"industryId"];
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