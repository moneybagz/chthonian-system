//
//  Company.m
//  NavCtrl
//
//  Created by Clyfford Millet on 4/21/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "Company.h"

@implementation Company

-(instancetype)init
{
    self = [super init];
    
    if (self) {
        _products = [[NSMutableArray alloc]init];
    }
    
    
    return self;
}
//
//-(void)dealloc{
//    //release all instance variables
//    
//    [super dealloc];
//    
////    [self.companyId release];
//    [self.companyName release];
//}



@end
