//
//  JPCollectionViewCellViewModel.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPCollectionViewCellViewModel.h"

@implementation JPCollectionViewCellViewModel
@synthesize jp_isSetedDone = _jp_isSetedDone;
@synthesize jp_itemFrame = _jp_itemFrame;
@synthesize jp_whScale = _jp_whScale;
@synthesize jp_colIndex = _jp_colIndex;
@synthesize jp_rowIndex = _jp_rowIndex;

- (instancetype)initWithPicModel:(JPPictureModel *)picModel {
    if (self = [super init]) {
        self.picModel = picModel;
    }
    return self;
}

- (void)setPicModel:(JPPictureModel *)picModel {
    _picModel = picModel;
    self.jp_whScale = picModel.picWhScale;
}

@end
