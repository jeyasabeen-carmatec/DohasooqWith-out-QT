//
//  bookings_cell.h
//  Dohasooq_mobile
//
//  Created by Test User on 21/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface bookings_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *LBL_event_name;
@property(nonatomic,weak) IBOutlet UILabel *LBL_confirmation_code;
@property(nonatomic,weak) IBOutlet UILabel *LBL_theatre;
@property(nonatomic,weak) IBOutlet UILabel *LBL_timings;
@property(nonatomic,weak) IBOutlet UILabel *LBL_seats;
@property(nonatomic,weak) IBOutlet UILabel *LBL_total_amount;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_item_name;

@end
