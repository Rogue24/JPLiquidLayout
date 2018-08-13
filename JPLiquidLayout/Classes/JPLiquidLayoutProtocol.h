//
//  JPLiquidLayoutProtocol.h
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol JPLiquidLayoutProtocol <NSObject>
@property (nonatomic, assign) CGFloat jp_whScale;
@property (nonatomic, assign) CGRect jp_itemFrame;
@property (nonatomic, assign) BOOL jp_isSetedItemFrame;
@property (nonatomic, assign) NSInteger jp_colIndex;
@property (nonatomic, assign) NSInteger jp_rowIndex;
@end
