//
//  CompanyViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProductViewController;

@interface CompanyViewController : UITableViewController <UITableViewDelegate>

@property (nonatomic, retain) NSMutableArray *companyList;
@property (nonatomic, retain) NSMutableArray *productLists;
@property (nonatomic, retain) NSMutableArray *urlLists;


@property (nonatomic, retain) IBOutlet  ProductViewController * productViewController;

@end
