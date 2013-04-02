//
//  Categories.m
//  test
//
//  Created by Hu, Leon on 4/2/13.
//  Copyright (c) 2013 Mellmo. All rights reserved.
//

#import "Categories.h"


@implementation Categories

@synthesize categoriesDict;

- (id)init {
    if (self = [super init]) {
    }
    return self;
}

- (void)dealloc{
    [super dealloc];
    [categoriesDict release];
}

- (NSArray *)allCategories {
    if (self.categoriesDict != nil) {
        return self.categoriesDict[@"categories"];
    }
    return nil;
}

- (NSArray *)allCategoryNames {
    NSMutableArray *names = [NSMutableArray new];
    for (NSDictionary *category in [self allCategories]) {
        [names addObject:category[@"name"]];
    }
    return [names autorelease];
}

- (void)readFromLocalStorage {
    self.categoriesDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoriesKey"];
}

- (void)writeToLocalStorage: (NSDictionary *)categoriesDictionary {
    self.categoriesDict = categoriesDictionary;
    [[NSUserDefaults standardUserDefaults] setObject:categoriesDictionary forKey:@"CategoriesKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

@end