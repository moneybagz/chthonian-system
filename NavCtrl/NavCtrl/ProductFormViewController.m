//
//  ProductFormViewController.m
//  NavCtrl
//
//  Created by Clyfford Millet on 4/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "ProductFormViewController.h"
#import "DataAccessObject.h"
#import "ProductViewController.h"
#import "CompanyViewController.h"


@interface ProductFormViewController ()

@end

@implementation ProductFormViewController

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
    [_productTextfield release];
    [_productURLtextfield release];
    [_companyTextfield release];
    [super dealloc];
}

- (IBAction)doneButton:(id)sender {
    //NSString *productName = self.productTextfield.text;
    
    
    
    [[DataAccessObject sharedDAO]createProductWithName:self.productTextfield.text productURL:self.productURLtextfield.text companyNameForProduct:self.productViewController.title];
    
//    for (Company *element in [[DataAccessObject sharedCompanies]allCompanies]){
//        if (element.companyName == self.productViewController.title) {
//            NSLog(@"%@", element.products);
//        }
//    }
    
   [self.navigationController popToViewController:self.productViewController animated:YES];
}
@end
