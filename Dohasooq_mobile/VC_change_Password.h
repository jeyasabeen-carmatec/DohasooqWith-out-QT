//
//  VC_change_Password.h
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HoshiTextField.h"
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface VC_change_Password : GAITrackedViewController

@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_old_pwd;
@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_new_pwd;
@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_confirm_pwd;
@property(nonatomic,weak) IBOutlet UIButton *BTN_save;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_back;
@property(nonatomic,weak) IBOutlet UIView *vw_align;




@end
