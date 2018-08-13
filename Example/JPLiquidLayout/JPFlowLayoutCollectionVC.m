//
//  JPFlowLayoutCollectionVC.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPFlowLayoutCollectionVC.h"
#import "JPLiquidLayout.h"
#import "JPCollectionViewCell.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"

@interface JPFlowLayoutCollectionVC ()
@property (nonatomic, strong) NSMutableArray *cellVMs;
@end

@implementation JPFlowLayoutCollectionVC

- (NSMutableArray *)cellVMs {
    if (!_cellVMs) {
        _cellVMs = [NSMutableArray array];
    }
    return _cellVMs;
}

+ (instancetype)collectionViewController {
    JPLiquidLayout *layout = [[JPLiquidLayout alloc] init];
    layout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
    layout.minimumLineSpacing = 2;
    layout.minimumInteritemSpacing = 2;
    layout.itemMaxWhScale = 16.0 / 9.0;
    layout.maxWidth = [UIScreen mainScreen].bounds.size.width - layout.sectionInset.left - layout.sectionInset.right;
    layout.baseHeight = layout.maxWidth * 0.5;
    layout.maxCol = 4;
    
    JPFlowLayoutCollectionVC *vc = [[self alloc] initWithCollectionViewLayout:layout];
    
    __weak typeof(vc) weakVC = vc;
    layout.itemWhScale = ^CGFloat(NSIndexPath *indexPath) {
        __strong typeof(weakVC) strongVC = weakVC;
        if (!strongVC || strongVC.cellVMs.count == 0) return 1;
        return [strongVC.cellVMs[indexPath.item] jp_whScale];
    };
    
    return vc;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    
    [self.collectionView registerClass:JPCollectionViewCell.class forCellWithReuseIdentifier:JPCollectionViewCellID];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(insertCellVMs)];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(insertCellVMs)];
    self.collectionView.mj_footer.hidden = YES;
    
    [self.collectionView.mj_header beginRefreshing];
}

- (void)insertCellVMs {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *cellVMs = [JPCollectionViewCellViewModel randomCellVMs];
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSInteger startIndex = self.cellVMs.count;
        for (NSInteger i = 0; i < cellVMs.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:startIndex + i inSection:0]];
        }
        [self.cellVMs addObjectsFromArray:cellVMs];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [self.collectionView performBatchUpdates:^{
                [self.collectionView insertItemsAtIndexPaths:indexPaths];
            } completion:^(BOOL finished) {
                self.collectionView.mj_footer.hidden = NO;
                self.collectionView.mj_header.hidden = YES;
            }];
        });
    });
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.cellVMs.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JPCollectionViewCellID forIndexPath:indexPath];
    cell.pictureView.image = [UIImage imageNamed:[self.cellVMs[indexPath.item] picName]];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//
//    JPCollectionViewCellViewModel *cellVM = self.cellVMs[indexPath.item];
//    cellVM.jp_whScale = _maxWhScale;
//
//    [JPLiquidLayoutTool updateItemFrames:self.cellVMs
//                               fromIndex:indexPath.item
//                              flowLayout:(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout
//                                maxWidth:_maxW
//                              baseHeight:_baseH
//                          itemMaxWhScale:_maxWhScale
//                                  maxCol:_maxCol];
//
//    [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:0.1 options:kNilOptions animations:^{
//        [self.collectionView performBatchUpdates:^{
//            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
//        } completion:nil];
//    } completion:nil];
}

@end
