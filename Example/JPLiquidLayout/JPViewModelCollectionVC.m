//
//  JPViewModelCollectionVC.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPViewModelCollectionVC.h"
#import "JPCollectionViewCell.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshAutoNormalFooter.h"

@interface JPViewModelCollectionVC ()
@property (nonatomic, strong) NSMutableArray *cellVMs;
@end

@implementation JPViewModelCollectionVC
{
    CGFloat _maxWhScale;
    CGFloat _maxW;
    CGFloat _baseH;
    CGFloat _maxCol;
}

- (NSMutableArray *)cellVMs {
    if (!_cellVMs) {
        _cellVMs = [NSMutableArray array];
    }
    return _cellVMs;
}

+ (instancetype)collectionViewController {
    return [[self alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
        flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
        flowLayout.minimumLineSpacing = 2;
        flowLayout.minimumInteritemSpacing = 2;
        
        _maxWhScale = 16.0 / 9.0;
        _maxW = [UIScreen mainScreen].bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right;
        _baseH = _maxW * 0.5;
        _maxCol = 4;
        self.collectionView.collectionViewLayout = flowLayout;
    }
    return self;
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
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSArray *cellVMs = [JPCollectionViewCellViewModel randomCellVMs];
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSInteger startIndex = self.cellVMs.count;
        for (NSInteger i = 0; i < cellVMs.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:startIndex + i inSection:0]];
        }
        [self.cellVMs addObjectsFromArray:cellVMs];
        [JPLiquidLayoutTool insertOrDeleteItemFrames:self.cellVMs
                                         targetIndex:startIndex
                                          flowLayout:flowLayout
                                            maxWidth:self->_maxW
                                          baseHeight:self->_baseH
                                      itemMaxWhScale:self->_maxWhScale
                                              maxCol:self->_maxCol];
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

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPCollectionViewCellViewModel *cellVM = self.cellVMs[indexPath.item];\
    return cellVM.jp_itemFrame.size;
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
    
    [self.cellVMs removeObjectAtIndex:indexPath.item];
    
//    [self.cellVMs replaceObjectAtIndex:indexPath.item withObject:[JPCollectionViewCellViewModel randomCellVM]];
    
//    [JPLiquidLayoutTool updateItemFrames:self.cellVMs
//                               fromIndex:indexPath.item
//                              flowLayout:(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout
//                                maxWidth:_maxW
//                              baseHeight:_baseH
//                          itemMaxWhScale:_maxWhScale
//                                  maxCol:_maxCol];
    
    [JPLiquidLayoutTool insertOrDeleteItemFrames:self.cellVMs
                                     targetIndex:indexPath.item
                                      flowLayout:(UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout
                                        maxWidth:_maxW
                                      baseHeight:_baseH
                                  itemMaxWhScale:_maxWhScale
                                          maxCol:_maxCol];
    
    [UIView animateWithDuration:0.65 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:0.1 options:kNilOptions animations:^{
        [self.collectionView performBatchUpdates:^{
//            [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
            [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
        } completion:nil];
    } completion:nil];
}

@end
