//
//  VC_myaddress.h
//  Dohasooq_mobile
//
//  Created by Test User on 18/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_myaddress : GAITrackedViewController
@property(nonatomic,weak) IBOutlet UITableView *TBL_address;
@property(strong,nonatomic)UIPickerView *staes_country_pickr;
@property(strong,nonatomic)UIPickerView *phone_picker_view;

@end
