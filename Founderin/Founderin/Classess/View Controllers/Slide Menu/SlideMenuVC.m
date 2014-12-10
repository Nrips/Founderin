//
//  SlideMenuVC.m
//  Founderin
//
//  Created by Neuron on 12/2/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "SlideMenuVC.h"

#import "SlideMenuCell.h"
#import "MyMeetingsVC.h"
#import "FindPeopleVC.h"
#import "LetsMeetNowVC.h"

@interface SlideMenuVC () <UITableViewDelegate, UITableViewDataSource>

@property (strong, nonatomic) NSArray                   *arrMenuViewTitles;
@property (strong, nonatomic) NSArray                   *arrMenuViewImages;

@end

@implementation SlideMenuVC

@synthesize tblMenu;

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //--->    Intialize menu title array
    self.arrMenuViewTitles          = [[NSArray alloc] initWithObjects:@"Chat",@"Friends", @"Notification", @"My Meetings", @"Let's Meet Now", @"Find People", @"Calendar", @"Contacts", @"Logout", nil];
    
    //--->    Intialize menu icon array with images
    self.arrMenuViewImages          = [[NSArray alloc] initWithObjects:@"chat.png", @"user.png", @"notification.png", @"meetings.png", @"meet_now.png", @"find_people.png", @"calendar.png", @"contacts.png", @"logout.png", nil];
}

#pragma mark - API Methods
- (void)callLogoutService
{
    if (![appDelegate isNetworkAvailable])
    {
        [Utility showNetWorkAlert];
        return;
    }
    
    NSDictionary *postParams = @{       @"member_id" : ObjectOrBlank([userDefaults valueForKey:@"member_id"]),
                                        @"device_id" : ObjectOrBlank(@"3a76f63450168f9abd76cb1c173ebe21cc80043be30a962d076c98f4ca06b814"),
                                        @"certification_type" : ObjectOrBlank(@"develpoment"),
                                };
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, WEB_URL_Logout];
    
    [serviceManager executeServiceWithURL:urlString andParameters:postParams forTask:kTaskFindPeople completionHandler:^(id response, NSError *error, TaskType task)
     {
         if (!error && response)
         {
             NSDictionary *dict = [[NSDictionary alloc]init];
             dict = (NSDictionary *)response;
             if ([[response valueForKey:@"response_code"] isEqualToString:@"RC0000"])
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     [userDefaults removeObjectForKey:@"member_id"];
                     [userDefaults removeObjectForKey:@"member_image"];
                     [userDefaults removeObjectForKey:@"login_name"];
                     [self.navigationController popToRootViewControllerAnimated:YES];
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

#pragma mark - UITableview DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //*>    Initialize header view object
    UIView *viewHeader              = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 140)];
    viewHeader.backgroundColor      = White_Color;
    
    UIImageView *imgViewUser        = [[UIImageView alloc] initWithFrame:CGRectMake(97, 5, 85, 85)];
    imgViewUser.clipsToBounds       = YES;
    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"member_image"]];
    
    if (strImageUrl != nil)
    {
        NSURL *imageUrl = [NSURL URLWithString:strImageUrl];
        
        [[MySingleton sharedMySingleton] setRoundedImage:imgViewUser toDiameter:85.0];
        
        if (imageUrl)
        {
            __block UIActivityIndicatorView *activityIndicator;
            [imgViewUser sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize)
             {
                 if (!activityIndicator)
                 {
                     [imgViewUser addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                     activityIndicator.center = imgViewUser.center;
                     [activityIndicator startAnimating];
                 }
             }
             completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 imgViewUser.image  = image;
                 
                 [activityIndicator removeFromSuperview];
                 activityIndicator  = nil;
             }];
        }
    }
    
    UILabel *lblUserName            = [[UILabel alloc] initWithFrame:CGRectMake(20, 105, 230, 23)];
    lblUserName.backgroundColor     = [UIColor clearColor];
    lblUserName.textColor           = [UIColor darkGrayColor];
    lblUserName.textAlignment       = NSTextAlignmentCenter;
    lblUserName.font                = [UIFont fontWithName:@"Helvetica Neue" size:19.0];
    lblUserName.text                = [NSString stringWithFormat:@"%@", [userDefaults objectForKey:@"login_name"]];
    
    UIImageView *imgViewSeparater   = [[UIImageView alloc] initWithFrame:CGRectMake(0, 139, tableView.frame.size.width, 1)];
    imgViewSeparater.image          = [UIImage imageNamed:@"separater_Strip.png"];
    
    [viewHeader addSubview:imgViewUser];
    [viewHeader addSubview:lblUserName];
    [viewHeader addSubview:imgViewSeparater];
    
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 140;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrMenuViewTitles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SlideMenuCell";
    SlideMenuCell *cell = (SlideMenuCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[SlideMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier] ;
    }
    
    cell.lblMenuTitle.text = [NSString stringWithFormat:@"%@", [self.arrMenuViewTitles objectAtIndex:indexPath.row]];
    cell.imgViewMenuIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", [self.arrMenuViewImages objectAtIndex:indexPath.row]]];
    
    return cell;
}

#pragma mark - UITableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 3)
    {
        MyMeetingsVC *objMyMeetings = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([MyMeetingsVC class])];
        [self.navigationController pushViewController:objMyMeetings animated:YES];
    }
    else if (indexPath.row == 4)
    {
        LetsMeetNowVC *objLetsMeetNow = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([LetsMeetNowVC class])];
        [self.navigationController pushViewController:objLetsMeetNow animated:YES];
    }
    else if (indexPath.row == 5)
    {
        FindPeopleVC *objFindPeople = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([FindPeopleVC class])];
        [self.navigationController pushViewController:objFindPeople animated:YES];
    }
    else if (indexPath.row == 8)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Logout" message:@"Are you sure want to Logout?" delegate:self cancelButtonTitle:@"NO" otherButtonTitles:@"YES" , nil];
        alert.tag = 101;
        [alert show];
    }
}

#pragma mark - UIAlertview Delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 101)
    {
        if(buttonIndex == 1)
        {
            [self callLogoutService];
        }
    }
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end