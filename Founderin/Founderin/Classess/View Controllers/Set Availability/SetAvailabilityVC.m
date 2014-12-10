//
//  SetAvailabilityVC.m
//  Founderin
//
//  Created by Neuron on 12/9/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "SetAvailabilityVC.h"
#import "SearchFilterCell.h"

@interface SetAvailabilityVC () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, weak) IBOutlet UIPickerView   *picker;
@property (strong, nonatomic) UIToolbar             *toolBarPickerHeader;

@property (strong, nonatomic) NSMutableArray *arrHour, *arrMinute, *arrAmpm;
@property (strong, nonatomic) UILabel *lblSelected;

@end

@implementation SetAvailabilityVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrHour     = [[NSMutableArray alloc] initWithObjects:@"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"11", @"12", nil];
    self.arrMinute   = [[NSMutableArray alloc] initWithObjects:@"00", @"15", @"30", @"45", nil];
    self.arrAmpm     = [[NSMutableArray alloc] initWithObjects:@"AM", @"PM", nil];
}

#pragma mark - Action Methods
- (IBAction)btnCancel_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnDone_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)btnStartTime_Action:(id)sender
{
    self.picker.hidden = NO;
    
    _toolBarPickerHeader = [[UIToolbar alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 206, 320, 44)];
    [_toolBarPickerHeader setBackgroundColor:[UIColor whiteColor]];
    [_toolBarPickerHeader sizeToFit];
    NSMutableArray *barItems = [[NSMutableArray alloc] init];
    
    UIBarButtonItem *cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(btnCancelPicker_Action:)];
    
    [cancel setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor blackColor], NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    UILabel *lblSince = [[UILabel alloc] initWithFrame:CGRectMake(100, 12, 120, 21)];
    lblSince.text = @"START";
    lblSince.textAlignment = NSTextAlignmentCenter;
    lblSince.font = [UIFont fontWithName:@"Helvetica Neue" size:10.0];
    
    UIBarButtonItem *flexSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStylePlain target:self action:@selector(btnDonePicker_Action:)];
    [done setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:App_Theme_Color, NSForegroundColorAttributeName, nil] forState:UIControlStateNormal];
    
    [barItems addObject:cancel];
    [barItems addObject:flexSpace];
    [barItems addObject:done];
    
    [_toolBarPickerHeader setItems:barItems animated:YES];
    
    [_toolBarPickerHeader addSubview:lblSince];
    
    [self.view addSubview:_toolBarPickerHeader];
}

- (IBAction)btnCancelPicker_Action:(id)sender
{
    [_toolBarPickerHeader removeFromSuperview];
    self.picker.hidden = YES;
}

- (IBAction)btnDonePicker_Action:(id)sender
{
    [_toolBarPickerHeader removeFromSuperview];
    self.picker.hidden = YES;
}

#pragma mark - UIPickerview Datasource & Delegate
// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.arrHour.count;
    }
    else if (component == 1)
    {
        return self.arrMinute.count;
    }
    else
    {
        return self.arrAmpm.count;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        return self.arrHour[row];
    }
    else if (component == 1)
    {
        return self.arrMinute[row];
    }
    else
    {
        return self.arrAmpm[row];
    }
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    self.lblSelected = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, 40, 25)];
    self.lblSelected.backgroundColor = [UIColor clearColor];
    self.lblSelected.textColor = [UIColor blackColor];
    self.lblSelected.textAlignment = NSTextAlignmentCenter;
    self.lblSelected.font = [UIFont fontWithName:@"Helvetica Neue" size:20];
    
    NSString *strValue;
    
    if (component == 0)
    {
        strValue = [self.arrHour objectAtIndex:row];
        self.lblSelected.text = [NSString stringWithFormat:@"%@", strValue];
    }
    if (component == 1)
    {
        strValue = [self.arrMinute objectAtIndex:row];
        self.lblSelected.text = [NSString stringWithFormat:@"%@", strValue];
    }
    if (component == 2)
    {
        strValue = [self.arrAmpm objectAtIndex:row];
        self.lblSelected.text = [NSString stringWithFormat:@"%@", strValue];
    }
    
    return self.lblSelected;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{

}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end