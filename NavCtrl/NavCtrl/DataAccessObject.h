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
@property int undoLimit;

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
           companyPrimaryKey:(int)companyPrimaryKey
                productCount:(int)productCount;
-(void)fetchDataCompanies;
-(void)fetchDataProductsWithCompanyName:(int)companyPrimaryKey;
-(void)deleteCompanyWithPrimaryKey:(int)companyPrimaryKey;
-(void)deleteProductWithPrimaryKey:(int)productPrimaryKey
                 companyPrimaryKey:(int)companyPrimaryKey;
-(void)editCompanyName:(NSString *)nameChange :(int)companyPrimaryKey;
-(void)editProdutNameAndUrl:(NSString *)nameChange
                        URL:(NSString *)urlChange
          productPrimaryKey:(int)productPrimaryKey;
-(void)companyMoveRowFromIndex:(int)fromIndex toIndex:(int)toIndex;
-(void)productMoveRowFromIndex:(int)fromIndex
                       toIndex:(int)toIndex
             companyPrimaryKey:(int)companyPrimaryKey;
-(void)hardcode;
-(void)undoManagerCompanies;
-(void)undoManagerProducts;


@end
