//
//  VC_wish_list.h
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBadgeButton.h"
 #import <GoogleAnalytics/GAITrackedViewController.h>
@interface VC_wish_list :GAITrackedViewController
@property(nonatomic,strong) IBOutlet MIBadgeButton *BTN_cart;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_fav;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_back;
@property(nonatomic,weak) IBOutlet UIButton *BTN_header;

- (IBAction)wishList_to_cartPage:(id)sender;
@property(nonatomic,weak) IBOutlet UITableView *TBL_wish_list_items;
//EMPTY VIEW
@property(nonatomic,weak)IBOutlet UIView *VW_empty;
@property(nonatomic,weak)IBOutlet UIButton *BTN_empty;

@end
