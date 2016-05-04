//
//  Company.h
//  NavCtrl
//
//  Created by Clyfford Millet on 4/21/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Company : NSObject

@property int companyId;
@property (nonatomic, retain) NSString *companyName;
@property (nonatomic, retain) NSMutableArray *products;

-(instancetype)initWithCompanyName:(NSString *)name;

@end
