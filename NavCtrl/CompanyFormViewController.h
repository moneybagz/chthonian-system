//
//  CompanyFormViewController.h
//  NavCtrl
//
//  Created by Clyfford Millet on 4/26/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Company;
@class CompanyViewController;

@interface CompanyFormViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *companyTextfield;
@property (nonatomic, retain) UIToolbar *toolbar;


- (IBAction)doneButton:(id)sender;



@end
