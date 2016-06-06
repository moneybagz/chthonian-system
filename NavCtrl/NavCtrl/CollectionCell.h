//
//  CollectionCell.h
//  NavCtrl
//
//  Created by Clyfford Millet on 6/4/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CompanyViewController.h"
#import "EditViewController.h"
#import "NavControllerAppDelegate.h"

@interface CollectionCell : UICollectionViewCell

@property (retain, nonatomic) CompanyViewController *companyViewController;

@property (retain, nonatomic) IBOutlet UIImageView *collectionViewLogo;
@property (retain, nonatomic) IBOutlet UILabel *collectionCompanyLabel;
@property (retain, nonatomic) IBOutlet UILabel *collectionStockLabel;
@property (retain, nonatomic) IBOutlet UILabel *editLabel;
@property (retain, nonatomic) IBOutlet UILabel *nameLabel;
@property (retain, nonatomic) IBOutlet UILabel *deleteLabel;
@property (retain, nonatomic) IBOutlet UILabel *collectionProductLabel;





@end
