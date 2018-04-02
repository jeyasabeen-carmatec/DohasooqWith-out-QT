//
//  product_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 25/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface product_cell : UICollectionViewCell
@property(nonatomic,weak) IBOutlet UIImageView *IMG_item;
@property(nonatomic,weak) IBOutlet UILabel *LBL_rating;
@property(nonatomic,weak) IBOutlet UIButton *LBL_item_name;
@property(nonatomic,weak) IBOutlet UITextView *LBL_current_price;
@property(nonatomic,weak) IBOutlet UIButton *BTN_price;
@property(nonatomic,weak) IBOutlet UILabel *LBL_discount;
@property(nonatomic,weak) IBOutlet UIButton *BTN_fav;
@property(nonatomic,weak) IBOutlet UILabel *LBL_stock;


@end
