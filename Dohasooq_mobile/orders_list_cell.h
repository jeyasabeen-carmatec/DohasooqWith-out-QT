//
//  orders_list_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 04/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orders_list_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIButton *BTN_order_ID;
@property(nonatomic,weak) IBOutlet UIButton *BTN_track_location;
@property(nonatomic,weak) IBOutlet UILabel *LBL_order_date;
@property(nonatomic,weak) IBOutlet UILabel *LBL_price;
@property(nonatomic,weak) IBOutlet UIView *VW_content;




@end
