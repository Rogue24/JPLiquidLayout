//
//  JPLiquidLayoutTool.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPLiquidLayoutTool.h"

@implementation JPLiquidLayoutTool

+ (CGFloat)updateItemFrames:(NSArray<NSObject<JPLiquidLayoutProtocol> *> *)items
                  fromIndex:(NSInteger)fromIndex
                 flowLayout:(UICollectionViewFlowLayout *)flowLayout
                   maxWidth:(CGFloat)maxWidth
                 baseHeight:(CGFloat)baseHeight
             itemMaxWhScale:(CGFloat)itemMaxWhScale
                     maxCol:(NSInteger)maxCol {
    if (items.count == 0) return 0;
    if (fromIndex > items.count - 1) return CGRectGetMaxY([items.lastObject jp_itemFrame]) + flowLayout.minimumLineSpacing;
    NSObject<JPLiquidLayoutProtocol> *fromItem = items[fromIndex];
    for (NSObject<JPLiquidLayoutProtocol> *item in items) {
        if (item.jp_rowIndex >= fromItem.jp_rowIndex) {
            item.jp_isSetedItemFrame = NO;
        }
    }
    return [self calculateItemFrames:items
                          flowLayout:flowLayout
                            maxWidth:maxWidth
                          baseHeight:baseHeight
                      itemMaxWhScale:itemMaxWhScale
                              maxCol:maxCol];
}

+ (CGFloat)insertOrDeleteItemFrames:(NSArray<NSObject<JPLiquidLayoutProtocol> *> *)items
                        targetIndex:(NSInteger)targetIndex
                         flowLayout:(UICollectionViewFlowLayout *)flowLayout
                           maxWidth:(CGFloat)maxWidth
                         baseHeight:(CGFloat)baseHeight
                     itemMaxWhScale:(CGFloat)itemMaxWhScale
                             maxCol:(NSInteger)maxCol {
    NSInteger count = items.count;
    if (count == 0) return 0;
    if (targetIndex > 0) {
        NSInteger maxIndex = count - 1;
        NSInteger lastIndex = targetIndex - 1;
        NSObject<JPLiquidLayoutProtocol> *lastItem = items[lastIndex];
        for (NSInteger i = 0; i < maxIndex; i++) {
            NSObject<JPLiquidLayoutProtocol> *item = items[i];
            if (item.jp_rowIndex >= lastItem.jp_rowIndex || i > lastIndex) {
                item.jp_isSetedItemFrame = NO;
            }
        }
    }
    return [self calculateItemFrames:items
                          flowLayout:flowLayout
                            maxWidth:maxWidth
                          baseHeight:baseHeight
                      itemMaxWhScale:itemMaxWhScale
                              maxCol:maxCol];
}

+ (CGFloat)calculateItemFrames:(NSArray<NSObject<JPLiquidLayoutProtocol> *> *)items
                    flowLayout:(UICollectionViewFlowLayout *)flowLayout
                      maxWidth:(CGFloat)maxWidth
                    baseHeight:(CGFloat)baseHeight
                itemMaxWhScale:(CGFloat)itemMaxWhScale
                        maxCol:(NSInteger)maxCol {
    
    CGFloat maxHeight = 0;
    NSInteger count = items.count;
    if (count == 0) return maxHeight;
    
    UIEdgeInsets sectionInset = flowLayout.sectionInset;
    CGFloat lineSpacing = flowLayout.minimumLineSpacing;
    CGFloat interitemSpacing = flowLayout.minimumInteritemSpacing;
    
    NSInteger maxIndex = count - 1;
    NSInteger colIndex = 0;
    NSInteger rowIndex = 0;
    CGFloat x = sectionInset.left;
    CGFloat y = sectionInset.top;
    
    for (NSInteger i = 0; i < count; i++) {
        
        NSObject<JPLiquidLayoutProtocol> *item = items[i];
        if (item.jp_isSetedItemFrame) {
            maxHeight = CGRectGetMaxY(item.jp_itemFrame) + sectionInset.bottom;
            continue;
        }
        
        CGFloat w = 0;
        CGFloat h = 0;
        
        if (item.jp_whScale > itemMaxWhScale) {
            
            w = maxWidth;
            h = w / item.jp_whScale;
            
            item.jp_itemFrame = CGRectMake(x, y, w - 0.1, h);
            item.jp_colIndex = colIndex;
            item.jp_rowIndex = rowIndex;
            item.jp_isSetedItemFrame = YES;
            
            y += h + lineSpacing;
            rowIndex += 1;
            
        } else {
            
            h = baseHeight;
            w = h * item.jp_whScale;
            item.jp_itemFrame = CGRectMake(x, y, w - 0.1, h);
            
            if (i == maxIndex) {
                item.jp_colIndex = colIndex;
                item.jp_rowIndex = rowIndex;
                item.jp_isSetedItemFrame = YES;
                maxHeight = CGRectGetMaxY(item.jp_itemFrame) + sectionInset.bottom;
            } else {
                CGFloat totalW = w;
                NSInteger totalLeftCount = count - (i + 1);
                NSInteger leftCount = totalLeftCount < maxCol ? totalLeftCount : (maxCol - 1);
                
                NSMutableArray *thisRowItems = [NSMutableArray array];
                [thisRowItems addObject:item];
                
                if (leftCount > 0 && totalW < maxWidth) {
                    NSArray *leftItems = [items subarrayWithRange:NSMakeRange(i + 1, leftCount)];
                    for (NSObject<JPLiquidLayoutProtocol> *leftItem in leftItems) {
                        CGFloat width = h * leftItem.jp_whScale;
                        leftItem.jp_itemFrame = CGRectMake(x, y, width - 0.1, h);
                        [thisRowItems addObject:leftItem];
                        
                        totalW += (interitemSpacing + width);
                        if (totalW >= maxWidth) {
                            break;
                        }
                    }
                }
                
                /**
                 * totalW < photoMaxW：宽度不够，增加高度
                 * totalW > photoMaxW：宽度超出，减小高度
                 */
                
                NSInteger thisRowCount = thisRowItems.count;
                CGFloat scale = 1;
                if (totalW != maxWidth) {
                    CGFloat itemTotalSpace = (thisRowCount - 1) * interitemSpacing;
                    CGFloat maxW = (maxWidth - itemTotalSpace) / thisRowCount;
                    CGFloat currentW = (totalW - itemTotalSpace) / thisRowCount;
                    scale = maxW / currentW;
                }
                
                for (NSInteger i = 0; i < thisRowCount; i++) {
                    NSObject<JPLiquidLayoutProtocol> *thisRowItem = thisRowItems[i];
                    
                    CGRect frame = thisRowItem.jp_itemFrame;
                    frame.size.width *= scale;
                    frame.size.height *= scale;
                    frame.origin.x = x;
                    frame.origin.y = y;
                    
                    thisRowItem.jp_itemFrame = frame;
                    thisRowItem.jp_colIndex = colIndex;
                    thisRowItem.jp_rowIndex = rowIndex;
                    thisRowItem.jp_isSetedItemFrame = YES;
                    
                    x += frame.size.width + interitemSpacing;
                    colIndex += 1;
                    if (i == thisRowCount - 1) {
                        maxHeight = CGRectGetMaxY(frame) + sectionInset.bottom;
                        y += frame.size.height + lineSpacing;
                        rowIndex += 1;
                    }
                }
            }
        }
        x = sectionInset.left;
        colIndex = 0;
    }
    
    return maxHeight;
}
@end
