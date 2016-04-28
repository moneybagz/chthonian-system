//
//  EditViewController.h
//  NavCtrl
//
//  Created by Clyfford Millet on 4/28/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
@class Company;

@interface EditViewController : UIViewController

@property (retain, nonatomic) IBOutlet UITextField *changeNameTextfield;
@property (retain, nonatomic) Company *company;


- (IBAction)doneButton:(id)sender;

@end
