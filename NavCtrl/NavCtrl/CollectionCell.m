//
//  CollectionCell.m
//  NavCtrl
//
//  Created by Clyfford Millet on 6/4/16.
//  Copyright © 2016 Aditya Narayan. All rights reserved.
//

#import "CollectionCell.h"

@implementation CollectionCell

- (void)dealloc {
    [_collectionViewLogo release];
    [_collectionCompanyLabel release];
    [_collectionStockLabel release];
    [_editLabel release];
    [_nameLabel release];
    [_deleteLabel release];
    [_collectionProductLabel release];
    [super dealloc];
}
- (IBAction)deleteButton:(id)sender {
}

- (IBAction)editNameButton:(id)sender {
    
//    if (!self.editViewController) {
//        self.editViewController = [[EditViewController alloc]init];
//    }
//    
//    self.companyViewController.customEditingMode = NO;
//        
//    [self.companyViewController.navigationController pushViewController:self.editViewController animated:YES];

}
@end
