//
//  product_cell.m
//  Dohasooq_mobile
//
//  Created by Test User on 25/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "product_cell.h"

@implementation product_cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.LBL_item_name.titleLabel.lineBreakMode = NSLineBreakByWordWrapping;
}

@end
