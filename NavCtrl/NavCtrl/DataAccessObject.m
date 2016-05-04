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

@interface DataAccessObject () {
    //@property (nonatomic) NSMutableArray *privateCompanies;
    sqlite3 *companyDB;
    NSString *dbPathString;
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
    
    return self;
}

//-(NSArray *)allCompanies
//{
//    return [self.privateCompanies copy];
//}

-(void)createCompany:(NSString *)companyName
{
    Company *company = [[Company alloc]initWithCompanyName:companyName];
    
    [self.allCompanies addObject:company];
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"NavController.db"];

    char *error;


    if(sqlite3_open([dbPathString UTF8String], &companyDB) == SQLITE_OK) {

        DataAccessObject *dao = [DataAccessObject sharedDAO];

        NSString *insertStmt = [NSString stringWithFormat:@"INSERT INTO Company (id, companyName) VALUES ('%lu','%s')", (dao.allCompanies.count),[companyName UTF8String]];


        const char *insert_stmt = [insertStmt UTF8String];
        //NSLog(@"Add Person button click..");
        if (sqlite3_exec(companyDB, insert_stmt, NULL, NULL, &error) == SQLITE_OK) {

            NSLog(@"Company added to DB");
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Add Company Complete" message:@"Company added to DB" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
            [alert show];
        }
        sqlite3_close(companyDB);
    }
}




-(void)addToDAO:(Company *)company
{
    [self.allCompanies addObject:company];
}

-(void)createProductWithName:(NSString *)productName
                  productURL:(NSString *)productURL
       companyNameForProduct:(NSString *)companyNameForProduct
{
    Product *product = [[Product alloc]init];
    
    product.productName = productName;
    product.productUrl = productURL;
    
    for (Company *element in self.allCompanies){
        if (element.companyName == companyNameForProduct) {
            [element.products addObject:product];
        }
    }
}

-(void)copyDatabaseIfNotExist
{
    NSError *copyError;
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *docPath = [path objectAtIndex:0];
    dbPathString = [docPath stringByAppendingPathComponent:@"NavController.db"];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    if (![fileManager fileExistsAtPath:dbPathString])
    {
        NSString *dataPath = [[NSBundle mainBundle] pathForResource:@"NavController" ofType:@"db"];
        [fileManager copyItemAtPath:dataPath toPath:dbPathString error:&copyError];
        if (copyError) {
            NSLog(@"ERROR: %@", copyError.localizedDescription);
        }
    }
    
    
    
    [self readDatabase];
}

-(void)readDatabase {
    sqlite3_stmt *statement ;
    NSLog(@"%@",dbPathString);
    if (sqlite3_open([dbPathString UTF8String], &companyDB)==SQLITE_OK)
    {
        [self.allCompanies removeAllObjects];
        NSString *querySQL = [NSString stringWithFormat:@"SELECT * from Company"];
        const char *query_sql = [querySQL UTF8String];
        int sql_status = sqlite3_prepare(companyDB, query_sql, -1, &statement, NULL);
        if (sql_status == SQLITE_OK)
        {
            while (sqlite3_step(statement)== SQLITE_ROW)
            {
//                const unsigned char* companyId = sqlite3_column_text(statement, 0);
                int companyId2 = sqlite3_column_int(statement, 0);
                NSString *name = [[NSString alloc]initWithUTF8String:(const char *)sqlite3_column_text(statement, 1)];
                
                Company *company = [[Company alloc] initWithCompanyName:name];
//                company.companyId = *companyId - 48;
                company.companyId = companyId2;
                [self.allCompanies addObject:company];
                
            }
        }
    }
    //[[self myTableView]reloadData];
}

-(void)deleteCompanyData:(NSString *)deleteQuery
{
    char *error;
    if (sqlite3_exec(companyDB, [deleteQuery UTF8String], NULL, NULL, &error)==SQLITE_OK)
    {
        NSLog(@"Company Deleted");
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"Delete" message:@"Company Deleted" delegate:self cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
    }
}



@end
