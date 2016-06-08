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
#import "CollectionCell.h"

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
    [self createToolbar];
    //NO LINES ON BACKGROUND
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
   
    
    
    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
    
    
    
    
    //Create collection View
    UICollectionViewFlowLayout *vfl= [[UICollectionViewFlowLayout alloc]init];
    
    self.cv = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) collectionViewLayout:vfl];
    
    
    self.cv.backgroundColor = [UIColor whiteColor];
    
    
    
    self.cv.delegate = self;
    self.cv.dataSource = self;
    
    //lets use this code to use our custom cell
    [self.cv registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:[NSBundle mainBundle]]
forCellWithReuseIdentifier:@"CollectionCell"];
    
    [self.view addSubview:self.cv];
    
    
    [self.navigationItem.backBarButtonItem setAction:@selector(leftButtonSelected:)];
}

#pragma mark - collection view methods


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // REMEMBER initialize your custom UICollectionViewCell  (COLLECTIONCELL) class not the default
    CollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    if (self.customEditingMode == NO) {
        [cell.editLabel setHidden:YES];
        [cell.nameLabel setHidden:YES];
    } else {
        [cell.editLabel setHidden:NO];
        [cell.nameLabel setHidden:NO];
    }
    
    if (self.deleteMode == NO) {
        [cell.deleteLabel setHidden:YES];
    } else {
        [cell.deleteLabel setHidden:NO];
    }
    
    
    Product *product = [self.products objectAtIndex:[indexPath row]];
    
    [cell.collectionProductLabel setText:product.productName];
    
    
    // next time use else if
    if ([self.title isEqualToString:@"SpaceX"]) {
        [cell.collectionViewLogo setImage: [UIImage imageNamed:@"spacex-logo.jpg"]];
    }
    
    else if ([self.title  isEqual:@"Apple mobile devices"]) {
        [cell.collectionViewLogo setImage: [UIImage imageNamed:@"apple.gif"]];
    }
    
    else if ([self.title  isEqual:@"Clyff's CHEESE HOUSE!"]) {
        [cell.collectionViewLogo setImage: [UIImage imageNamed:@"cheese.png"]];
    }
    
    else if ([self.title  isEqual:@"Samsung mobile devices"]) {
        [cell.collectionViewLogo setImage: [UIImage imageNamed:@"samsung.gif"]];
        
    } else {
        [cell.collectionViewLogo setImage:[UIImage imageNamed:@"Question-mark.jpg"]];
    }
    
    
    return cell;
}
//
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.products.count;
}
//
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(150, 190);
}
//
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 5);
}
//
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.customEditingMode == YES){
        
        self.editFormViewController = [[EditFormViewController alloc]init];
            self.editFormViewController.productViewController = self;
        
            self.editFormViewController.product = self.products[indexPath.row];
        // Pass the id information so you can edit in DAO
        self.editFormViewController.product.companyID = self.companyPrimaryKey;


        [self.navigationController pushViewController:self.editFormViewController animated:YES];
    }
    else if (self.deleteMode == YES){
        
        NSArray *productz = [[DataAccessObject sharedDAO]allCompanies];
        
        Product *product = [productz objectAtIndex:indexPath.row];
        
        [self.products removeObjectAtIndex:indexPath.row];
        
        [[DataAccessObject sharedDAO]deleteProductWithPrimaryKey:product.primaryKey companyPrimaryKey:self.companyPrimaryKey];
        
        [self.cv reloadData];
    }
    else {
        WebViewController *wvc = [[WebViewController alloc] initWithNibName:nil bundle:nil];

        //wvc.url = self.urls[indexPath.row];

        Product *product = self.products[indexPath.row];

        wvc.url = product.productUrl;


//        [self.navigationItem.rightBarButtonItem release];

        // Push the view controller.
        [self.navigationController pushViewController:wvc animated:YES];
    }
}

#pragma mark - my methods


-(void)createToolbar
{
    //Create a toolbar so you can have more than 2 buttons in Navbar
    self.toolbar = [[UIToolbar alloc]
                    initWithFrame:CGRectMake(0, 0, 250, 45)];
    [self.toolbar setBarStyle: UIBarStyleDefault];
    
    // create an array for the buttons
    NSMutableArray* buttons = [[NSMutableArray alloc]init];
    
    // create an add button to add companies
    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProductForm:)];
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
    
    UIBarButtonItem *deleteBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trash)];
    [buttons addObject:deleteBtn];
    [deleteBtn release];
    
    // create a spacer between the buttons
    UIBarButtonItem *spacer3 = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                target:nil
                                action:nil];
    [buttons addObject:spacer3];
    
    UIBarButtonItem *undoBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undo)];
    [buttons addObject:undoBtn];
    //    [addBtn release];
    
    UIBarButtonItem *spacer4 = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
                                target:nil
                                action:nil];
    [buttons addObject:spacer4];
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
    
    
    
    
    
    //Create a toolbar so you can have more than 2 buttons in Navbar
//    self.toolbar = [[UIToolbar alloc]
//                    initWithFrame:CGRectMake(0, 0, 200, 45)];
//    [self.toolbar setBarStyle: UIBarStyleDefault];
//    
//    // create an array for the buttons
//    NSMutableArray* buttons = [[NSMutableArray alloc]init];
//    
//    // create an add button to add companies
//    UIBarButtonItem *addBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addNewProductForm:)];
//    [buttons addObject:addBtn];
//    [addBtn release];
//    
//    // create a spacer between the buttons
//    UIBarButtonItem *spacer = [[UIBarButtonItem alloc]
//                               initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                               target:nil
//                               action:nil];
//    [buttons addObject:spacer];
//    [spacer release];
//    
//    // create a edit button to edit company name
//    UIBarButtonItem *editBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemEdit target:self action:@selector(editPlease)];
//    [buttons addObject:editBtn];
//    [editBtn release];
//    
//    // create a spacer between the buttons
//    UIBarButtonItem *spacer2 = [[UIBarButtonItem alloc]
//                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                target:nil
//                                action:nil];
//    [buttons addObject:spacer2];
//    //    [spacer release];
//    
//    UIBarButtonItem *undoBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemUndo target:self action:@selector(undo)];
//    [buttons addObject:undoBtn];
//    //    [addBtn release];
//    
//    UIBarButtonItem *spacer3 = [[UIBarButtonItem alloc]
//                                initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace
//                                target:nil
//                                action:nil];
//    [buttons addObject:spacer3];
//    //    [spacer release];
//    
//    UIBarButtonItem *saveBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSave target:self action:@selector(save)];
//    [buttons addObject:saveBtn];
//    //    [addBtn release];
//    
//    
//    
//    // put the buttons in the toolbar and release them
//    [self.toolbar setItems:buttons animated:NO];
//    [buttons release];
//    
//    // place the toolbar into the navigation bar
//    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
//                                              initWithCustomView:self.toolbar];
//    [self.toolbar release];
}

-(void)undo
{
    [[DataAccessObject sharedDAO]undoManagerProducts];
    
    [[DataAccessObject sharedDAO]fetchDataProductsWithCompanyName:self.companyPrimaryKey];
    
    [self.cv reloadData];
}

-(void)save
{
    [[DataAccessObject sharedDAO]saveContext];
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
    self.customEditingMode = YES;
    
    [self.cv reloadData];
    
    //     create a done button to replace toolbar
    self.doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    [self.navigationItem.rightBarButtonItem release];
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

-(void)done
{
    self.customEditingMode = NO;
    self.deleteMode = NO;
    
    [self.cv reloadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:self.toolbar];
}

-(void)trash
{
    self.deleteMode = YES;
    
    [self.cv reloadData];
    
    //     create a done button to replace toolbar
    self.doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    [self.navigationItem.rightBarButtonItem release];
    self.navigationItem.rightBarButtonItem = self.doneButton;
}

-(IBAction)addNewProductForm:(id)sender
{
    if (!self.productFormViewController) {
        self.productFormViewController = [[ProductFormViewController alloc]init];
    }
    
    self.productFormViewController.productViewController = self;
    
    self.productFormViewController.companyPrimaryKey = self.companyPrimaryKey;
    
    self.productFormViewController.companyName = self.title;
    
    self.productFormViewController.productCount = (int)[self.products count];
    
    [self.navigationController
     pushViewController:self.productFormViewController
     animated:YES];
}


- (void)viewWillAppear:(BOOL)animated {

    [[DataAccessObject sharedDAO]fetchDataProductsWithCompanyName:self.companyPrimaryKey];
    self.products = [[DataAccessObject sharedDAO] allProducts];
    
    [super viewWillAppear:animated];
    
    [self.cv reloadData];
}

-(void) leftButtonSelected:(id)sender {
    
    self.deleteMode = NO;
    self.customEditingMode = NO;
    
    [self.navigationItem.rightBarButtonItem release];
    
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return [self.products count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//    }
//    // Configure the cell...
//    //cell.textLabel.text = [self.products objectAtIndex:[indexPath row]];
//    
//    self.products = [[DataAccessObject sharedDAO] allProducts];
//    
//    Product *product = [self.products objectAtIndex:[indexPath row]];
//    
//    
//    cell.textLabel.text = product.productName;
//    
//    if ([self.title  isEqualToString:@"Apple mobile devices"]) {
//        [[cell imageView] setImage: [UIImage imageNamed:@"apple.gif"]];
//    } else if ([self.title  isEqualToString:@"Samsung mobile devices"]) {
//        [[cell imageView] setImage: [UIImage imageNamed:@"samsung.gif"]];
//    } else if ([self.title  isEqualToString:@"Clyff's CHEESE HOUSE!"]) {
//        cell.imageView.image = [UIImage imageNamed:@"cheese.png"];
//    } else if ([self.title  isEqualToString:@"SpaceX"]) {
//        cell.imageView.image = [UIImage imageNamed:@"spacex-logo.jpg"];
//    } else {
//        [[cell imageView] setImage: [UIImage imageNamed:@"Question-mark.jpg"]];
//    }
//    
//    
//    return cell;
//    
//}
//
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete){
//        
//        NSArray *productz = [[DataAccessObject sharedDAO]allProducts];
//        
//        Product *product = [productz objectAtIndex:indexPath.row];
//        
//        [[DataAccessObject sharedDAO]deleteProductWithPrimaryKey:product.primaryKey companyPrimaryKey:self.companyPrimaryKey];
//        
//        [self.products removeObject:product];
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
//        
//        [tableView reloadData];
//    }
//}
//
//-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//    
//    [[DataAccessObject sharedDAO]productMoveRowFromIndex:(int)fromIndexPath.row toIndex:(int)toIndexPath.row companyPrimaryKey:self.companyPrimaryKey];
//    
//    NSString * product = [self.products objectAtIndex:fromIndexPath.row];
//    
//    NSInteger fromIndex = fromIndexPath.row;
//    NSInteger toIndex = toIndexPath.row;
//    
//    [self.products removeObjectAtIndex:fromIndex];
//    [self.products insertObject:product atIndex:toIndex];
//    
//    
//    [tableView reloadData];
//}
//
//
///*
//// Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//*/
//
///*
//// Override to support editing the table view.
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
//*/
//
///*
//// Override to support rearranging the table view.
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
//}
//*/
//
///*
//// Override to support conditional rearranging of the table view.
//- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the item to be re-orderable.
//    return YES;
//}
//*/
//
//
//#pragma mark - Table view delegate
//
//// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Navigation logic may go here, for example:
//    // Create the next view controller.
//    
//    if (self.editing == YES) {
//        if (!self.editFormViewController) {
//            self.editFormViewController = [[EditFormViewController alloc]init];
//            self.editFormViewController.productViewController = self;
//        }
//            self.editFormViewController.product = self.products[indexPath.row];
//        // Pass the id information so you can edit in DAO
//        self.editFormViewController.product.companyID = self.companyPrimaryKey;
//        
////        [self.navigationItem.rightBarButtonItem release];
//        
//            [self.navigationController pushViewController:self.editFormViewController animated:YES];
//    } else {
//        WebViewController *wvc = [[WebViewController alloc] initWithNibName:nil bundle:nil];
//        
//        //wvc.url = self.urls[indexPath.row];
//        
//        Product *product = self.products[indexPath.row];
//        
//        wvc.url = product.productUrl;
//        
//        
////        [self.navigationItem.rightBarButtonItem release];
//        
//        // Push the view controller.
//        [self.navigationController pushViewController:wvc animated:YES];
//    }
//}
// 


@end
