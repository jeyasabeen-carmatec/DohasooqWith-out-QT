//
//  VC_sign_up.h
//  Dohasooq_mobile
//
//  Created by Test User on 22/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HoshiTextField.h"
#import "Hoshi_Billing_ADDR.h"

@interface VC_sign_up : UIViewController
@property(nonatomic,weak) IBOutlet UILabel *LBL_sign_up;
@property(nonatomic,weak) IBOutlet UIImageView *BTN_close;
@property(nonatomic,weak) IBOutlet UIView *VW_contents;
@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_contents;
@property(nonatomic,weak) IBOutlet UIButton *BTN_submit;

//Textfields

@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_F_name;
@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_L_name;
@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_email;
@property(nonatomic,weak) IBOutlet Hoshi_Billing_ADDR *TXT_phone;
@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_password;
@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_con_password;
@property(nonatomic,weak) IBOutlet UITextField *TXT_prefix;
@property(nonatomic,weak) IBOutlet UIPickerView *phone_picker;






@end
