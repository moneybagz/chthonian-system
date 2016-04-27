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
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
//    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewCompanyForm:)];
//    self.navigationItem.leftBarButtonItem = addBtn;
    
    
    [[DataAccessObject sharedCompanies]createCompanyAndProducts];
    self.companyList = [[DataAccessObject sharedCompanies]allCompanies];

    
    
//    [[DataAccessObject sharedCompanies]createCompany:@"Bill's cheese factory"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"Swiss" productURL:@"http://www.cheese.com/swiss/" companyNameForProduct:@"Bill's cheese factory"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"Gruyere" productURL:@"http://www.cheese.com/gruyere/" companyNameForProduct:@"Bill's cheese factory"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"Roquefort" productURL:@"http://www.cheese.com/roquefort/" companyNameForProduct:@"Bill's cheese factory"];
//    
//    [[DataAccessObject sharedCompanies]createCompany:@"Apple mobile devices"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"iPad" productURL:@"http://www.apple.com/ipad/" companyNameForProduct:@"Apple mobile devices"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"iPod" productURL:@"http://www.apple.com/ipod/" companyNameForProduct:@"Apple mobile devices"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"iPhone" productURL:@"http://www.apple.com/iphone/" companyNameForProduct:@"Apple mobile devices"];
//    
//    [[DataAccessObject sharedCompanies]createCompany:@"Samsung mobile devices"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"Galaxy S4" productURL:@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKPVZW" companyNameForProduct:@"Samsung mobile devices"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"Galaxy Note" productURL:@"http://www.samsung.com/us/mobile/cell-phones/SM-N920AZKAATT" companyNameForProduct:@"Samsung mobile devices"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"Galaxy Tab" productURL:@"http://www.samsung.com/us/mobile/galaxy-tab/SM-T230NZWAXAR" companyNameForProduct:@"Samsung mobile devices"];
//    
//    [[DataAccessObject sharedCompanies]createCompany:@"SpaceX"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"Falcon 9 Rocket" productURL:@"http://www.spacex.com/falcon9" companyNameForProduct:@"SpaceX"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"Dragon Capsule" productURL:@"http://www.spacex.com/dragon" companyNameForProduct:@"SpaceX"];
//    [[DataAccessObject sharedCompanies]createProductWithName:@"Falcon Heavy" productURL:@"http://www.spacex.com/falcon-heavy" companyNameForProduct:@"SpaceX"];
//    
//    
//    self.companyList = [[DataAccessObject sharedCompanies]allCompanies];
//    
//    
//    
//
//    NSArray *kompanys = [[DataAccessObject sharedCompanies]allCompanies];
//    Company *kompany = kompanys[0];
//    NSLog(@"%@", kompany.companyName);
//    NSArray *productz = kompany.products;
//    NSLog(@"%@", productz[0]);

    

//    Company *shithouse = [[Company alloc]init];
//    shithouse.companyName =@"SHIT HOUSE";
//    self.kompany = shithouse;
//    [self addNewCompany];
    
    if (!self.kompany) {
        self.kompany = [[Company alloc]init];
    }
    

 
    
    self.title = @"Mobile device makers";
    
    
    self.toolbar = [[UIToolbar alloc]
                          initWithFrame:CGRectMake(0, 0, 100, 45)];
    [self.toolbar setBarStyle: UIBarStyleDefault];
    
    // create an array for the buttons
    NSMutableArray* buttons = [[NSMutableArray alloc] initWithCapacity:3];
    
    // create a standard save button
    //    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc]
    //                                   initWithBarButtonSystemItem:UIBarButtonSystemItemSave
    //                                   target:self
    //                                   action:@selector(saveAction:)];
    //    saveButton.style = UIBarButtonItemStyleBordered;
    //    [buttons addObject:saveButton];
    //    [saveButton release];
    
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
    
    // create a standard delete button with the trash icon
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

//-(void)setEditing:(BOOL)editing animated:(BOOL)animated {
//    
//    [super setEditing:editing animated:animated];
//    
//    if(editing) {
//        //Do something for edit mode
//    }
//    
//    else {
//        //Do something for non-edit mode
//    }
//    
//}

-(void)editPlease
{
    [self.tableView setEditing:YES animated:YES];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    
    self.navigationItem.rightBarButtonItem = doneButton;
}

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
    
//    if (self.kompany.companyName != nil && ![self.kompany.companyName isEqualToString:@""]) {
//        for (Company *element in [[DataAccessObject sharedCompanies]allCompanies]){
//            if (element.companyName != self.kompany.companyName) {
//                NSLog(@"%@", self.kompany.companyName);
//
//                [self addNewCompany];
//            }
//        }
//    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)addNewCompanyForm:(id)sender
{
    if (!self.companyFormViewController) {
        _companyFormViewController = [[CompanyFormViewController alloc]init];
    }
    
    [self.navigationController
     pushViewController:self.companyFormViewController
     animated:YES];
}

//-(void)addNewCompany
//{
//    Company *company = self.kompany;
//    
//    [[DataAccessObject sharedCompanies]addToDAO:company];
//    
//    NSInteger lastRow = [[[DataAccessObject sharedCompanies]allCompanies] indexOfObject:company];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:lastRow inSection:0];
//    
//    [self.tableView insertRowsAtIndexPaths:@[indexPath]
//                          withRowAnimation:UITableViewRowAnimationTop];
//}

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
    
    // Configure the cell...
//        cell.textLabel.text = [self.companyList objectAtIndex:[indexPath row]];


    Company *company = [self.companyList objectAtIndex:[indexPath row]];
//
//    cell.textLabel.text = company.companyName;
    
//    NSArray *companies = [[DataAccessObject sharedCompanies]allCompanies];
//    Company *company = [companies objectAtIndex:indexPath.row];
        cell.textLabel.text = company.companyName;

    
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
    return cell;
    
    
    
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    //if (editingStyle == UITableViewCellEditingStyleDelete) {
        //add code here for when you hit delete
        [self.companyList removeObjectAtIndex:indexPath.row];
//        [self.urlLists removeObjectAtIndex:indexPath.row];
//        [self.productLists removeObjectAtIndex:indexPath.row];

        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        
    //}
    
    
    [tableView reloadData];
}

-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
//    if (fromIndexPath < toIndexPath) {
//        toIndexPath.row--; // Optional
//    }
    
    NSString * company = [self.companyList objectAtIndex:fromIndexPath.row];
    [company retain];
    
    
    
    NSInteger fromIndex = fromIndexPath.row;
    NSInteger toIndex = toIndexPath.row;
    
//    if (fromIndex < toIndex) {
//        toIndex--; // Optional
//    }
    
    
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

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

//    NSArray *companies = [[DataAccessObject sharedCompanies]allCompanies];
//    Company *company = [companies objectAtIndex:indexPath.row];
//    
//    self.productViewController.title = company.companyName;
//    self.productViewController.products = company.products;
    
    
    Company *company = self.companyList[indexPath.row];
    
    
    self.productViewController.title = company.companyName;
    self.productViewController.products = company.products;
    
    [self.navigationController
        pushViewController:self.productViewController
        animated:YES];
    

}
 


@end
