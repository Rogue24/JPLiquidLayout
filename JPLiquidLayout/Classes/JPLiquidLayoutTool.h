//
//  JPLiquidLayoutTool.h
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPLiquidLayoutProtocol.h"

@interface JPLiquidLayoutTool : NSObject
+ (CGFloat)calculateItemFrames:(NSArray<NSObject<JPLiquidLayoutProtocol> *> *)items
                    flowLayout:(UICollectionViewFlowLayout *)flowLayout
                      maxWidth:(CGFloat)maxWidth
                    baseHeight:(CGFloat)baseHeight
                itemMaxWhScale:(CGFloat)itemMaxWhScale
                        maxCol:(NSInteger)maxCol;

+ (CGFloat)updateItemFrames:(NSArray<NSObject<JPLiquidLayoutProtocol> *> *)items
                  fromIndex:(NSInteger)fromIndex
                 flowLayout:(UICollectionViewFlowLayout *)flowLayout
                   maxWidth:(CGFloat)maxWidth
                 baseHeight:(CGFloat)baseHeight
             itemMaxWhScale:(CGFloat)itemMaxWhScale
                     maxCol:(NSInteger)maxCol;


+ (CGFloat)insertOrDeleteItemFrames:(NSArray<NSObject<JPLiquidLayoutProtocol> *> *)items
                        targetIndex:(NSInteger)targetIndex
                         flowLayout:(UICollectionViewFlowLayout *)flowLayout
                           maxWidth:(CGFloat)maxWidth
                         baseHeight:(CGFloat)baseHeight
                     itemMaxWhScale:(CGFloat)itemMaxWhScale
                             maxCol:(NSInteger)maxCol;
@end
