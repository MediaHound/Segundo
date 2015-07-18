//
//  MHEmbeddedCollectionViewCell.m
//  mediaHound
//
//  Created by Dustin Bachrach on 3/22/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHEmbeddedCollectionViewCell.h"
#import "MHStore.h"
#import "MHSection.h"
#import "MHRow.h"
#import "MHStoreDataSource.h"
#import "MHStoreDelegate.h"
#import "MHCircularLoadingIndicator.h"

#import <KVOController/FBKVOController.h>
#import <KVOController/NSObject+FBKVOController.h>
#import <AtSugar/AtSugar.h>


@implementation MHEmbeddedCollectionViewCell

- (instancetype)initWithCoder:(NSCoder*)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self defaultInitializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self defaultInitializer];
    }
    return self;
}

- (void)defaultInitializer
{
    self.dataSource = [[MHStoreDataSource alloc] init];
    self.storeDelegate = [[MHStoreDelegate alloc] init];
    self.storeDelegate.scrollViewDelegate = self;
}

- (void)awakeFromNib
{
    self.collectionView.dataSource = self.dataSource;
    self.collectionView.delegate = self.storeDelegate;
    self.collectionView.scrollsToTop = NO;
}

- (void)prepareForReuse
{
    [super prepareForReuse];
    [self.KVOController unobserveAll];
}

@declare_class_property (hasDynamicSize, YES)

- (CGSize)dynamicSize
{
    [self.collectionView reloadData];
    const CGSize size = self.collectionView.collectionViewLayout.collectionViewContentSize;
    return size;
}

- (void)setStore:(MHStore*)store
{
    for (Class<MHCollectionCell> cellClass in store.allCellClasses) {
        [cellClass registerInCollectionView:self.collectionView];
    }
    
    for (MHSection* section in store.sections) {
        for (MHRow* row in section.rows) {
            [self.KVOController observeOnMainThread:row
                                keyPath:@"cellClass"
                                options:NSKeyValueObservingOptionNew
                                  block:^(id observer, id object, NSDictionary* change) {
                                      [(Class<MHCollectionCell>)row.cellClass registerInCollectionView:self.collectionView];
                                  }];
        }
    }
    
    _store = store;
    _store.delegate = self.row.store.delegate;
    
    self.dataSource.store = store;
    self.storeDelegate.store = store;
}

- (void)configureForEmpty
{
    self.store = nil;
    
    [self.collectionView reloadData];
    
    [MHCircularLoadingIndicator showLoadingIndicatorOnView:self.collectionView];
}

@end
