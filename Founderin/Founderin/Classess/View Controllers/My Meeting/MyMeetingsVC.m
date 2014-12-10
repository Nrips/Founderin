//
//  MyMeetingsVC.m
//  Founderin
//
//  Created by Neuron on 12/3/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "MyMeetingsVC.h"
#import "SlideMenuVC.h"
#import "MeetingStatusCell.h"
#import "MeetingAvailabilityCell.h"
#import "SetAvailabilityVC.h"

@interface MyMeetingsVC ()

@property (weak, nonatomic) IBOutlet UIView         *viewMain;
@property (weak, nonatomic) IBOutlet UIView         *viewSideMenu;

@property (weak, nonatomic) IBOutlet UITableView    *tblViewMyMeetings;

@property (weak, nonatomic) IBOutlet UIImageView    *imgViewHeader;

@property (weak, nonatomic) IBOutlet UIButton       *btnSideMenu;
@property (weak, nonatomic) IBOutlet UIButton       *btnMeetings;
@property (weak, nonatomic) IBOutlet UIButton       *btnInvites;

@property (strong, nonatomic) NSMutableArray        *arrConfirmedMeetings;
@property (strong, nonatomic) NSMutableArray        *arrYourAvailability;

@end

@implementation MyMeetingsVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.arrConfirmedMeetings = [[NSMutableArray alloc] init];
    self.arrYourAvailability = [[NSMutableArray alloc] init];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self addSlideView];
}

#pragma mark - Custom Methods
- (void)addSlideView
{
    SlideMenuVC *nonSystemsController = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SlideMenuVC class])];
    
    nonSystemsController.view.frame = self.viewSideMenu.bounds;
    [self.viewSideMenu addSubview:nonSystemsController.view];
    [nonSystemsController didMoveToParentViewController:self];
    [self addChildViewController:nonSystemsController];
}

#pragma mark - Action Methods
- (IBAction)btnSlideMenu_Action:(UIButton *)sender
{
    if (sender.tag == 0)
    {
        //--->    Show Menu View
        self.btnSideMenu.tag = 1;
        [UIView animateWithDuration:0.5 animations:^(void){
            [self.viewMain setFrame:CGRectMake(270, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height + 20)];
        }];
    }
    else
    {
        //--->    Hide Menu View
        self.btnSideMenu.tag = 0;
        [UIView animateWithDuration:0.5 animations:^(void){
            [self.viewMain setFrame:CGRectMake(0, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height + 20)];
        }];
    }
}

- (IBAction)btnMeetings_Action:(id)sender
{
    self.imgViewHeader.image     = [UIImage imageNamed:@"tabbar_meetings"];
    
    if (self.btnMeetings.selected)
    {
        self.btnMeetings.selected    = !self.btnMeetings.selected;
    }
    self.btnInvites.selected = NO;
}

- (IBAction)btnInvites_Action:(id)sender
{
    self.imgViewHeader.image     = [UIImage imageNamed:@"tabbar_invites"];

    if (!self.btnInvites.selected)
    {
        self.btnInvites.selected    = !self.btnInvites.selected;
    }
    self.btnMeetings.selected = YES;
}

- (IBAction)btnSetAvailability_Action:(id)sender
{
    SetAvailabilityVC *objSetAvailability = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SetAvailabilityVC class])];
    [self.navigationController pushViewController:objSetAvailability animated:NO];
}

#pragma mark - UITableview DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //*>    Initialize header view object
    
    UIView *viewHeader                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 25)];
    [viewHeader setBackgroundColor:[UIColor colorWithRed:122.0/255.0 green:192.0/255.0 blue:199.0/255.0 alpha:1.0]];
    
    UILabel *lblSectionTitle            = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 280, 15)];
    lblSectionTitle.backgroundColor     = [UIColor clearColor];
    lblSectionTitle.textColor           = [UIColor blackColor];;
    lblSectionTitle.font                = [UIFont fontWithName:@"Helvetica Neue" size:11.0];
    
    if (section == 0)
    {
        lblSectionTitle.text            = @"CONFIRMED MEETINGS";
    }
    else if (section == 1)
    {
        lblSectionTitle.text            = @"AVAILAVLE FOR MEETINGS";
    }
    
    [viewHeader addSubview:lblSectionTitle];
    
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        if (self.arrConfirmedMeetings.count == 0)
        {
            return 1;
        }
        else
        {
            return [self.arrConfirmedMeetings count] + 1;
        }
    }
    else
    {
        if (self.arrYourAvailability.count == 0)
        {
            return 1;
        }
        else
        {
            return [self.arrYourAvailability count] + 1;
        }
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        static NSString *simpleTableIdentifier = @"MeetingStatusCell";
        MeetingStatusCell *cell = (MeetingStatusCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[MeetingStatusCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier] ;
        }

        if (self.arrConfirmedMeetings.count == 0)
        {
            cell.lblNoMeetings.text = @"You have no upcoming meetings, go and find people or set your specific availability so others can find you.";
        }
        else
        {
            
        }
        return cell;
    }
    else
    {
        static NSString *simpleTableIdentifier = @"MeetingAvailabilityCell";
        MeetingAvailabilityCell *cell = (MeetingAvailabilityCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
        if (cell == nil)
        {
            cell = [[MeetingAvailabilityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier] ;
        }

        if (self.arrYourAvailability.count == 0)
        {
            cell.lblAvalability.hidden = NO;
            cell.lblDay.hidden = YES;
            cell.lblTimeDetail.hidden = YES;

            cell.lblAvalability.text = @"Set Your Availability";
            [cell.btnAvaalibility setBackgroundImage:[UIImage imageNamed:@"plus.png"] forState:UIControlStateNormal];
            
            cell.btnAvaalibility.tag = indexPath.row;
            [cell.btnAvaalibility addTarget:self action:@selector(btnSetAvailability_Action:) forControlEvents:UIControlEventTouchUpInside];
        }
        else
        {
            cell.lblAvalability.hidden = YES;
            cell.lblDay.hidden = NO;
            cell.lblTimeDetail.hidden = NO;
            
            cell.lblDay.text = @"Today";
            cell.lblTimeDetail.text = @"Today";
            
            [cell.btnAvaalibility setBackgroundImage:[UIImage imageNamed:@"user_gray.png"] forState:UIControlStateNormal];
            cell.btnAvaalibility.tag = indexPath.row;
            [cell.btnAvaalibility addTarget:self action:@selector(btnSetAvailability_Action:) forControlEvents:UIControlEventTouchUpInside];
        }
        return cell;
    }
    return nil;
}

#pragma mark - UITableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end