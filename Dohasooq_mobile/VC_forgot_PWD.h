//
//  VC_forgot_PWD.h
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HoshiTextField.h"
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_forgot_PWD : GAITrackedViewController
@property(nonatomic,weak) IBOutlet UILabel *lbl_forgot_pwd;
@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_forgot_pwd;
@property(nonatomic,weak) IBOutlet UIButton *BTN_reset_PWD;
@property(nonatomic,weak) IBOutlet UIImageView *BTN_close;
@property(nonatomic,weak) IBOutlet UIView *vw_align;








@end
