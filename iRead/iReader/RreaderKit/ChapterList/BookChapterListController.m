//
//  BookChapterListController.m
//  iReader
//
//  Created by zzyong on 2018/7/13.
//  Copyright © 2018年 zouzhiyong. All rights reserved.
//

#import "BookChapterListCell.h"
#import "BookChapterListController.h"
#import "IREpubHeaders.h"

@interface BookChapterListController () <UICollectionViewDelegateFlowLayout, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation BookChapterListController

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

#pragma mark - Private

- (void)commonInit
{
    self.title = @"目录";
    [self setupLeftBackBarButton];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupCollectionView];
}

- (void)setupCollectionView
{
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds
                                                          collectionViewLayout:flowLayout];
    collectionView.dataSource = self;
    collectionView.delegate   = self;
    collectionView.backgroundColor = [UIColor whiteColor];
    collectionView.alwaysBounceVertical = YES;
    collectionView.showsVerticalScrollIndicator = NO;
    collectionView.showsHorizontalScrollIndicator = NO;
    
    [collectionView registerClass:[BookChapterListCell class] forCellWithReuseIdentifier:@"BookChapterListCell"];
    
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    if (self.collectionView.numberOfSections && [self.collectionView numberOfItemsInSection:0] > self.selectChapterIndex) {
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.selectChapterIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

#pragma mark - UICollectionView

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.chapterList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    BookChapterListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"BookChapterListCell" forIndexPath:indexPath];
    cell.chapter = [self.chapterList objectAtIndex:indexPath.row];
    [cell setSelected:(indexPath.row == self.selectChapterIndex)];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    IRTocRefrence *chapter = [self.chapterList objectAtIndex:indexPath.row];
    CGSize titleSize = [chapter.title sizeWithAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:kChapterListCellFontSize]}];
    CGFloat cellHeight = ceil(titleSize.height) * ceil(titleSize.width / (collectionView.width - 20));
    return CGSizeMake(collectionView.width, cellHeight + 30);
}
                                                       
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    [self.navigationController popViewControllerAnimated:YES];
    if ([self.delegate respondsToSelector:@selector(bookChapterListControllerDidSelectChapterAtIndex:)]) {
        [self.delegate bookChapterListControllerDidSelectChapterAtIndex:indexPath.row];
    }
}

@end
