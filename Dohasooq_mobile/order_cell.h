//
//  order_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 28/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface order_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *LBL_seller;

@property(nonatomic,weak) IBOutlet UIImageView *IMG_item;
@property(nonatomic,weak) IBOutlet UILabel *LBL_item_name;
@property(nonatomic,weak) IBOutlet UITextView *LBL_current_price;
//@property(nonatomic,weak) IBOutlet UILabel *LBL_prev_price;
@property(nonatomic,weak) IBOutlet UILabel *LBL_discount;
@property(nonatomic,weak) IBOutlet UIButton *BTN_calendar;

@property(nonatomic,strong) IBOutlet UIButton *BTN_plus;
@property(nonatomic,strong) IBOutlet UIButton *BTN_minus;
@property(nonatomic,strong) IBOutlet UITextField *_TXT_count;
@property(nonatomic,weak) IBOutlet UILabel *LBL_date;
@property(nonatomic,weak) IBOutlet UILabel *LBL_charge;
//@property(nonatomic,weak) IBOutlet UILabel *LBL_pick_merchant_location;
@property (weak, nonatomic) IBOutlet UIButton *BTN_box;

@property(nonatomic,weak) IBOutlet UIButton *BTN_stat;
@property(nonatomic,weak) IBOutlet UIImageView *LBL_stat;

@property (weak, nonatomic) IBOutlet UIView *seperator_view;
@property (weak, nonatomic) IBOutlet UILabel *_LBL_Doha_Miles;


// HeightConstraints
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *CalenderHeight;

@end
