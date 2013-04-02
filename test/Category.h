//
//  Category.h
//  test
//
//  Created by Hu, Leon on 4/2/13.
//  Copyright (c) 2013 Mellmo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Category : NSObject

@property (nonatomic, copy) NSDictionary *categoryDict;

- (void)writeToLocalStorage;
- (void)readFromLocalStorage;
- (NSArray *)allCategories;
- (NSArray *)allCountries;

@end
