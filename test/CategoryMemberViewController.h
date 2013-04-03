//
//  MasterViewController.h
//  test
//
//  Created by Brett Callaghan on 5/9/12.
//  Copyright (c) 2012 Mellmo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Categories.h"


@interface CategoryMemberViewController : UITableViewController <NSFetchedResultsControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) Categories * categories;
@property (nonatomic, retain) UISegmentedControl *fetchControl;

- (void)refresh:(id)sender;
@end
