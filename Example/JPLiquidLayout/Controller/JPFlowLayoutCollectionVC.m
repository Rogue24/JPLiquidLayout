//
//  JPFlowLayoutCollectionVC.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPFlowLayoutCollectionVC.h"
#import "JPLiquidLayout.h"
#import "JPPictureModel.h"

@interface JPFlowLayoutCollectionVC ()
@property (nonatomic, strong) NSMutableArray<JPPictureModel *> *picModels;
@end

@implementation JPFlowLayoutCollectionVC

+ (instancetype)collectionViewController {
    JPFlowLayoutCollectionVC *vc = [[self alloc] initWithCollectionViewLayout:[[JPLiquidLayout alloc] init]];
    return vc;
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        if ([layout isKindOfClass:JPLiquidLayout.class]) {
            JPLiquidLayout *liquidLayout = (JPLiquidLayout *)layout;

            liquidLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
            liquidLayout.minimumLineSpacing = 2;
            liquidLayout.minimumInteritemSpacing = 2;
            
            liquidLayout.maxCol = 4;
            liquidLayout.maxWidth = [UIScreen mainScreen].bounds.size.width - liquidLayout.sectionInset.left - liquidLayout.sectionInset.right;
            liquidLayout.baseHeight = liquidLayout.maxWidth * 0.5;
            liquidLayout.itemMaxWhScale = 16.0 / 9.0;
            
            __weak typeof(self) weakSelf = self;
            liquidLayout.itemWhScale = ^CGFloat(NSIndexPath *indexPath) {
                __strong typeof(weakSelf) strongSelf = weakSelf;
                if (!strongSelf || strongSelf.picModels.count == 0) return 1;
                return [strongSelf.picModels[indexPath.item] picWhScale];
            };
        }
        
        self.picModels = [NSMutableArray array];
    }
    return self;
}

- (void)insertCellVMs {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *picModels = [JPPictureModel randomPicModels];
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSInteger startIndex = self.picModels.count;
        for (NSInteger i = 0; i < picModels.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:startIndex + i inSection:0]];
        }
        [self.picModels addObjectsFromArray:picModels];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:indexPaths];
            } completion:^(BOOL finished) {
                self.collectionView.mj_footer.hidden = NO;
                self.collectionView.mj_header.hidden = YES;
                if (self.picModels.count > 300) {
                    [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                }
            }];
        });
    });
}

- (NSInteger)numberOfItems {
    return self.picModels.count;
}

- (void)setupCell:(JPCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.pictureView.image = [UIImage imageNamed:[self.picModels[indexPath.item] picName]];
}

- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            [self.picModels insertObject:[JPPictureModel randomPicModel] atIndex:indexPath.item];
            break;
        }
            
        case 1:
        {
            [self.picModels removeObjectAtIndex:indexPath.item];
            break;
        }
            
        case 2:
        {
            [self.picModels replaceObjectAtIndex:indexPath.item withObject:[JPPictureModel randomPicModel]];
            break;
        }
            
    }
}

@end
