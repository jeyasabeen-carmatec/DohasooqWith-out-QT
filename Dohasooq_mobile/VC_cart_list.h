//
//  VC_cart_list.h
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBadgeButton.h"
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_cart_list : GAITrackedViewController

@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_cart;
@property(nonatomic,strong) IBOutlet MIBadgeButton *BTN_fav;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_back;

@property(nonatomic,weak) IBOutlet UITableView *TBL_cart_items;
@property(nonatomic,weak) IBOutlet UIView *VW_filter;

@property(nonatomic,weak) IBOutlet UILabel *LBL_price;
@property(nonatomic,weak) IBOutlet UILabel *LBL_next;
@property(nonatomic,weak) IBOutlet UILabel *LBL_miles;
@property(nonatomic,weak) IBOutlet UIButton *BTN_header;



@property(nonatomic,strong) IBOutlet UIButton *BTN_view_price;
@property(nonatomic,strong) IBOutlet UIButton *BTN_clear_cart;
@property(nonatomic,strong) IBOutlet UIButton *BTN_next;


@property(nonatomic,strong) IBOutlet UIImageView *IMG_cart;
- (IBAction)wishListAction:(id)sender;

//EMPTY VIEW
@property(nonatomic,weak)IBOutlet UIView *VW_empty;
@property(nonatomic,weak)IBOutlet UIButton *BTN_empty;

//scrol view




@end
