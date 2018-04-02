//
//  hot_deals_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 23/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface hot_deals_cell : UICollectionViewCell

@property(nonatomic,weak) IBOutlet UIImageView *IMG_item;
@property(nonatomic,weak) IBOutlet UILabel *LBL_item_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_price;
//@property(nonatomic,weak) IBOutlet UILabel *LBL_prev_price;
@property(nonatomic,weak) IBOutlet UILabel *LBL_discount;



@end
