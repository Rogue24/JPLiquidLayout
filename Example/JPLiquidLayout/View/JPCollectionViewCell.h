//
//  JPCollectionViewCell.h
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/14.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import <UIKit/UIKit.h>

static NSString *const JPCollectionViewCellID = @"JPCollectionViewCell";

@interface JPCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *pictureView;
@end
