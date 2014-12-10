//
//  SelectLocationVC.h
//  Founderin
//
//  Created by Neuron on 12/2/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SPGooglePlacesAutocompleteQuery;

@protocol SelectLocationVCDelegate <NSObject>

- (void)didSelectLocation:(NSString *)location;

@end

@interface SelectLocationVC : UIViewController

@property (weak, nonatomic) id<SelectLocationVCDelegate>delegate;

@end