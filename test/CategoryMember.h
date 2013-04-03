//
//  CategoryMember.h
//  test
//
//  Created by Leon Hu on 4/2/13.
//  Copyright (c) 2013 Mellmo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface CategoryMember : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSNumber * previousValue;
@property (nonatomic, retain) NSNumber * value;

@end
