//
//  IRMineViewController.m
//  iReader
//
//  Created by zouzhiyong on 2018/3/12.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRMineViewController.h"
#import "IRSettingViewController.h"
#import "IRCommonArrowCell.h"
#import "IRCommonCellModel.h"
#import "IRCommonCellSectionModel.h"
#import "IRCommonTextCell.h"
#import "IRCommonSwitchCell.h"
#import "IRSettingViewController.h"

@interface IRMineViewController ()<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<IRCommonCellSectionModel *> *mineInfos;

@end

@implementation IRMineViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self commonInit];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

- (void)dealloc
{
    self.collectionView.delegate = nil;
    self.collectionView.dataSource = nil;
}

#pragma mark - UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.mineInfos.count;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    IRCommonCellSectionModel *sectionModel = [self.mineInfos safeObjectAtIndex:section];
    return sectionModel.items.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRCommonCellSectionModel *sectionModel = [self.mineInfos safeObjectAtIndex:indexPath.section];
    IRCommonCellModel *settingModel = [sectionModel.items safeObjectAtIndex:indexPath.row];
    if (settingModel.cellType == IRCommonCellTypeArrow) {
        IRCommonArrowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRCommonArrowCell" forIndexPath:indexPath];
        cell.commonCellModel = settingModel;
        return cell;
    } else if (settingModel.cellType == IRCommonCellTypeText) {
        IRCommonTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRCommonTextCell" forIndexPath:indexPath];
        cell.commonCellModel = settingModel;
        return cell;
    } else {
        return  [collectionView dequeueReusableCellWithReuseIdentifier:@"defaultCell" forIndexPath:indexPath];
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.5];
        return header;
    } else {
        return [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:@"footer" forIndexPath:indexPath];
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.width, 44);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(collectionView.width, 20);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRCommonCellSectionModel *sectionModel = [self.mineInfos safeObjectAtIndex:indexPath.section];
    IRCommonCellModel *settingModel = [sectionModel.items safeObjectAtIndex:indexPath.row];
    if (settingModel.clickedHandler) {
        settingModel.clickedHandler(settingModel);
    }
}

#pragma mark - DataSource

- (void)setupMineInfos
{
    NSMutableArray *tempSettingInfos = [NSMutableArray array];
    __weak typeof(self) weakSelf = self;
    
    IRCommonCellSectionModel *commonSection = [[IRCommonCellSectionModel alloc] init];
    IRCommonCellModel *setting = [[IRCommonCellModel alloc] init];
    setting.title = @"设置";
    setting.imageName = @"reader_more_setting";
    setting.cellType = IRCommonCellTypeArrow;
    setting.clickedHandler = ^(IRCommonCellModel * _Nonnull cellModel) {
        [weakSelf onSettingCellClicked];
    };
    
    commonSection.items = @[setting];
    [tempSettingInfos addObject:commonSection];
    
    self.mineInfos = [tempSettingInfos copy];
}

#pragma mark -Actions

- (void)onSettingCellClicked
{
    IRSettingViewController *vc = [[IRSettingViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - Private

- (void)commonInit
{
    self.title = @"我的";
    [self setupMineInfos];
    [self setupLeftBackBarButton];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate   = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[IRCommonTextCell class] forCellWithReuseIdentifier:@"IRCommonTextCell"];
    [collectionView registerClass:[IRCommonArrowCell class] forCellWithReuseIdentifier:@"IRCommonArrowCell"];
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"defaultCell"];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
              withReuseIdentifier:@"header"];
    [collectionView registerClass:[UICollectionReusableView class]
       forSupplementaryViewOfKind:UICollectionElementKindSectionFooter
              withReuseIdentifier:@"footer"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
}

@end
