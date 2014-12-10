//
//  CWCardAnnotation.m
//  CardWiser
//
//  Created by CardWiser on 10/9/14.
//  Copyright (c) 2014 CardWiser LLC. All rights reserved.
//

#import "UserAnnotation.h"

@implementation UserAnnotation

#pragma mark - Public Methods
/**
 **     Return Annotation view
 **/
+ (MKAnnotationView *)createViewAnnotationForMapView:(MKMapView *)mapView annotation:(id <MKAnnotation>)annotation
{
    MKAnnotationView *returnedAnnotationView =
    [mapView dequeueReusableAnnotationViewWithIdentifier:NSStringFromClass([UserAnnotation class])];
    
    if (returnedAnnotationView == nil)
    {
        returnedAnnotationView = [[MKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:NSStringFromClass([UserAnnotation class])];
        
        returnedAnnotationView.canShowCallout = YES;
        
        //*>    offset the flag annotation so that the flag pole rests on the map coordinate
        returnedAnnotationView.centerOffset = CGPointMake( returnedAnnotationView.centerOffset.x + returnedAnnotationView.image.size.width/2, returnedAnnotationView.centerOffset.y - returnedAnnotationView.image.size.height/2 );
    }
    else
    {
        returnedAnnotationView.annotation = annotation;
    }
    return returnedAnnotationView;
}

#pragma mark - Custom Methods
/**
 **     Return coordinate of annotation
 **/
- (CLLocationCoordinate2D)coordinate
{
    return _coordinate;
}

/**
 **     Return Title of annotation
 **/
- (NSString *)title
{
    return self.strTitle;
}

// optional
- (NSString *)subtitle
{
    return self.strSubTitle;
}

@end