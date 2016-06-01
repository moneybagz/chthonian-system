//
//  ProductFormViewController.h
//  NavCtrl
//
//  Created by Clyfford Millet on 4/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ProductViewController;
@class Product;

@interface ProductFormViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *productTextfield;
@property (retain, nonatomic) IBOutlet UITextField *productURLtextfield;
//@property (retain, nonatomic) IBOutlet UITextField *companyTextfield;
@property (retain, nonatomic) ProductViewController *productViewController;
@property int companyPrimaryKey;
@property int productCount;
@property (retain, nonatomic) NSString *companyName;



- (IBAction)doneButton:(id)sender;


@end
