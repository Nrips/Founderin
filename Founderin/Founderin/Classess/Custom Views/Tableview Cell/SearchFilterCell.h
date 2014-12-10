//
//  SearchFilterCell.h
//  Founderin
//
//  Created by Neuron on 12/3/14.
//  Copyright (c) 2014 Neuron. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchFilterCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel      *lblSearchTitle;
@property (strong, nonatomic) IBOutlet UIImageView  *imgViewSearchIcon;
@property (strong, nonatomic) IBOutlet UIButton     *btnSearcgResult;

@end