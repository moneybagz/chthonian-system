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

@interface DataAccessObject ()
//@property (nonatomic) NSMutableArray *privateCompanies;
@end

@implementation DataAccessObject

+(instancetype)sharedCompanies
{
    static DataAccessObject *sharedCompanies;
    
    if (!sharedCompanies) {
        
        sharedCompanies =[[self alloc]initPrivate];

    }
    
    return sharedCompanies;
}

-(instancetype)init
{
    [NSException raise:@"Singleton"
                format:@"Use +[DataAccessObject sharedCompanies]"];
    
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


@end
