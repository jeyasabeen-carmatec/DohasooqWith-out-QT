//
//  special_cell.m
//  Dohasooq_mobile
//
//  Created by anumolu mac mini on 06/02/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import "special_cell.h"

@implementation special_cell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.LBL_instructions.layer.borderWidth = 0.5f;
    self.LBL_instructions.layer.borderColor = [UIColor lightGrayColor].CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
