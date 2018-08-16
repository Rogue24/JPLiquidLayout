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
    while (picModels.count < 40) {
        NSString *picName = picModels.count ? [picModels.lastObject picName] : nil;
        JPPictureModel *picModel = [self randomPicModel:picName];
        if (picModel) {
            [picModels addObject:picModel];
        } else {
            continue;
        }
    }
    return picModels;
}

+ (JPPictureModel *)randomPicModel:(NSString *)picName {
    NSInteger index = arc4random_uniform(20);
    NSString *randomName = [NSString stringWithFormat:@"pic_%02zd", index];
    if (picName && [randomName isEqualToString:picName]) {
        return [self randomPicModel:picName];
    }
    UIImage *image = [UIImage imageNamed:randomName];
    if (image) {
        JPPictureModel *picModel = [JPPictureModel new];
        picModel.picName = randomName;
        picModel.picWhScale = image.size.width / image.size.height;
        return picModel;
    } else {
        return nil;
    }
}

@end
