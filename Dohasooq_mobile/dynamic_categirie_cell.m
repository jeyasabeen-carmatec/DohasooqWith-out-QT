//
//  dynamic_categirie_cell.m
//  Dohasooq_mobile
//
//  Created by Test User on 17/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "dynamic_categirie_cell.h"

@implementation dynamic_categirie_cell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.LBL_name = [[UILabel alloc]initWithFrame:CGRectMake(15, 10, 320, 20)];
        self.LBL_name.backgroundColor = [UIColor clearColor];
        [self.contentView addSubview:self.LBL_name];
        // Initialization code
    }
    return self;
}

        
    - (void)setSelected:(BOOL)selected animated:(BOOL)animated
    {
        [super setSelected:selected animated:animated];
        
        // Configure the view for the selected state
    }
    
    
    - (void)layoutSubviews{
        [super layoutSubviews];
        float indentPoints = self.indentationLevel * self.indentationWidth;
        
        self.contentView.frame = CGRectMake(
                                            indentPoints,
                                            self.contentView.frame.origin.y,
                                            self.contentView.frame.size.width - indentPoints,
                                            self.contentView.frame.size.height
                                            );
    }

@end
