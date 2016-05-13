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


@interface ProductViewController : UITableViewController <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, retain) NSMutableArray *products;
@property (nonatomic, retain) NSMutableArray *buttons;

@property (nonatomic, retain) IBOutlet ProductFormViewController *productFormViewController;
@property (nonatomic, retain) IBOutlet EditFormViewController *editFormViewController;

@property (nonatomic, retain) UIToolbar *toolbar;
@property (nonatomic, retain) UIBarButtonItem *doneButton;
@property (nonatomic, retain) UIBarButtonItem *buttonWithToolbar;
//@property (nonatomic) BOOL editor;

@property int ID;





@end
