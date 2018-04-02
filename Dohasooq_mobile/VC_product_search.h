//
//  VC_product_search.h
//  Dohasooq_mobile
//
//  Created by Test User on 14/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_product_search : GAITrackedViewController
@property(nonatomic,weak) IBOutlet UITextField *TXT_search;
@property(nonatomic,weak) IBOutlet UIButton *BTN_close;
@property(nonatomic,weak) IBOutlet UITableView  *TBL_search_results;

@property(nonatomic,weak) IBOutlet UIView *VW_navMenu;
@property(nonatomic,weak) IBOutlet UIButton *BTN_search;

//EMPTY VIEW
@property(nonatomic,weak)IBOutlet UIView *VW_empty;
@property(nonatomic,weak)IBOutlet UIButton *BTN_empty;


@end
