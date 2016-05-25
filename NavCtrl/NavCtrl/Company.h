//
//  Company.h
//  NavCtrl
//
//  Created by Clyfford Millet on 4/21/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Company : NSManagedObject

@property int primaryKey;
@property (nonatomic, retain) NSString *companyName;
//@property (nonatomic, retain) NSMutableArray *products;

-(instancetype)initWithCompanyName:(NSString *)name;

@end
