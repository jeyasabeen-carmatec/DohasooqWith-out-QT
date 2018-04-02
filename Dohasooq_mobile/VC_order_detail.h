//
//  VC_order_detail.h
//  Dohasooq_mobile
//
//  Created by Test User on 28/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Hoshi_Billing_ADDR.h"
#import "billing_address.h"
#import "MIBadgeButton.h"
#import <GoogleAnalytics/GAITrackedViewController.h>


@interface VC_order_detail : GAITrackedViewController

@property(nonatomic,weak) IBOutlet UILabel *LBL_order_detail;
@property(nonatomic,weak) IBOutlet UILabel *LBL_shipping;
@property(nonatomic,weak) IBOutlet UILabel *LBL_Payment;
@property(nonatomic,weak) IBOutlet UITextField *TXT_first;
@property(nonatomic,weak) IBOutlet UITextField *TXT_second;
@property(nonatomic,weak) IBOutlet UIView *VW_top;


@property(nonatomic,weak) IBOutlet UITableView *TBL_orders;

@property(nonatomic,strong) IBOutlet MIBadgeButton *BTN_cart;
@property(nonatomic,strong) IBOutlet MIBadgeButton *BTN_fav;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_back;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *LBL_navigation;


@property(nonatomic,weak) IBOutlet UILabel *LBL_product_summary;
@property(nonatomic,weak) IBOutlet UILabel *LBL_next;
@property(nonatomic,weak) IBOutlet UIButton *BTN_next;


//shipping view
@property(nonatomic,weak) IBOutlet UIView *VW_shipping;
@property(nonatomic,weak) IBOutlet UIScrollView *scroll_shipping;
 //Billing_address
@property(nonatomic,weak) IBOutlet UIView *VW_BILLING_ADDRESS;
@property(nonatomic,weak) IBOutlet UILabel *LBL_HEADER;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_fname;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_lname;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_phone;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_addr1;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_addr2;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_state;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_city;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_country;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_zip;
@property (weak, nonatomic) IBOutlet UITextField *TXT_Cntry_code;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_email;

// Shiiping address
@property(nonatomic,weak) IBOutlet UIView *VW_SHIIPING_ADDRESS;

@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_fname;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_lname;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_phone;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_addr1;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_addr2;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_state;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_city;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_country;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_zip;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_ship_email;
@property (weak, nonatomic) IBOutlet UITextField *TXT_ship_cntry_code;



@property(nonatomic,weak) IBOutlet UITableView *TBL_address;
//@property(nonatomic,weak) IBOutlet UIButton *BTN_add;
@property(nonatomic,weak) IBOutlet UIView *VW_next;

//payment view
@property(nonatomic,weak) IBOutlet UIView *VW_payment;



// card view
@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_card;
@property(nonatomic,weak) IBOutlet UIView *VW_card;
@property(nonatomic,weak) IBOutlet UIImageView *LBL_stat;
@property(nonatomic,weak) IBOutlet UIButton *BTN_check;
@property(nonatomic,weak) IBOutlet UIButton *BTN_close;



@property(nonatomic,weak) IBOutlet UILabel *LBL_terms;
@property(nonatomic,weak) IBOutlet UIButton *BTN_pay;

//Summary View

@property(nonatomic,weak) IBOutlet UIView *VW_summary;
@property(nonatomic,weak) IBOutlet UILabel *LBL_sub_total;
@property(nonatomic,weak) IBOutlet UILabel *LBL_shipping_charge;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_cupon;
@property (weak, nonatomic) IBOutlet UILabel *LBL_summry_miles;
@property (weak, nonatomic) IBOutlet UILabel *title_Discount;
@property (weak, nonatomic) IBOutlet UILabel *LBL_Promo_discount;



@property(nonatomic,weak) IBOutlet UILabel *LBL_total;
@property(nonatomic,weak) IBOutlet UIButton *BTN_apply_promo;

@property(nonatomic,weak) IBOutlet UIButton *BTN_Product_summary;
@property(nonatomic,weak) IBOutlet UILabel *LBL_arrow;
@property(nonatomic,weak) IBOutlet UIView *VW_pay_cards;
@property(nonatomic,weak) IBOutlet UIButton *BTN_cod;
@property(nonatomic,weak) IBOutlet UIButton *BTN_debit_card;
@property(nonatomic,weak) IBOutlet UIButton *BTN_doha_bank_account;
@property(nonatomic,weak) IBOutlet UIButton *BTN_doha_miles;
@property(nonatomic,weak) IBOutlet UIButton *BTN_credit;
@property (weak, nonatomic) IBOutlet UILabel *LBL_cash_on_Delivary;


// view delivery slot
@property(nonatomic,weak) IBOutlet UIView *VW_delivery_slot;
@property(nonatomic,weak) IBOutlet UIButton *BTN_done;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_Date;
@property (weak, nonatomic) IBOutlet Hoshi_Billing_ADDR *TXT_Time;
@property(strong,nonatomic)UIPickerView *pickerView;
@property(strong,nonatomic)UIPickerView *staes_country_pickr;

- (IBAction)order_to_cartPage:(id)sender;
- (IBAction)order_to_wishListPage:(id)sender;

@property(strong,nonatomic)UIPickerView *country_code_Pickerview;
@property (weak, nonatomic) IBOutlet UIButton *BTN_logo;

//OTP Validation
@property(nonatomic,weak) IBOutlet UIView *VW_otp_vw;
@property(nonatomic,weak) IBOutlet UIButton *BTN_validate_otp;
@property(nonatomic,weak) IBOutlet UIButton *BTN_resend_otp;
@property(nonatomic,weak) IBOutlet Hoshi_Billing_ADDR *TXT_message_field;
@property(nonatomic,weak) IBOutlet UILabel *LBL_timer_lbl;

//special instructions view

@property(nonatomic,weak) IBOutlet UIView *VW_special;
@property(nonatomic,weak) IBOutlet Hoshi_Billing_ADDR *TXT_instructions;



@property(strong,nonatomic)UIPickerView *shipping_PickerView;

@end
