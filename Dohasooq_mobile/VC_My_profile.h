//
//  VC_My_profile.h
//  Dohasooq_mobile
//
//  Created by Test User on 28/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "profile_Hoshi_Billing_ADDR.h"
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_My_profile : GAITrackedViewController <UIGestureRecognizerDelegate>

@property(nonatomic,weak) IBOutlet UIScrollView *scroll_contents;

// profile edit view
@property(nonatomic,weak) IBOutlet UIView *VW_profile_pic;

@property(nonatomic,weak) IBOutlet UIImageView *IMG_Profile_pic;
@property(nonatomic,weak) IBOutlet UITextField *TXT_name;
@property(nonatomic,weak) IBOutlet UIButton *BTN_camera;
@property(nonatomic,weak) IBOutlet UIView *VW_layer;
@property(nonatomic,weak) IBOutlet UIView *VW_profile;
@property(nonatomic,weak) IBOutlet UIButton *BTN_edit;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_first_name;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_last_name;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_land_phone;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_mobile_phone;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_Dob;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_group;
@property(nonatomic,weak) IBOutlet UITextField *TXT_country_fld;
@property(nonatomic,weak) IBOutlet UILabel *LBL_arrow;

@property(nonatomic,weak) IBOutlet UIButton *BTN_bank_customer;
@property(nonatomic,weak) IBOutlet UIButton *BTN_bank_employee;
@property(nonatomic,weak) IBOutlet UIButton *BTN_male;
@property(nonatomic,weak) IBOutlet UIButton *BTN_feamle;

@property(nonatomic,weak) IBOutlet UIButton *BTN_save;
@property (nonatomic, strong) UIDatePicker *date_picker;




//login_view

@property(nonatomic,weak) IBOutlet UIView *VW_login;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_email;
@property(nonatomic,weak) IBOutlet UIView *VW_layer_login;

//biiling view

@property(nonatomic,weak) IBOutlet UIView *VW_billing;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_country;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_state;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_city;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_address1;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_address2;
@property(nonatomic,weak) IBOutlet profile_Hoshi_Billing_ADDR *TXT_zipcode;


@property(nonatomic,weak) IBOutlet UIView *VW_layer_billing;
@property(nonatomic,weak) IBOutlet UIButton *BTN_edit_billing;
@property(nonatomic,weak) IBOutlet UIButton *BTN_save_billing;

@property (nonatomic, strong) UIPickerView *contry_pickerView;
@property (nonatomic, strong) UIPickerView *state_pickerView;
//@property (nonatomic, strong) UIPickerView *group_pickerVIEW;
@property(strong,nonatomic)UIPickerView *flag_contry_pickerCiew;







@end
