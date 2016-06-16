//
//  EditViewController.m
//  NavCtrl
//
//  Created by Clyfford Millet on 4/28/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "EditViewController.h"
#import "Company.h"
#import "DataAccessObject.h"


@interface EditViewController ()

@end

@implementation EditViewController

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
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)save{
    [[DataAccessObject sharedDAO]editCompanyName:self.changeNameTextfield.text
    :self.company.primaryKey];
    
    self.company.companyName = self.changeNameTextfield.text;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (void)dealloc {
    [_changeNameTextfield release];
    [super dealloc];
}
- (IBAction)doneButton:(id)sender {
    
    [[DataAccessObject sharedDAO]editCompanyName:self.changeNameTextfield.text
                                                :self.company.primaryKey];
    
    self.company.companyName = self.changeNameTextfield.text;
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
