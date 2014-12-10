//
//  SearchPlacesVC.m
//  LetsTalkBusiness
//
//  Created by Neuron-iPhone on 8/20/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "SelectVenueVC.h"
#import "SVPullToRefresh.h"
#import "SelectVenueCell.h"

@interface SelectVenueVC ()<UITableViewDataSource, UITableViewDelegate, NSURLConnectionDataDelegate, CLLocationManagerDelegate>
{    
    NSString            *currentLatitude;
    NSString            *currentLongitude;
    
    CLLocationManager   *locationManager;
    CLLocation          *currentLocation;
}

@property (weak, nonatomic) IBOutlet UILabel            *lblNoPlacesFound;

@property (weak, nonatomic) IBOutlet UITableView        *tblSearchResults;

@property (weak, nonatomic) IBOutlet UISearchBar        *searchBrands;

@property (weak, nonatomic) NSString                    *nextPageToken;

@property (strong, nonatomic) NSMutableArray            *arrPlacesNearBy;
@property (strong, nonatomic) NSMutableArray            *arrFilterRecords;

@property (assign, nonatomic) BOOL                      bShouldBeginEditing;
@property (assign, nonatomic) BOOL                      isnextPageToken;

@end

@implementation SelectVenueVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.bShouldBeginEditing = YES;
    
    for (UIView *subview in self.searchBrands.subviews)
    {
        for (UIView *subSubview in subview.subviews)
        {
            //*>    Set keyboard Appearance
            if ([subSubview conformsToProtocol:@protocol(UITextInputTraits)])
            {
                UITextField *textField = (UITextField *)subSubview;
                [textField setKeyboardAppearance: UIKeyboardAppearanceLight];
                textField.returnKeyType = UIReturnKeyDone;
                textField.enablesReturnKeyAutomatically = NO;
                break;
            }
        }
    }

    self.arrPlacesNearBy = [NSMutableArray new];
    self.arrFilterRecords = [NSMutableArray new];
    
    [self CurrentLocationIdentifier];
    
    __weak SelectVenueVC *weakSelf = self;
    
    self.tblSearchResults.pullToRefreshView.backgroundColor = [UIColor blueColor];
    
    [self.tblSearchResults addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

#pragma mark - Custom Methods
- (void)insertRowAtBottom
{
    __weak SelectVenueVC *weakSelf = self;
    
    if (self.isnextPageToken)
    {
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void)
        {
            [weakSelf.tblSearchResults beginUpdates];
            [self callNearByPlaces:currentLatitude and:currentLongitude];
            [weakSelf.tblSearchResults reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationTop];
            [weakSelf.tblSearchResults endUpdates];
            [weakSelf.tblSearchResults.infiniteScrollingView stopAnimating];
        });
    }
    else
    {
        DLog(@"No more pages to load");
        [weakSelf.tblSearchResults.infiniteScrollingView stopAnimating];
    }
}

- (void)CurrentLocationIdentifier
{
    locationManager = [CLLocationManager new];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [locationManager requestWhenInUseAuthorization];
        [locationManager requestAlwaysAuthorization];
        [locationManager startMonitoringSignificantLocationChanges];
    }
    locationManager.delegate = self;
    locationManager.distanceFilter = kCLDistanceFilterNone;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;

    [locationManager startUpdatingLocation];
}

#pragma mark - API Methods
- (void)callNearByPlaces:(NSString *)latitute and:(NSString *)longitude
{
    if (![appDelegate isNetworkAvailable])
    {
        [Utility showNetWorkAlert];
        return;
    }
    else
    {
        NSString *urlString = [NSString new];
        NSString *types     = @"restaurant";
        if (!self.isnextPageToken)
        {
            urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=10000&types=%@&rankBy=distance&key=%@&pagetoken=", latitute, longitude, types, API_KEY_GOOGLEPLACES];
        }
        else
        {
            urlString = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=%@,%@&radius=500&types=%@&rankBy=distance&key=%@&pagetoken=%@", latitute, longitude, types, API_KEY_GOOGLEPLACES, self.nextPageToken];
        }
        NSString *properlyEscapedURL = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        
        [serviceManager executeServiceWithURL:properlyEscapedURL forTask:kTaskNearByPlaces completionHandler:^(id response, NSError *error, TaskType task)
         {
             if (!error && response)
             {
                 self.nextPageToken = [response objectForKey:@"next_page_token"];
                 
                 NSArray *dataSource = [NSArray new];
                 dataSource = [response objectForKey:@"results"];
                 
                 if ([Utility getValidString:self.nextPageToken].length > 0)
                     self.isnextPageToken = YES;
                 else
                     self.isnextPageToken = NO;
                 
                 if (self.isnextPageToken)
                 {
                     [self.arrPlacesNearBy addObjectsFromArray:dataSource];
                     [self.arrFilterRecords addObjectsFromArray:dataSource];
                 }
                 [self.tblSearchResults reloadData];
             }
         }];
    }
}

#pragma mark - Action Methods
- (IBAction)btnBack_Action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - CLLocationManager Delegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    currentLocation = [locations lastObject];
    [locationManager stopUpdatingLocation];
    
    if (currentLocation != nil)
    {
        currentLongitude = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        currentLatitude  = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    [self callNearByPlaces:currentLatitude and:currentLongitude];
    self.lblNoPlacesFound.hidden = YES;
}

#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
};

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrFilterRecords.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectVenueCell *cell = [self.tblSearchResults dequeueReusableCellWithIdentifier:@"SelectVenueCell" forIndexPath:indexPath];
        
    cell.lblVenueName.text = [[self.arrFilterRecords objectAtIndex:indexPath.row] valueForKey:@"name"];
        
    return cell;
}

#pragma mark - tableview delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *address;
    
    SelectVenueCell *cell = (SelectVenueCell *)[self.tblSearchResults cellForRowAtIndexPath:indexPath];
    address = cell.lblVenueName.text;

    if ([self.delegate respondsToSelector:@selector(didSelectPlaceWithCoordinates:)])
    {
        [self.delegate didSelectPlaceWithCoordinates:address];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UISearchBarDelegate methods
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString:@""])
    {
        self.bShouldBeginEditing = false;
        [self.arrFilterRecords removeAllObjects];
        for(id cores in self.arrPlacesNearBy)
        {
            [self.arrFilterRecords addObject:cores];
        }
        [self.tblSearchResults reloadData];
        return;
    }
    
    [self.arrFilterRecords removeAllObjects];
    
    for(id cores in self.arrPlacesNearBy)
    {
        id title        = [cores valueForKey:@"name"];
        NSRange range   = [title rangeOfString:searchText options:NSCaseInsensitiveSearch];
        
        if (range.length > 0)
        {
            [self.arrFilterRecords addObject:cores];
            [self.tblSearchResults reloadData];
        }
    }
    if (![self.arrFilterRecords count] > 0)
    {
        [self.tblSearchResults reloadData];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)bar
{
    BOOL boolToReturn = self.bShouldBeginEditing;
    self.bShouldBeginEditing = YES;
    return boolToReturn;
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    self.bShouldBeginEditing = YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
}

- (void)searchDisplayControllerDidEndSearch:(UISearchController *)controller
{
    [self.arrFilterRecords removeAllObjects];
    
    for(id cores in self.arrPlacesNearBy)
    {
        [self.arrFilterRecords addObject:cores];
    }
    [self.tblSearchResults reloadData];
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end