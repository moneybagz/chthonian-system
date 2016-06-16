//
//  EditFormViewController.m
//  NavCtrl
//
//  Created by Clyfford Millet on 4/27/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EditFormViewController.h"
#import "Product.h"
#import "DataAccessObject.h"
#import "ProductViewController.h"

@interface EditFormViewController ()

@end

@implementation EditFormViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UIBarButtonItem *rightButton = [[UIBarButtonItem alloc]
                                    initWithTitle:@"Save"
                                    style:UIBarButtonItemStyleBordered
                                    target:self
                                    action:@selector(save)];
    self.navigationItem.rightBarButtonItem = rightButton;
    
    UIBarButtonItem *leftButton = [[UIBarButtonItem alloc]
                                   initWithTitle:@"Cancel"
                                   style:UIBarButtonItemStyleBordered
                                   target:self
                                   action:@selector(pop)];
    self.navigationItem.leftBarButtonItem = leftButton;
    
    self.navigationItem.title =@"Edit Company";
}

-(void)pop{
    [self.navigationController popToViewController:self.webViewController animated:YES];
}

-(void)save{
    [[DataAccessObject sharedDAO]editProdutNameAndUrl:self.changeNameTextfield.text URL:self.changeURLtextfield.text productPrimaryKey:self.product.primaryKey];
    
//    ProductViewController *pvc = [[ProductViewController alloc] initWithNibName:nil bundle:nil];
//    
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:pvc animated:YES];
    
    NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:[self.navigationController viewControllers]];
    for (UIViewController *aViewController in allViewControllers) {
        if ([aViewController isKindOfClass:[ProductViewController class]]) {
//            aViewController.companyPrimaryKey = self.comp
            [self.navigationController popToViewController:aViewController animated:YES];
        }
    }
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
    
//    [[DataAccessObject sharedDAO]editProductNameSQL:self.changeNameTextfield.text :self.changeURLtextfield.text :self.product];
    
//    self.product.productName = self.changeNameTextfield.text;
//    self.product.productUrl = self.changeURLtextfield.text;
    
    [[DataAccessObject sharedDAO]editProdutNameAndUrl:self.changeNameTextfield.text URL:self.changeURLtextfield.text productPrimaryKey:self.product.primaryKey];
    
    [self.navigationController popToViewController:self.productViewController animated:YES];
}

@end
