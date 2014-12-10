//
//  FindPeopleCell.h
//  Founderin
//
//  Created by Neuron on 12/2/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FindPeopleCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel      *lblUserName;
@property (strong, nonatomic) IBOutlet UILabel      *lblProfessionalDetail;
@property (strong, nonatomic) IBOutlet UILabel      *lblTime;
@property (strong, nonatomic) IBOutlet UILabel      *lblSelectVenue;

@property (strong, nonatomic) IBOutlet UIImageView  *imgViewUser;

@property (strong, nonatomic) IBOutlet UIButton     *btnUserDetail;
@property (strong, nonatomic) IBOutlet UIButton     *btnSelectTime;
@property (strong, nonatomic) IBOutlet UIButton     *btnSelectVenue;
@property (strong, nonatomic) IBOutlet UIButton     *btnMeet;

@end