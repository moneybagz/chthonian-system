//
//  ProductViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "ProductViewController.h"
#import "WebViewController.h"
#import "Company.h"
#import "Product.h"
#import "ProductFormViewController.h"
#import "EditFormViewController.h"
#import "DataAccessObject.h"

@interface ProductViewController ()

@end

@implementation ProductViewController

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

    
    
//    [[DataAccessObject sharedDAO]readDatabaseProducts:self.ID];
//    self.products = [[DataAccessObject sharedDAO] allProducts];

    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    [self createToolbar];
    
    
    [self.navigationItem.backBarButtonItem setAction:@selector(leftButtonSelected:)];
}

-(void)createToolbar
{
    self.toolbar = [[UIToolbar alloc]
                    initWithFrame:CGRectMake(0, 0, 100, 45)];
    [self.toolbar setBarStyle: UIBarStyleDefault];
    
    // create an array for the buttons
    self.buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProductForm:)];
    [self.buttons addObject:addBtn];
    [addBtn release];
    
    // create a spacer between the buttons
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                               target:nil
                               action:nil];
    [self.buttons addObject:spacer];
    [spacer release];
    
    // create a standard delete button with the trash icon
    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPlease)];
    [self.buttons addObject:editBtn];
    self.navigationItem.rightBarButtonItem = editBtn;
    
    [editBtn release];
    
    // put the buttons in the toolbar and release them
    [self.toolbar setItems:self.buttons animated:NO];
    [self.buttons release];
    
    // place the toolbar into the navigation bar
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.toolbar];
    
    [self.toolbar release];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    
    if(editing == YES)
    {
        // Your code for entering edit mode goes here
        self.tableView.allowsSelectionDuringEditing = YES;
        self.doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];

        [self.navigationItem.rightBarButtonItem release];
        self.navigationItem.rightBarButtonItem = self.doneButton;
    }
}

-(void)editPlease
{
    [self.tableView setEditing:YES animated:YES];
    self.editing = YES;
}

-(void)done
{
    [self.tableView setEditing:NO animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.toolbar];

}

-(IBAction)addNewProductForm:(id)sender
{
    if (!self.productFormViewController) {
        self.productFormViewController = [[ProductFormViewController alloc]init];
    }
    
    self.productFormViewController.productViewController = self;
    
    self.productFormViewController.companyID = self.ID;
    
    self.productFormViewController.companyName = self.title;
    
    [self.navigationController
     pushViewController:self.productFormViewController
     animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {
    [self.tableView setEditing:NO animated:YES];
    self.editing = NO;
    
    [[DataAccessObject sharedDAO]fetchDataProductsWithCompanyName:self.title];
    self.products = [[DataAccessObject sharedDAO] allProducts];
    
    [super viewWillAppear:animated];
    
       [self.tableView reloadData];
}

-(void) leftButtonSelected:(id)sender {
    
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.toolbar];
    
    [self.navigationItem.rightBarButtonItem release];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.products count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    // Configure the cell...
    //cell.textLabel.text = [self.products objectAtIndex:[indexPath row]];
    
    self.products = [[DataAccessObject sharedDAO] allProducts];
    
    Product *product = [self.products objectAtIndex:[indexPath row]];
    
    
    cell.textLabel.text = product.productName;
    
    if ([self.title  isEqualToString:@"Apple mobile devices"]) {
        [[cell imageView] setImage: [UIImage imageNamed:@"apple.gif"]];
    } else if ([self.title  isEqualToString:@"Samsung mobile devices"]) {
        [[cell imageView] setImage: [UIImage imageNamed:@"samsung.gif"]];
    } else if ([self.title  isEqualToString:@"Clyff's CHEESE HOUSE!"]) {
        cell.imageView.image = [UIImage imageNamed:@"cheese.png"];
    } else if ([self.title  isEqualToString:@"SpaceX"]) {
        cell.imageView.image = [UIImage imageNamed:@"spacex-logo.jpg"];
    } else {
        [[cell imageView] setImage: [UIImage imageNamed:@"Question-mark.jpg"]];
    }
    
    
    return cell;
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    if (editingStyle == UITableViewCellEditingStyleDelete){
        
        NSArray *productz = [[DataAccessObject sharedDAO]allProducts];
        
        Product *product = [productz objectAtIndex:indexPath.row];
        [[DataAccessObject sharedDAO]deleteSingleProductWithPrimaryKey:product];
        
        
//        [self.products removeObjectAtIndex:indexPath.row];
        
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
        [tableView reloadData];
    }
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    
    
    NSString * product = [self.products objectAtIndex:fromIndexPath.row];
    
    NSInteger fromIndex = fromIndexPath.row;
    NSInteger toIndex = toIndexPath.row;
    
    [self.products removeObjectAtIndex:fromIndex];
    [self.products insertObject:product atIndex:toIndex];
    
    
    [tableView reloadData];
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    
    if (self.editing == YES) {
        if (!self.editFormViewController) {
            self.editFormViewController = [[EditFormViewController alloc]init];
            self.editFormViewController.productViewController = self;
        }
            self.editFormViewController.product = self.products[indexPath.row];
        // Pass the id information so you can edit in DAO
        self.editFormViewController.product.companyID = self.ID;
        
//        [self.navigationItem.rightBarButtonItem release];
        
            [self.navigationController pushViewController:self.editFormViewController animated:YES];
    } else {
        WebViewController *wvc = [[WebViewController alloc] initWithNibName:nil bundle:nil];
        
        //wvc.url = self.urls[indexPath.row];
        
        Product *product = self.products[indexPath.row];
        
        wvc.url = product.productUrl;
        
        
//        [self.navigationItem.rightBarButtonItem release];
        
        // Push the view controller.
        [self.navigationController pushViewController:wvc animated:YES];
    }
}
 


@end
