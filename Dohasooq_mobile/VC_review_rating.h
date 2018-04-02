//
//  VC_review_rating.h
//  Dohasooq_mobile
//
//  Created by Test User on 05/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HCSStarRatingView.h"

@interface VC_review_rating : UIViewController
@property(nonatomic,weak) IBOutlet UILabel *LBL_item_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_my_review;
@property(nonatomic,weak) IBOutlet UIImageView *Item_image;

@property(nonatomic,weak) IBOutlet UILabel *LBL_seller;
@property(nonatomic,weak) IBOutlet UILabel *LBL_rating;
@property(nonatomic,weak) IBOutlet UIButton *BTN_save;
@property(nonatomic,weak) IBOutlet UITextView *TXT_review_review;




@end
