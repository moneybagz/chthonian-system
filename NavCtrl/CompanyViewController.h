//
//  CompanyViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyFormViewController.h"

@class ProductViewController;
@class Company;
@class EditViewController;

@interface CompanyViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate>

{
    NSMutableData *_responseData;
}
@property (nonatomic, retain) NSMutableArray *companyList;
@property (nonatomic, retain) IBOutlet  ProductViewController * productViewController;
@property (nonatomic, retain) IBOutlet  CompanyFormViewController *companyFormViewController;
@property (nonatomic, retain) IBOutlet  EditViewController *editViewController;
//@property (nonatomic, retain) Company *kompany;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) NSDictionary *jsonDictionary;
@property (nonatomic, retain) NSDictionary *stockQuotes;

@end
