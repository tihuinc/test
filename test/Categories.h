//
//  Categories.h
//  test
//
//  Created by Hu, Leon on 4/2/13.
//  Copyright (c) 2013 Mellmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Categories : NSObject

@property (nonatomic, copy) NSDictionary *categoriesDict;

- (void)writeToLocalStorage: (NSDictionary *)categoriesDict;
- (void)readFromLocalStorage;
- (NSArray *)allCategories;
- (NSArray *)allCategoryNames;

@end