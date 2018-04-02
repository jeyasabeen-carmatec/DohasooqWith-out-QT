//
//  sellers_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 19/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface sellers_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UITextView *LBL_cost;
@property(nonatomic,weak) IBOutlet UILabel *LBL_status;
@property(nonatomic,weak) IBOutlet UILabel *LBL_name;
//@property(nonatomic,weak) IBOutlet UILabel *LBL_rating;
@property(nonatomic,weak) IBOutlet UILabel *LBL_riview;;
@property(nonatomic,weak) IBOutlet UIButton *BTN_add_cart;;
@property(nonatomic,weak) IBOutlet UIButton *BTN_details;;

@property (weak, nonatomic) IBOutlet HCSStarRatingView *starView;





@end
