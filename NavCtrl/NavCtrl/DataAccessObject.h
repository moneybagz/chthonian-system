//
//  DataAccessObject.h
//  NavCtrl
//
//  Created by Clyfford Millet on 4/21/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Company;
@class Product;

@interface DataAccessObject : NSObject

//@property (nonatomic, readonly, copy) NSArray *allCompanies;
@property (nonatomic, retain) NSMutableArray *allCompanies;
@property (nonatomic, retain) NSMutableArray *allProducts;
@property (nonatomic, retain) NSString *dbPathString;


+(instancetype)sharedDAO;
//-(void)createCompany:(NSString *)companyName;
//-(void)createProductWithName:(NSString *)productName
//                  productURL:(NSString *)productURL
//       companyNameForProduct:(NSString *)companyNameForProduct;
//-(void)copyDatabaseIfNotExist;
//-(void)addToDAO:(Company *)company;

- (void)saveContext;
- (NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectModel *)managedObjectModel;
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
- (NSURL *)applicationDocumentsDirectory;
-(void)createCompany:(NSNumber*)primaryKey name:(NSString*)companyName;
-(void)createProductWithName:(NSString *)productName
                  productURL:(NSString *)productURL
           companyPrimaryKey:(NSString *)companyPrimaryKey;
-(void)fetchDataCompanies;
-(void)fetchDataProductsWithCompanyName:(int)companyPrimaryKey;
-(void)deleteCompanyWithPrimaryKey:(int)companyPrimaryKey;
-(void)deleteProductWithPrimaryKey:(int)productPrimaryKey;
-(void)editCompanyName:(NSString *)nameChange :(int)companyPrimaryKey;
-(void)editProdutNameAndUrl:(NSString *)nameChange
                        URL:(NSString *)urlChange
          productPrimaryKey:(int)productPrimaryKey;
-(void)moveRowFromIndex:(int)fromIndex toIndex:(int)toIndex;
-(void)hardcode;


@end
