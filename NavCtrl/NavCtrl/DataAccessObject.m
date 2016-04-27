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

-(void)createCompanyAndProducts
{
    //Create product objects
        Product *ipad = [[Product alloc]init];
        ipad.productName =@"iPad";
        ipad.productUrl =@"http://www.apple.com/ipad/";
        Product *ipod = [[Product alloc]init];
        ipod.productName =@"iPod";
        ipod.productUrl =@"http://www.apple.com/ipod/";
        Product *iphone = [[Product alloc]init];
        iphone.productName =@"iPhone";
        iphone.productUrl =@"http://www.apple.com/iphone/";
    
        Product *galaxyS4 = [[Product alloc]init];
        galaxyS4.productName =@"Galaxy S4";
        galaxyS4.productUrl =@"http://www.samsung.com/us/mobile/cell-phones/SCH-I545ZKPVZW";
        Product *galaxyNote = [[Product alloc]init];
        galaxyNote.productName =@"Galaxy Note";
        galaxyNote.productUrl =@"http://www.samsung.com/us/mobile/cell-phones/SM-N920AZKAATT";
        Product *galaxyTab = [[Product alloc]init];
        galaxyTab.productName =@"Galaxy Tab";
        galaxyTab.productUrl =@"http://www.samsung.com/us/mobile/galaxy-tab/SM-T230NZWAXAR";
    
        Product *falcon9rocket = [[Product alloc]init];
        falcon9rocket.productName =@"Falcon 9 Rocket";
        falcon9rocket.productUrl =@"http://www.spacex.com/falcon9";
        Product *dragonCapsule = [[Product alloc]init];
        dragonCapsule.productName =@"Dragon Capsule";
        dragonCapsule.productUrl =@"http://www.spacex.com/dragon";
        Product *falconHeavy = [[Product alloc]init];
        falconHeavy.productName =@"Falcon Heavy";
        falconHeavy.productUrl =@"http://www.spacex.com/falcon-heavy";
    
        Product *swiss = [[Product alloc]init];
        swiss.productName =@"Swiss";
        swiss.productUrl =@"http://www.cheese.com/swiss/";
        Product *gruyere = [[Product alloc]init];
        gruyere.productName =@"Gruyere";
        gruyere.productUrl =@"http://www.cheese.com/gruyere/";
        Product *roqueforte = [[Product alloc]init];
        roqueforte.productName =@"Roqueforte";
        roqueforte.productUrl =@"http://www.cheese.com/roquefort/";
    
    
        //Create company objects and fill them with product objects
        Company *appleMobileDevices = [[Company alloc]init];
        appleMobileDevices.companyName =@"Apple mobile devices";
        appleMobileDevices.products = [[NSMutableArray alloc]init];
        [appleMobileDevices.products addObject:ipad];
        [appleMobileDevices.products addObject:ipod];
        [appleMobileDevices.products addObject:iphone];
    
        Company *samsungMobileDevices = [[Company alloc]init];
        samsungMobileDevices.companyName =@"Samsung mobile devices";
        samsungMobileDevices.products = [[NSMutableArray alloc]init];
        [samsungMobileDevices.products addObject:galaxyS4];
        [samsungMobileDevices.products addObject:galaxyNote];
        [samsungMobileDevices.products addObject:galaxyTab];
    
        Company *spaceX = [[Company alloc]init];
        spaceX.companyName =@"SpaceX";
        spaceX.products = [[NSMutableArray alloc]init];
        [spaceX.products addObject:falcon9rocket];
        [spaceX.products addObject:dragonCapsule];
        [spaceX.products addObject:falconHeavy];
    
        Company *billsCheeseFactory = [[Company alloc]init];
        billsCheeseFactory.companyName =@"Bill's cheese factory";
        billsCheeseFactory.products = [[NSMutableArray alloc]init];
        [billsCheeseFactory.products addObject:swiss];
        [billsCheeseFactory.products addObject:gruyere];
        [billsCheeseFactory.products addObject:roqueforte];
    
    [self.allCompanies addObject:appleMobileDevices];
    [self.allCompanies addObject:samsungMobileDevices];
    [self.allCompanies addObject:spaceX];
    [self.allCompanies addObject:billsCheeseFactory];
}

@end
