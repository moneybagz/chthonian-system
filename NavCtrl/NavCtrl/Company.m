//
//  Company.m
//  NavCtrl
//
//  Created by Clyfford Millet on 4/21/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)initWithCompanyName:(NSString *)name
{
    self = [super init];
    
    if (self) {
        _companyName = name;
        
        _products = [[NSMutableArray alloc]init];
    }
    
    
    return self;
}




@end
