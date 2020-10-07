//
//  IRDebugViewController.m
//  iReader
//
//  Created by zzyong on 2018/10/1.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "IRDebugViewController.h"
#import "IRCommonSwitchCell.h"
#import "IRCommonCellModel.h"
#import "IRDebugConst.h"
#import "AppDelegate+Debug.h"
#import "DTCoreTextLayoutFrame.h"
#import "IRCommonArrowCell.h"

@interface IRDebugViewController ()
<
UICollectionViewDelegateFlowLayout,
UICollectionViewDataSource,
IRCommonSwitchCellDelegate
>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<IRCommonCellModel *> *debugInfos;

@end

@implementation IRDebugViewController

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

#pragma mark - IRCommonSwitchCellDelegate

- (void)switchCellDidClickSwitchButton:(IRCommonSwitchCell *)cell
{
    IRCommonCellModel *model = cell.commonCellModel;
    
    if ([model.cellKind isEqualToString:@"DTCoreText"]) {
        [self onDTDebugCellValueChanged:cell.switchView.isOn];
    } else if ([model.cellKind isEqualToString:@"flex"]) {
        [self onFlexCellValueChanged:cell.switchView.isOn];
    }
}

- (void)onFlexCellValueChanged:(BOOL)value
{
    [[IRCacheManager sharedInstance] asyncSetObject:@(!value) forKey:kFlexDebugDisableCacheKey];
    
    [[(AppDelegate *)[UIApplication sharedApplication].delegate flexWindow] setHidden:!value];
}

- (void)onDTDebugCellValueChanged:(BOOL)value
{
    [[IRCacheManager sharedInstance] asyncSetObject:@(value) forKey:kDTCoreTextDebugEnableCacheKey];
    
    [DTCoreTextLayoutFrame setShouldDrawDebugFrames:value];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.debugInfos.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRCommonCellModel *settingModel = [self.debugInfos safeObjectAtIndex:indexPath.row];
    if (settingModel.cellType == IRCommonCellTypeSwitch) {
        IRCommonSwitchCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRCommonSwitchCell" forIndexPath:indexPath];
        cell.delegate = self;
        cell.commonCellModel = settingModel;
        return cell;
    } else if (settingModel.cellType == IRCommonCellTypeArrow) {
        IRCommonArrowCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRCommonArrowCell" forIndexPath:indexPath];
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
    IRCommonCellModel *settingModel = [self.debugInfos safeObjectAtIndex:indexPath.row];
    if (settingModel.clickedHandler) {
        settingModel.clickedHandler(settingModel);
    }
}

#pragma mark - DataSource

- (void)setupDebugInfos
{
    IRCommonCellModel *flex = [[IRCommonCellModel alloc] init];
    flex.title = @"FLEX";
    flex.cellKind = @"flex";
    flex.cellType = IRCommonCellTypeSwitch;
    flex.isSwitchOn = ![[[IRCacheManager sharedInstance] objectForKey:kFlexDebugDisableCacheKey] boolValue];
    
    IRCommonCellModel *dtDebug = [[IRCommonCellModel alloc] init];
    dtDebug.title = @"DTCoreText Debug";
    dtDebug.cellKind = @"DTCoreText";
    dtDebug.cellType = IRCommonCellTypeSwitch;
    dtDebug.isSwitchOn = [[[IRCacheManager sharedInstance] objectForKey:kDTCoreTextDebugEnableCacheKey] boolValue];
    
    self.debugInfos = @[flex, dtDebug];
}

#pragma mark - Private

- (void)commonInit
{
    self.title = @"开发实验室";
    [self setupDebugInfos];
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
    collectionView.backgroundColor      = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    
    [collectionView registerClass:[IRCommonSwitchCell class] forCellWithReuseIdentifier:@"IRCommonSwitchCell"];
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

