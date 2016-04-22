//
//  DGArticlesViewController.h
//  Dogo
//
//  Created by Marsal on 04/09/15.
//  Copyright (c) 2015 Marsal Silveira. All rights reserved.
//

#import "DGArticleFetcher.h"

/**
 * Main View Controller responsible to show all Articles in a TableView
 */
@interface DGArticlesViewController : UITableViewController <DGArticleFetcherDelegate>

@end