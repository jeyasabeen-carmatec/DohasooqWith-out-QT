//
//  VC_myorders.h
//  Dohasooq_mobile
//
//  Created by Test User on 18/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_myorders : GAITrackedViewController
@property(nonatomic,weak) IBOutlet UITableView *TBL_orders;
@property(nonatomic,weak) IBOutlet UILabel *LBL_order_ID;

@property(nonatomic,weak) IBOutlet UILabel *LBL_order_date;


@end
