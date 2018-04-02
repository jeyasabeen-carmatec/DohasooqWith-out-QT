//
//  orders_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 18/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface orders_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *LBL_item_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_price;
@property(nonatomic,weak) IBOutlet UILabel *LBL_QTY;
@property(nonatomic,weak) IBOutlet UILabel *LBL_seller;

@property(nonatomic,weak) IBOutlet UIImageView *IMG_track;
@property(nonatomic,weak) IBOutlet UILabel *LBL_Deliver_on;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_item_image;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_track_image;

@property(nonatomic,weak) IBOutlet UIButton *BTN_rating;
@property (weak, nonatomic) IBOutlet UILabel *LBL_shipping_type;






@end
