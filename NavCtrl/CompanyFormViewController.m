//
//  CompanyFormViewController.m
//  NavCtrl
//
//  Created by Clyfford Millet on 4/26/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "CompanyFormViewController.h"
#import "Company.h"
#import "CompanyViewController.h"
#import "DataAccessObject.h"

@interface CompanyFormViewController ()


@end

@implementation CompanyFormViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName: nibNameOrNil
                           bundle: nibBundleOrNil];
    if (self)
    {
        // Custom stuff
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.view endEditing:YES];
    

    
}



- (void)dealloc {
    [_companyTextfield release];
    [super dealloc];
}
- (IBAction)doneButton:(id)sender {
    NSString *kompanyName = self.companyTextfield.text;
    
    [[DataAccessObject sharedCompanies]createCompany:kompanyName];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end