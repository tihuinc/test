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

- (void)saveDictionary: (NSDictionary *)categoriesDict;
- (NSArray *)allCategories;
- (NSArray *)allCategoryNames;
- (NSArray *)allCategoryMembersForCategory:(NSString *)categoryName;

@end
