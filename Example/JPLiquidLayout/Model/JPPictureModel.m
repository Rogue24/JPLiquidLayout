//
//  JPPictureModel.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/15.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPPictureModel.h"

@implementation JPPictureModel

+ (NSArray<JPPictureModel *> *)randomPicModels {
    NSMutableArray *picModels = [NSMutableArray array];
    for (NSInteger i = 0; i < 40; i++) {
        JPPictureModel *picModel = [self randomPicModel];
        if (picModel) {
            [picModels addObject:picModel];
        } else {
            continue;
        }
    }
    return picModels;
}

+ (JPPictureModel *)randomPicModel {
    NSInteger index = arc4random_uniform(20);
    NSString *picName = [NSString stringWithFormat:@"pic_%02zd", index];
    UIImage *image = [UIImage imageNamed:picName];
    if (image) {
        JPPictureModel *picModel = [JPPictureModel new];
        picModel.picName = picName;
        picModel.picWhScale = image.size.width / image.size.height;
        return picModel;
    } else {
        return nil;
    }
}

@end
