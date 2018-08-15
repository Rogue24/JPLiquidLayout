//
//  JPTableViewController.m
//  JPLiquidLayout_Example
//
//  Created by 周健平 on 2018/8/13.
//  Copyright © 2018 Rogue24. All rights reserved.
//

#import "JPTableViewController.h"
#import "JPViewModelCollectionVC.h"
#import "JPFlowLayoutCollectionVC.h"

@interface JPTableViewController ()
@property (nonatomic, copy) NSArray *titles;
@end

@implementation JPTableViewController

static NSString * const reuseIdentifier = @"JPTableViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titles = @[@"使用ViewModel方式", @"使用系统FlowLayout方式"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier forIndexPath:indexPath];
    cell.textLabel.text = self.titles[indexPath.row];
    return cell;
}

#pragma mark -

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIViewController *vc;
    if (indexPath.row == 0) {
        JPViewModelCollectionVC *collectionVC = [JPViewModelCollectionVC collectionViewController];
        vc = collectionVC;
    } else {
        JPFlowLayoutCollectionVC *collectionVC = [JPFlowLayoutCollectionVC collectionViewController];
        vc = collectionVC;
    }
    vc.title = self.titles[indexPath.row];
    [self.navigationController pushViewController:vc animated:YES];
}

@end
