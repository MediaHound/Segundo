//
//  SGDTableViewController.h
//  Segundo
//
//  Created by Dustin Bachrach on 4/2/14.
//  Copyright (c) 2014 MediaHound. All rights reserved.
//

#import "SGDStoreViewController.h"


/**
 * Use SGDTableViewController as a superclass for any
 * table-based View Controller that you want to enhance with Segundo.
 * Note, this is not a subclass of UITableViewController, just UIViewController.
 */
@interface SGDTableViewController : SGDStoreViewController <UIScrollViewDelegate>

/**
 * The table view that this controller owns.
 */
@property (weak, nonatomic) IBOutlet UITableView* tableView;

@end
