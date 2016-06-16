//
//  EditFormViewController.h
//  NavCtrl
//
//  Created by Clyfford Millet on 4/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductViewController;
#import "Product.h"
@class WebViewController;

@interface EditFormViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *changeNameTextfield;
@property (retain, nonatomic) IBOutlet UITextField *changeURLtextfield;
@property (retain, nonatomic) ProductViewController *productViewController;
@property (retain, nonatomic) WebViewController *webViewController;

@property (nonatomic, retain) Product *product;
@property int companyPrimaryKey;


- (IBAction)doneButton:(id)sender;

@end
