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
    
    //Add this object to the contex. Nothing happens till it is saved
    Company *kompany = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
    
    [kompany setValue:companyName forKey:@"companyName"];
    [kompany setValue:primaryKey forKey:@"primaryKey"];
    
    
//    [self.allCompanies addObject:kompany];
    
    [self saveContext];
}

-(void) reloadDataFromContext
{
    
    NSFetchRequest *request = [[NSFetchRequest alloc]init];
    
    //A predicate template can also be used
    NSPredicate *p = [NSPredicate predicateWithFormat:@"primaryKey >=0 and companyName MATCHES '.*'"];
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

    self.allCompanies = [[NSMutableArray alloc]initWithArray:result];
//    [self setEmployees:[[NSMutableArray alloc]initWithArray:result]];
}

-(void)deleteCompany:(int)index
{
    
    
    Company *kompany = [[self allCompanies] objectAtIndex:index];
    
    //Remove object from context
    [self.managedObjectContext deleteObject:kompany];
    
    [self saveContext];

}

-(void)hardcode
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    BOOL secondRun = [defaults boolForKey:@"BoolFirstRun"];
   
    if (secondRun != YES) {
    
        Company *kompany = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
        
        NSNumber *pk = [NSNumber numberWithInt:1];
        
        [kompany setValue:@"Apple mobile devices" forKey:@"companyName"];
        [kompany setValue:pk forKey:@"primaryKey"];
        
        Company *kompany2 = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
        
        NSNumber *pk2 = [NSNumber numberWithInt:2];
        
        [kompany2 setValue:@"Samsung mobile devices" forKey:@"companyName"];
        [kompany2 setValue:pk2 forKey:@"primaryKey"];
        
        Company *kompany3 = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
        
        NSNumber *pk3 = [NSNumber numberWithInt:3];
        
        [kompany3 setValue:@"SpaceX" forKey:@"companyName"];
        [kompany3 setValue:pk3 forKey:@"primaryKey"];
        
        Company *kompany4 = [NSEntityDescription insertNewObjectForEntityForName:@"Company" inManagedObjectContext:self.managedObjectContext];
        
        NSNumber *pk4 = [NSNumber numberWithInt:3];
        
        [kompany4 setValue:@"Clyff's CHEESE HOUSE!" forKey:@"companyName"];
        [kompany4 setValue:pk4 forKey:@"primaryKey"];
        
        
        
        [defaults setBool:YES forKey:@"BoolFirstRun"];
        
        
        [self saveContext];
    }
}




















@end
