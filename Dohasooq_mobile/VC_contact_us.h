//
//  VC_contact_us.h
//  Dohasooq_mobile
//
//  Created by Test User on 07/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hoshi_Billing_ADDR.h"
#import "TXT_Placeholder.h"
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_contact_us : GAITrackedViewController
@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_contents;
@property(nonatomic,weak) IBOutlet UIView *VW_contents;
@property(nonatomic,weak) IBOutlet UIView *VW_contact;
@property(nonatomic,weak) IBOutlet UITextView *TXT_text;
@property(nonatomic,weak) IBOutlet UIView *VW_address;
@property(nonatomic,weak) IBOutlet UILabel *LBL_address;
@property(nonatomic,weak) IBOutlet UIView *VW_contact_us;
@property(nonatomic,weak) IBOutlet UIButton *BTN_submit;


@property(nonatomic,weak) IBOutlet Hoshi_Billing_ADDR *TXT_F_name;
@property(nonatomic,weak) IBOutlet Hoshi_Billing_ADDR *TXT_email;
@property(nonatomic,weak) IBOutlet Hoshi_Billing_ADDR *TXT_phone;

@property(nonatomic,weak) IBOutlet Hoshi_Billing_ADDR *TXT_message;
@property(nonatomic,weak) IBOutlet Hoshi_Billing_ADDR *TXT_organisation;


@end
