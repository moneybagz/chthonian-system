//
//  DataAccessObject.m
//  NavCtrl
//
//  Created by Clyfford Millet on 4/21/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "DataAccessObject.h"
#import "Company.h"
#import "Product.h"
#import "sqlite3.h"
#import "ProductViewController.h"

@interface DataAccessObject () {
    //@property (nonatomic) NSMutableArray *privateCompanies;
    sqlite3 *companyDB;
 //   NSString *dbPathString;
    Company *kompany;
}

@end

@implementation DataAccessObject

+(instancetype)sharedDAO
{
    static DataAccessObject *sharedDAO;
    
    if (!sharedDAO) {
        
        sharedDAO =[[self alloc]initPrivate];
        
    }
    
    return sharedDAO;
}

-(instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[DataAccessObject sharedDAO]"];
    
    return nil;
}

-(instancetype)initPrivate
{
    self = [super init];
    
    if (self) {
        _allCompanies = [[NSMutableArray alloc]init];
    }
    if (self) {
        _allProducts = [[NSMutableArray alloc]init];
    }
    
    return self;
}

//-(NSArray *)allCompanies
//{
//    return [self.privateCompanies copy];
//}

-(void)createCompany:(NSString *)companyName
{

    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    self.dbPathString = [docPath stringByAppendingPathComponent:@"NavController.db"];

    char *error;


    if(sqlite3_open([self.dbPathString UTF8String], &companyDB) == SQLITE_OK) {


        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO Company (companyName) VALUES ('%s')",[companyName UTF8String]];

        const char *insert_stmt = [insertStmt UTF8String];
        //NSLog(@"Add Person button click..");
        if (sqlite3_exec(companyDB, insert_stmt, NULL, NULL, &error) == SQLITE_OK) {

            NSLog(@"Company added to DB");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add Company Complete" message:@"Company added to DB" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
        }
        
        NSString *queryID = [NSString stringWithFormat:@"SELECT * FROM Company WHERE id=(select max(id) from Company)"];
        
        const char *query_ID = [queryID UTF8String];
        
        sqlite3_stmt *statement ;
        if (sqlite3_prepare(companyDB, query_ID, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement)== SQLITE_ROW)
            {
                int primaryKey = sqlite3_column_int(statement, 0);
                            NSLog(@"%d", primaryKey);
                
                Company *kompany = [[Company alloc]init];
                kompany.companyName = companyName;
                kompany.companyId = primaryKey;
                [self.allCompanies addObject:kompany];

            }
        }
        sqlite3_close(companyDB);


    }
    
//    [self readDatabase];
}




-(void)addToDAO:(Company *)company
{
    [self.allCompanies addObject:company];
}

-(void)createProductWithName:(NSString *)productName
                  productURL:(NSString *)productURL
                   companyID:(int)companyID
{
//    Product *product = [[Product alloc]init];
//    
//    product.productName = productName;
//    product.productUrl = productURL;
    
//    [self.allProducts addObject:product];

    
    //had to make class extension for kompany in if statement
//    for (Company *element in self.allCompanies){
//        if (element.companyName == companyID) {
////            [element.products addObject:product];
//            kompany = element;
//        }
//    }
//    
//    NSLog(@"MY NAME IS %@ MY COMPANY ID IS %d", kompany.companyName, kompany.companyId);
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    self.dbPathString = [docPath stringByAppendingPathComponent:@"NavController.db"];
    ;
    char *error;
    
    
    if(sqlite3_open([self.dbPathString UTF8String], &companyDB) == SQLITE_OK) {
        
        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO Product (company_id, productName, productURL) VALUES ('%d','%s','%s')", companyID, [productName UTF8String], [productURL UTF8String]];
        
        NSLog(@"%d, %@, %@", kompany.companyId, productName, productURL);
        
        const char *insert_stmt = [insertStmt UTF8String];
        

        //After product is put in database, ViewWillAppear will call readProductDatabase to fill the ProductViewController property array with new products that will be called be opened by the tableCell method
        if (sqlite3_exec(companyDB, insert_stmt, NULL, NULL, &error) == SQLITE_OK) {
            
            NSLog(@"Product added to DB");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add Product Complete" message:@"Product added to DB" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
        }
        
//        NSString *queryID = [NSString stringWithFormat:@"SELECT * FROM Product WHERE primaryKey=(select max(primaryKey) from Product)"];
//        
//        const char *query_ID = [queryID UTF8String];
//        
//        sqlite3_stmt *statement;
//        if (sqlite3_prepare(companyDB, query_ID, -1, &statement, NULL) == SQLITE_OK)
//        {
//            while (sqlite3_step(statement)== SQLITE_ROW)
//            {
//                int primaryKey = sqlite3_column_int(statement, 0);
//                NSLog(@"%d", primaryKey);
//                
//                Product *product = [[Product alloc]init];
//                product.primaryKey = primaryKey;
//                product.productName = productName;
//                product.productUrl = productURL;
//                product.companyID = companyID;
//                [self.allCompanies addObject:product];
//                
//            }
//        }
        sqlite3_close(companyDB);
    }
}

-(void)copyDatabaseIfNotExist
{
    NSError *copyError;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    self.dbPathString = [docPath stringByAppendingPathComponent:@"NavController.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:self.dbPathString])
    {
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"NavController" ofType:@"db"];
        [fileManager copyItemAtPath:dataPath toPath:self.dbPathString error:&copyError];
        if (copyError) {
            NSLog(@"ERROR: %@", copyError.localizedDescription);
        }
    }
    
    
    
    [self readDatabase];
}

-(void)readDatabase//:(NSString *)selectQuery
{
    sqlite3_stmt *statement ;
    NSLog(@"%@",self.dbPathString);
    if (sqlite3_open([self.dbPathString UTF8String], &companyDB)==SQLITE_OK)
    {
        [self.allCompanies removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from Company"];
        const char *query_sql = [querySQL UTF8String];
        //Debugging constant SQLITE_OK to see its value (its a BOOL)
        int sql_status = sqlite3_prepare(companyDB, query_sql, -1, &statement, NULL);
        if (sql_status == SQLITE_OK)
        {
            while (sqlite3_step(statement)== SQLITE_ROW)
            {
                int companyId2 = sqlite3_column_int(statement, 0);
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                Company *company = [[Company alloc] initWithCompanyName:name];
                company.companyId = companyId2;
                [self.allCompanies addObject:company];
                
            }
        }
    }
}

-(void)readDatabaseProducts:(int)companyID
{
    sqlite3_stmt *statement ;
    NSLog(@"%@",self.dbPathString);
    if (sqlite3_open([self.dbPathString UTF8String], &companyDB)==SQLITE_OK)
    {
//        for (Product *element in [self.allProducts reverseObjectEnumerator]){
//            if (element) {
//                [self.allProducts removeObject:element];
//                [element release];
//            }
//        }
        
        //If you delete while enumerating you create an NSGenericException
        //This code puts the items in a new array then deletes them
        NSMutableArray *discardedItems = [NSMutableArray array];
        
        for (Product *element in [self.allProducts reverseObjectEnumerator]){
                [discardedItems addObject:element];
                [element autorelease];
        }
        
        [self.allProducts removeObjectsInArray:discardedItems];
        
        discardedItems = nil;
        [discardedItems release];
        
        
//        [self.allProducts removeAllObjects];
        

        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from Product WHERE company_id = ('%d')", companyID];
//        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from Product";
        const char *query_sql = [querySQL UTF8String];
        if (sqlite3_prepare(companyDB, query_sql, -1, &statement, NULL) == SQLITE_OK)
        {
            while (sqlite3_step(statement)== SQLITE_ROW)
            {
                int primaryKey = sqlite3_column_int(statement, 0);
                int company_id = sqlite3_column_int(statement, 1);
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 2)];
                NSString *url = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 3)];

                Product *product = [[Product alloc] init];
                product.primaryKey = primaryKey;
                product.companyID = company_id;
                product.productName = name;
                product.productUrl = url;
                [self.allProducts addObject:product];
                
                //INSTRUMENTS LEAK #3
                [name release];
                [url release];
            }
        }
    }
}

//Delete Company and its Products using company ID
-(void)deleteCompany:(Company *)kompany
{
    
    char *error;
    
    NSString *SQLquery = [NSString stringWithFormat:@"DELETE FROM Product WHERE company_id IS '%d'",kompany.companyId];
    
    
    
    if (sqlite3_exec(companyDB, [SQLquery UTF8String], NULL, NULL, &error)==SQLITE_OK)
    {
        NSLog(@"Product Deleted");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Product(s) Deleted" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
    }

    

    
//    for (Product *element in [self.allProducts reverseObjectEnumerator]){
//        if (element.companyID == kompany.companyId ) {
//            [element release];
//        }
//    }
    
    //If you delete while enumerating you create an NSGenericException
    //This code puts the items in a new array then deletes them
    NSMutableArray *discardedItems = [NSMutableArray array];
    
    for (Product *element in [self.allProducts reverseObjectEnumerator]){
        if (element.companyID == kompany.companyId ) {
        [discardedItems addObject:element];
            [element autorelease];
        }
    }
    
    [self.allProducts removeObjectsInArray:discardedItems];
    
    discardedItems = nil;
    [discardedItems release];

    
    
    char *error2;
    
    NSString *SQLquery2 = [NSString stringWithFormat:@"DELETE FROM Company WHERE id IS '%d'", kompany.companyId];
    
    if (sqlite3_exec(companyDB, [SQLquery2 UTF8String], NULL, NULL, &error2)==SQLITE_OK)
    {
        NSLog(@"Company Deleted");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Company Deleted" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.allCompanies removeObject:kompany];
    
    [kompany release];
}

//Delete all products for deleted comapny using company id
//-(void)delete_All_Products_For_Deleted_Company:(int)company_id
//{
//    char *error;
//    
//    NSString *SQLquery = [NSString stringWithFormat:@"DELETE FROM Product WHERE company_id IS '%d'",company_id];
//    
//
//    
//    if (sqlite3_exec(companyDB, [SQLquery UTF8String], NULL, NULL, &error)==SQLITE_OK)
//    {
//        NSLog(@"Product Deleted");
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Product(s) Deleted" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
//        [alert show];
//    }
//    
//    for (Product *element in self.allProducts){
//        if (element.companyID == company_id) {
//            [self.allProducts removeObject:element];
//            [element release];
//        }
//    }
//    
//    
//}

-(void)deleteSingleProductWithPrimaryKey:(Product *)product
{
    char *error;
    
    NSString *SQLquery = [NSString stringWithFormat:@"DELETE FROM Product WHERE primaryKey IS '%d'",product.primaryKey];
    
    
    if (sqlite3_exec(companyDB, [SQLquery UTF8String], NULL, NULL, &error)==SQLITE_OK)
    {
        NSLog(@"Product Deleted");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Product Deleted" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
    }
    
    [self.allProducts removeObject:product];
    
    [product release];
}

-(void)editCompanyNameSQL:(NSString *)nameChange :(Company *)kompany
{
    char *error;
    
    NSString *changeName = [NSString stringWithFormat:@"UPDATE Company SET companyNAME = '%s' WHERE id IS '%d'",[nameChange UTF8String], kompany.companyId];
    
    
    if (sqlite3_exec(companyDB, [changeName UTF8String], NULL, NULL, &error)==SQLITE_OK)
    {
        NSLog(@"Company Name changed");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"NAME CHANGED" message:@"You Have Changed The Company Name" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
    }
}

-(void)editProductNameSQL:(NSString *)nameChange :(NSString *)urlChange :(Product *)product
{
    char *error;
    
    //Handles changing the product name
    NSString *changeName = [NSString stringWithFormat:@"UPDATE Product SET productName = '%s' WHERE primaryKey is '%d'",[nameChange UTF8String], product.primaryKey];
    
    //Handles changing the URL
    NSString *changeURL = [NSString stringWithFormat:@"UPDATE Product SET productURL = '%s' WHERE primaryKey is '%d'", [urlChange UTF8String], product.primaryKey];
    
    NSLog(@"%d!!!!!!!!!!!!", product.companyID);
    
    sqlite3_exec(companyDB, [changeURL UTF8String], NULL, NULL, &error);

    
    if (sqlite3_exec(companyDB, [changeName UTF8String], NULL, NULL, &error)==SQLITE_OK)
    {
        NSLog(@"Product Name changed");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"NAME CHANGED" message:@"You Have Changed The Product Name" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        
    }
}


@end
