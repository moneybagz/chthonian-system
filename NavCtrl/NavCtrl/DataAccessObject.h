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
-(void)createCompany:(NSString *)companyName;
-(void)createProductWithName:(NSString *)productName
                  productURL:(NSString *)productURL
       companyNameForProduct:(NSString *)companyNameForProduct;
-(void)copyDatabaseIfNotExist;
-(void)addToDAO:(Company *)company;
-(void)readDatabase;
-(void)readDatabaseProducts:(int)companyID;
-(void)deleteCompany:(Company *)kompany;
-(void)deleteSingleProductWithPrimaryKey:(Product *)product;
-(void)editCompanyNameSQL:(NSString *)nameChange :(Company *)kompany;
-(void)editProductNameSQL:(NSString *)nameChange :(NSString *)urlChange :(Product *)product;

@end
