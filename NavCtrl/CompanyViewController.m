//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"
#import "Company.h"
#import "Product.h"
#import "DataAccessObject.h"
#import "CompanyFormViewController.h"
#import "EditViewController.h"

@interface CompanyViewController ()

@end

@implementation CompanyViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    
    
    //Create a DOA and put your info in companylist array
    [[DataAccessObject sharedCompanies]createCompanyAndProducts];
    self.companyList = [[DataAccessObject sharedCompanies]allCompanies];

    
    

    
//    if (!self.kompany) {
//        self.kompany = [[Company alloc]init];
//    }
    

 
    
    self.title = @"Mobile device makers";
    
    //Create a toolbar so you can have more than 2 buttons in Navbar
    self.toolbar = [[UIToolbar alloc]
                          initWithFrame:CGRectMake(0, 0, 100, 45)];
    [self.toolbar setBarStyle: UIBarStyleDefault];
    
    // create an array for the buttons
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
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
    
    
    
    // put the buttons in the toolbar and release them
    [self.toolbar setItems:buttons animated:NO];
    [buttons release];
    
    // place the toolbar into the navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:self.toolbar];
    [self.toolbar release];
}


// method called by toolbar button edit button
-(void)editPlease
{
    
    [self.tableView setEditing:YES animated:YES];
    
    self.tableView.allowsSelectionDuringEditing = YES;
    
    // create a done button to replace toolbar
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

// method called by done button to end editing mode
-(void)done
{
    [self.tableView setEditing:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:self.toolbar];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//method called by ADD button
-(IBAction)addNewCompanyForm:(id)sender
{
    if (!self.companyFormViewController) {
        _companyFormViewController = [[CompanyFormViewController alloc]init];
    }
    
    [self.navigationController
     pushViewController:self.companyFormViewController
     animated:YES];
}



#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [[[DataAccessObject sharedCompanies]allCompanies]count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
 


    Company *company = [self.companyList objectAtIndex:[indexPath row]];

        cell.textLabel.text = company.companyName;

    // next time use else if
    if ([cell.textLabel.text  isEqual:@"SpaceX"]) {
        [[cell imageView] setImage: [UIImage imageNamed:@"spacex-logo.jpg"]];
    }
    if ([cell.textLabel.text  isEqual:@"Apple mobile devices"]) {
        [[cell imageView] setImage: [UIImage imageNamed:@"apple.gif"]];
    }
    
    if ([cell.textLabel.text  isEqual:@"Bill's cheese factory"]) {
        [[cell imageView] setImage: [UIImage imageNamed:@"cheese.png"]];
    }
    if ([cell.textLabel.text  isEqual:@"Samsung mobile devices"]) {
        [[cell imageView] setImage: [UIImage imageNamed:@"samsung.gif"]];
    }
    if (![cell.textLabel.text  isEqual:@"Samsung mobile devices"] && ![cell.textLabel.text  isEqual:@"Bill's cheese factory"] && ![cell.textLabel.text  isEqual:@"Apple mobile devices"] && ![cell.textLabel.text  isEqual:@"SpaceX"]){
        [[cell imageView] setImage: [UIImage imageNamed:@"Question-mark.jpg"]];
    }
    return cell;
    
    
    
}

// method to remove company cells
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    
        [self.companyList removeObjectAtIndex:indexPath.row];


        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    
    
    
    [tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

//method to be able move cells
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{

    
    NSString * company = [self.companyList objectAtIndex:fromIndexPath.row];
    [company retain];
    
    
    
    NSInteger fromIndex = fromIndexPath.row;
    NSInteger toIndex = toIndexPath.row;
    

    
    [self.companyList removeObjectAtIndex:fromIndex];
    [self.companyList insertObject:company atIndex:toIndex];
    

    
    [company release];


    
    [tableView reloadData];
}






 //Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}



// Override to support editing the table view.
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    if (editingStyle == UITableViewCellEditingStyleDelete) {
//        // Delete the row from the data source
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//    }   
//    else if (editingStyle == UITableViewCellEditingStyleInsert) {
//        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//    }   
//}



// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    
//}



// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}



#pragma mark - Table view delegate

// method to index into chosen cell
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{


    //display editView Controller if in editing mode
    if (self.tableView.editing == YES) {
        if (!self.editViewController) {
            self.editViewController = [[EditViewController alloc]init];
        }
        
            
            
            self.editViewController.company = self.companyList[indexPath.row];
            
            
            [self.tableView setEditing:NO animated:YES];
            
            self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                                      initWithCustomView:self.toolbar];
            
            [self.navigationController pushViewController:self.editViewController animated:YES];
        
    } else {
    //if not in editing mode continue to ProductViewController
    
    
    Company *company = self.companyList[indexPath.row];
    
    //pass company properties to ProductViewControllers properties
    self.productViewController.title = company.companyName;
    self.productViewController.products = company.products;
    
    [self.navigationController
        pushViewController:self.productViewController
        animated:YES];
        
    }
    

}
 


@end
