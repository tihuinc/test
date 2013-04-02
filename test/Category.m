//
//  Category.m
//  test
//
//  Created by Hu, Leon on 4/2/13.
//  Copyright (c) 2013 Mellmo. All rights reserved.
//

#import "Category.h"


@implementation Category

@synthesize categoryDict;

- (id)init {
    if (self = [super init]) {
        [self readFromLocalStorage];
    }
    return self;
}

- (NSArray *)allCategories {
    return NULL;
}

- (NSArray *)allCountries {
    return NULL;
}

- (void)readFromLocalStorage {
    self.categoryDict = [[NSUserDefaults standardUserDefaults] objectForKey:@"CategoryKey"];
}

- (void)writeToLocalStorage {
    [[NSUserDefaults standardUserDefaults] setObject:self.categoryDict forKey:@"CategoryKey"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
