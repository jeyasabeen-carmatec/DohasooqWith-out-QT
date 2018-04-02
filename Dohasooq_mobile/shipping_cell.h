//
//  shipping_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 04/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface shipping_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *LBL_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_address;
@property(nonatomic,weak) IBOutlet UIButton *BTN_radio;
@property(nonatomic,weak) IBOutlet UIButton *BTN_edit;
@property(nonatomic,weak) IBOutlet UIButton *BTN_edit_addres;


@end
