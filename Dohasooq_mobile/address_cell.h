//
//  address_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 18/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface address_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *LBL_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_address;
@property(nonatomic,weak) IBOutlet UILabel *LBL_address_type;
@property(nonatomic,weak) IBOutlet UIButton *BTN_edit;
@property(nonatomic,weak) IBOutlet UIButton *BTN_edit_addres;
@property(nonatomic,weak) IBOutlet UIView *VW_layer;
@property (weak, nonatomic) IBOutlet UILabel *Btn_close;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *Btn_close_width;


@end
