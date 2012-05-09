//
//  DetailViewController.h
//  test
//
//  Created by Brett Callaghan on 5/9/12.
//  Copyright (c) 2012 Mellmo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (strong, nonatomic) IBOutlet UILabel *detailDescriptionLabel;

@end
