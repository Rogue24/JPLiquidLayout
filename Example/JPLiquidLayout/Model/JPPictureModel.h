//
//  JPPictureModel.h
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/15.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPPictureModel : NSObject
@property (nonatomic, copy) NSString *picName;
@property (nonatomic, assign) CGFloat picWhScale;

+ (NSArray<JPPictureModel *> *)randomPicModels;
+ (JPPictureModel *)randomPicModel;
@end
