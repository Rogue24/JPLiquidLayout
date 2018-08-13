//
//  JPCollectionViewCell.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPCollectionViewCell.h"

@implementation JPCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIImageView *pictureView = [[UIImageView alloc] init];
        pictureView.contentMode = UIViewContentModeScaleAspectFill;
        [self.contentView addSubview:pictureView];
        self.pictureView = pictureView;
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.pictureView.frame = self.contentView.bounds;
}

@end
