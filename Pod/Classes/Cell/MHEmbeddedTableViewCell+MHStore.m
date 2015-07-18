//
//  MHEmbeddedTableViewCell+MHStore.m
//  mediaHound
//
//  Created by Dustin Bachrach on 3/22/14.
//  Copyright (c) 2014 Media Hound. All rights reserved.
//

#import "MHEmbeddedTableViewCell+MHStore.h"


@implementation MHEmbeddedTableViewCell (MHStore)

- (void)configureWithMHStore:(MHStore*)store
{
    self.store = store;
    
    [self.tableView reloadData];
}

@end
