//
//  JPLiquidLayout.h
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JPLiquidLayoutProtocol.h"

@interface JPLiquidLayout : UICollectionViewFlowLayout
@property (nonatomic, assign) CGFloat maxWidth;
@property (nonatomic, assign) CGFloat baseHeight;
@property (nonatomic, assign) CGFloat itemMaxWhScale;
@property (nonatomic, assign) NSInteger maxCol;
@property (nonatomic, copy) CGFloat (^itemWhScale)(NSIndexPath *indexPath);
@end

@interface JPLiquidLayoutAttributes: UICollectionViewLayoutAttributes <JPLiquidLayoutProtocol>

@end
