//
//  JPCollectionViewController.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/14.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPCollectionViewController.h"

@implementation JPCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor colorWithRed:208.0 / 255.0 green:84.0 / 255.0 blue:116.0 / 255.0 alpha:1.0];
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"JPCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:JPCollectionViewCellID];
    
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(insertCellVMs)];
    
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(insertCellVMs)];
    self.collectionView.mj_footer.hidden = YES;
    
    [self.collectionView.mj_header beginRefreshing];
    
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:@[@"增加", @"删除", @"替换"]];
    segmentedControl.selectedSegmentIndex = 0;
    segmentedControl.frame = CGRectMake(0, 0, 100, 30);
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:segmentedControl];
    self.navigationItem.rightBarButtonItem = barButtonItem;
    self.segmentedControl = segmentedControl;
}

- (void)insertCellVMs {}

- (NSInteger)numberOfItems {return 0;}

- (void)setupCell:(JPCollectionViewCell *)cell indexPath:(NSIndexPath *)indexPath {}

- (void)didSelectCellAtIndexPath:(NSIndexPath *)indexPath {}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self numberOfItems];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JPCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:JPCollectionViewCellID forIndexPath:indexPath];
    [self setupCell:cell indexPath:indexPath];
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    [self didSelectCellAtIndexPath:indexPath];
    
    [UIView animateWithDuration:0.85 delay:0 usingSpringWithDamping:0.55 initialSpringVelocity:0.1 options:kNilOptions animations:^{
        [self.collectionView performBatchUpdates:^{
            switch (self.segmentedControl.selectedSegmentIndex) {
                case 0:
                {
                    [self.collectionView insertItemsAtIndexPaths:@[indexPath]];
                    break;
                }
                case 1:
                {
                    [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
                    break;
                }
                case 2:
                {
                    [self.collectionView reloadItemsAtIndexPaths:@[indexPath]];
                    break;
                }
            }
        } completion:nil];
    } completion:nil];
}

@end
