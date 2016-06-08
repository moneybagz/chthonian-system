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
#import "CollectionCell.h"

@interface CompanyViewController ()

@property (strong, retain) IBOutlet UICollectionView *cv;
@property (strong, retain) CollectionCell *cell;
@property (strong, retain) UIImageView *movingCell;
@property (strong, retain) IBOutlet UICollectionViewFlowLayout *vfl;

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
    [[DataAccessObject sharedDAO]hardcode];
    
    
    //remove tableview line separaters
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

//
//    [[DataAccessObject sharedDAO]fetchDataCompanies];
//    
//    self.companyList = [[DataAccessObject sharedDAO] allCompanies];

    
    // Uncomment the following line to preserve selection between presentations.
     self.clearsSelectionOnViewWillAppear = NO;
 
    
    
    //Create a DOA and put your info in companylist array
//    [[DataAccessObject sharedDAO] copyDatabaseIfNotExist];
//    self.companyList = [[DataAccessObject sharedDAO] allCompanies];
 
    
    self.title = @"Mobile device makers";
    

    self.vfl= [[UICollectionViewFlowLayout alloc]init];
//
    self.cv = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 20, self.view.frame.size.width, self.view.frame.size.height - 20) collectionViewLayout:self.vfl];

    

//    self.vfl = [[UICollectionViewFlowLayout alloc] init];
    [self.vfl setItemSize:CGSizeMake(300, 300)];
//    [self.vfl setScrollDirection:UICollectionViewScrollDirectionHorizontal];
//    self.vfl.minimumInteritemSpacing = 0.0f;
//    [self.cv setCollectionViewLayout:self.vfl];
//    self.cv.bounces = YES;
//    [self.cv setShowsHorizontalScrollIndicator:NO];
//    [self.cv setShowsVerticalScrollIndicator:NO];

    self.cv.backgroundColor = [UIColor whiteColor];
    
    

    self.cv.delegate = self;
    self.cv.dataSource = self;
    
    // Code below is for a default cell
//    [[cv registerClass:[UICollectionViewCell class]] forCellWithReuseIdentifier:@"cell"];

    //lets use this code to use our custom cell
    [self.cv registerNib:[UINib nibWithNibName:@"CollectionCell" bundle:[NSBundle mainBundle]]
    forCellWithReuseIdentifier:@"CollectionCell"];

    [self.view addSubview:self.cv];
    
}
//
#pragma mark - collection view methods


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    // REMEMBER initialize your custom UICollectionViewCell  (COLLECTIONCELL) class not the default
    self.cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"CollectionCell" forIndexPath:indexPath];
    
    self.cell.companyViewController = self;
    
    if (self.customEditingMode == NO) {
        [self.cell.editLabel setHidden:YES];
        [self.cell.nameLabel setHidden:YES];
    } else {
        [self.cell.editLabel setHidden:NO];
        [self.cell.nameLabel setHidden:NO];
    }
    
    if (self.deleteMode == NO) {
        [self.cell.deleteLabel setHidden:YES];
    } else {
        [self.cell.deleteLabel setHidden:NO];
    }

    
    Company *company = [self.companyList objectAtIndex:[indexPath row]];

    [self.cell.collectionCompanyLabel setText:company.companyName];
    
    
    // next time use else if
    if ([self.cell.collectionCompanyLabel.text  isEqual:@"SpaceX"]) {
        [self.cell.collectionViewLogo setImage: [UIImage imageNamed:@"spacex-logo.jpg"]];
        self.cell.collectionStockLabel.text =[self.stockQuotes objectForKey:@"SpaceX"];
    }
    
    else if ([self.cell.collectionCompanyLabel.text  isEqual:@"Apple mobile devices"]) {
        [self.cell.collectionViewLogo setImage: [UIImage imageNamed:@"apple.gif"]];
        self.cell.collectionStockLabel.text =[self.stockQuotes objectForKey:@"Apple"];
    }
    
    else if ([self.cell.collectionCompanyLabel.text  isEqual:@"Clyff's CHEESE HOUSE!"]) {
        [self.cell.collectionViewLogo setImage: [UIImage imageNamed:@"cheese.png"]];
        self.cell.collectionStockLabel.text =[self.stockQuotes objectForKey:@"Bill's"];
    }
    
    else if ([self.cell.collectionCompanyLabel.text  isEqual:@"Samsung mobile devices"]) {
        [self.cell.collectionViewLogo setImage: [UIImage imageNamed:@"samsung.gif"]];
        self.cell.collectionStockLabel.text =[self.stockQuotes objectForKey:@"Samsung"];
        
    } else {
        [self.cell.collectionViewLogo setImage:[UIImage imageNamed:@"Question-mark.jpg"]];
    }
    
    return self.cell;
}
//
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.companyList.count;
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
        
        if (!self.editViewController) {
                self.editViewController = [[EditViewController alloc]init];
            }
        
        self.editViewController.company = self.companyList[indexPath.row];
        
        self.customEditingMode = NO;
        
       [self.navigationController pushViewController:self.editViewController animated:YES];
    }
    else if (self.deleteMode == YES){
        
        NSArray *kompanies = [[DataAccessObject sharedDAO]allCompanies];
        
        Company *kompany = [kompanies objectAtIndex:indexPath.row];
        
        [self.companyList removeObjectAtIndex:indexPath.row];
        
        [[DataAccessObject sharedDAO]deleteCompanyWithPrimaryKey:kompany.primaryKey];
        
        [self.cv reloadData];
    }
    else {
        Company *company = self.companyList[indexPath.row];
    
        self.productViewController.title = company.companyName;
    
        self.productViewController.companyPrimaryKey = company.primaryKey; ////////////////////////
        
        NSLog(@"%d&&&&&&&&&&&&&&&&&&&&&&&", self.productViewController.companyPrimaryKey);
    
        [self.navigationItem.rightBarButtonItem release];
    
        [self.navigationController
            pushViewController:self.productViewController
            animated:YES];
    }
}

//-(void)handlePan:(UIPanGestureRecognizer *)panRecognizer {
//    
//    CGPoint locationPoint = [panRecognizer locationInView:self.cv];
//    
//    if (panRecognizer.state == UIGestureRecognizerStateBegan) {
//        
//        NSIndexPath *indexPathOfMovingCell = [self.cv indexPathForItemAtPoint:locationPoint];
//        self.cell = [self.cv cellForItemAtIndexPath:indexPathOfMovingCell];
//        
//        UIGraphicsBeginImageContext(cell.bounds.size);
//        [cell.layer renderInContext:UIGraphicsGetCurrentContext()];
//        UIImage *cellImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        
//        self.movingCell = [[UIImageView alloc] initWithImage:cellImage];
//        [self.movingCell setCenter:locationPoint];
//        [self.movingCell setAlpha:0.75f];
//        [self.cv addSubview:self.movingCell];
//        
//    }
//    
//    if (panRecognizer.state == UIGestureRecognizerStateChanged) {
//        [self.cell setCenter:locationPoint];
//    }
//    
//    if (panRecognizer.state == UIGestureRecognizerStateEnded) {
//        [self.cell removeFromSuperview];
//    }
//}
// method called by toolbar button edit button

#pragma mark - my methods


-(void)editPlease
{
    
    self.customEditingMode = YES;
    
    [self.cv reloadData];
    
//    [self.navigationController pushViewController:self.editViewController animated:YES];

    
//     create a done button to replace toolbar
    self.doneButton = [[UIBarButtonItem alloc ] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(done)];
    
    [self.navigationItem.rightBarButtonItem release];
    self.navigationItem.rightBarButtonItem = self.doneButton;
    
    //INSTRUMENT RELEASE 2
//    [doneButton release];
}

// method called by done button to end editing mode
-(void)done
{
//    [self.tableView setEditing:NO animated:YES];
    self.customEditingMode = NO;
    self.deleteMode = NO;
    
    [self.cv reloadData];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithCustomView:self.toolbar];
    
}



-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [[DataAccessObject sharedDAO]fetchDataCompanies];

    self.companyList = [[DataAccessObject sharedDAO] allCompanies];
    
    [self.cv reloadData];

    [self setToolbar];
    
    
    //Get Companies stock symbol and add them to the string
    NSMutableString *stockSymbols = [[NSMutableString alloc]initWithString:@"http://finance.yahoo.com/d/quotes.csv?s="];
    for (Company *kompany in self.companyList){
        [stockSymbols appendString:kompany.stockSymbol];
        [stockSymbols appendString:@"+"];
        if (kompany.orderValue == self.companyList.count){
            //remove the last plus sign
            [stockSymbols substringToIndex:[stockSymbols length] - 1];
        }
    }
    [stockSymbols appendString:@"&f=a"];
    NSLog(@"%@***************", stockSymbols);

    
    // 1
//   NSString *dataUrl = @"http://finance.yahoo.com/d/quotes.csv?s=AAPL+GOOG+TSLA+WFM&f=a";
    NSURL *url = [NSURL URLWithString:stockSymbols];
    
    // 2
    NSURLSession *session = [NSURLSession sharedSession];
                             
    NSURLSessionTask *task = [session dataTaskWithURL:url completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        //NSLog(@"response == %@", response);
        [self processData:data];
    }];
    
    
    [task resume];
    [self.tableView reloadData];

}

-(void)processData:(NSData *)data
{
    NSString* stockString;
    stockString = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    
    //NSLog(@"%@", stockString);
    
    NSArray *stockPrices = [stockString componentsSeparatedByString:@"\n"];
    
    self.stockQuotes =@{@"Apple": stockPrices[0],
                        @"Samsung": stockPrices[1],
                        @"SpaceX": stockPrices[2],
                        @"Bill's": stockPrices[3],
                        };
    
    NSLog(@"%@***********************", [self.stockQuotes objectForKey:@"SpaceX"]);
    
    
    //    NSLog(@"%@ money", [self.stockQuotes objectForKey:@"Apple"]);
    //    NSLog(@"%@ money", [self.stockQuotes objectForKey:@"Samsung"]);
    
    //My first memory leak to be released via instruments stack trace
    [stockString release];
    
    //i forget why i needed this. (now i remember syncing asyncronous call with tableviewcell stock price)
    [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
    //Switch reloading of data to collection view
    [self.cv performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
    
}

-(void)setToolbar
{
    //Create a toolbar so you can have more than 2 buttons in Navbar
    self.toolbar = [[UIToolbar alloc]
                    initWithFrame:CGRectMake(0, 0, 250, 45)];
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

-(void)undo
{
    
    [[DataAccessObject sharedDAO]undoManagerCompanies];
    
    [[DataAccessObject sharedDAO]fetchDataCompanies];
    
    [self.cv reloadData];
}

-(void)save
{
    [[DataAccessObject sharedDAO]saveContext];
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
    
    [self.navigationItem.rightBarButtonItem release];
    
    [self.navigationController
     pushViewController:self.companyFormViewController
     animated:YES];
}

#pragma mark - NSURLconnection delegate methods


//- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
//    // A response has been received, this is where we initialize the instance var you created
//    // so that we can append data to it in the didReceiveData method
//    // Furthermore, this method is called each time there is a redirect so reinitializing it
//    // also serves to clear it
//    NSLog(@"DidReceiveResponse");
//    _responseData = [[NSMutableData alloc] init];
//    
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
//    // Append the new data to the instance variable you declared
//    NSLog(@"DidReceiveData");
//    [_responseData appendData:data];
//    
//}
////
////- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
////                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
////    // Return nil to indicate not necessary to store a cached response for this connection
////    return nil;
////}
//
//- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
//    
//    NSString* stockString;
//    stockString = [[NSString alloc] initWithData:_responseData encoding:NSASCIIStringEncoding];
//    
//    NSLog(@"%@", stockString);
//    
//    NSArray *stockPrices = [stockString componentsSeparatedByString:@"\n"];
//    
//    self.stockQuotes =@{@"Apple": stockPrices[0],
//                        @"Samsung": stockPrices[1],
//                        @"SpaceX": stockPrices[2],
//                        @"Bill's": stockPrices[3],
//                        };
//    
//    NSLog(@"%@ money", [self.stockQuotes objectForKey:@"Apple"]);
//    
//    [self.tableView reloadData];
//    
//    
////    self.jsonDictionary = [[NSDictionary alloc]init];
////    
////    self.jsonDictionary = [NSJSONSerialization JSONObjectWithData:_responseData
////                                                          options:0
////                                                            error:nil];
////    
////    NSLog(@"%@", self.jsonDictionary);
//}
//
//- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
//    // The request has failed for some reason!
//    // Check the error var
//}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//    // Return the number of sections.
//    return 1;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//    // Return the number of rows in the section.
//    return [[[DataAccessObject sharedDAO]allCompanies]count];
//}
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    static NSString *CellIdentifier = @"Cell";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
//    }
//    
// 
//
//
//    Company *company = [self.companyList objectAtIndex:[indexPath row]];
//
//        cell.textLabel.text = company.companyName;
//    [[cell textLabel] setText: [company companyName] ];
//    
//
//
//    // next time use else if
//    if ([cell.textLabel.text  isEqual:@"SpaceX"]) {
//        [[cell imageView] setImage: [UIImage imageNamed:@"spacex-logo.jpg"]];
//        cell.detailTextLabel.text =[self.stockQuotes objectForKey:@"SpaceX"];
//    }
//    
//    else if ([cell.textLabel.text  isEqual:@"Apple mobile devices"]) {
//        [[cell imageView] setImage: [UIImage imageNamed:@"apple.gif"]];
//        cell.detailTextLabel.text =[self.stockQuotes objectForKey:@"Apple"];
//    }
//    
//    else if ([cell.textLabel.text  isEqual:@"Clyff's CHEESE HOUSE!"]) {
//        [[cell imageView] setImage: [UIImage imageNamed:@"cheese.png"]];
//        cell.detailTextLabel.text =[self.stockQuotes objectForKey:@"Bill's"];
//    }
//    
//    else if ([cell.textLabel.text  isEqual:@"Samsung mobile devices"]) {
//        [[cell imageView] setImage: [UIImage imageNamed:@"samsung.gif"]];
//        //cell.detailTextLabel.text =@"WFM %@", [self.stockQuotes objectForKey:@"Samsung"];
//        cell.detailTextLabel.text =[self.stockQuotes objectForKey:@"Samsung"];
//
//    }
//    
//    else if (![cell.textLabel.text  isEqual:@"Samsung mobile devices"] && ![cell.textLabel.text  isEqual:@"Bill's cheese factory"] && ![cell.textLabel.text  isEqual:@"Apple mobile devices"] && ![cell.textLabel.text  isEqual:@"SpaceX"]){
//        [[cell imageView] setImage: [UIImage imageNamed:@"Question-mark.jpg"]];
//    }
//    return cell;
//    
//    
//    
//}
//
//// method to remove company cells
//- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    
//    if (editingStyle == UITableViewCellEditingStyleDelete){
//        
//        NSArray *kompanies = [[DataAccessObject sharedDAO]allCompanies];
//        
//        Company *kompany = [kompanies objectAtIndex:indexPath.row];
//
////        NSLog(@"%d", (int)indexPath.row);
//        
//        [self.companyList removeObjectAtIndex:indexPath.row];
//
//        [[DataAccessObject sharedDAO]deleteCompanyWithPrimaryKey:kompany.primaryKey];
////        self.companyList = [[DataAccessObject sharedDAO]allCompanies];
//        
////        [self.companyList removeObject:kompany];
//        
//        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
////
//        [tableView reloadData];
//    }
//}
//
//
//
//
//-(BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}
//
////method to be able move cells
//- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
//{
////    Company *kompany1 = self.companyList[fromIndexPath.row];
////    Company *kompany2 = self.companyList[toIndexPath.row];
//
//
//    [[DataAccessObject sharedDAO]companyMoveRowFromIndex:(int)fromIndexPath.row toIndex:(int)toIndexPath.row];
//    
//    NSString * company = [self.companyList objectAtIndex:fromIndexPath.row];
//    [company retain];
//    
//    NSInteger fromIndex = fromIndexPath.row;
//    NSInteger toIndex = toIndexPath.row;
//    
//    [self.companyList removeObjectAtIndex:fromIndex];
//    [self.companyList insertObject:company atIndex:toIndex];
//    
//
//    
//    [company release];
//
//
//    
//    [tableView reloadData];
//}
//
//
//
//
//
//
// //Override to support conditional editing of the table view.
//- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    // Return NO if you do not want the specified item to be editable.
//    return YES;
//}
//
//
//
//// Override to support editing the table view.
////- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    if (editingStyle == UITableViewCellEditingStyleDelete) {
////        // Delete the row from the data source
////        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
////    }   
////    else if (editingStyle == UITableViewCellEditingStyleInsert) {
////        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
////    }   
////}
//
//
//
//// Override to support rearranging the table view.
////- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
////{
////    
////}
//
//
//
//// Override to support conditional rearranging of the table view.
////- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
////{
////    // Return NO if you do not want the item to be re-orderable.
////    return YES;
////}
//
//
//
//#pragma mark - Table view delegate
//
//// method to index into chosen cell
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
//{
//
//
//    //display editView Controller if in editing mode
//    if (self.tableView.editing == YES) {
//        if (!self.editViewController) {
//            self.editViewController = [[EditViewController alloc]init];
//        }
//        
//            
//            
//        self.editViewController.company = self.companyList[indexPath.row];
//            
//            
//        [self.tableView setEditing:NO animated:YES];
//            
//
//        
//        [self.navigationItem.rightBarButtonItem release];
//        
//        [self.navigationController pushViewController:self.editViewController animated:YES];
//        
//    } else {
//    //if not in editing mode continue to ProductViewController
//    
//    
//    Company *company = self.companyList[indexPath.row];
//    
//    //pass company properties to ProductViewControllers properties
//    self.productViewController.title = company.companyName;
//    //self.productViewController.products = company.products;
//        
//    self.productViewController.companyPrimaryKey = company.primaryKey; ////////////////////////
//    
//    [self.navigationItem.rightBarButtonItem release];
//    
//    [self.navigationController
//        pushViewController:self.productViewController
//        animated:YES];
//        
//    }
//
//}
// 


@end
