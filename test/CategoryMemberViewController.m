//
//  MasterViewController.m
//  test
//
//  Created by Brett Callaghan on 5/9/12.
//  Copyright (c) 2012 Mellmo. All rights reserved.
//

#import "CategoryMemberViewController.h"
#import "TestUtils.h"
#import "AppDelegate.h"
#import "CategoryMember.h"


@interface CategoryMemberViewController ()
- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath;
@end


#pragma mark -
@implementation CategoryMemberViewController

@synthesize fetchedResultsController = _fetchedResultsController;
@synthesize managedObjectContext = _managedObjectContext;
@synthesize categories;
@synthesize fetchControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    if (!(self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        return nil;
    }
    return self;
}
							
- (void)dealloc
{
    [_fetchedResultsController release];
    [_managedObjectContext release];
    [super dealloc];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initializeToolbar];

    self.categories = [[[Categories alloc] init] autorelease];
    
    UIBarButtonItem * barButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemRefresh target:self action:@selector(refresh:)] autorelease];
    self.navigationItem.rightBarButtonItem = barButtonItem;
}

- (void)initializeToolbar{
    NSArray *itemArray = [NSArray arrayWithObjects: [UIImage imageNamed:@"up.png"], [UIImage imageNamed:@"down.png"], @"All", nil];
    self.fetchControl = [[[UISegmentedControl alloc] initWithItems:itemArray] autorelease];
    [fetchControl addTarget:self
                         action:@selector(changeFilter:)
               forControlEvents:UIControlEventValueChanged];
    [self.navigationController.toolbar addSubview:fetchControl];

    self.navigationController.toolbarHidden = NO;
    [fetchControl release];
}

- (void)changeFilter:(id)sender {
    self.fetchedResultsController = nil;
    [self fetch];
}

- (void)fetch {
    NSError *error = nil;
    BOOL success = [self.fetchedResultsController performFetch:&error];
    NSAssert2(success, @"Unhandled error performing fetch at CategoryMemberViewController, line %d: %@", __LINE__, [error localizedDescription]);
    [self.tableView reloadData];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait || interfaceOrientation == UIInterfaceOrientationMaskLandscape);
}

- (void)refresh:(id)sender
{
    /*
     The following method generates an updated json file containing updated values for the category displayed by this view controller.
     The categories.json file is located in this application's document's directory.
     1) Import the contents of this file (NSJSONSerialization).
     2) Parse the json data and update the "value" property of the CategoryMember Core Data entities.
     3) Set the CategoryMember object's "previousValue" (See README) to its previous value.
     4) Don't add duplicates.
     5) You will need to add NSManagedObject instances to the view controller's managedObjectContext.
     */
    [TestUtils refreshCategoriesJSONFile];
    [self parseJSONFileForCategories];
}

- (void)parseJSONFileForCategories {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:@"categories.json"];
    NSString * content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    NSData* data = [content dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *jsonDict = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    [self.categories writeToLocalStorage:jsonDict];
    [self processCategoryData];
}

- (void)processCategoryData{
    NSString * categoryName = [[self.categories allCategoryNames] objectAtIndex:0];
    self.navigationItem.title = categoryName;
    NSArray * members = [self.categories allCategoryMembersForCategory:categoryName];
    for (NSDictionary *member in members){
        [self addToCategoryMemberCoreData:[member objectForKey:@"name"] Value:[member objectForKey:@"value"]];
    }
}

- (void)addToCategoryMemberCoreData:(NSString *)name Value:(NSNumber *)value
{
    NSManagedObjectContext *moc = [self.fetchedResultsController managedObjectContext];
    NSEntityDescription *entityDescription = [NSEntityDescription
                                              entityForName:@"CategoryMember" inManagedObjectContext:moc];

    NSFetchRequest *request = [[[NSFetchRequest alloc] init] autorelease];
    [request setEntity:entityDescription];
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name == %@", name];
    [request setPredicate:predicate];
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc]
                                        initWithKey:@"name" ascending:YES] autorelease];
    [request setSortDescriptors:@[sortDescriptor]];
    
    NSError *error;
    NSArray *array = [moc executeFetchRequest:request error:&error];
    if ([array count] == 0)
    {
        CategoryMember *categoryMember = [NSEntityDescription insertNewObjectForEntityForName:@"CategoryMember" inManagedObjectContext:moc];
        categoryMember.name = name;
        categoryMember.value = value;
        categoryMember.difference = value;
    }
    else{
        CategoryMember *member = [array objectAtIndex:0];
        member.previousValue = member.value;
        member.name = name;
        member.value = value;
        member.difference =  [NSNumber numberWithDouble:([member.value doubleValue] - [member.previousValue doubleValue])];
    }

    if (![moc save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
}

#pragma mark UITableView

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil] autorelease];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


#pragma mark NSFetchedResultsController

- (NSFetchedResultsController *)fetchedResultsController
{
    if (nil != _fetchedResultsController) {
        return _fetchedResultsController;
    }

    NSFetchRequest *fetchRequest = [[[NSFetchRequest alloc] init] autorelease];
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"CategoryMember" inManagedObjectContext:self.managedObjectContext];
    [fetchRequest setEntity:entity];
    
    [fetchRequest setFetchBatchSize:10];
    if ([self.fetchControl selectedSegmentIndex] == 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"difference >= 0"];
        [fetchRequest setPredicate:predicate];
    }
    else if ([self.fetchControl selectedSegmentIndex] == 1){
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"difference < 0"];
        [fetchRequest setPredicate:predicate];
    }
    
    NSSortDescriptor *sortDescriptor = [[[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES] autorelease];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    [fetchRequest setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *aFetchedResultsController = [[[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil cacheName:nil] autorelease];
    aFetchedResultsController.delegate = self;
    self.fetchedResultsController = aFetchedResultsController;
    
	NSError *error = nil;
	if (![self.fetchedResultsController performFetch:&error]) {
	     // Replace this implementation with code to handle the error appropriately.
	     // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development. 
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return _fetchedResultsController;
}    

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type
{
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeUpdate:
            [self configureCell:[tableView cellForRowAtIndexPath:indexPath] atIndexPath:indexPath];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath]withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    NSManagedObject *object = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = [[object valueForKey:@"name"] description];
    cell.textLabel.backgroundColor = [UIColor clearColor];
    cell.detailTextLabel.text = [object primitiveValueForKey:@""];
    cell.detailTextLabel.backgroundColor = [UIColor clearColor];
    
    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
    NSNumber *difference = [object primitiveValueForKey:@"difference"];

    if ([difference doubleValue] > 0)
    {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"+%@", [numberFormatter stringFromNumber:difference]];
        cell.imageView.image = [self maskImageWithColor:@"green" withMask:[UIImage imageNamed:@"Arrow.png"]];
    }
    else {
        cell.detailTextLabel.text = [numberFormatter stringFromNumber:difference];
        cell.imageView.image = [self maskImageWithColor:@"red" withMask:[UIImage imageNamed:@"Arrow.png"]];
        cell.imageView.center = CGPointMake(100.0, 100.0);
        cell.imageView.transform = CGAffineTransformMakeRotation(2*M_PI_2);
    }

    [numberFormatter release];
}

- (UIImage*) maskImageWithColor:(NSString *)triangleColor withMask:(UIImage *) mask
{
    UIImage *image;
    if ([triangleColor isEqualToString:@"green"]){
       image = [self imageWithColor:[UIColor greenColor]];
    }
    else{
       image = [self imageWithColor:[UIColor redColor]];
    }

    CGImageRef imageReference = image.CGImage;
    CGImageRef maskReference = mask.CGImage;
    
    CGImageRef imageMask = CGImageMaskCreate(CGImageGetWidth(maskReference),
                                             CGImageGetHeight(maskReference),
                                             CGImageGetBitsPerComponent(maskReference),
                                             CGImageGetBitsPerPixel(maskReference),
                                             CGImageGetBytesPerRow(maskReference),
                                             CGImageGetDataProvider(maskReference),
                                             NULL, // Decode is null
                                             YES // Should interpolate
                                             );
    
    CGImageRef maskedReference = CGImageCreateWithMask(imageReference, imageMask);
    CGImageRelease(imageMask);
    
    UIImage *maskedImage = [UIImage imageWithCGImage:maskedReference];
    CGImageRelease(maskedReference);
    
    return maskedImage;
}

- (UIImage *)imageWithColor:(UIColor *)imageColor {
    CGRect rect = CGRectMake(0, 0, 200, 200);
    // Create a 1 by 1 pixel context
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [imageColor setFill];
    UIRectFill(rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
