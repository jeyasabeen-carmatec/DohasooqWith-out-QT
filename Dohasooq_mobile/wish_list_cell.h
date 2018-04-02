//
//  wish_list_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wish_list_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UIImageView *IMG_item;
@property(nonatomic,weak) IBOutlet UILabel *LBL_item_name;
@property(nonatomic,weak) IBOutlet UITextView *LBL_current_price;
//@property(nonatomic,weak) IBOutlet UILabel *LBL_prev_price;
@property(nonatomic,weak) IBOutlet UILabel *LBL_discount;
@property(nonatomic,weak) IBOutlet UIImageView *BTN_close;

@property(nonatomic,strong) IBOutlet UIButton *BTN_plus;
@property(nonatomic,strong) IBOutlet UIButton *BTN_minus;
@property(nonatomic,strong) IBOutlet UITextField *_TXT_count;
//@property(nonatomic,strong) IBOutlet UIButton *BTN_ADD_cart;
@property (weak, nonatomic) IBOutlet UIButton *Btn_add_cart;

@property(nonatomic,weak) IBOutlet UILabel *LBL_ad_to_cart;



@end
