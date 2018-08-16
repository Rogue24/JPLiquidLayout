//
//  JPViewModelCollectionVC.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPViewModelCollectionVC.h"

@interface JPViewModelCollectionVC ()
@property (nonatomic, strong) NSMutableArray<JPCollectionViewCellViewModel *> *cellVMs;
@end

@implementation JPViewModelCollectionVC
{
    CGFloat _maxWhScale;
    CGFloat _maxW;
    CGFloat _baseH;
    CGFloat _maxCol;
}

+ (instancetype)collectionViewController {
    return [[self alloc] initWithCollectionViewLayout:[[UICollectionViewFlowLayout alloc] init]];
}

- (instancetype)initWithCollectionViewLayout:(UICollectionViewLayout *)layout {
    if (self = [super initWithCollectionViewLayout:layout]) {
        if ([layout isKindOfClass:UICollectionViewFlowLayout.class]) {
            UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)layout;
            flowLayout.sectionInset = UIEdgeInsetsMake(8, 8, 8, 8);
            flowLayout.minimumLineSpacing = 2;
            flowLayout.minimumInteritemSpacing = 2;
            
            _maxWhScale = 16.0 / 9.0;
            _maxW = [UIScreen mainScreen].bounds.size.width - flowLayout.sectionInset.left - flowLayout.sectionInset.right;
            _baseH = _maxW * 0.5;
            _maxCol = 3;
        }
        
        self.cellVMs = [NSMutableArray array];
    }
    return self;
}

- (void)insertCellVMs {
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    // 放入子线程计算布局
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 一般从服务器请求获取的数据会给出图片的尺寸（相册使用photoKit的话，asset对象也会有照片尺寸给出），获取图片的宽高比
        NSArray *picModels = [JPPictureModel randomPicModels];
        NSMutableArray *indexPaths = [NSMutableArray array];
        NSInteger startIndex = self.cellVMs.count;
        for (NSInteger i = 0; i < picModels.count; i++) {
            [indexPaths addObject:[NSIndexPath indexPathForItem:startIndex + i inSection:0]];
            JPPictureModel *picModel = picModels[i];
            // 创建遵守JPLiquidLayoutProtocol协议的viewModel
            JPCollectionViewCellViewModel *cellVM = [[JPCollectionViewCellViewModel alloc] initWithPicModel:picModel];
            [self.cellVMs addObject:cellVM];
        }
        // 使用JPLiquidLayoutTool工具类进行布局计算
        // 需要传入【整个】viewModel数组，和其他参数
        [JPLiquidLayoutTool updateItemFrames:self.cellVMs
                                 targetIndex:startIndex
                                  flowLayout:flowLayout
                                    maxWidth:self->_maxW
                                  baseHeight:self->_baseH
                              itemMaxWhScale:self->_maxWhScale
                                      maxCol:self->_maxCol];
        // 回到主线程进行刷新
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.collectionView.mj_header endRefreshing];
            [self.collectionView.mj_footer endRefreshing];
            [UIView animateWithDuration:0.85 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:0.1 options:kNilOptions animations:^{
                [self.collectionView performBatchUpdates:^{
                    [self.collectionView insertItemsAtIndexPaths:indexPaths];
                } completion:^(BOOL finished) {
                    self.collectionView.mj_footer.hidden = NO;
                    self.collectionView.mj_header.hidden = YES;
                    if (self.cellVMs.count > 300) {
                        [self.collectionView.mj_footer endRefreshingWithNoMoreData];
                    }
                }];
            } completion:nil];
        });
    });
}

- (NSInteger)numberOfItems {
    return self.cellVMs.count;
}

- (void)setupCell:(JPCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {
    cell.pictureView.image = [UIImage imageNamed:[self.cellVMs[indexPath.item] picModel].picName];
}

- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath {
    JPCollectionViewCellViewModel *cellVM = self.cellVMs[indexPath.item];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    switch (self.segmentedControl.selectedSegmentIndex) {
        case 0:
        {
            [self.cellVMs insertObject:[[JPCollectionViewCellViewModel alloc] initWithPicModel:[JPPictureModel randomPicModel:cellVM.picModel.picName]] atIndex:indexPath.item];
            break;
        }
            
        case 1:
        {
            [self.cellVMs removeObjectAtIndex:indexPath.item];
            break;
        }
            
        case 2:
        {
            [self.cellVMs replaceObjectAtIndex:indexPath.item withObject:[[JPCollectionViewCellViewModel alloc] initWithPicModel:[JPPictureModel randomPicModel:cellVM.picModel.picName]]];
            break;
        }
            
    }
    
    [JPLiquidLayoutTool updateItemFrames:self.cellVMs
                             targetIndex:indexPath.item
                              flowLayout:flowLayout
                                maxWidth:_maxW
                              baseHeight:_baseH
                          itemMaxWhScale:_maxWhScale
                                  maxCol:_maxCol];
}

#pragma mark - <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPCollectionViewCellViewModel *cellVM = self.cellVMs[indexPath.item];\
    return cellVM.jp_itemFrame.size;
}

@end
