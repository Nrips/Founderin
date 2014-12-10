//
//  CWCardAnnotation.h
//  CardWiser
//
//  Created by CardWiser on 10/9/14.
//  Copyright (c) 2014 CardWiser LLC. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface UserAnnotation : NSObject <MKAnnotation>

@property (nonatomic, strong) NSString *strTitle;
@property (nonatomic, strong) NSString *strSubTitle;
@property (nonatomic, strong) NSString *strAge;
@property (nonatomic) int arryUserIndex;
@property (nonatomic, strong) NSString *strAnnotationImageUrl;
@property (nonatomic) CLLocationCoordinate2D coordinate;

+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation;

@end