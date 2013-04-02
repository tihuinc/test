//
//  Category.m
//  test
//
//  Created by Hu, Leon on 4/2/13.
//  Copyright (c) 2013 Mellmo. All rights reserved.
//

#import "Category.h"

@interface Category()

@property (nonatomic, copy) NSDictionary *categoryDict;
- (void)writeToLocalStorage;
- (void)readFromLocalStorage;

@end

@implementation Category

- (id)init {
    if (self = [super init]) {
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
