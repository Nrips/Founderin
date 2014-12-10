//
//  FindPeopleVC.m
//  Founderin
//
//  Created by Neuron on 11/22/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "FindPeopleVC.h"
#import "FindPeopleCell.h"
#import "SlideMenuVC.h"
#import "SearchFilterCell.h"
#import "SelectVenueVC.h"

@interface FindPeopleVC () <UITableViewDelegate, UITableViewDataSource, SelectVenueVCDelegate>
{
    NSIndexPath *selectedIndexPath;
    
    NSString    *strSelectedVenue;
}

@property (weak, nonatomic) IBOutlet UIView             *viewMain;
@property (weak, nonatomic) IBOutlet UIView             *viewSideMenu;
@property (weak, nonatomic) IBOutlet UIView             *viewSearchFilter;

@property (weak, nonatomic) IBOutlet UIButton           *btnSideMenu;
@property (weak, nonatomic) IBOutlet UIButton           *btnSearchFilter;

@property (weak, nonatomic) IBOutlet UICollectionView   *collectionView;

@property (weak, nonatomic) IBOutlet UITableView        *tblViewSearchFilter;

@property (strong, nonatomic) NSMutableArray            *arrNearByFriends;

@end

@implementation FindPeopleVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    //---> Do any additional setup after loading the view.
    
    // Configure Uicollectionview layout
    UICollectionViewFlowLayout *flowLayout =[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setItemSize:CGSizeMake(deviceWidth, 500)];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    [self.collectionView setCollectionViewLayout:flowLayout];
    
    [self addSlideView];
    
    self.arrNearByFriends = [NSMutableArray new];
    
    [self callFindNearByFriendsService];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
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

- (void)handleSwipeRight:(UISwipeGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView: self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (indexPath != nil)
    {
        NSInteger countt = indexPath.row + 1;
        FindPeopleCell* cell = (FindPeopleCell *) [self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell)
        {
            [self snapToCellAtIndexRight:countt withAnimation:YES];//paas index here to move to.
        }
    }
}

- (void)handleSwipeLeft:(UISwipeGestureRecognizer *)gestureRecognizer
{
    CGPoint p = [gestureRecognizer locationInView: self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:p];
    
    if (indexPath != nil)
    {
        NSInteger swipeLeft = indexPath.row;
        swipeLeft --;
        
        FindPeopleCell* cell = (FindPeopleCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
        if (cell)
        {
            [self snapToCellAtIndexLeft:swipeLeft withAnimation:YES];//paas index here to move to.
        }
    }
}

- (void)snapToCellAtIndexLeft:(NSInteger)index withAnimation:(BOOL)animated
{
    NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:IndexPath atScrollPosition:UICollectionViewScrollPositionLeft animated:animated];
    
    CGRect frame;
    frame.origin.x = self.collectionView.frame.size.width * index;
    frame.origin.y = 0;
    frame.size = self.collectionView.frame.size;
    [self.collectionView setContentSize:CGSizeMake(self.collectionView.frame.size.width * index, self.collectionView.frame.size.height)];
}

- (void)snapToCellAtIndexRight:(NSInteger)index withAnimation:(BOOL)animated
{
    NSIndexPath *IndexPath = [NSIndexPath indexPathForRow:index inSection:0];
    [self.collectionView scrollToItemAtIndexPath:IndexPath atScrollPosition:UICollectionViewScrollPositionRight animated:animated];
    
    CGRect frame;
    frame.origin.x = self.collectionView.frame.size.width * index;
    frame.origin.y = 0;
    frame.size = self.collectionView.frame.size;
    [self.collectionView setContentSize:CGSizeMake(self.collectionView.frame.size.width * index, self.collectionView.frame.size.height)];
}

#pragma mark - API Methods
- (void)callFindNearByFriendsService
{
    if (![appDelegate isNetworkAvailable])
    {
        [Utility showNetWorkAlert];
        return;
    }
    
    NSDictionary *postParams = @{ @"member_id" : ObjectOrBlank([userDefaults valueForKey:@"member_id"]),};
    
    NSString *urlString = [NSString stringWithFormat:@"%@%@", BASE_URL, WEB_URL_Find_People];
    
    [serviceManager executeServiceWithURL:urlString andParameters:postParams forTask:kTaskFindPeople completionHandler:^(id response, NSError *error, TaskType task)
     {
         if (!error && response)
         {
             NSDictionary *dict = [[NSDictionary alloc]init];
             dict = (NSDictionary *)response;
             if ([[response valueForKey:@"response_code"] isEqualToString:@"RC0000"])
             {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     self.arrNearByFriends = [response valueForKey:@"data"];
                     [self.collectionView reloadData];
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
- (IBAction)btnSlideMenu_Action:(UIButton *)sender
{
    self.viewSearchFilter.hidden = YES;
    self.viewSideMenu.hidden = NO;
    
    if (sender.tag == 0)
    {
        //--->    Show Menu View
        self.btnSideMenu.tag = 1;
        [UIView animateWithDuration:0.5 animations:^(void)
        {
            [self.viewMain setFrame:CGRectMake(270, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height + 20)];
        }];
    }
    else
    {
        //--->    Hide Menu View
        self.btnSideMenu.tag = 0;
        [UIView animateWithDuration:0.5 animations:^(void)
        {
            [self.viewMain setFrame:CGRectMake(0, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height + 20)];
        }];
    }
}

- (IBAction)btnSearchFilter_Action:(UIButton *)sender
{
    self.viewSearchFilter.hidden = NO;
    self.viewSideMenu.hidden = YES;

    if (sender.tag == 0)
    {
        //--->    Show Menu View
        self.btnSearchFilter.tag = 1;
        [UIView animateWithDuration:0.5 animations:^(void)
        {
            [self.viewMain setFrame:CGRectMake(-270, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height + 20)];
        }];
    }
    else
    {
        //--->    Hide Menu View
        self.btnSearchFilter.tag = 0;
        [UIView animateWithDuration:0.5 animations:^(void)
        {
            [self.viewMain setFrame:CGRectMake(0, 0, self.viewMain.frame.size.width, self.viewMain.frame.size.height + 20)];
        }];
    }
}

- (IBAction)btnMeet_Action:(id)sender
{
    
}

- (IBAction)btnSelectVenue_Action:(id)sender
{
    NSInteger btnTag = [sender tag];
    
    selectedIndexPath = [NSIndexPath indexPathForRow:btnTag inSection:0];
    
    SelectVenueVC *objSelectvenue = [self.storyboard instantiateViewControllerWithIdentifier:NSStringFromClass([SelectVenueVC class])];
    [objSelectvenue setDelegate:self];
    [self.navigationController pushViewController:objSelectvenue animated:YES];
}

#pragma mark - UITableview DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    //*>    Initialize header view object
    
    UIView *viewHeader                  = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    
    UIImageView *imgViewUser            = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 35)];
    imgViewUser.image                   = [UIImage imageNamed:@"section_row.png"];
    
    UILabel *lblSectionTitle            = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, 280, 25)];
    lblSectionTitle.backgroundColor     = [UIColor clearColor];
    lblSectionTitle.textColor           = App_Theme_Color;
    lblSectionTitle.font                = [UIFont fontWithName:@"Helvetica Neue" size:21.0];

    if (section == 0)
    {
        lblSectionTitle.text            = @"Date & Time";
    }
    else if (section == 1)
    {
        lblSectionTitle.text            = @"Location";
    }
    else if (section == 2)
    {
        lblSectionTitle.text            = @"Interest";
    }
    
    [viewHeader addSubview:imgViewUser];
    [viewHeader addSubview:lblSectionTitle];
    
    return viewHeader;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else if (section == 1)
    {
        return 1;
    }
    else
    {
        return 2;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SearchFilterCell";
    SearchFilterCell *cell = (SearchFilterCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        cell = [[SearchFilterCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier] ;
    }
    
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            cell.imgViewSearchIcon.image            = [UIImage imageNamed:@"day"];
            cell.lblSearchTitle.text                = @"Day";
            cell.btnSearcgResult.titleLabel.text    = @"Select Day";
        }
        else if (indexPath.row == 1)
        {
            cell.imgViewSearchIcon.image            = [UIImage imageNamed:@"time"];
            cell.lblSearchTitle.text                = @"Start";
            cell.btnSearcgResult.titleLabel.text    = @"Select Start Time";
        }
        else if (indexPath.row == 2)
        {
            cell.imgViewSearchIcon.image            = [UIImage imageNamed:@"time"];
            cell.lblSearchTitle.text                = @"End";
            cell.btnSearcgResult.titleLabel.text    = @"Select End Time";
        }
    }
    else if (indexPath.section == 1)
    {
        if (indexPath.row == 0)
        {
            cell.imgViewSearchIcon.image            = [UIImage imageNamed:@"city"];
            cell.lblSearchTitle.text                = @"City";
            cell.btnSearcgResult.titleLabel.text    = @"Select Location";
        }
    }
    else if (indexPath.section == 2)
    {
        if (indexPath.row == 0)
        {
            cell.imgViewSearchIcon.image            = [UIImage imageNamed:@"industry_search"];
            cell.lblSearchTitle.text                = @"Industry";
            cell.btnSearcgResult.titleLabel.text    = @"Any";
        }
        if (indexPath.row == 1)
        {
            cell.imgViewSearchIcon.image            = [UIImage imageNamed:@"purpose"];
            cell.lblSearchTitle.text                = @"Purpose";
            cell.btnSearcgResult.titleLabel.text    = @"Any";
        }
    }
    
    return cell;
}

#pragma mark - UITableview Delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

#pragma mark UICollectionview Data source And Delegate
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.collectionView.frame.size;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrNearByFriends.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier         = @"FindPeopleCell";
    
    FindPeopleCell *cell            = (FindPeopleCell *)[collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    cell.lblUserName.text = [NSString stringWithFormat:@"%@", [[self.arrNearByFriends objectAtIndex:indexPath.row] valueForKey:@"member_name"]];
    
    cell.lblProfessionalDetail.numberOfLines = 0;
    cell.lblProfessionalDetail.text = [NSString stringWithFormat:@"%@ at %@\n%@, %@", [[self.arrNearByFriends objectAtIndex:indexPath.row] valueForKey:@"member_company_title"], [[self.arrNearByFriends objectAtIndex:indexPath.row] valueForKey:@"member_company_name"], [[self.arrNearByFriends objectAtIndex:indexPath.row] valueForKey:@"member_company_industry"], [[self.arrNearByFriends objectAtIndex:indexPath.row] valueForKey:@"member_address"]];
    
    NSString *strImageUrl = [NSString stringWithFormat:@"%@", [[self.arrNearByFriends objectAtIndex:indexPath.row] valueForKey:@"member_image"]];
    
    strImageUrl = [strImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *imageUrl = [NSURL URLWithString:strImageUrl];
    
    cell.imgViewUser.clipsToBounds = YES;
    
    if (indexPath.row == selectedIndexPath.row)
    {
        if (strSelectedVenue != nil)
        {
            cell.lblSelectVenue.text = strSelectedVenue;
        }
    }
    
    [[MySingleton sharedMySingleton] setRoundedImage:cell.imgViewUser toDiameter:85.0];
    
    if (imageUrl)
    {
        __block UIActivityIndicatorView *activityIndicator;
        [cell.imgViewUser sd_setImageWithURL:imageUrl placeholderImage:nil options:SDWebImageProgressiveDownload progress:^(NSInteger receivedSize, NSInteger expectedSize)
         {
             if (!activityIndicator)
             {
                 [cell.imgViewUser addSubview:activityIndicator = [UIActivityIndicatorView.alloc initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray]];
                 activityIndicator.center = cell.imgViewUser.center;
                 [activityIndicator startAnimating];
             }
         }
         completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
         {
             cell.imgViewUser.image = image;
             
             [activityIndicator removeFromSuperview];
             activityIndicator = nil;
         }];
    }
    
    [cell.btnMeet setTitle:[NSString stringWithFormat:@"I want to meet %@", [[self.arrNearByFriends objectAtIndex:indexPath.row] valueForKey:@"member_name"]] forState:UIControlStateNormal];
    cell.btnMeet.tag = indexPath.row;
    [cell.btnMeet addTarget:self action:@selector(btnMeet_Action:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.btnSelectVenue.tag = indexPath.row;
    [cell.btnSelectVenue addTarget:self action:@selector(btnSelectVenue_Action:) forControlEvents:UIControlEventTouchUpInside];
    
    UISwipeGestureRecognizer *swipeLeftt = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeRight:)];
    UISwipeGestureRecognizer *swipeRightt = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeLeft:)];
    
    [swipeLeftt setNumberOfTouchesRequired:1];
    [swipeLeftt setDirection:UISwipeGestureRecognizerDirectionLeft];
    [swipeRightt setNumberOfTouchesRequired:1];
    [swipeRightt setDirection:UISwipeGestureRecognizerDirectionRight];
    
    [cell.contentView addGestureRecognizer:swipeLeftt];
    [cell.contentView addGestureRecognizer:swipeRightt];
    
    return cell;
}

#pragma mark - custom delegates
- (void)didSelectPlaceWithCoordinates:(NSString *)place
{
    strSelectedVenue = place;
    
    FindPeopleCell *cell = (FindPeopleCell *) [self.collectionView cellForItemAtIndexPath:selectedIndexPath];
    cell.lblSelectVenue.text = place;
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self removeFromParentViewController];
}

@end