//
//  ProductViewController.h
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductFormViewController;
@class EditFormViewController;


@interface ProductViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSMutableArray *buttons;

@property (retain, nonatomic) IBOutlet UITableView *productsTableView;
@property (nonatomic, retain) IBOutlet ProductFormViewController *productFormViewController;
@property (nonatomic, retain) IBOutlet EditFormViewController *editFormViewController;


@property (nonatomic, retain) UITableView *tableView;



@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UIBarButtonItem *buttonWithToolbar;
//@property (nonatomic) BOOL editor;

@property int companyPrimaryKey;


@property (retain, nonatomic) IBOutlet UIImageView *companyLogoImage;
@property (retain, nonatomic) IBOutlet UILabel *companyNameLabel;
- (IBAction)addProductButton:(id)sender;
@property (nonatomic, retain) UIView *productOpeningView;






@end
