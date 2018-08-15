//
//  JPCollectionViewCellViewModel.h
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JPPictureModel.h"
#import "JPLiquidLayoutTool.h"

@interface JPCollectionViewCellViewModel : NSObject <JPLiquidLayoutProtocol>
- (instancetype)initWithPicModel:(JPPictureModel *)picModel;
@property (nonatomic, strong) JPPictureModel *picModel;
@end
