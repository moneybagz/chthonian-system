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

@interface CompanyViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSURLConnectionDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

{
    NSMutableData *_responseData;
}
@property (nonatomic, retain) NSMutableArray *companyList;
@property (nonatomic, retain) IBOutlet  ProductViewController * productViewController;
@property (nonatomic, retain) IBOutlet  CompanyFormViewController *companyFormViewController;
@property (nonatomic, retain) IBOutlet  EditViewController *editViewController;
//@property (nonatomic, retain) Company *kompany;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) NSDictionary *jsonDictionary;
@property (nonatomic, retain) NSArray *dictionaryArray;
@property (nonatomic, retain) NSArray *stockPrices;

@property BOOL customEditingMode;
@property BOOL deleteMode;

@end
