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
    
    self.navigationItem.title =@"Add Company";
}

-(void)pop{
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void)save{
    
    NSNumber *pk = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    NSLog(@"PK: %@", pk);
    
    [[DataAccessObject sharedDAO]createCompany:pk name:self.companyTextfield.text];
    
    [self.navigationController popToRootViewControllerAnimated:YES];
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
//    NSString *kompanyName = self.companyTextfield.text;
    
    
    NSNumber *pk = [NSNumber numberWithInt:[[NSDate date] timeIntervalSince1970]];
    NSLog(@"PK: %@", pk);
    
    [[DataAccessObject sharedDAO]createCompany:pk name:self.companyTextfield.text];

    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)setToolbar
{
    //Create a toolbar so you can have more than 2 buttons in Navbar
    self.toolbar = [[UIToolbar alloc]
                    initWithFrame:CGRectMake(0, 0, 200, 45)];
    [self.toolbar setBarStyle: UIBarStyleDefault];
    
    // create an array for the buttons
    NSMutableArray* buttons = [[NSMutableArray alloc]init];
    
    // create an add button to add companies
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCompanyForm:)];
    [buttons addObject:addBtn];
    [addBtn release];
    
    // create a spacer between the buttons
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    [buttons addObject:spacer];
    [spacer release];
    
    // create a edit button to edit company name
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPlease)];
    [buttons addObject:editBtn];
    [editBtn release];
    
    // create a spacer between the buttons
    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                target:nil
                                action:nil];
    [buttons addObject:spacer2];
    //    [spacer release];
    
    UIBarButtonItem *undoBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undo)];
    [buttons addObject:undoBtn];
    //    [addBtn release];
    
    UIBarButtonItem *spacer3 = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                target:nil
                                action:nil];
    [buttons addObject:spacer3];
    //    [spacer release];
    
    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
    [buttons addObject:saveBtn];
    //    [addBtn release];
    
    
    
    // put the buttons in the toolbar and release them
    [self.toolbar setItems:buttons animated:NO];
    [buttons release];
    
    // place the toolbar into the navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:self.toolbar];
    [self.toolbar release];
}

@end
