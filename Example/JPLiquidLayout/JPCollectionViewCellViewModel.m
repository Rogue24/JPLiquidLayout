//
//  JPCollectionViewCellViewModel.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPCollectionViewCellViewModel.h"

@implementation JPCollectionViewCellViewModel
@synthesize jp_isSetedItemFrame = _jp_isSetedItemFrame;
@synthesize jp_itemFrame = _jp_itemFrame;
@synthesize jp_whScale = _jp_whScale;
@synthesize jp_colIndex = _jp_colIndex;
@synthesize jp_rowIndex = _jp_rowIndex;

+ (NSArray<JPCollectionViewCellViewModel *> *)randomCellVMs {
    NSMutableArray *cellVMs = [NSMutableArray array];
    for (NSInteger i = 0; i < 40; i++) {
        JPCollectionViewCellViewModel *cellVM = [self randomCellVM];
        if (cellVM) {
            [cellVMs addObject:cellVM];
        } else {
            continue;
        }
    }
    return cellVMs;
}

+ (JPCollectionViewCellViewModel *)randomCellVM {
    NSInteger index = arc4random_uniform(20);
    NSString *picName = [NSString stringWithFormat:@"pic_%02zd", index];
    UIImage *image = [UIImage imageNamed:picName];
    if (image) {
        JPCollectionViewCellViewModel *cellVM = [JPCollectionViewCellViewModel new];
        cellVM.picName = picName;
        cellVM.jp_whScale = image.size.width / image.size.height;
        return cellVM;
    } else {
        return nil;
    }
}

@end
