//
//  IRReaderBackgroundSelectView.m
//  iReader
//
//  Created by zzyong on 2018/8/28.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import <Masonry.h>
#import "IRReaderBackgroundSelectView.h"
#import "IRReaderBackgroundSelectCell.h"

@interface IRReaderBackgroundSelectView () <UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) NSArray<UIColor *> *bgColors;
@property (nonatomic, strong) NSIndexPath *cureentIndexPath;

@end

@implementation IRReaderBackgroundSelectView

- (instancetype)init
{
    if (self = [super init]) {
        self.bgColors = IR_READER_CONFIG.readerBgSelectColors;
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    CGFloat collectionViewH = 25;
    CGFloat collectionViewY = ([IRReaderBackgroundSelectView viewHeight] - collectionViewH) * 0.5;
    CGRect frame = CGRectMake(0, collectionViewY, [IRUIUtilites UIScreenMinWidth], collectionViewH);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:frame
                                                          collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate   = self;
    collectionView.backgroundColor      = [UIColor whiteColor];
    collectionView.alwaysBounceHorizontal = YES;
    collectionView.showsHorizontalScrollIndicator = NO;
    [collectionView registerClass:[IRReaderBackgroundSelectCell class] forCellWithReuseIdentifier:@"IRReaderBackgroundSelectCell"];
    [self addSubview:collectionView];
    self.collectionView = collectionView;
    
    UIView *topLine = [[UIView alloc] init];
    topLine.backgroundColor = [UIColor ir_separatorLineColor];
    [self addSubview:topLine];
    [topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(0.5);
        make.top.right.left.equalTo(self);
    }];
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.bgColors.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UIColor *cellColor =  [self.bgColors safeObjectAtIndex:indexPath.row];
    IRReaderBackgroundSelectCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"IRReaderBackgroundSelectCell" forIndexPath:indexPath];
    cell.backgroundColor = cellColor;
    BOOL isSelected = CGColorEqualToColor(IR_READER_CONFIG.readerBgSelectColor.CGColor, cellColor.CGColor);
    if (isSelected) {
        self.cureentIndexPath = indexPath;
        [collectionView scrollToItemAtIndexPath:indexPath
                               atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally
                                        animated:NO];
    }
    [cell setSelected:isSelected];
    return cell;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 15, 0, 15);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(64, collectionView.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:self.cureentIndexPath];
    [cell setSelected:NO];
    self.cureentIndexPath = indexPath;
    
    [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    
     UIColor *cellColor =  [self.bgColors safeObjectAtIndex:indexPath.row];
    IR_READER_CONFIG.readerBgColor = cellColor;
    if ([self.delegate respondsToSelector:@selector(readerBackgroundSelectViewDidSelectBackgroundColor:)]) {
        [self.delegate readerBackgroundSelectViewDidSelectBackgroundColor:cellColor];
    }
}

+ (CGFloat)viewHeight
{
    return 60;
}

@end
