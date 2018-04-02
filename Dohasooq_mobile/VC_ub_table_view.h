//
//  VC_ub_table_view.h
//  Dohasooq_mobile
//
//  Created by Test User on 04/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_ub_table_view : GAITrackedViewController

@property(nonatomic,weak) IBOutlet UITableView *TBL_sub_brnds;
@property(nonatomic,weak) IBOutlet UIButton *BTN_title;

//EMPTY VIEW
@property(nonatomic,weak)IBOutlet UIView *VW_empty;
@property(nonatomic,weak)IBOutlet UIButton *BTN_empty;

@end
