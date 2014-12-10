//
//  LetsMeetNowVC.m
//  Founderin
//
//  Created by Neuron on 12/9/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import "LetsMeetNowVC.h"
#import "SlideMenuVC.h"
#import "UserAnnotation.h"

@interface LetsMeetNowVC () <MKMapViewDelegate, CLLocationManagerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView      *mapView;

@property (weak, nonatomic) IBOutlet UIView         *viewMain;
@property (weak, nonatomic) IBOutlet UIView         *viewSideMenu;

@property (weak, nonatomic) IBOutlet UIButton       *btnSideMenu;

@property (nonatomic, strong) NSMutableArray        *arrMapAnnotations;
@property (nonatomic, strong) NSMutableArray        *arrNearByFriends;

@property CLLocationManager                         *locationManager;
@property CLLocation                                *currentLocation;

@end

@implementation LetsMeetNowVC

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self addSlideView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    //    Stop getting location update
    [self.locationManager stopUpdatingLocation];
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

- (void)currentLocationIdentifier
{
    self.locationManager = [CLLocationManager new];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0)
    {
        [self.locationManager requestWhenInUseAuthorization];
        [self.locationManager requestAlwaysAuthorization];
        [self.locationManager startMonitoringSignificantLocationChanges];
    }
    
    //  We don't want to be notified of small changes in location, Update after movements of 500 meter
    self.mapView.showsUserLocation  = YES;
    self.locationManager.delegate = self;
    self.locationManager.distanceFilter = 500;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [self.locationManager startUpdatingLocation];
}

- (void)displayCardsAnnotationOnMap
{
    self.arrMapAnnotations = [NSMutableArray new];
    
    //    Remove any annotations that exist
    [self.mapView removeAnnotations:self.mapView.annotations];
    
    //  Check if annotations exist
    if (self.arrMapAnnotations.count > 0)
    {
        //    Add all annotations
        [self.mapView addAnnotations:self.arrMapAnnotations];
        
        //   Zoom map so that display annotion of all cards on map
        [self.mapView showAnnotations:self.arrMapAnnotations animated:YES];
    }
}

#pragma mark - Action Methods
- (IBAction)btnSlideMenu_Action:(UIButton *)sender
{
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

#pragma mark - MKMapViewDelegate
/**
 **    User tapped the disclosure button of  Card
 **/
- (void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    // here we illustrate how to detect which annotation type was clicked on for its callout
    id <MKAnnotation> annotation = [view annotation];
    if ([annotation isKindOfClass:[UserAnnotation class]])
    {

    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view
{
    DLog(@"");
}

- (void)mapView:(MKMapView *)mapView didDeselectAnnotationView:(MKAnnotationView *)view
{
    DLog(@"");
}

/**
 **     Create and return cards Annotation view
 **/
- (MKAnnotationView *)mapView:(MKMapView *)theMapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnedAnnotationView = nil;
    
    if ([annotation isKindOfClass:[UserAnnotation class]])
    {
        returnedAnnotationView       = [UserAnnotation createViewAnnotationForMapView:self.mapView annotation:annotation];
        returnedAnnotationView.frame = CGRectMake(0, 0, 50, 50);
        
        //Intialize and set custom |rightCalloutAccessoryView|
        UIButton *rightButton        = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 50)];
        
        [rightButton setBackgroundImage:[UIImage imageNamed:@"arrow_next"] forState:UIControlStateNormal];
        [rightButton addTarget:nil action:nil forControlEvents:UIControlEventTouchUpInside];
        ((MKPinAnnotationView *)returnedAnnotationView).rightCalloutAccessoryView = rightButton;
        
        //Intialize and set Age view over map
        UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        button.frame = CGRectMake(40, 0, 20, 20);
        button.clipsToBounds = YES;
        button.userInteractionEnabled = NO;
        button.backgroundColor = App_Theme_Color;
        button.layer.cornerRadius = button.frame.size.width/2;
        [button setTitle:((UserAnnotation *)annotation).strAge forState:UIControlStateNormal];
        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:12.0];
        
        NSURL *imgUrl = [NSURL URLWithString:((UserAnnotation *)annotation).strAnnotationImageUrl];
        
        //Intialize and set User image view over map
        UIImageView *bgImg = [[UIImageView alloc] init];
        bgImg.backgroundColor = [UIColor clearColor];
        
        bgImg.frame = CGRectMake(0, 0, 50, 50);
        bgImg.clipsToBounds = YES;
        
        [[MySingleton sharedMySingleton] setRoundedImage:bgImg toDiameter:50.0];
        
        if (imgUrl)
        {
            [bgImg sd_setImageWithURL:imgUrl placeholderImage:[UIImage imageNamed:@"user_default_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
             {
                 DLog(@"error:%@",error);
                 returnedAnnotationView.frame = CGRectMake(0, 0, 50, 50);
             }];
        }
        else
        {
            bgImg.image = [UIImage imageNamed:@"user_default_placeholder"];
        }
        returnedAnnotationView.frame = CGRectMake(0, 0, 50, 50);
        [returnedAnnotationView addSubview:bgImg];
        [returnedAnnotationView addSubview:button];
    }
    return returnedAnnotationView;
}

#pragma mark - CLLocationManagerDelegate

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    DLog(@"CLLocationManager error: %@", error);
}

- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation     = [locations lastObject];
    NSUInteger locationCount    = locations.count;
    CLLocation *oldLocation     = (locationCount > 1 ? locations[locationCount - 2] : nil);
    
    self.currentLocation = newLocation;
    
    if (!oldLocation || ((oldLocation.coordinate.latitude != newLocation.coordinate.latitude) && (oldLocation.coordinate.longitude != newLocation.coordinate.longitude)))
    {

    }
}

#pragma mark - Memory Warning
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
    [self removeFromParentViewController];
}

@end