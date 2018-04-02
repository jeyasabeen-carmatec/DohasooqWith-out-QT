//
//  Payment_summary_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 20/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Payment_summary_cell : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *LBL_discount;
@property(nonatomic,weak) IBOutlet UILabel *LBL_discount_TXT;

@property(nonatomic,weak) IBOutlet UILabel *LBL_sub_total;

@property(nonatomic,weak) IBOutlet UILabel *LBL_ship_charge;
@property(nonatomic,weak) IBOutlet UILabel *LBL_total;


@end
