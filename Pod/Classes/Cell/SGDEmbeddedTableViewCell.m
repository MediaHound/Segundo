//
//  SGDEmbeddedTableViewCell.m
//  Segundo
//
//  Created by Dustin Bachrach on 3/22/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDEmbeddedTableViewCell.h"
#import "SGDStore.h"
#import "SGDRow.h"
#import "SGDStoreDataSource.h"
#import "SGDStoreDelegate.h"

#import <AtSugar/AtSugar.h>


@implementation SGDEmbeddedTableViewCell

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
    self.tableView.dataSource = self.dataSource;
    self.tableView.delegate = self.storeDelegate;
    self.tableView.scrollsToTop = NO;
}

@declare_class_property (hasDynamicSize, YES)

- (CGSize)dynamicSize
{
    [self.tableView reloadData];
    const CGSize size = self.tableView.contentSize;
    return size;
}

- (void)setStore:(SGDStore*)store
{
    // TODO: All cell classes should just include header footers too
    for (Class<SGDTableCell> cellClass in store.allCellClasses) {
        [cellClass registerInTableView:self.tableView];
    }
    
    for (Class<SGDTableCell> cellClass in store.allHeaderFooterCellClasses) {
        [cellClass registerInTableView:self.tableView];
    }
    
    _store = store;
    _store.delegate = self.row.store.delegate;
    
    self.dataSource.store = store;
    self.storeDelegate.store = store;
}

@end
