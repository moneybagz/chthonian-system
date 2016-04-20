//
//  CompanyViewController.m
//  NavCtrl
//
//  Created by Aditya Narayan on 10/22/13.
//  Copyright (c) 2013 Aditya Narayan. All rights reserved.
//

#import "CompanyViewController.h"
#import "ProductViewController.h"

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
    self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    
    //Create an array of product arrays to help index into ProductViewController
    NSMutableArray *AppleMobileDevices = [NSMutableArray arrayWithObjects:@"iPad", @"iPod Touch",@"iPhone", nil];
    NSMutableArray *SamsungMobileDevices = [NSMutableArray arrayWithObjects:@"Galaxy S4", @"Galaxy Note", @"Galaxy Tab", nil];
    NSMutableArray *SpaceX = [NSMutableArray arrayWithObjects:@"Falcon 9 Rocket", @"Dragon Capsule", @"Falcon Heavy", nil];
    NSMutableArray *BillsCheeseFactory = [NSMutableArray arrayWithObjects:@"Swiss", @"Gruyere", @"Roqueforte", nil];
    
    self.productLists = [[NSMutableArray alloc]init];
    
    [self.productLists addObject:AppleMobileDevices];
    [self.productLists addObject:SamsungMobileDevices];
    [self.productLists addObject:SpaceX];
    [self.productLists addObject:BillsCheeseFactory];

    //create a company array to display cell info
    self.companyList = [[NSMutableArray alloc] init];
    
    [self.companyList addObject:@"Apple mobile devices"];
    [self.companyList addObject:@"Samsung mobile devices"];
    [self.companyList addObject:@"SpaceX"];
    [self.companyList addObject:@"Bill's cheese factory"];
    
    //Create a url array of arrays to give array property to ProductViewController
    // which will eventually give url information to WebViewController
    NSMutableArray *appleURLs = [NSMutableArray arrayWithObjects:@"http://www.apple.com/ipad/", @"http://www.apple.com/ipod/", @"http://www.apple.com/iphone/", nil];
    NSMutableArray *samsungURLs = [NSMutableArray arrayWithObjects:@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKPVZW", @"http://www.samsung.com/us/mobile/cell-phones/SM-N920AZKAATT", @"http://www.samsung.com/us/mobile/galaxy-tab/SM-T230NZWAXAR", nil];
    NSMutableArray *spacexURLs = [NSMutableArray arrayWithObjects:@"http://www.spacex.com/falcon9", @"http://www.spacex.com/dragon", @"http://www.spacex.com/falcon-heavy", nil];
    NSMutableArray *cheeseURLs = [NSMutableArray arrayWithObjects:@"http://www.cheese.com/swiss/", @"http://www.cheese.com/gruyere/", @"http://www.cheese.com/roquefort/", nil];
    
    self.urlLists = [[NSMutableArray alloc]init];
    
    [self.urlLists addObject:appleURLs];
    [self.urlLists addObject:samsungURLs];
    [self.urlLists addObject:spacexURLs];
    [self.urlLists addObject:cheeseURLs];




    
//    self.companyList = @[@"Apple mobile devices",
//                         @"Samsung mobile devices",
//                         @"SpaceX",
//                         @"Bill's cheese factory"];
    
    
    self.title = @"Mobile device makers";
    
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    return [self.companyList count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    
    
    cell.textLabel.text = [self.companyList objectAtIndex:[indexPath row]];
    
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
        [self.urlLists removeObjectAtIndex:indexPath.row];
        [self.productLists removeObjectAtIndex:indexPath.row];

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
    
    
    NSMutableArray *productList = [self.productLists objectAtIndex:fromIndexPath.row];
    NSMutableArray *urlList = [self.urlLists objectAtIndex:fromIndexPath.row];
    [productList retain];
    [urlList retain];
    
    NSInteger fromIndex = fromIndexPath.row;
    NSInteger toIndex = toIndexPath.row;
    
    if (fromIndex < toIndex) {
        toIndex--; // Optional
    }
    
    
    [self.companyList removeObjectAtIndex:fromIndex];
    [self.companyList insertObject:company atIndex:toIndex];
    
    [self.productLists removeObjectAtIndex:fromIndex];
    [self.productLists insertObject:productList atIndex:toIndex];
    
    [self.urlLists removeObjectAtIndex:fromIndex];
    [self.urlLists insertObject:urlList atIndex:toIndex];
    
    [company release];
    [productList release];
    [urlList release];
//    id object = [self.productLists objectAtIndex:fromIndex];
//    [self.productLists removeObjectAtIndex:fromIndex];
//    [self.productLists insertObject:object atIndex:toIndex];
//    
//    id object2 = [self.urlLists objectAtIndex:fromIndex];
//    [self.urlLists removeObjectAtIndex:fromIndex];
//    [self.urlLists insertObject:object2 atIndex:toIndex];
    
//    NSInteger fromIndex = fromIndexPath.row;
//    NSInteger toIndex = toIndexPath.row;
//
//    
//    id buffer2 = [self.urlLists objectAtIndex:fromIndex];
//    [self.urlLists removeObjectAtIndex:fromIndex];
//    [self.urlLists insertObject:buffer2 atIndex:toIndex];
//    
//    id buffer3 = [self.productLists objectAtIndex:fromIndex];
//    [self.productLists removeObjectAtIndex:fromIndex];
//    [self.productLists insertObject:buffer3 atIndex:toIndex];
//    
//    [self.urlLists exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
//    [self.productLists exchangeObjectAtIndex:fromIndex withObjectAtIndex:toIndex];
    
//    [self reOrderFrom:&fromIndex reOrderTo:&toIndex];
    
    [tableView reloadData];
}

//- (void)reOrderFrom:(NSInteger *)index1 reOrderTo:(NSInteger *)index2
//{
//    if (index1 < index2) {
//        index2--; // Optional
//    }
//    
//    id buffer2 = [self.urlLists objectAtIndex:(int)index1];
//    [self.urlLists removeObjectAtIndex:(int)index1];
//    [self.urlLists insertObject:buffer2 atIndex:(int)index2];
//    
//    id buffer3 = [self.productLists objectAtIndex:(int)index1];
//    [self.productLists removeObjectAtIndex:(int)index1];
//    [self.productLists insertObject:buffer3 atIndex:(int)index2];
//}


 //Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}



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

    self.productViewController.title = self.companyList[indexPath.row];
    self.productViewController.urls = self.urlLists[indexPath.row];
    self.productViewController.products = self.productLists[indexPath.row];
    
    [self.navigationController
        pushViewController:self.productViewController
        animated:YES];
    

}
 


@end
