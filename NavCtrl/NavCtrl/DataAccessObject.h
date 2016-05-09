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
-(void)readDatabaseProducts:(int)productID;
-(void)deleteData:(NSString *)deleteQuery;
-(void)deleteData2:(int)deleteQuery;
-(void)deleteData3:(NSString *)deleteQuery;
-(void)editCompanyNameSQL:(NSString *)nameChange :(NSString *)companyName;
-(void)editProductNameSQL:(NSString *)nameChange :(NSString *)productName :(NSString *) productURL;

@end
