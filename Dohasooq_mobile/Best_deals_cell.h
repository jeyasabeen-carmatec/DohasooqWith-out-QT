//
//  Best_deals_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 25/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Best_deals_cell : UICollectionViewCell
@property(nonatomic,weak) IBOutlet UIImageView *IMG_item;
@property(nonatomic,weak) IBOutlet UILabel *LBL_best_item_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_best_price;
//@property(nonatomic,weak) IBOutlet UILabel *LBL_prev_best_price;
@property(nonatomic,weak) IBOutlet UILabel *LBL_best_discount;

@end
