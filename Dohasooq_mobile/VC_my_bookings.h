//
//  VC_my_bookings.h
//  Dohasooq_mobile
//
//  Created by Test User on 21/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_my_bookings : GAITrackedViewController

@property(nonatomic,weak) IBOutlet UITableView *TBL_bookings;
@property(nonatomic,weak) IBOutlet UIView *VW_segment;
//Empty View
@property(nonatomic,weak)IBOutlet UIView *VW_empty;
@property(nonatomic,weak)IBOutlet UIButton *BTN_empty;
@end
