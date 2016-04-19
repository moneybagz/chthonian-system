//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProductViewController : UITableViewController <UITableViewDelegate>
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSMutableArray *urls;


@end
