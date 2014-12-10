//
//  SearchPlacesVC.h
//  LetsTalkBusiness
//
//  Created by Neuron-iPhone on 8/20/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import <CoreLocation/CoreLocation.h>

@protocol SelectVenueVCDelegate <NSObject>

- (void)didSelectPlaceWithCoordinates:(NSString *)place;

@end

@interface SelectVenueVC : UIViewController

@property (nonatomic, weak) id <SelectVenueVCDelegate>delegate;

@end