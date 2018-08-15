//
//  JPCollectionViewController.h
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/14.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPCollectionViewCell.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"
#import "JPCollectionViewCellViewModel.h"

@interface JPCollectionViewController : UICollectionViewController
@property (nonatomic, weak) UISegmentedControl *segmentedControl;
@end
