//
//  ViewController.h
//  Dohasooq_mobile
//
//  Created by Test User on 22/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HoshiTextField.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface ViewController : GAITrackedViewController


@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_username;
@property(nonatomic,weak) IBOutlet HoshiTextField *TXT_password;
@property(nonatomic,weak) IBOutlet UIButton *BTN_login;

@property(nonatomic,weak) IBOutlet UIView *VW_fields;


@property(nonatomic,weak) IBOutlet UIButton *BTN_sign_up;
@property(nonatomic,weak) IBOutlet UILabel *LBL_sign_up;
@property (weak, nonatomic) IBOutlet UIButton  *BTN_facebook;
@property (weak, nonatomic) IBOutlet UIButton  *BTN_Google_PLUS;
@property (weak, nonatomic) IBOutlet UIButton  *BTN_guest;














@end

