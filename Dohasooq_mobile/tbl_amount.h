//
//  tbl_amount.h
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface tbl_amount : UITableViewCell

@property(nonatomic,weak) IBOutlet UILabel *LBL_amount;
//@property(nonatomic,weak) IBOutlet UILabel *LBL_redemption;
@property(nonatomic,weak) IBOutlet UILabel *LBL_total_amount;
@property (weak, nonatomic) IBOutlet UILabel *redempion_lbl;
@property (weak, nonatomic) IBOutlet UILabel *redemption_amt;
@property (weak, nonatomic) IBOutlet UILabel *LBL_dohamiles;


@end
