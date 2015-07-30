//
//  SGDEmbeddedCollectionViewCell.m
//  Segundo
//
//  Created by Dustin Bachrach on 3/22/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDEmbeddedCollectionViewCell.h"
#import "SGDStore.h"
#import "SGDSection.h"
#import "SGDRow.h"
#import "SGDStoreDataSource.h"
#import "SGDStoreDelegate.h"

#import <KVOController/FBKVOController.h>
#import "FBKVOController+StillValid.h"
#import <AtSugar/AtSugar.h>


@implementation SGDEmbeddedCollectionViewCell

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
    self.dataSource = [[SGDStoreDataSource alloc] init];
    self.storeDelegate = [[SGDStoreDelegate alloc] init];
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

- (void)setStore:(SGDStore*)store
{
    @weakSelf()
    
    for (Class<SGDCollectionCell> cellClass in store.allCellClasses) {
        [cellClass registerInCollectionView:self.collectionView];
    }
    
    for (SGDSection* section in store.sections) {
        for (SGDRow* row in section.rows) {
            [self.KVOController observeOnMainThread:row
                                keyPath:@"cellClass"
                                options:NSKeyValueObservingOptionNew
                                  block:^(id observer, id object, NSDictionary* change) {

                                      [(Class<SGDCollectionCell>)row.cellClass registerInCollectionView:weakSelf.collectionView];
                                  }
                             stillValid:^BOOL{
                                 return YES;
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
}

@end
