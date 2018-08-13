//
//  JPLiquidLayout.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPLiquidLayout.h"
#import "JPLiquidLayoutTool.h"

@interface JPLiquidLayout ()
@property (nonatomic, strong) NSMutableArray<JPLiquidLayoutAttributes *> *attributes;
@property (nonatomic, assign) CGFloat maxHeight;
@end

@implementation JPLiquidLayout

- (instancetype)init {
    if (self = [super init]) {
        self.itemMaxWhScale = 1;
        self.maxCol = 1;
    }
    return self;
}

- (void)prepareLayout {
    [super prepareLayout];
    
    self.attributes = [NSMutableArray array];
    
    NSInteger count = [self.collectionView numberOfItemsInSection:0];
    
    for (NSInteger i = 0; i < count; i++) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        JPLiquidLayoutAttributes *att = [JPLiquidLayoutAttributes layoutAttributesForCellWithIndexPath:indexPath];
        att.jp_whScale = self.itemWhScale ? self.itemWhScale(indexPath) : 1;
        [self.attributes addObject:att];
    }
    
    self.maxHeight = [JPLiquidLayoutTool calculateItemFrames:self.attributes flowLayout:self maxWidth:self.maxWidth baseHeight:self.baseHeight itemMaxWhScale:self.itemMaxWhScale maxCol:self.maxCol];
}

- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect {
    return self.attributes;
}

- (CGSize)collectionViewContentSize {
    return CGSizeMake(0, self.maxHeight);
}

@end

@implementation JPLiquidLayoutAttributes

@synthesize jp_whScale = _jp_whScale;
@synthesize jp_itemFrame = _jp_itemFrame;
@synthesize jp_rowIndex = _jp_rowIndex;
@synthesize jp_colIndex = _jp_colIndex;
@synthesize jp_isSetedItemFrame = _jp_isSetedItemFrame;

- (void)setJp_itemFrame:(CGRect)jp_itemFrame {
    self.frame = jp_itemFrame;
}

- (CGRect)jp_itemFrame {
    return self.frame;
}

@end
