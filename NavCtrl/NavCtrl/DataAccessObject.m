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
@import CoreData;


@interface DataAccessObject ()
    
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, strong) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, strong) NSPersistentStoreCoordinator *persistentStoreCoordinator;

@property (nonatomic, strong) NSString *storeURLstring;

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

-(void)addToDAO:(Company *)company
{
    [self.allCompanies addObject:company];
}

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
    NSLog(@"WORKED?");
}

- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    
//    [self setModel:[NSManagedObjectModel mergedModelFromBundles:nil]];
    
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"NavController.sqlite"];
    NSLog(@"%@",storeURL);
    
    self.storeURLstring = [storeURL absoluteString];
    NSLog(@"%@", self.storeURLstring);
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(void)createCompany:(NSNumber*)primaryKey name:(NSString*)companyName
{

    // Create Company
    NSEntityDescription *entityCompany1 = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *kompany1 = [[NSManagedObject alloc] initWithEntity:entityCompany1 insertIntoManagedObjectContext:self.managedObjectContext];
    
    [kompany1 setValue:companyName forKey:@"companyName"];
    [kompany1 setValue:primaryKey forKey:@"primaryKey"];
    
    
    [self.allCompanies addObject:kompany1];
    
    [self saveContext];
}

-(void)createProductWithName:(NSString *)productName
                  productURL:(NSString *)productURL
       companyNameForProduct:(NSString *)companyNameForProduct
{
    
    // Create Company
    NSEntityDescription *entityProduct = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
    NSManagedObject *product = [[NSManagedObject alloc] initWithEntity:entityProduct insertIntoManagedObjectContext:self.managedObjectContext];
    
    [product setValue:productName forKey:@"productName"];
    [product setValue:productURL forKey:@"productURL"];
    
    
    
    
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"%K == %@", @"companyName", companyNameForProduct];
    [request setPredicate:p];
    
    
    NSEntityDescription *e = [[self.managedObjectModel entitiesByName] objectForKey:@"Company"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
//    //empty allproducts before filling with values
//    [self.allProducts removeAllObjects];
    
    for (NSManagedObject *companyElement in result){
        
        
        NSMutableSet *products = [companyElement mutableSetValueForKey:@"products"];
        [products addObject:product];
        
//            [self.allProducts addObject:product];
    }
    [self saveContext];
}


-(void)fetchDataCompanies
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
//    NSPredicate *p = [NSPredicate predicateWithFormat:@"primaryKey >=0 and companyName MATCHES '.*'"];
    NSPredicate *p = [NSPredicate predicateWithFormat:@"companyName MATCHES '.*'"];
    [request setPredicate:p];
    
    
    
    //Change ascending  YES/NO and validate
    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc]
                                    initWithKey:@"primaryKey" ascending:YES];
    
    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSEntityDescription *e = [[self.managedObjectModel entitiesByName] objectForKey:@"Company"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    [self.allCompanies removeAllObjects];
    
    for (NSManagedObject *element in result) {
        
        Company *kompany = [[Company alloc]init];
        kompany.companyName = [element valueForKey:@"companyName"];
        kompany.primaryKey = [element valueForKey:@"primaryKey"];
        NSLog(@"name:%@ key:%d", kompany.companyName, kompany.primaryKey);
    }
    
    [self.allCompanies removeAllObjects];

    self.allCompanies = [[NSMutableArray alloc]initWithArray:result];
//    [self setEmployees:[[NSMutableArray alloc]initWithArray:result]];
}

-(void)fetchDataProductsWithCompanyName:(NSString *)companyName
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"%K == %@", @"companyName", companyName];
    [request setPredicate:p];
    
    
    
    //Change ascending  YES/NO and validate
//    NSSortDescriptor *sortByName = [[NSSortDescriptor alloc]
//                                    initWithKey:@"primaryKey" ascending:YES];
//    
//    [request setSortDescriptors:[NSArray arrayWithObject:sortByName]];
    
    NSEntityDescription *e = [[self.managedObjectModel entitiesByName] objectForKey:@"Company"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    //empty allproducts before filling with values
    [self.allProducts removeAllObjects];
    
    for (NSManagedObject *companyElement in result){
        
        //use keyvalue coding to get the array of products in Company relationship "products"
        NSArray * products = [companyElement valueForKey:@"products"];
        for(NSManagedObject *productElement in products){
            Product *product = [[Product alloc]init];
            product.productName = [productElement valueForKey:@"productName"];
            product.productUrl = [productElement valueForKey:@"productURL"];
            NSLog(@"name:%@ url:%@", product.productName, product.productUrl);
            
            [self.allProducts addObject:product];
        }
    }
}


-(void)deleteCompany:(int)index
{
    
    Company *kompany = [[self allCompanies] objectAtIndex:index];
    
    [self.allCompanies removeObjectAtIndex:index];
    
    //Remove object from context
    [self.managedObjectContext deleteObject:kompany];
    
    [self saveContext];

}

-(void)editCompanyName:(NSString *)nameChange :(NSString *)companyName
{
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"%K == %@", @"companyName", companyName];
    [request setPredicate:p];
    
    NSEntityDescription *e = [[self.managedObjectModel entitiesByName] objectForKey:@"Company"];
    [request setEntity:e];
    NSError *error = nil;
    
    
    //This gets data only from context, not from store
    NSArray *result = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if(!result)
    {
        [NSException raise:@"Fetch Failed" format:@"Reason: %@", [error localizedDescription]];
    }
    
    
    for (NSManagedObject *companyElement in result){
        
        [companyElement setValue:nameChange forKey:@"companyName"];
    }
    
    [self saveContext];
}

-(void)hardcode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL pastFirstRun = [defaults boolForKey:@"BoolFirstRun"];
   
    //make sure hardcode only occurs during first run
    if (pastFirstRun == NO) {
    
  
        
        
        
        
        // Create Company
        NSEntityDescription *entityCompany1 = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *kompany1 = [[NSManagedObject alloc] initWithEntity:entityCompany1 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set company name and primary key
        NSNumber *pk = [NSNumber numberWithInt:1];
        
        [kompany1 setValue:@"Apple mobile devices" forKey:@"companyName"];
        [kompany1 setValue:pk forKey:@"primaryKey"];
        
        
        NSEntityDescription *entityCompany2 = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *kompany2 = [[NSManagedObject alloc] initWithEntity:entityCompany2 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set company name and primary key
        NSNumber *pk2 = [NSNumber numberWithInt:2];
        
        [kompany2 setValue:@"Samsung mobile devices" forKey:@"companyName"];
        [kompany2 setValue:pk2 forKey:@"primaryKey"];
        
        
        NSEntityDescription *entityCompany3 = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *kompany3 = [[NSManagedObject alloc] initWithEntity:entityCompany3 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set company name and primary key
        NSNumber *pk3 = [NSNumber numberWithInt:3];
        
        [kompany3 setValue:@"SpaceX" forKey:@"companyName"];
        [kompany3 setValue:pk3 forKey:@"primaryKey"];
        
        
        NSEntityDescription *entityCompany4 = [NSEntityDescription entityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *kompany4 = [[NSManagedObject alloc] initWithEntity:entityCompany4 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set company name and primary key
        NSNumber *pk4 = [NSNumber numberWithInt:4];
        
        [kompany4 setValue:@"Clyff's CHEESE HOUSE!" forKey:@"companyName"];
        [kompany4 setValue:pk4 forKey:@"primaryKey"];
        
        
        
                                      //Create Products
        
        // Create Product
        NSEntityDescription *entityProduct1 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product1 = [[NSManagedObject alloc] initWithEntity:entityProduct1 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product1 setValue:@"iPad" forKey:@"productName"];
        [product1 setValue:@"http://www.apple.com/ipad/" forKey:@"productURL"];
        
        
        // Create Product
        NSEntityDescription *entityProduct2 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product2 = [[NSManagedObject alloc] initWithEntity:entityProduct2 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product2 setValue:@"iPod" forKey:@"productName"];
        [product2 setValue:@"http://www.apple.com/ipod/" forKey:@"productURL"];
 
        
        // Create Product
        NSEntityDescription *entityProduct3 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product3 = [[NSManagedObject alloc] initWithEntity:entityProduct3 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product3 setValue:@"iPhone" forKey:@"productName"];
        [product3 setValue:@"http://www.apple.com/iphone/" forKey:@"productURL"];
        
        //now add products to NSMutableset in Company(entity) products(relationship)
        NSMutableSet *productsForApple = [kompany1 mutableSetValueForKey:@"products"];
        [productsForApple addObject:product1];
        [productsForApple addObject:product2];
        [productsForApple addObject:product3];
        
        
        // Create Product
        NSEntityDescription *entityProduct4 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product4 = [[NSManagedObject alloc] initWithEntity:entityProduct4 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product4 setValue:@"Galaxy S4" forKey:@"productName"];
        [product4 setValue:@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKPVZW" forKey:@"productURL"];
        
        
        // Create Product
        NSEntityDescription *entityProduct5 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product5 = [[NSManagedObject alloc] initWithEntity:entityProduct5 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product5 setValue:@"Galaxy Note" forKey:@"productName"];
        [product5 setValue:@"http://www.samsung.com/us/mobile/cell-phones/SM-N920AZKAATT" forKey:@"productURL"];
        
        
        // Create Product
        NSEntityDescription *entityProduct6 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product6 = [[NSManagedObject alloc] initWithEntity:entityProduct6 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product6 setValue:@"Galaxy Tab" forKey:@"productName"];
        [product6 setValue:@"http://www.samsung.com/us/mobile/galaxy-tab/SM-T230NZWAXAR" forKey:@"productURL"];
        
        //now add products to NSMutableset in Company(entity) products(relationship)
        NSMutableSet *productsForSamsung = [kompany2 mutableSetValueForKey:@"products"];
        [productsForSamsung addObject:product4];
        [productsForSamsung addObject:product5];
        [productsForSamsung addObject:product6];
        
        // Create Product
        NSEntityDescription *entityProduct7 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product7 = [[NSManagedObject alloc] initWithEntity:entityProduct7 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product7 setValue:@"Falcon 9 Rocket" forKey:@"productName"];
        [product7 setValue:@"http://www.spacex.com/falcon9" forKey:@"productURL"];
        
        
        // Create Product
        NSEntityDescription *entityProduct8 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product8 = [[NSManagedObject alloc] initWithEntity:entityProduct8 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product8 setValue:@"Dragon Capsule" forKey:@"productName"];
        [product8 setValue:@"http://www.spacex.com/dragon" forKey:@"productURL"];
        
        
        // Create Product
        NSEntityDescription *entityProduct9 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product9 = [[NSManagedObject alloc] initWithEntity:entityProduct9 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product9 setValue:@"Falcon Heavy" forKey:@"productName"];
        [product9 setValue:@"http://www.spacex.com/falcon-heavy" forKey:@"productURL"];
        
        //now add products to NSMutableset in Company(entity) products(relationship)
        NSMutableSet *productsForSpaceX = [kompany3 mutableSetValueForKey:@"products"];
        [productsForSpaceX addObject:product7];
        [productsForSpaceX addObject:product8];
        [productsForSpaceX addObject:product9];
        
        
        // Create Product
        NSEntityDescription *entityProduct10 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product10 = [[NSManagedObject alloc] initWithEntity:entityProduct10 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product10 setValue:@"Swiss" forKey:@"productName"];
        [product10 setValue:@"http://www.cheese.com/swiss/" forKey:@"productURL"];
        
        
        // Create Product
        NSEntityDescription *entityProduct11 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product11 = [[NSManagedObject alloc] initWithEntity:entityProduct11 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product11 setValue:@"Gruyere" forKey:@"productName"];
        [product11 setValue:@"http://www.cheese.com/gruyere/" forKey:@"productURL"];
        
        
        // Create Product
        NSEntityDescription *entityProduct12 = [NSEntityDescription entityForName:@"Product" inManagedObjectContext:self.managedObjectContext];
        NSManagedObject *product12 = [[NSManagedObject alloc] initWithEntity:entityProduct12 insertIntoManagedObjectContext:self.managedObjectContext];
        
        // Set Product name and product url
        [product12 setValue:@"Roqueforte" forKey:@"productName"];
        [product12 setValue:@"http://www.cheese.com/roquefort/" forKey:@"productURL"];
        
        //now add products to NSMutableset in Company(entity) products(relationship)
        NSMutableSet *productsForCheeseCo = [kompany4 mutableSetValueForKey:@"products"];
        [productsForCheeseCo addObject:product10];
        [productsForCheeseCo addObject:product11];
        [productsForCheeseCo addObject:product12];
        
        
        
        
        

        
        
        [defaults setBool:YES forKey:@"BoolFirstRun"];
        
        
        [self saveContext];
    }
}




















@end
