//
//  EditFormViewController.m
//  NavCtrl
//
//  Created by Clyfford Millet on 4/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EditFormViewController.h"
#import "Product.h"

@interface EditFormViewController ()

@end

@implementation EditFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    [_changeNameTextfield release];
    [_changeURLtextfield release];
    [super dealloc];
}
- (IBAction)doneButton:(id)sender {
    
    
    self.product.productName = self.changeNameTextfield.text;
    self.product.productUrl = self.changeURLtextfield.text;
    
    [self.navigationController popToViewController:self.productViewController animated:YES];
}

@end
