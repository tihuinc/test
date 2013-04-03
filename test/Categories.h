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
@property (nonatomic, copy) NSDictionary *lastCategoriesDict;

- (void)writeToLocalStorage: (NSDictionary *)categoriesDict;
- (void)readFromLocalStorage;
- (NSArray *)allCategories;
- (NSArray *)allLastCategories;
- (NSArray *)allCategoryNames;
- (NSArray *)allCategoryMembersForCategory:(NSString *)categoryName;
- (NSArray *)allLastCategoryMembersForCategory:(NSString *)categoryName;

@end
