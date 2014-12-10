//
//  MeetingAvailabilityCell.h
//  Founderin
//
//  Created by Neuron on 12/9/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MeetingAvailabilityCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel   *lblAvalability;
@property (strong, nonatomic) IBOutlet UILabel   *lblDay;
@property (strong, nonatomic) IBOutlet UILabel   *lblTimeDetail;

@property (strong, nonatomic) IBOutlet UIButton  *btnAvaalibility;

@end