//
//  VC_order_detail.m
//  Dohasooq_mobile
//
//  Created by Test User on 28/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//


#import "VC_order_detail.h"
#import "order_cell.h"
#import "shipping_cell.h"
#import "pay_cell.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "VC_DS_Checkout.h"
#import "Helper_activity.h"


@interface VC_order_detail ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UITextFieldDelegate,UIGestureRecognizerDelegate,UITextViewDelegate>

{
    
       
    NSArray *ARR_pdts;
    
    NSMutableArray *radioButtonArray,*deliverySlotPickerArray,*countryStatesArray,*shipping_Countries_array;//*stat_arr
    
    NSString *TXT_count, *product_id,*item_count,*qr_code,*qar_miles_value;
//   int j;
    NSInteger edit_tag,cntry_ID;
    
    BOOL isAddClicked,is_Txt_date,isCountrySelected,isCash_on_delivary; 
    float scroll_height,shiiping_ht;
    UIView *VW_overlay;
    NSMutableDictionary *jsonresponse_dic,*jsonresponse_dic_address,*delivary_slot_dic,*response_countries_dic;
    NSString *merchent_id,*date_str,*time_str,*promo_codeStr;;  //for payment parameters
    NSArray *slot_keys_arr; // time_slot keys for  PickerView
    UIToolbar *accessoryView;
    
    NSString *cntry_selection,*state_selection;//*selection_str,
    
    float total;
    float charge_ship; //For lbl shipping charge
    
    //payment parameters
    NSString *payment_type_str,*billcheck_clicked,*blng_cntry_ID,*ship_cntry_ID,*blng_state_ID,*ship_state_ID,*newaddressinput;
    NSMutableArray *date_time_merId_Arr;
    BOOL select_blng_ctry_state; // finding which state/country selected instead of creating new pickerview
    
    NSString *title_page_str;
    
    //Country Code
    NSMutableArray *phone_code_arr;
    NSString *flag;
    
    //Delivary Slot
    NSDateFormatter *dateFormatter;
    
   //OneTime Pwd
    NSTimer *timer;
    int currMinute;
    int currSeconds;
    NSString *otp_str;
    BOOL isResendSelected;            //,isTimeExpired
  
    //For Picker Default Selection
    NSString *pickerSelection;
    BOOL isPickerViewScrolled;
    
}

//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@end

@implementation VC_order_detail
#define TRANSFORM_CELL_VALUE CGAffineTransformMakeScale(0.8, 0.8)
#define ANIMATION_SPEED 0.2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [_TXT_instructions setDelegate:self];
    // border for textview
    self.TXT_instructions.layer.borderWidth = 1.0f;
    self.TXT_instructions.layer.borderColor = [[UIColor grayColor] CGColor];
    
    
    self.screenName = @"Order Checkout screen";

    _TXT_message_field.delegate= self;
    [_BTN_logo addTarget:self action:@selector(go_To_Home) forControlEvents:UIControlEventTouchUpInside];
    
    _TXT_instructions.delegate = self;
    title_page_str = @"ORDER DETAIL";
    
    // Do any additional setup after loading the view.
   // isfirstTimeTransform = YES;
   // stat_arr = [[NSMutableArray alloc]init];
    //stat_arr = [NSMutableArray arrayWithObjects:@"0", nil];
    
    // For Payment
    newaddressinput=@"0";
    billcheck_clicked = @"0";
    promo_codeStr = @"";
    
    
    
    [_BTN_close addTarget:self action:@selector(close_ACTION) forControlEvents:UIControlEventTouchUpInside];
  
    jsonresponse_dic  = [[NSMutableDictionary alloc]init];
    jsonresponse_dic_address = [[NSMutableDictionary alloc]init];
    
    countryStatesArray = [NSMutableArray array];
    
    
    //Hiding LBL Discount(Promo Discount) related to productSummary
    self.title_Discount.hidden =YES;
    self.LBL_Promo_discount.hidden = YES;
    
    
   
    [_BTN_apply_promo addTarget:self action:@selector(apply_promo_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_resend_otp addTarget:self action:@selector(resend_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_validate_otp addTarget:self action:@selector(validate_OTP) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_validate_otp setBackgroundColor:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]];
    [_BTN_validate_otp setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    
   
    
    //gettingCountryCodeForMobile Code Related
    [self gettingCountryCodeForMobile];
    // Delivary Slot API
     [self delivary_slot_API];
    
    dateFormatter = [[NSDateFormatter alloc] init];

    _VW_otp_vw.hidden =YES;
    _LBL_arrow.hidden = YES;
    isCash_on_delivary = YES;
    
    isResendSelected = NO;
    //isTimeExpired = NO;
    
    [self ShippingCountryAPICall];
    
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationItem.hidesBackButton = YES;
    VW_overlay = [[UIView alloc]init];
    CGRect vwframe;
    vwframe = VW_overlay.frame;
    vwframe.origin.y = self.navigationController.navigationBar.frame.origin.y;
    vwframe.size.height = self.view.frame.size.height;
    vwframe.size.width = self.view.frame.size.width;
    VW_overlay.frame = vwframe;
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5]; //[UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    // VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
     VW_overlay.hidden = YES;
    
    UITapGestureRecognizer *close_Views = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Close_Views_on_overLay:)];
    close_Views.delegate = self;
    close_Views.numberOfTapsRequired = 1;
    [VW_overlay addGestureRecognizer:close_Views];
    
    [self performSelector:@selector(order_detail_API_call) withObject:nil afterDelay:0.01];
   
}

// Implementing tap Gesture For VW_overLay
-(void)Close_Views_on_overLay:(UITapGestureRecognizer *)tapGesture{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:-5];
    VW_overlay.hidden = YES;
    _VW_summary.hidden=YES;
    _VW_delivery_slot.hidden = YES;
    
    if (_VW_otp_vw.hidden == NO && _VW_pay_cards.hidden == NO) {
        VW_overlay.hidden = NO;
       //_LBL_next.hidden = NO;
    }
    else{
         VW_overlay.hidden = YES;
        _VW_otp_vw.hidden = YES;
    }
    
    
    [UIView commitAnimations];
}


-(void)set_UP_VIEW
{
    
    //isfirstTimeTransform = YES;
    
    _LBL_stat.tag = 0;

    
  
//    arr_product = [[NSMutableArray alloc]init];
   
    
   // j = 0;;//i = 1,
    CGRect frame_set ;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        CGRect frame_set = _TXT_first.frame;
        frame_set.origin.x = _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width - 1;
        frame_set.size.width = _LBL_order_detail.frame.origin.x - ( _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width)  + 2 ;
        _TXT_first.frame = frame_set;
        
        
        
        frame_set = _TXT_second.frame;
        frame_set.origin.x = _LBL_Payment.frame.origin.x + _LBL_Payment.frame.size.width - 1;
        frame_set.size.width = _LBL_shipping.frame.origin.x - ( _LBL_Payment.frame.origin.x + _LBL_Payment.frame.size.width) + 2 ;
        _TXT_second.frame = frame_set;
        
    }
    else{
        
        CGRect frame_set = _TXT_first.frame;
        frame_set.origin.x = _LBL_order_detail.frame.origin.x + _LBL_order_detail.frame.size.width - 1;
        frame_set.size.width = _LBL_shipping.frame.origin.x - ( _LBL_order_detail.frame.origin.x + _LBL_order_detail.frame.size.width)  + 2 ;
        _TXT_first.frame = frame_set;
        
        frame_set = _TXT_second.frame;
        frame_set.origin.x = _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width - 1;
        frame_set.size.width = _LBL_Payment.frame.origin.x - ( _LBL_shipping.frame.origin.x + _LBL_shipping.frame.size.width) + 2 ;
        _TXT_second.frame = frame_set;
        
    }
    frame_set = _scroll_shipping.frame;
    frame_set.size.width = _VW_shipping.frame.size.width;
    _scroll_shipping.frame = frame_set;
    
   
    
    
    
    frame_set = _VW_BILLING_ADDRESS.frame;
    frame_set.size.height = _VW_BILLING_ADDRESS.frame.size.height;
    frame_set.size.width =_VW_shipping.frame.size.width;
    _VW_BILLING_ADDRESS.frame = frame_set;
    
    [self.scroll_shipping addSubview:_VW_BILLING_ADDRESS];
    
    // ADD Special Instructions
    
    
    frame_set  = _VW_special.frame;
    frame_set.origin.x = _TXT_Cntry_code.frame.origin.x;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"]){frame_set.origin.x = _TXT_phone.frame.origin.x;
        
    }
    frame_set.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
    _VW_special.frame = frame_set;
    [self.scroll_shipping addSubview:_VW_special];
    
    

    _VW_special.layer.borderWidth = 0.5f;
    _VW_special.layer.borderColor = [UIColor lightGrayColor].CGColor;
    
     _TBL_address.hidden = YES;
    
    
    [_TBL_address reloadData];
    frame_set = _TBL_address.frame;
    frame_set.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
    frame_set.size.height = _TBL_address.frame.origin.y + _TBL_address.contentSize.height;
    _TBL_address.frame =frame_set;
    
    [self.scroll_shipping addSubview:_TBL_address];
     _TBL_address.hidden = YES;
    _VW_SHIIPING_ADDRESS.hidden = YES;

    
    shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
    
    
    
    frame_set = _VW_pay_cards.frame;
   // frame_set.origin.y = _collectionView.frame.origin.y + _collectionView.frame.size.height;
    frame_set.size.width = _Scroll_card.frame.size.width;
    frame_set.size.height = _VW_pay_cards.frame.origin.y + _VW_pay_cards.frame.size.height;
    _VW_pay_cards.frame = frame_set;
    [self.Scroll_card addSubview:_VW_pay_cards];
    scroll_height = _VW_pay_cards.frame.origin.y + _VW_pay_cards.frame.size.height;
    
    
    
    frame_set = _VW_summary.frame;
    frame_set.origin.y = _VW_next.frame.origin.y - _VW_summary.frame.size.height - 20;
    frame_set.size.width = _TBL_orders.frame.size.width;
    //  frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
    _VW_summary.frame = frame_set;
    [VW_overlay addSubview:_VW_summary];
    _VW_summary.hidden = YES;
    
    
    
    
    _BTN_apply_promo.layer.cornerRadius = 2.0f;
    _BTN_apply_promo.layer.masksToBounds = YES;
    
    
    
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:17.0f]
       } forState:UIControlStateNormal];
    
    
    
    
    
    
    
    _LBL_order_detail.layer.cornerRadius = _LBL_order_detail.frame.size.width / 2;
    _LBL_order_detail.layer.borderWidth = 2.5f;
    _LBL_order_detail.layer.borderColor = [UIColor whiteColor].CGColor;
    _LBL_order_detail.backgroundColor = [UIColor colorWithRed:0.20 green:0.76 blue:0.33 alpha:1.0];
    _LBL_order_detail.layer.masksToBounds = YES;
    
    
    _LBL_shipping.layer.cornerRadius = _LBL_order_detail.frame.size.width / 2;
    _LBL_shipping.layer.borderWidth = 2.5f;
    _LBL_shipping.layer.borderColor = [UIColor whiteColor].CGColor;
    _LBL_shipping.layer.masksToBounds = YES;
    
    _LBL_Payment.layer.cornerRadius = _LBL_order_detail.frame.size.width / 2;
    _LBL_Payment.layer.borderWidth = 2.5f;
    _LBL_Payment.layer.borderColor = [UIColor whiteColor].CGColor;
    _LBL_Payment.layer.masksToBounds = YES;
    
    _TXT_first.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_first.layer.borderWidth = 1.7f;
    
    _TXT_second.layer.borderColor = [UIColor whiteColor].CGColor;
    _TXT_second.layer.borderWidth = 1.7f;
    
    _BTN_credit.tag = 1;
    _BTN_debit_card.tag = 1;
    _BTN_doha_bank_account.tag = 1;
    _BTN_doha_miles.tag = 1;
    _BTN_cod.tag = 1;

    [_BTN_cod addTarget:self action:@selector(cod_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_credit addTarget:self action:@selector(credit_cerd_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_debit_card addTarget:self action:@selector(debit_card_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_doha_miles addTarget:self action:@selector(doha_miles_action) forControlEvents:UIControlEventTouchUpInside];
    
    [_BTN_doha_bank_account addTarget:self action:@selector(doha_bank_action) forControlEvents:UIControlEventTouchUpInside];

    // Attributed text for Next Button....
    
    NSString *next = @"";
    
    NSString *next_text = [NSString stringWithFormat:@"NEXT %@",next];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        next  = @"";
        next_text = [NSString stringWithFormat:@"%@ التالي ",next];
    }
    
    if ([_LBL_next respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_next.textColor,
                                  NSFontAttributeName:_LBL_next.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:next_text attributes:attribs];
        
        
        
        NSRange ename = [next_text rangeOfString:next];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:25.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:ename];
        }
        
        _LBL_next.attributedText = attributedText;
    }
    else
    {
        _LBL_next.text = next_text;
    }
    
    
    
    
    //PickerView set Up.....
    
    _staes_country_pickr = [[UIPickerView alloc]init];
    _staes_country_pickr.delegate = self;
    _staes_country_pickr.dataSource = self;
    
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    
    
    
    _shipping_PickerView = [[UIPickerView alloc]init];
    _shipping_PickerView.delegate = self;
    _shipping_PickerView.dataSource = self;
    
    _TXT_Date.delegate = self;
    _TXT_Time.delegate = self;
    
    _TXT_Date.inputView = self.pickerView;
    _TXT_Time.inputView = self.pickerView;
    
    
    // TollBar For PickerView
    accessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    accessoryView.barStyle = UIBarStyleBlackTranslucent;
    [accessoryView sizeToFit];
   
    
    _TXT_country.inputView = _staes_country_pickr;
    _TXT_state.inputView = _staes_country_pickr;
    _TXT_ship_state.inputView =_staes_country_pickr;

    _TXT_ship_country.inputView =_shipping_PickerView;

   //  Done Button  For Tool Bar
//    UIButton *done=[[UIButton alloc]init];
//    done.frame=CGRectMake(accessoryView.frame.size.width - 100, 0, 100, accessoryView.frame.size.height);
//    [done setTitle:@"Done" forState:UIControlStateNormal];
//    [done addTarget:self action:@selector(picker_done_btn_action:) forControlEvents:UIControlEventTouchUpInside];
//    [accessoryView addSubview:done];
//
//
//    //Close ButtonFor ToolBar
//    UIButton *close=[[UIButton alloc]init];
//    close.frame=CGRectMake(accessoryView.frame.origin.x -20, 0, 100, accessoryView.frame.size.height);
//    [close setTitle:@"Close" forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(picker_close_action) forControlEvents:UIControlEventTouchUpInside];
//    [accessoryView addSubview:close];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(picker_done_btn_action:)];
    [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(picker_close_action)];
    [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    NSMutableArray *barItems = [NSMutableArray arrayWithObjects:cancelBtn,flexibleItem,doneBtn, nil];
    [accessoryView setItems:barItems animated:YES];
    
    // Country Code Picker
    self.country_code_Pickerview = [[UIPickerView alloc]init];
    _country_code_Pickerview.delegate = self;
    _country_code_Pickerview.dataSource = self;
    
    
    //Shipping Address Textfield
    _TXT_ship_cntry_code.inputView = self.country_code_Pickerview;
    _TXT_ship_cntry_code.inputAccessoryView = accessoryView;
    
    //Billing Address Textfield
    _TXT_Cntry_code.inputAccessoryView=accessoryView;
    _TXT_Cntry_code.inputView=_country_code_Pickerview;
    
    
    _TXT_Time.inputAccessoryView = accessoryView;
    _TXT_Date.inputAccessoryView = accessoryView;
    
    
    _TXT_ship_country.inputAccessoryView =accessoryView;
    _TXT_ship_state.inputAccessoryView =accessoryView;
    
    _TXT_country.inputAccessoryView =accessoryView;
    _TXT_state.inputAccessoryView =accessoryView;

    
    // Set actions to Buttons....
    [_BTN_next addTarget:self action:@selector(next_page) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Product_summary addTarget:self action:@selector(product_clicked) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_done addTarget:self action:@selector(deliveryslot_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_check addTarget:self action:@selector(BTN_check_clickd) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    
}

// Set Data for Billing Address........

-(void)set_DATA
{
    @try {
        
        NSString *state = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"state"];
        NSString *country = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"country"];
                NSString *str_fname,*str_lname,*str_addr1,*str_addr2,*str_city,*str_zip_code,*str_phone,*str_country,*str_state,*str_cntry_code;
        
        //fnaem
        str_fname = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"firstname"];
      
       
        if ([str_fname isKindOfClass:[NSNull class]]||[str_fname isEqualToString:@"<null>"] ||[str_fname isEqualToString:@"<nil>"]||[str_fname isEqualToString:@"null"] ) {
            str_fname = @"";
        }
        _TXT_fname.text =  str_fname;
        
        //lname
         str_lname = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"lastname"];
        if ([str_lname isKindOfClass:[NSNull class]]||[str_lname isEqualToString:@"<null>"] ||[str_lname isEqualToString:@"<nil>"]||[str_lname isEqualToString:@"null"] ) {
            str_lname = @"";
        }
        
        _TXT_lname.text =  str_lname;
        
        //phone
        str_phone = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"phone"];
        
        @try {
            
            if ([str_phone isKindOfClass:[NSNull class]] ||[str_phone isEqualToString:@"<null>"] ||[str_phone isEqualToString:@"<nil>"]||[str_phone isEqualToString:@""]) {
                str_phone = @"";
                _TXT_phone.userInteractionEnabled = YES;
                _TXT_phone.backgroundColor = [UIColor clearColor];
            }
            else{
                _TXT_phone.userInteractionEnabled = NO;
                _TXT_phone.backgroundColor = [UIColor lightGrayColor];
            }
        } @catch (NSException *exception) {
            NSLog(@"Phone exception....");
        }
        
        
        
        
        str_phone = [str_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        _TXT_phone.text =  str_phone;
        
        //Phone_Country_code
        str_cntry_code = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"phonecode"];
        //str_cntry_code = [str_cntry_code stringByReplacingOccurrencesOfString:@"<null>" withString:@"974"];
        
        if ([str_cntry_code isKindOfClass:[NSNull class]] ||[str_cntry_code isEqualToString:@"<null>"] ||[str_cntry_code isEqualToString:@"<nil>"]||[str_cntry_code isEqualToString:@""] ) {
            str_cntry_code = @"974";
            _TXT_Cntry_code.userInteractionEnabled = YES;
           // _TXT_Cntry_code.backgroundColor = [UIColor clearColor];
        }
        else{
            _TXT_Cntry_code.userInteractionEnabled = NO;
            _TXT_Cntry_code.backgroundColor = [UIColor lightGrayColor];
        }
        
        _TXT_Cntry_code.text = [NSString stringWithFormat:@"+%@",str_cntry_code];
        
        
        //Country_code for ShipCntryCode
        _TXT_ship_cntry_code.text = [NSString stringWithFormat:@"+%@",str_cntry_code];
        
        
        //Address1
        str_addr1 = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address1"];
        
        if ([str_addr1 isKindOfClass:[NSNull class]]||[str_addr1 isEqualToString:@"<null>"] ||[str_addr1 isEqualToString:@"<nil>"]||[str_addr1 isEqualToString:@"null"] ) {
            str_addr1 = @"";
        }
        _TXT_addr1.text =  str_addr1;


        //address2
        str_addr2 = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address2"];
        if ([str_addr2 isKindOfClass:[NSNull class]]||[str_addr2 isEqualToString:@"<null>"] ||[str_addr2 isEqualToString:@"<nil>"]||[str_addr2 isEqualToString:@"null"] ) {
            str_addr2 = @"";
        }
        _TXT_addr2.text =  str_addr2;

        
  //  City
        str_city = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"city"];
        
        if ([str_city isKindOfClass:[NSNull class]]||[str_city isEqualToString:@"<null>"] ||[str_city isEqualToString:@"<nil>"]||[str_city isEqualToString:@"null"] ) {
            str_city = @"";
        }
        _TXT_city.text =  str_city;
        
   // Zipcode
        str_zip_code = [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"zip_code"];
        if ([str_zip_code isKindOfClass:[NSNull class]]||[str_zip_code isEqualToString:@"<null>"] ||[str_zip_code isEqualToString:@"<nil>"]||[str_zip_code isEqualToString:@"null"] ) {
            str_zip_code = @"";
        }
        
        
        _TXT_zip.text =  str_zip_code;
        

        
        str_country = country;
        str_state =state;
        
        // Country
        if ([str_country isKindOfClass:[NSNull class]]||[str_country isEqualToString:@"<null>"] ||[str_country isEqualToString:@"<nil>"]||[str_country isEqualToString:@"null"] ||[str_country isEqualToString:@""]) {
            str_country = @"";
                   }
        _TXT_country.text =  str_country;

        
        //State
        if ([str_state isKindOfClass:[NSNull class]]||[str_state isEqualToString:@"<null>"] ||[str_state isEqualToString:@"<nil>"]||[str_state isEqualToString:@"null"] ||[str_state isEqualToString:@""]) {
            str_state = @"";
           // _TXT_state.placeholder = @"Select State*";
        }
        _TXT_state.text =  str_state;
        
       
// Getting State_id and Cntry_Id for Payment
        
blng_cntry_ID = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"country_id"]];
        
        if ([blng_cntry_ID isKindOfClass:[NSNull class]]||[blng_cntry_ID isEqualToString:@"<null>"] ||[blng_cntry_ID isEqualToString:@"<nil>"]||[blng_cntry_ID isEqualToString:@"null"] ||[blng_cntry_ID isEqualToString:@""]) {
            
            
            blng_cntry_ID = @"";
            
        }
        
blng_state_ID = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"state_id"]];
        
        if ([blng_state_ID isKindOfClass:[NSNull class]]||[blng_state_ID isEqualToString:@"<null>"] ||[blng_state_ID isEqualToString:@"<nil>"]||[blng_state_ID isEqualToString:@"null"] ||[blng_state_ID isEqualToString:@""]) {
            
            blng_state_ID = @"";
            
        }
        
// Shipping Country  ID Must Be  Related Local Country  ........
        
        
        @try {
            if (shipping_Countries_array.count !=0) {
                
            _TXT_ship_country.text = [[shipping_Countries_array objectAtIndex:0] valueForKey:@"name"];
            cntry_ID = [[[shipping_Countries_array objectAtIndex:0] valueForKey:@"id"] integerValue];
            ship_cntry_ID = [NSString stringWithFormat:@"%@",[[shipping_Countries_array objectAtIndex:0] valueForKey:@"id"]];
            }
            else{
                NSLog(@"No Countries ");
            }
        } @catch (NSException *exception) {
            
        }
    }
    @catch(NSException *exception)
    {
    }
    
}

// Set Data to product view Summary(for Sub total and Shipping Charge label)........


-(void)set_data_to_product_Summary_View{
  
    @try {
        
       
        
        qar_miles_value = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"oneQARtoDM"]];
        
     
    NSString *sub_total = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"subsum"]];
    
    sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
        
    NSString *sub_total_seperator = [HttpClient currency_seperator:sub_total];
        
// SubTotal Amount
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
             _LBL_sub_total.text = [NSString stringWithFormat:@"%@ %@",sub_total_seperator,[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"]];
        }else{
             _LBL_sub_total.text = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults]valueForKey:@"currency"],sub_total_seperator];
        }
        
        

    total = [sub_total floatValue]+ charge_ship;

      // Shipping Charge In Product Summary View
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%.2f %@",charge_ship,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        }
        else{
            self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%@ %.2f",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],charge_ship];
        }
        [self fill_value_to_Lbl_product_summary:@" "];
        
        
        [self LBl_dohamilesAndTotalAmount:total];
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
   }

#pragma mark  LabelDohamiles And Total Amount in ProductSummaryView


-(void)LBl_dohamilesAndTotalAmount:(float)TotalAmount{
    
    
     float doha_val = [qar_miles_value intValue]*total;
    
    NSString *currency = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        NSString *prec_price = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",total]];
       // NSString *doha_value = [NSString stringWithFormat:@"%f",doha_val];
         NSString *doha_value = [HttpClient doha_currency_seperator:[NSString stringWithFormat:@"%.2f",doha_val]];

    NSString *summary_text;
    NSString *str_miles;
    NSString *str_or;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
       
        str_or = @"(أو)";
        summary_text = [NSString stringWithFormat:@"%@ %@\n%@",prec_price,currency,str_or];
        str_miles = [NSString stringWithFormat:@"%@ أميال الدوحة",doha_value];
        
    }
    else{
        str_or = @"(OR)";
        summary_text = [NSString stringWithFormat:@"%@ %@\n%@",currency,prec_price,str_or];
        str_miles= [NSString stringWithFormat:@"Doha Miles %@",doha_value];
    }
    
    
//Custom Text For LBL Total (Product Summary View)
    if ([_LBL_total respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_total.textColor,
                                  NSFontAttributeName:_LBL_total.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:summary_text attributes:attribs];
        
        
        
        NSRange ename = [summary_text rangeOfString:currency];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16.0]}
                                range:ename];
        
        NSRange cmp = [summary_text rangeOfString:prec_price];
        
        
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                range:cmp ];
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                range:[summary_text rangeOfString:str_or] ];
        
        _LBL_total.attributedText = attributedText;
    }
    else
    {
        _LBL_total.text = summary_text;
    }
    
// Dohamiles Customization (Product Summary View)
    if ([_LBL_summry_miles respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_summry_miles.textColor,
                                  NSFontAttributeName:_LBL_summry_miles.font
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_miles attributes:attribs];
        
        
        NSRange doha_va = [str_miles rangeOfString:str_miles];
        
        
        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:16.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                range:doha_va ];
        
        _LBL_summry_miles.attributedText = attributedText;
        
        
        
    }
    else
    {
        _LBL_summry_miles.text = str_miles;
    }
    
}



// Data for LBL Summary with arrow
#pragma mark Label ProductSummary(Footer Section) Custom Text
-(void)fill_value_to_Lbl_product_summary:(NSString *)arrow{
    
    
    NSString *seperator = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",total]];
    
      NSString *price;
    
    NSString *currency = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];

    
    NSString *text;
    
    
    NSMutableParagraphStyle *paragraphStyle = NSMutableParagraphStyle.new;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        price =[NSString stringWithFormat:@"%@ %@",arrow,seperator];
        text = [NSString stringWithFormat:@"%@ %@ ",price,currency];
        [paragraphStyle setAlignment:NSTextAlignmentCenter];
        
    }
    else{
        price =[NSString stringWithFormat:@"%@ %@",seperator,arrow];
        text = [NSString stringWithFormat:@"%@ %@ ",currency,price];
        [paragraphStyle setAlignment:NSTextAlignmentLeft];
        
        
    }
    
    
    if ([_LBL_product_summary respondsToSelector:@selector(setAttributedText:)]) {
        
        // Define general attributes for the entire text
        NSDictionary *attribs = @{
                                  NSForegroundColorAttributeName:_LBL_product_summary.textColor,
                                  NSFontAttributeName:_LBL_product_summary.font,
                                  NSParagraphStyleAttributeName:paragraphStyle
                                  };
        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
        
        
        
        NSRange ename = [text rangeOfString:currency];
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                    range:ename];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:16.0]}
                                    range:ename];
        }
        NSRange cmp = [text rangeOfString:price];
       
        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:21.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                    range:cmp];
        }
        else
        {
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:16.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:cmp ];
        }
        
        _LBL_product_summary.attributedText = attributedText;
        
        
    }
    else
    {
        _LBL_product_summary.text = text;
    }

}


-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_card layoutIfNeeded];
    if(_scroll_shipping)
    {
        _scroll_shipping.contentSize = CGSizeMake(_scroll_shipping.frame.size.width,shiiping_ht);
    }
    else{
    _Scroll_card.contentSize = CGSizeMake(_Scroll_card.frame.size.width,scroll_height);
    }
}
#pragma tableview delagates
#pragma tableview delagates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    @try {
        if(tableView == _TBL_address)
        {
            return 1;
            // return sec;
        }
        else
        {
            NSInteger count = 0;
//            NSArray *keys_arr;
            
           /* for(int l = 0;l<[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] count];l++)*/
            //{
//            NSArray *ARR_pdts = [[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"];
            if([ARR_pdts count] != 0)
            {
//                keys_arr = [[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"];
                
//                [[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] objectAtIndex:0] allKeys];*/
                
//                count = [[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] count];
                count = [ARR_pdts count];
                
            }
            else
            {
                count = 0;
            }
            //}
            
            return count;
            
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    @try {
        
        if(tableView == _TBL_orders)
        {
            
            NSDictionary *ARR_val = [ARR_pdts objectAtIndex:section];
            
            NSArray *keys_arr = [ARR_val allKeys];
            
            NSString *STR_cntnt = [keys_arr objectAtIndex:0];
            
            NSArray *ARR_CNNN = [ARR_val valueForKey:STR_cntnt];
        
            return [ARR_CNNN count];
        }
        else      // TableView Address
        {
            NSInteger ct = 0;
            if(section == 0)
            {
                
                if([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]])
                {
                    NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
                    ct = keys_arr.count;
                    
                    
                }
                else{
                    ct = 0;  ////
                    
                }
                
                
                
                
                return ct;
            }
           
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    NSString *identifier_order,*identifier_shipping;//,*identifier_billing
    NSInteger index;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        //identifier_billing = @"Qbilling_address";
        identifier_order = @"Qorder_cell";
        identifier_shipping = @"Qshipping_cell";
        index = 1;
        
    }
    else{
        
        //identifier_billing = @"billing_address";
        identifier_order = @"order_cell";
        identifier_shipping = @"shipping_cell";
        index = 0;
        
        
    }
    if(tableView == _TBL_orders)
    {
        order_cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier_order];
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"order_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }
     
        NSDictionary *ARR_val = [ARR_pdts objectAtIndex:indexPath.section];
       
        NSArray *keys_arr = [ARR_val allKeys];
        
        NSString *STR_cntnt = [keys_arr objectAtIndex:0];
        
        NSArray *ARR_CNNN = [ARR_val valueForKey:STR_cntnt];

            
            @try
            {
                NSString *str = [NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"merchantId"]];
               
                
                NSString *img_url = [NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"productimage"]];

                [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
                
                NSString *item_name =[NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"product_name"]];
                
                item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@" "];
                
                NSString *item_seller;
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                item_seller =[NSString stringWithFormat:@"البائع: %@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"merchantname"]];
                }else{
                   item_seller =[NSString stringWithFormat:@"Seller: %@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"merchantname"]];
                }
                item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
                cell.LBL_item_name.text = item_name;
                
                
                if ([cell.LBL_seller respondsToSelector:@selector(setAttributedText:)])
                {
                                      // Define general attributes for the entire text
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:[UIColor colorWithRed:84.0/255.0 green:84.0/255.0 blue:84.0/255.0 alpha:1],
                                              NSFontAttributeName:cell.LBL_date .font
                                              };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:item_seller attributes:attribs];
                    
                    cell.LBL_seller.attributedText = attributedText;
                    
                }
                else{
                    cell.LBL_seller.text = item_seller;
                  }
                
                
   // Product Quantity.....
                
                cell._TXT_count.text = [NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"product_qty"]];
                NSString *qnty = [NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"product_qty"]];
                if([qnty isEqualToString:@""]|| [qnty isEqualToString:@"null"]||[qnty isEqualToString:@"<null>"])
                {
                    qnty = @"0";
                }
                
                TXT_count = cell._TXT_count.text;
                
  
   // Custom text for Price ....
                NSString *qr = [NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"currencycode"]];
                qr_code = qr;
                NSString *mils;
               
                NSString *prev_price = [NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"productprice"]];
                
                NSString *price = [NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"specialPrice"]];
                price = [price stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                price = [price stringByReplacingOccurrencesOfString:@"null" withString:@""];
                
                NSString *doha_miles = [NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"dohamileprice"]];
                doha_miles = [doha_miles stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                doha_miles = [doha_miles stringByReplacingOccurrencesOfString:@"null" withString:@""];
                
                if([doha_miles isEqualToString:@""]|| [doha_miles isEqualToString:@"null"]||[doha_miles isEqualToString:@"<null>"])
                {
                    mils  = @"";
                }
                else
                {
                    mils  = @"Doha Miles";
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        mils = @" أميال الدوحة";
                    }
                }
                
    // Calculating Dohamiles Value and Prices Based on Quantity
                
                @try {
                    int quantity = [qnty intValue];
                    
                    
                        @try {
                            //Product Price Multiplication

                        float productprice = [prev_price floatValue];
                        productprice = quantity*productprice;
                        prev_price = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",productprice]];
                            //prev_price = [NSString stringWithFormat:@"%.2f",productprice];
                           
                            //Miles Price Multiplication
                            float price_mls = [doha_miles floatValue];
                            price_mls = quantity * price_mls;
                            doha_miles = [NSString stringWithFormat:@"%f",price_mls];
                            doha_miles = [HttpClient doha_currency_seperator:doha_miles];
                           
                            
                            if([price isEqualToString:@""]|| [price isEqualToString:@"null"]||[price isEqualToString:@"<null>"])
                            {
                                
                            }
                            else{// Special Price Calculation.....
                                float spcl_prc = [price floatValue];
                                spcl_prc = quantity * spcl_prc;
                                
                                price = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",spcl_prc]];
                               // price = [NSString stringWithFormat:@"%.2f",spcl_prc];
                            }
                            
                    } @catch (NSException *exception) {
                        
                    }
                    
                } @catch (NSException *exception) {
                    
                }
                
        
                

                NSString *only_price;
                
         if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {

                 only_price = [NSString stringWithFormat:@"/  %@ %@ ",qr,prev_price];

                }
                else
                {
                    only_price = [NSString stringWithFormat:@"%@ %@ /",qr,prev_price];
                }
        
                
            // Font size Based on Screen
                
                
                float font_size;
                
                CGSize result = [[UIScreen mainScreen] bounds].size;
                if(result.height <= 480)
                {
                    // iPhone Classic
                    font_size = 13.0;
                    
                }
                else if(result.height <= 568)
                {
                    // iPhone 5
                    font_size = 13.0;
                }
                else
                {
                    font_size = 15.0;
                }

                
#pragma mark LBL_current_price Attributed Text
                
                
                if ([cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)])
                {
                    
                    if ([price isEqualToString:@""] && ![doha_miles isEqualToString:@""]) {
                        
                    
                        
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:only_price attributes:nil];
                        
                        NSRange qrs = [only_price rangeOfString:qr];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:font_size],NSForegroundColorAttributeName:[UIColor grayColor]}
                                                range:qrs];
                        
                        NSRange ename = [only_price rangeOfString:prev_price];
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:font_size],NSForegroundColorAttributeName:[UIColor grayColor]}
                                                range:ename];
                        
                        
                        cell.LBL_current_price.attributedText = attributedText;
                        
                        
                        
                    }

                    
                    else{
                        
                    NSString *text;
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                        {
                            prev_price = [NSString stringWithFormat:@"%@ %@",prev_price,qr];
                            price = [NSString stringWithFormat:@"%@ %@",price,qr];
//                            text = [NSString stringWithFormat:@" %@ %@ / %@ %@ %@",mils,doha_miles,prev_price,price,qr];
                            text = [NSString stringWithFormat:@"/  %@ %@",prev_price,price];

                        }else{
                            prev_price = [NSString stringWithFormat:@"%@ %@",qr,prev_price];
                            price = [NSString stringWithFormat:@"%@ %@",qr,price];

                            text = [NSString stringWithFormat:@"%@ %@ /",price,prev_price];
  
                        }
                        
                        
                        NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                        

                        
                        
                        
                        NSRange ename = [text rangeOfString:price];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                                    range:ename];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:font_size],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                    range:ename];
                        }
                        
                        
                        
                        
                        NSRange cmp = [text rangeOfString:prev_price];
                        //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
                        if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:21.0]}
                                                    range:cmp];
                        }
                        else
                        {
                            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:font_size],NSForegroundColorAttributeName:[UIColor grayColor]}
                                                    range:cmp];
                        }
                        @try {

                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                            {
                                 [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(3, [prev_price length])];
                            }
                            else{
                                 [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(price.length+1, [prev_price length])];
                            }
                            
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    
                        
                        
                        cell.LBL_current_price .attributedText = attributedText;
                    }
                
                    
                }
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    cell.LBL_current_price.textAlignment = NSTextAlignmentRight;
                }
                
               
       
   // Custom text For DohaMiles Label
                
                
                NSString *doha_text = [NSString stringWithFormat:@"%@ %@",mils,doha_miles];
                if ([cell._LBL_Doha_Miles respondsToSelector:@selector(setAttributedText:)])
                {
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:doha_text attributes:nil];
                    
                    NSRange qrs = [doha_text rangeOfString:doha_miles];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:21.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:qrs];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:font_size],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:qrs];
                    }
                    cell._LBL_Doha_Miles.attributedText = attributedText;
                
                }
                else{
                    cell._LBL_Doha_Miles.text = doha_text;
                }
                
                
                
                
                
        // Add Target For Buttons in cell
                
                [cell.BTN_plus addTarget:self action:@selector(plus_action:) forControlEvents:UIControlEventTouchUpInside];
                [cell.BTN_minus addTarget:self action:@selector(minus_action:) forControlEvents:UIControlEventTouchUpInside];
                cell.BTN_plus.tag = [[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"product_id"] intValue];
                cell.BTN_minus.tag = [[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"product_id"] intValue];
            
                
                
                cell.BTN_calendar.tag = [[NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"merchantId"]] integerValue];
                [cell.BTN_calendar addTarget:self action:@selector(calendar_action:) forControlEvents:UIControlEventTouchUpInside];
                
                [cell.BTN_stat addTarget:self action:@selector(BTN_check_clickds:) forControlEvents:UIControlEventTouchUpInside];
                [cell.BTN_box addTarget:self action:@selector(BTN_check_clickds:) forControlEvents:UIControlEventTouchUpInside];
                
                cell.BTN_stat.tag = [[NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"merchantId"]] integerValue];
                cell.BTN_box.tag = cell.BTN_stat.tag;
                
               
                
                cell._TXT_count.layer.borderWidth = 0.4f;
                cell._TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
                
                cell.BTN_plus.layer.borderWidth = 0.4f;
                cell.BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
                cell.BTN_minus.layer.borderWidth = 0.4f;
                cell.BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
                

                
                NSInteger totalRow = [tableView numberOfRowsInSection:indexPath.section];//first get total rows in that section by current indexPath.
                
                
    // seperator View Border Setting
                
                if(indexPath.row == totalRow -1){ //last row

                cell.seperator_view.layer.borderWidth = 0.2f;
                cell.seperator_view.layer.borderColor = [UIColor lightGrayColor].CGColor;
                }
                
                
     //Checking Cash On Delivary Available or Not For Payment Options
                if ([[NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"cod"]] isEqualToString:@"No"]) {
                    isCash_on_delivary = NO;
                }
//                else
//                {
//                    isCash_on_delivary = YES;
//                }
                
    //Delivary Slot checking Condition
                
                
        NSString *delivery_slot_available  =[NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"delivery_slot_available"]];
                
        
                
                if(indexPath.row == totalRow -1){ //last row
                    
                   
                     cell.CalenderHeight.constant = 50;
                    
                    if ([delivery_slot_available isEqualToString:@"No"] || [delivery_slot_available isEqualToString:@"<null>"])
                    {
                        
                        cell.BTN_calendar.hidden = YES;
                    }
                    else{
                        cell.BTN_calendar.hidden = NO;
                    }
                    
                }
                else{ //Not last row
                  //  cell.seperator_view.hidden = YES;

                     cell.CalenderHeight.constant = 3;
                    cell.BTN_calendar.hidden = YES;
                }
                
                
     //Expected Delivary Date customization
                
                NSString *expected_delivary_date  =[NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"expecteddelivery"]];
                
                if ([expected_delivary_date isEqualToString:@"No delivery date allocated"]) {
                    
                    cell.LBL_date.text = nil;
//                    cell.LBL_date.text = expected_delivary_date;
//                    cell.LBL_date.textColor = [UIColor redColor];
                }
                else{
                    expected_delivary_date = [expected_delivary_date stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    
                    NSString *text1 = [NSString stringWithFormat:@"Expected Delivery On %@",expected_delivary_date];
                    
                    if ([delivery_slot_available isEqualToString:@"No"] || [delivery_slot_available isEqualToString:@"<null>"])
                    {
                      
                       
                       
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                        {
                            text1 = [NSString stringWithFormat:@"الموعد المتوقع للتسليم:  %@",expected_delivary_date];
                        }
                        else{
                            text1 = [NSString stringWithFormat:@"Expected Delivery On %@",expected_delivary_date];
                        }
                    
                    
                    }
                    else{
                        
                        
                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                        {
                            
                            text1 = [NSString stringWithFormat:@"أختر الوقت المناسب لتوصيل الطلب "];
                        }
                        else{
                            text1 = [NSString stringWithFormat:@"Note: Choose a time that works best for you and place your order."];
                            
                        }

                    
                    
                    }
                    
                    
                    
                    if ([cell.LBL_date respondsToSelector:@selector(setAttributedText:)]) {
                        
                    // Define general attributes for the entire text
                            NSDictionary *attribs = @{
                                                      NSForegroundColorAttributeName:cell.LBL_date.textColor,
                                                      NSFontAttributeName:cell.LBL_date .font
                                                      };
                            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text1 attributes:attribs];
                            
                            NSRange ename = [text1 rangeOfString:expected_delivary_date];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                        range:ename];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName:[UIColor greenColor]}
                                                        range:ename];
                            }
                            
                            NSRange order = [text1 rangeOfString:@"Expected Delivery On"];
                            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                        range:order];
                            }
                            else
                            {
                                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:12.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                                        range:order];
                            }
                            
                            
                            
                            cell.LBL_date .attributedText = attributedText;
                        }
              
                    else
                    {
                        cell.LBL_date .text = text1;
                    }
                }
            
                
    // PickUp from merchant location condition checking
                

                
                
                if(indexPath.row == totalRow -1){ //last row
                    
                    if ([[jsonresponse_dic valueForKey:@"pickup"] isKindOfClass:[NSDictionary class]]) {
                        NSArray *pickUpkeys = [[jsonresponse_dic valueForKey:@"pickup"]allKeys];
                        
                        @try {
                            
                            if ([pickUpkeys containsObject:str]) {
                                
                                NSLog(@"Available %@",str);
                               // cell.LBL_stat.hidden = NO;
                                cell.BTN_box.hidden = NO;
                                cell.BTN_stat.hidden = NO;
                            }else{
                                //cell.LBL_stat.hidden = YES;
                                cell.BTN_box.hidden = YES;
                                cell.BTN_stat.hidden = YES;
                            }
                            
                            
                            
                        } @catch (NSException *exception) {
                            //cell.LBL_stat.hidden = YES;
                            cell.BTN_box.hidden = YES;
                            cell.BTN_stat.hidden = YES;
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    else{ //Not Dictionary
                        //cell.LBL_stat.hidden = YES;
                        cell.BTN_box.hidden = YES;
                        cell.BTN_stat.hidden = YES;
                    }
                }
                else{ // not last row
                    //cell.LBL_stat.hidden = YES;
                    cell.BTN_box.hidden = YES;
                    cell.BTN_stat.hidden = YES;
                }

                
// Shipping Charge labelcustomization..........
                NSString *CHRGE;
                NSString *qrcode = [NSString stringWithFormat:@"%@",[[ARR_CNNN objectAtIndex:indexPath.row] valueForKey:@"currencycode"]];
                NSString *shipping_type;
                

                NSArray *key_ship_arr;
                if(indexPath.row == totalRow -1){
                    @try
                    {
                      key_ship_arr =[[jsonresponse_dic valueForKey:@"shipcharge"] allKeys];
                        
                    
                            if([key_ship_arr containsObject:str])
                            {
                                
                                @try {
                                    cell.LBL_charge.hidden = NO;
                                    
                                    CHRGE = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:str] valueForKey:@"charge"]];
                                    
                                    shipping_type = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:str] valueForKey:@"methodname"]];
                                    
                                    
                                    if ([shipping_type isKindOfClass:[NSNull class]] || [shipping_type isEqualToString:@"(null)"] || [shipping_type isEqualToString:@"<null>"]) {
                                        shipping_type = @"";
                                    }
                                    
                                    
                                } @catch (NSException *exception) {
                                    
                                    CHRGE = @"";
                                    shipping_type =@"";
                                    
                                    NSLog(@"%@",exception);
                                }
                            }
                            else{
                                cell.LBL_charge.hidden = YES;
                            }
                        
                    }
                    @catch(NSException *exception)
                    {
                        CHRGE = [NSString stringWithFormat:@"%@", [jsonresponse_dic valueForKey:@"shipcharge"]];
                        
                    }
                    
                    
                }
                else{
                    cell.LBL_charge.hidden = YES;
                }

                NSString *text2;
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    CHRGE = [CHRGE stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
//                    text2 = [NSString stringWithFormat:@"%@    رسوم الشحن %@ %@",CHRGE,qr,shipping_type]
//                    ;.......
                    text2 = [NSString stringWithFormat:@"%@    رسوم الشحن %@ %@",shipping_type,qr,CHRGE]
                    ;
                }
                else{
                    CHRGE = [CHRGE stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
                    text2 = [NSString stringWithFormat:@"%@    Shipping Charge %@ %@",shipping_type,qr,CHRGE]
                    ;
                }
            
               
              //  NSLog(@"........%@",text2);
                
                
                if ([cell.LBL_charge respondsToSelector:@selector(setAttributedText:)]) {
                    
                    // Define general attributes for the entire text
                    NSDictionary *attribs = @{
                                              NSForegroundColorAttributeName:cell.LBL_charge.textColor,
                                              NSFontAttributeName:cell.LBL_charge .font
                                              };
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text2 attributes:attribs];
                    
                    NSRange ename = [text2 rangeOfString:qrcode];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                range:ename];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
                                                range:ename];
                    }
                    
                    NSRange flatrate = [text2 rangeOfString:shipping_type];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0]}
                                                range:flatrate];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:14.0]}
                                                range:flatrate];
                    }
                    
                    NSRange chrge = [text2 rangeOfString:CHRGE];
                    if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:25.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:chrge];
                    }
                    else
                    {
                        [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:chrge];
                    }
                    
                    
                    cell.LBL_charge .attributedText = attributedText;
                }
                else
                {
                    cell.LBL_charge .text = text2;
                }
                
           // CheckBox Pick From Merchant Location customization
                
                if (indexPath.row == totalRow-1) {
                    
                    if ([[[date_time_merId_Arr objectAtIndex:indexPath.section] valueForKey:@"pickMethod"]isEqualToString:@"1"]) {
                        
                        
                       
                        
                     cell.LBL_stat.image = [UIImage imageNamed:@"checkbox_select.png"];
                        [cell.BTN_box setBackgroundImage:[UIImage imageNamed:@"checkbox_select.png"] forState:UIControlStateNormal];
                        
                      // Calander
                        if ([delivery_slot_available isEqualToString:@"Yes"]) {
                            
                            cell.BTN_calendar.hidden = YES;
                        }
                      //Ship Charge
                        if([key_ship_arr containsObject:str])
                        {
                            cell.LBL_charge.text=nil;
                            //cell.LBL_charge.hidden = YES;
                        }
                        
                    }
                    else{
                    
                        
                        cell.LBL_stat.image = [UIImage imageNamed:@"profile_checkbox.png"];
                         [cell.BTN_box setBackgroundImage:[UIImage imageNamed:@"profile_checkbox.png"] forState:UIControlStateNormal];
                        
                        //Calender
                        if ([delivery_slot_available isEqualToString:@"Yes"]) {
                            
                            cell.BTN_calendar.hidden = NO;
                        }
                        //Chgarge 
                        if([key_ship_arr containsObject:str])
                        {
                            cell.LBL_charge.hidden = NO;
                        }


                    }
                  
                }
                
                
            }
            
            @catch(NSException *exception)
            {
                NSLog(@"%@",exception);
            }
        
     
    
        return cell;
        
    }
    
    else
    {
        // ***************TableView Address**************
        
        shipping_cell *cell;
        
        @try {
            NSMutableDictionary *dict_shipping = [jsonresponse_dic_address valueForKey:@"shipaddress"];
            NSArray *keys_arr;
            
            if ([dict_shipping isKindOfClass:[NSDictionary class]]) {
                keys_arr = [dict_shipping allKeys];
            }
            
            if([dict_shipping isKindOfClass:[NSDictionary class]])
            {
                
                
                cell = [tableView dequeueReusableCellWithIdentifier:identifier_shipping];
                
                if (cell == nil)
                {
                    NSArray *nib;
                    nib = [[NSBundle mainBundle] loadNibNamed:@"shipping_cell" owner:self options:nil];
                    cell = [nib objectAtIndex:index];
                }
                
                cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
                cell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
                cell.layer.shadowOpacity = 1.0;
                cell.layer.shadowRadius = 4.0;
                
                
                [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd:) forControlEvents:UIControlEventTouchUpInside];
                cell.BTN_edit.tag = indexPath.row;

                
                
                if (keys_arr.count <3 && indexPath.row == keys_arr.count - 1) {
                    
                    //                if(indexPath.row == keys_arr.count - 1 )
                    //                {
                    cell.BTN_edit_addres.hidden = NO;
                    //}
                    
                }
                else{
                    cell.BTN_edit_addres.hidden = YES;
                }
                
              // Load Shipping Address to Shipping AddressTableView..........
                
                NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"],[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"]];
                name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                cell.LBL_name.text = name_str;
                // NSString *country;
                NSString *state = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state"];
                NSString *country = [[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"];
                
                
                
                state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                NSString *cntry_zip = [NSString stringWithFormat:@"%@",country];
                
                NSString *zipcode = [NSString stringWithFormat:@",%@",[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"]];
                
               if ([zipcode containsString:@"<null>"] ||[zipcode containsString:@"<nil>"] || [zipcode isEqualToString:@""] || [zipcode containsString:@"null"]) {
                    zipcode = @"";
                }
                cntry_zip = [NSString stringWithFormat:@"%@ %@",cntry_zip,zipcode];
                
                
                NSString *address_str = [NSString stringWithFormat:@"%@,\n%@ \n%@,\n%@\n%@",[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address1"],[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"city"],state,cntry_zip,[[[dict_shipping valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"phone"]];
                
                address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
                
                
                cell.LBL_address.text = address_str;
            
                [cell.BTN_edit_addres addTarget:self action:@selector(add_new_address:) forControlEvents:UIControlEventTouchUpInside];
                cell.BTN_edit_addres.tag = indexPath.row;
                
                cell.BTN_radio.tag = indexPath.row;
                [cell.BTN_radio addTarget:self action:@selector(radio_btn_action:) forControlEvents:UIControlEventTouchUpInside];
                
                //Radio Button Status Checking
                
                if ([[radioButtonArray objectAtIndex:indexPath.row] isEqualToString:@"Yes"]) {
                    
                    [cell.BTN_radio setBackgroundImage:[UIImage imageNamed:@"radiobtn.png"] forState:UIControlStateNormal];
                   // cell.BTN_edit.enabled = YES;
                    
                    
                }
                else{
                    [cell.BTN_radio setBackgroundImage:[UIImage imageNamed:@"radio_unSlt.png"] forState:UIControlStateNormal];
                   // cell.BTN_edit.enabled = NO;
                    
                }
            }
            
            
            }
            @catch(NSException *exception)
            {
                
            }
        return cell;
            }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(tableView == _TBL_orders)
    {

        
        @try {
            
            
            CGSize result = [[UIScreen mainScreen] bounds].size;
            
            NSDictionary *ARR_val = [ARR_pdts objectAtIndex:indexPath.row];
            //            NSArray *keys_arr = [[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] objectAtIndex:indexPath.section] allKeys];
            NSArray *keys_arr = [ARR_val allKeys];
            
            NSString *STR_cntnt = [keys_arr objectAtIndex:0];
            
            NSArray *ARR_CNNN = [ARR_val valueForKey:STR_cntnt];
//            ct = [[[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] objectAtIndex:0] valueForKey:[keys_arr objectAtIndex:indexPath.row]]count];
            
          
//            int randomWordIndex = rand() % [ARR_cntnt count];
            
            if ([ARR_CNNN count]-1 == indexPath.row) {
                
                
                if(result.height <= 480)
                {
                    return 240.0;
                }
                else if(result.height <= 568)
                {
                    return 240.0;
                }
                else
                {
                    return 230.0;
                }
                
                //return UITableViewAutomaticDimension;
            }
            
            else{
                
                if(result.height <= 480)
                {
                    return 200;
                }
                else if(result.height <= 568)
                {
                    return 200;
                }
                else
                {
                    return 170;
                }
                
                
                
                //return UITableViewAutomaticDimension;
                
                
            }
            
        } @catch (NSException *exception) {
            
        }
        
        
    }
    else
    {
        
        if(indexPath.section == 0)
        {
            return 200;
            
            
        }
        else
        {//[jsonresponse_dic_address valueForKey:@"shipaddress"];
            if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
                return 200;
            }
            else{
                return 624.0;
            }
            
        }
        
    }
    
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if(tableView == _TBL_orders)
    {
        return 5;
    }
    return 0;
}



#pragma mark button_actions.....

//SAME AS   BILLING ADDRESS CHECK BOX SELECTION
-(void)BTN_check_clickd
{
    //profile_checkbox.png
    //checkbox_select.png

    NSData *imgData1 = UIImagePNGRepresentation(self.LBL_stat.image);
    NSData *imgData2 = UIImagePNGRepresentation([UIImage imageNamed:@"profile_checkbox.png"]);
    BOOL isCompare =  [imgData1 isEqualToData:imgData2];
    if (isCompare) {
        isCompare = NO;
        billcheck_clicked = @"0"; // for place order
        self.LBL_stat.image = [UIImage imageNamed:@"checkbox_select.png"];
        _TBL_address.hidden = YES;
        _VW_SHIIPING_ADDRESS.hidden = YES;
        CGRect frame_set  = _VW_special.frame;
        frame_set.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
        _VW_special.frame = frame_set;
        shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
    }
    else
    {
        [self collapse_TBL];
       // [self collapse_TBL];
    }
    [self viewDidLayoutSubviews];
}

-(void)collapse_TBL
{
    NSData *imgData1 = UIImagePNGRepresentation(self.LBL_stat.image);
    NSData *imgData2 = UIImagePNGRepresentation([UIImage imageNamed:@"profile_checkbox.png"]);
    BOOL isCompare =  [imgData1 isEqualToData:imgData2];
    //Checking Shippng Country is Quater Or Not
    billcheck_clicked = @"1"; // for place order
    isCompare = YES;
    self.LBL_stat.image = [UIImage imageNamed:@"profile_checkbox.png"];
    
    if([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]])
    {
        _TBL_address.hidden = NO;
        NSLog(@"Before lay Out frame%@",NSStringFromCGRect(_TBL_address.frame));
        NSLog(@"Before lay Out frame Content Hesigtht%f",_TBL_address.contentSize.height);
        
        [_TBL_address reloadData];
        [_TBL_address layoutIfNeeded];
        //[_TBL_address layoutIfNeeded];
        
        NSLog(@"After lay Out frame%@",NSStringFromCGRect(_TBL_address.frame));
        NSLog(@"After lay Out frame Content Hesigtht%f",_TBL_address.contentSize.height);
        
        CGRect frame_set = _TBL_address.frame;
        //frame_set.size.height =_TBL_address.contentSize.height; //+ _VW_special.frame.size.height-30;
        // frame_set.size.height =_TBL_address.contentSize.height ;//+ _VW_special.frame.size.height+50;
        frame_set.size.height = _TBL_address.contentSize.height + _TBL_address.contentInset.bottom + _TBL_address.contentInset.top + 30;
        _TBL_address.frame= frame_set;
        
        frame_set = _VW_special.frame;
        frame_set.origin.y = _TBL_address.frame.origin.y + _TBL_address.contentSize.height + 30;
        _VW_special.frame = frame_set;
        
        shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
        [self viewDidLayoutSubviews];
        
        NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
        for (int keys=0; keys<[keys_arr count]; keys++)
        {
                        // Checking Condition Which Shipping address is by default selected........

            if ( [[[[[jsonresponse_dic_address valueForKey:@"shipaddress"] valueForKey:[keys_arr objectAtIndex:keys]] valueForKey:@"shippingaddress"] valueForKey:@"default"] isEqualToString:@"Yes"])
            {
                [self loadShippingAddress:keys];
            }
        }
        
    }
    else
    {
        //shipping address is nil load Empty Shipping address(Hide TableView)......
        billcheck_clicked = @"1";
        _TBL_address.hidden = YES;
        _VW_SHIIPING_ADDRESS.hidden = NO;
        
        CGRect frameset = _VW_SHIIPING_ADDRESS.frame;
        frameset.origin.y = _VW_BILLING_ADDRESS.frame.origin.y + _VW_BILLING_ADDRESS.frame.size.height;
        frameset.size.width = _VW_shipping.frame.size.width;
        _VW_SHIIPING_ADDRESS.frame = frameset;
        [self.scroll_shipping addSubview:_VW_SHIIPING_ADDRESS];
        
        frameset = _VW_special.frame;
        frameset.origin.y = _VW_SHIIPING_ADDRESS.frame.origin.y + _VW_SHIIPING_ADDRESS.frame.size.height;
        _VW_special.frame = frameset;
        
        shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
        [self viewDidLayoutSubviews];
    }
}

-(void)calendar_action:(UIButton *)sender
{
    merchent_id = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
   // [self delivary_slot_API];
    //[self performSelector:@selector(delivary_slot_API) withObject:activityIndicatorView afterDelay:0.001];

    _TXT_Date.text = nil;
    _TXT_Time.text = nil;
    
    VW_overlay.hidden = NO;
    _VW_delivery_slot.hidden = NO;
    _BTN_done.layer.cornerRadius = 2.0f;
    _BTN_done.layer.masksToBounds = YES;
    _VW_delivery_slot.center = VW_overlay.center;
    _VW_delivery_slot.layer.cornerRadius = 2.0f;
    _VW_delivery_slot.layer.masksToBounds = YES;
    [VW_overlay addSubview:_VW_delivery_slot];
    //_VW_delivery_slot.hidden = NO;
    
}
// Button Next Page Action.......
-(void)next_page
{
    
    if([title_page_str isEqualToString:@"ORDER DETAIL"])
    {

            VW_overlay.hidden = YES;

        
            [self performSelector:@selector(move_to_shipping) withObject:nil afterDelay:0.01];

           
      
        
    }
    else  if([title_page_str isEqualToString:@"SHIPPING"])
    {
        
       
             VW_overlay.hidden = YES;
        
            [self performSelector:@selector(validatingTextField) withObject:nil afterDelay:0.01];
           
        
    }
    
      else if ([title_page_str isEqualToString:@"PAYMENT"] && _VW_payment.hidden == NO) {
        VW_overlay.hidden = YES;
          
          [self performSelector:@selector(move_to_payment_integration) withObject:nil afterDelay:0.01];
          
       
    }
    
}

// Loading Shipping Page(Billing ,Shipping address Views and MultipleShipping addresses in tableview...)
-(void)move_to_shipping
{
    _TBL_orders.hidden = NO;
    
    title_page_str = @"SHIPPING";
    //_LBL_navigation.title = @"SHIPPING";
    //_scroll_shipping.hidden = NO;
    _VW_shipping.hidden = NO;

    _TBL_address.estimatedRowHeight = 4.0;
    _TBL_address.rowHeight = UITableViewAutomaticDimension;
     [self.TBL_address reloadData];
    [self begin_responder];
  
    if ([billcheck_clicked isEqualToString:@"1"]) {
        
        
        if(_TBL_address.hidden == YES)
        {
            _TBL_address.hidden = YES;
            
        }
        else{
            _TBL_address.hidden = NO;
        }
        
    }
    else{
          _TBL_address.hidden = YES;
    }
    
    
    
    //[_TBL_orders removeFromSuperview];
    CGRect frame_set = _VW_shipping.frame;
    frame_set.origin.y = _VW_top.frame.origin.y + _VW_top.frame.size.height;
    frame_set.size.width = _TBL_orders.frame.size.width;
    frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
    _VW_shipping.frame = frame_set;
    [self.view addSubview:_VW_shipping];
    _TXT_first.backgroundColor = _LBL_order_detail.backgroundColor;
    _LBL_shipping.backgroundColor =_LBL_order_detail.backgroundColor;
    
//    VW_overlay.hidden = YES;
//    [activityIndicatorView stopAnimating];

    
}
-(void)back_to_shipping
{
    _TBL_orders.hidden = YES;
    
    title_page_str = @"SHIPPING";
    //_LBL_navigation.title = @"SHIPPING";
    //_scroll_shipping.hidden = NO;
    _VW_shipping.hidden = NO;
    
//    _TBL_address.estimatedRowHeight = 4.0;
//    _TBL_address.rowHeight = UITableViewAutomaticDimension;
    
    
    [self.TBL_address reloadData];
    if ([billcheck_clicked isEqualToString:@"1"]) {
        
        
        if(_TBL_address.hidden == YES)
        {
            _TBL_address.hidden = NO;
            
        }
        else{
            _TBL_address.hidden = YES;
        }
        
    }
    else{
        _TBL_address.hidden = YES;
    }

    
    //[_TBL_orders removeFromSuperview];
    CGRect frame_set = _VW_shipping.frame;
    frame_set.origin.y = _VW_top.frame.origin.y + _VW_top.frame.size.height;
    frame_set.size.width = _TBL_orders.frame.size.width;
    frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
    _VW_shipping.frame = frame_set;
    [self.view addSubview:_VW_shipping];
    _TXT_first.backgroundColor = _LBL_order_detail.backgroundColor;
    _LBL_shipping.backgroundColor =_LBL_order_detail.backgroundColor;

}

-(void)move_to_payment_integration{
   
    
    
        NSLog(@"%@",payment_type_str);
    
        if ([payment_type_str isEqualToString:@"1"]||[payment_type_str isEqualToString:@"2"] ||[payment_type_str isEqualToString:@"3"] ||[payment_type_str isEqualToString:@"4"] || [payment_type_str isEqualToString:@"5"]) {
            
        
            
            VW_overlay.hidden = NO;
            [self.view addSubview:VW_overlay];
            
            
            [_LBL_timer_lbl setText:@"05:00"];
            currMinute= 5;
            currSeconds=00;
            
           // [_BTN_resend_otp setEnabled:NO];
            [_BTN_resend_otp setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];

            if ([payment_type_str isEqualToString:@"5"]) {
                
                [timer invalidate];
                [self gettingOtpForCashOnDelivary];
                
                //
                
                self.VW_summary.hidden = YES;
                self.VW_delivery_slot.hidden = YES;
                
                self.VW_otp_vw.hidden = NO;
                self.VW_otp_vw.frame = self.VW_otp_vw.frame;
                self.VW_otp_vw.center = VW_overlay.center;
                [self->VW_overlay addSubview:self.VW_otp_vw];
               // timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                
                [_BTN_validate_otp setEnabled:YES];
            
                
            }
            else{
               // _LBL_next.hidden = NO;
                self.VW_otp_vw.hidden = YES;
               [self performSelector:@selector(place_oredr_parameters_parsing) withObject:nil afterDelay:0.01];
            }

            
            
        }
        else{
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
           
            [HttpClient createaAlertWithMsg:@"الرجاء تحديد نوع الدفع" andTitle:@""];
            }
            else{
            [HttpClient createaAlertWithMsg:@"Please Select Payment Type" andTitle:@""];
            }
        }
    }
#pragma mark Timer Implementation of OTP for Cash On Delivery......

-(void)timerFired
{
    
    if((currMinute>0 || currSeconds>=0) && currMinute>=0)
    {
        if(currSeconds==0)
        {
            currMinute-=1;
            currSeconds=59;
        }
        else if(currSeconds>0)
        {
            currSeconds-=1;
        }
        if(currMinute>-1)
            [_LBL_timer_lbl setText:[NSString stringWithFormat:@"%d%@%02d",currMinute,@":",currSeconds]];
        
        
    }
    else
    {
        [timer invalidate];
        
        [_BTN_validate_otp setEnabled:NO];
    
        if (isResendSelected) {
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@" انتهت صلاحية OTP ، يرجى المحاولة مرة أخرى" delegate:self cancelButtonTitle:@"حسنا" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                
            }
            else
            {
                
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"OTP expired, Please try again" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                alert.tag = 1;
                [alert show];
                
            }

            _BTN_resend_otp.hidden  = YES;
        }
        else{
            
        [_BTN_resend_otp setEnabled:YES];
        
        [_BTN_resend_otp setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        }
    }
   }

// Validate_OTP Action
-(void)validate_OTP{
    
    [Helper_activity animating_images:self];
    
    
        if ([_TXT_message_field.text isEqualToString:otp_str]) {
            NSLog(@"Validate");
            [self place_oredr_parameters_parsing];
        }
        else{
            
            [Helper_activity stop_activity_animation:self];
            _TXT_message_field.text = @"";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
            [HttpClient createaAlertWithMsg:@"يرجى إدخال كلمة المرور الصالحة لمرة واحدة" andTitle:@""];
            }else{
                [HttpClient createaAlertWithMsg:@"Please Enter Valid OTP" andTitle:@""];
 
            }
        
            [_TXT_message_field becomeFirstResponder];
        }
    }


//resend_action.......
-(void)resend_action{
    
    
    [timer invalidate];
    [self gettingOtpForCashOnDelivary];
    [_LBL_timer_lbl setText:@"05:00"];
    currMinute=05;
    currSeconds=00;
//    timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
        isResendSelected = YES;
    [_BTN_validate_otp setEnabled:YES];
    
    _BTN_resend_otp.hidden = YES;
    
    
}

// Loading Payment Page.......
-(void)move_to_payment_types{
    
    [self performSelector:@selector(payment_methods_API) withObject:nil afterDelay:0.001];
    _TBL_address.hidden = YES;
    title_page_str =@"PAYMENT";
    
    // Showing Payment methods type.....
    _VW_payment.hidden =NO;
    
    CGRect frame_set = _VW_payment.frame;
    frame_set.origin.y = _VW_top.frame.origin.y + _VW_top.frame.size.height;
    frame_set.size.width = _TBL_orders.frame.size.width;
    frame_set.size.height = _VW_next.frame.origin.y - _TBL_orders.frame.origin.y;
    _VW_payment.frame = frame_set;
    [self.view addSubview:_VW_payment];

    // Filling Status of Payment in  Top View....
    _TXT_second.backgroundColor = _LBL_order_detail.backgroundColor;
    _LBL_Payment.backgroundColor=_LBL_order_detail.backgroundColor;

    
}

// Loading ProductSummaryView .......
-(void)product_clicked
{
    if([title_page_str isEqualToString:@"ORDER DETAIL"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
    }
    
    else if([title_page_str isEqualToString:@"SHIPPING"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
        
    }
    else if([title_page_str isEqualToString:@"PAYMENT"])
    {
        [self.view addSubview:VW_overlay];
        [self sumary_VIEW];
        
    }
    
}
// Setting Frame for ProductSummaryView.....
-(void)sumary_VIEW
{
    if([_LBL_arrow.text isEqualToString:@""])  //Showing SummaryView
    {
        _LBL_arrow.text = @"";
        CGRect frameset = VW_overlay.frame;
        frameset.size.height = self.view.frame.size.height - _VW_next.frame.size.height-20;
        VW_overlay.frame = frameset;
        // Before displaying _VW_summary  Close remaining view on VW Overlay if they present
        _VW_otp_vw.hidden = YES;
        _VW_delivery_slot.hidden= YES;
        
      //Display Vw Summary View
        VW_overlay.hidden = NO;
       _VW_summary.hidden = NO;
        
        //_LBL_arrow.text = @"";
        
        [self fill_value_to_Lbl_product_summary:@""];
    }
    else         // Hiding Summary View....
    {
        _LBL_arrow.text =@"";
        CGRect frameset = VW_overlay.frame;
        frameset.size.height = self.view.frame.size.height;
        VW_overlay.frame = frameset;

        VW_overlay.hidden = YES;
        _VW_summary.hidden =  YES;
        
         [self fill_value_to_Lbl_product_summary:@""];
        
    }
    
}
// PromoCode Button Action.......
-(void)apply_promo_action{
    
    if ([self.TXT_cupon.text isEqualToString:@""]) {
    
        [self.TXT_cupon becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
        [HttpClient createaAlertWithMsg:@"الرجاء إدخال رمز الكوبون" andTitle:@""];
        }
        else{
             [HttpClient createaAlertWithMsg:@"Please enter cupon code" andTitle:@""];
        }
    }
    else{
     
    [self performSelector:@selector(apply_promo_Code) withObject:nil afterDelay:0.001];
    }
}


// Loading Shipping Address in ShippingView.....
-(void)loadShippingAddress:(NSInteger)edited_tag{
   
   
    edit_tag = edited_tag;
    
    @try {
        
        
        if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
            
        
        NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
        
        
        
            
           NSLog(@"===========%@==========", [[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]]valueForKey:@"shippingaddress"]);
            
            
        NSString *state = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"state"];
        NSString *country = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"country"];
        //  state = [state stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        //  country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        NSString *str_fname,*str_lname,*str_addr1,*str_addr2,*str_city,*str_zip_code,*str_phone,*str_country,*str_state,*str_email,*str_phone_code;
        
        str_fname = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"];
        str_lname = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"lastname"];
        str_addr1 = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"address1"];
        str_addr2 = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"address2"];
        str_city = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"city"];
        str_zip_code = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"]  valueForKey:@"zip_code"];
        str_phone = [[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"phone"];
        str_country = country;
        str_state =state;
        
        
        //cell.Btn_save.hidden = YES;
        
        ship_state_ID = [NSString stringWithFormat:@"%@",[[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"state_id"]];
        
        ship_cntry_ID = [NSString stringWithFormat:@"%@",[[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"country_id"]];
        
        str_phone_code=[[[[jsonresponse_dic_address valueForKey:@"shipaddress"]valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"phonecode"];
        
        if ([str_phone_code isEqualToString:@"<null>"] ||[str_phone_code isEqualToString:@"<nil>"]||[str_phone_code isEqualToString:@""] ) {
            str_phone_code = @"974";
            _TXT_ship_cntry_code.userInteractionEnabled = YES;
           // _TXT_ship_cntry_code.backgroundColor = [UIColor clearColor];
        }
        else{
            _TXT_ship_cntry_code.userInteractionEnabled = NO;
            _TXT_ship_cntry_code.backgroundColor = [UIColor lightGrayColor];
        }
            str_phone_code = [NSString stringWithFormat:@"+%@",str_phone_code];
            
        
        str_fname = [str_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        str_lname = [str_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_addr1 = [str_addr1 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_addr2 = [str_addr2 stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_city = [str_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_zip_code = [str_zip_code stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_phone = [str_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        str_country = [str_country stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        str_state = [str_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_email = [str_email stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        
        if ([str_zip_code isEqualToString:@"<null>"] ||[str_zip_code isEqualToString:@"<nil>"]||[str_zip_code isEqualToString:@"null"] ) {
            str_zip_code = @"";
        }
        
            
            if ([str_phone isEqualToString:@"<null>"] ||[str_phone isEqualToString:@"<nil>"]||[str_phone isEqualToString:@""] ) {
                str_phone = @"";
                _TXT_ship_phone.userInteractionEnabled = YES;
                _TXT_ship_phone.backgroundColor = [UIColor clearColor];
            }
            else{
                _TXT_ship_phone.userInteractionEnabled = NO;
                _TXT_ship_phone.backgroundColor = [UIColor lightGrayColor];
            }
            
            
            
        _TXT_ship_fname.text =  str_fname;
        _TXT_ship_lname.text =  str_lname;
        _TXT_ship_addr1.text =  str_addr1;
        _TXT_ship_addr2.text =  str_addr2;
        _TXT_ship_city.text =  str_city;
        _TXT_ship_state.text =  str_state;
        _TXT_ship_zip.text =  str_zip_code;
        _TXT_ship_country.text =  str_country;
        _TXT_ship_email.text =  str_email;
        _TXT_ship_phone.text =  str_phone;
        _TXT_ship_cntry_code.text =str_phone_code;
        
        }
       
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    
}

// Edit Shipping Address (TableViewShippingAddress).......

-(void)BTN_edit_clickd:(UIButton*)sender
{
   // Set frame for Shipping Address View......
    
    _VW_SHIIPING_ADDRESS.hidden = NO;
    CGRect frameset = _VW_SHIIPING_ADDRESS.frame;
    frameset.origin.y = _TBL_address.frame.origin.y + _TBL_address.contentSize.height + 20;
    frameset.size.width = _VW_shipping.frame.size.width;
    _VW_SHIIPING_ADDRESS.frame = frameset;
    [self.scroll_shipping addSubview:_VW_SHIIPING_ADDRESS];
    [self begin_ship_responder];
    frameset = _VW_special.frame;
    frameset.origin.y = _VW_SHIIPING_ADDRESS.frame.origin.y + _VW_SHIIPING_ADDRESS.frame.size.height;
    _VW_special.frame = frameset;
    
    shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
    [self viewDidLayoutSubviews];
    
//    isAddClicked = NO;
//    i = 3;
    edit_tag = [sender tag];
    
    @try {
        
        NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
        
        
        
        for (int keys=0; keys<[keys_arr count]; keys++) {
            
            if (keys == sender.tag) {
                
                
                [radioButtonArray replaceObjectAtIndex:keys withObject:@"Yes"];
            }
            else{
                [radioButtonArray replaceObjectAtIndex:keys withObject:@"No"];
            }
            
            
        }
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TBL_address];
        NSIndexPath *indexPath = [self.TBL_address indexPathForRowAtPoint:buttonPosition];
        
        //Reload Particular Section in TableView
        [self.TBL_address beginUpdates];
        [self.TBL_address reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self.TBL_address endUpdates];

        [self loadShippingAddress:edit_tag];


        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}
// Add New Shipping Address when Shipping address count less than 3......
-(void)add_new_address:(UIButton*)sender{
    
    //Shipping Address  For PAyment Paramater
     newaddressinput= @"1";
    
    
    //  Loading Empty Form of Shipping Address.....
    _VW_SHIIPING_ADDRESS.hidden = NO;
    CGRect frameset = _VW_SHIIPING_ADDRESS.frame;
    frameset.origin.y = _TBL_address.frame.origin.y + _TBL_address.contentSize.height + 40;
    frameset.size.width = _VW_shipping.frame.size.width;
    _VW_SHIIPING_ADDRESS.frame = frameset;
    [self.scroll_shipping addSubview:_VW_SHIIPING_ADDRESS];
    
    frameset = _VW_special.frame;
    frameset.origin.y = _VW_SHIIPING_ADDRESS.frame.origin.y + _VW_SHIIPING_ADDRESS.frame.size.height;
    _VW_special.frame = frameset;
    
    shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
    [self viewDidLayoutSubviews];
    
    _TXT_ship_fname.text =  nil;
    _TXT_ship_lname.text =  nil;
    _TXT_ship_addr1.text =  nil;
    _TXT_ship_addr2.text =  nil;
    _TXT_ship_city.text =  nil;
    _TXT_ship_state.text =  nil;
    _TXT_ship_zip.text =  nil;
    _TXT_ship_email.text =  nil;
    _TXT_ship_phone.text =  nil;
    
    _TXT_ship_cntry_code.text = @"+974";
    
    _TXT_ship_cntry_code.backgroundColor = [UIColor blackColor];
    _TXT_ship_phone.backgroundColor = [UIColor clearColor];
    
    _TXT_ship_cntry_code.userInteractionEnabled = YES;
    _TXT_ship_phone.userInteractionEnabled = YES;
    
    
// Shipping Country  ID Must Be  Related Local Country ID
    
    @try {
        
        if (shipping_Countries_array.count != 0) {
       
        _TXT_ship_country.text = [[shipping_Countries_array objectAtIndex:0] valueForKey:@"name"];
        cntry_ID = [[[shipping_Countries_array objectAtIndex:0] valueForKey:@"id"] integerValue];
        ship_cntry_ID = [NSString stringWithFormat:@"%@",[[shipping_Countries_array objectAtIndex:0] valueForKey:@"id"]];
        }
        else{
            NSLog(@"No Countries ");
        }

    } @catch (NSException *exception) {
        
    }
}
// Delivery Slot Action........
-(void)deliveryslot_action // Done Button
{
    if ([_TXT_Date.text length] != 0 && [_TXT_Time.text length] != 0) {
        
        // Getting merchant Id ,Day/Date and time Id for payment
        for (int m=0; m<date_time_merId_Arr.count; m++) {
            
            if ([merchent_id isEqualToString:[[date_time_merId_Arr objectAtIndex:m] valueForKey:@"mer_id"]]) {
                
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [dic addEntriesFromDictionary:[date_time_merId_Arr objectAtIndex:m]];
                
                [dic setObject:time_str forKey:@"time"];
                [dic setObject:date_str forKey:@"date"];

               // NSDictionary *dic = @{@"mer_id":merchent_id,@"time":time_str,@"date":date_str};
                
                [date_time_merId_Arr replaceObjectAtIndex:m withObject:dic];
                
            }
        }NSLog(@"@@@@@@@@@@ %@",date_time_merId_Arr);
        
        
        VW_overlay.hidden = YES;
        _VW_delivery_slot.hidden = YES;
        
        _TXT_Date.text = nil;
        _TXT_Time.text = nil;
        
        
    }
    else{
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
            [HttpClient createaAlertWithMsg:@" يرجى اختيار الوقت و اليوم / التاريخ" andTitle:@""];;
        }
        else{
            [HttpClient createaAlertWithMsg:@"please select delivery date / Time" andTitle:@""];
        }
       
    }
    
    
    
}

//Shipping address(address tableview) Radio_button_action.......
-(void)radio_btn_action:(UIButton*)sender{
    
    
    @try {
        
        if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
            NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
            for (int keys=0; keys<[keys_arr count]; keys++) {
                
                if (keys == sender.tag) {

                    [radioButtonArray replaceObjectAtIndex:keys withObject:@"Yes"];
        
                }
                else{
                    [radioButtonArray replaceObjectAtIndex:keys withObject:@"No"];
                }
                
                
            }
        }
        
        CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TBL_address];
        NSIndexPath *indexPath = [self.TBL_address indexPathForRowAtPoint:buttonPosition];
        
        //Reload Particular Section in TableView
        [self.TBL_address beginUpdates];
        [self.TBL_address reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        [self.TBL_address endUpdates];
        if (edit_tag != sender.tag) {
            [self radio_BTN_action];
            //[self radio_BTN_action];

            shiiping_ht = _VW_special.frame.origin.y + _VW_special.frame.size.height;
            [self viewDidLayoutSubviews];
            [self.VW_SHIIPING_ADDRESS removeFromSuperview];
             [self loadShippingAddress:sender.tag];
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
    
}
-(void)radio_BTN_action
{
    CGRect frame_set = _TBL_address.frame;
     frame_set.size.height = _TBL_address.contentSize.height + _TBL_address.contentInset.bottom + _TBL_address.contentInset.top + 30;
    _TBL_address.frame= frame_set;
    
    frame_set = _VW_special.frame;
    frame_set.origin.y = _TBL_address.frame.origin.y + _TBL_address.contentSize.height + 30;
    _VW_special.frame = frame_set;

}

// Filtering RadioButton VAlues for default selection of shipping address.....

-(void)radioButton_values{
    
    @try {
        
        radioButtonArray = [NSMutableArray array];
        
        if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
            
            
            NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"shipaddress"] allKeys];
            for (int keys=0; keys<[keys_arr count]; keys++) {
                
                [radioButtonArray addObject:[[[[jsonresponse_dic_address valueForKey:@"shipaddress"] valueForKey:[keys_arr objectAtIndex:keys]] valueForKey:@"shippingaddress"] valueForKey:@"default"]];
                
                
            }
            NSLog(@"radioButtonArray ::::%@",radioButtonArray);
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
}


// TableView orders Cell checkBox Clicked(Pick Up From Merchant Location)..........

-(void)BTN_check_clickds:(UIButton *)sender
{

    
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.TBL_orders];
    NSIndexPath *indexPathsec = [self.TBL_orders indexPathForRowAtPoint:buttonPosition];
    
    merchent_id = [NSString stringWithFormat:@"%ld",(long)sender.tag];
    
    //checkbox selection status adding to placeorder paramaters
    
    for (int m=0; m<date_time_merId_Arr.count; m++) {
     
     if ([merchent_id isEqualToString:[[date_time_merId_Arr objectAtIndex:m] valueForKey:@"mer_id"]]) {
     
     NSMutableDictionary *dic = [NSMutableDictionary dictionary];
     [dic addEntriesFromDictionary:[date_time_merId_Arr objectAtIndex:m]];
     
         
         if ([[NSString stringWithFormat:@"%@",[dic valueForKey:@"pickMethod"]] isEqualToString:@"0"]) {
             
              [dic setObject:@"1" forKey:@"pickMethod"];
             [self Updating_ship_charge_when_pick_up_selection:@"minus"]; // Reduce amount
         }else{
            [dic setObject:@"0" forKey:@"pickMethod"];
             
             [self Updating_ship_charge_when_pick_up_selection:@"plus"]; // Add Amount
             
         }

     [date_time_merId_Arr replaceObjectAtIndex:m withObject:dic];
         
         
         [self.TBL_orders beginUpdates];
         
         [self.TBL_orders reloadSections:[NSIndexSet indexSetWithIndex:indexPathsec.section] withRowAnimation:UITableViewRowAnimationNone];
         
         [self.TBL_orders endUpdates];
     
     }
     }
}
#pragma mark Updating Shipping Charge When pick From Merchant location

-(void)Updating_ship_charge_when_pick_up_selection:(NSString *)reduce{
    
    @try {
        
        NSString *reduce_amount = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:merchent_id] valueForKey:@"charge"]];
        
        if ([reduce_amount isEqualToString:@"<null>"]||[reduce_amount isEqualToString:@"<nil>"]||[reduce_amount isEqualToString:@""]) {
            reduce_amount=@"0";
        }
        if ([reduce isEqualToString:@"minus"]) {
            charge_ship = charge_ship-[reduce_amount floatValue];
            
            total = total-[reduce_amount floatValue];
            
            
        }
        else{
            charge_ship = charge_ship+[reduce_amount floatValue];
              total = total+[reduce_amount floatValue];
        }
       // Shipping Charrge Label....
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%.2f %@",charge_ship,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        }
        else{
            
          self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%@ %.2f",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],charge_ship];
        }
        
    } @catch (NSException *exception) {
        
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%.2f %@",charge_ship,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        }
        else{
        
        self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%@ %.2f",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],charge_ship];
        }
        
    }
// For Updating Total Amount and Dohamiles value in  product View Summary
    
    [self fill_value_to_Lbl_product_summary:@" "]; // Footer Section Total Amount
    
    [self LBl_dohamilesAndTotalAmount:total];    // Product Summary Total amount
}



//-(void)tapGesture_close
//{
//    // [self dismissViewControllerAnimated:NO completion:nil];
//    NSLog(@"the cancel clicked");
//}


// Minus Button Action.......

-(void)minus_action:(UIButton*)btn
{
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:self.TBL_orders];
    NSIndexPath *indexPath = [self.TBL_orders indexPathForRowAtPoint:rootViewPoint];
    
    order_cell *cell = (order_cell*)[self.TBL_orders cellForRowAtIndexPath:indexPath];
    
    if ([cell._TXT_count.text isEqualToString:@"1"]) {
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
            [HttpClient createaAlertWithMsg:@"يجب أن يكون الحد الأدنى من الكمية 1." andTitle:@""];;
        }
        else{
            [HttpClient createaAlertWithMsg:@"Minimum Quantity Should be 1." andTitle:@""];
        }

        
        }else{
        
        NSString *cnt = [NSString stringWithFormat:@"%ld",[cell._TXT_count.text integerValue]-1];
        
        item_count = cnt;
        
        
        product_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];//Getting product Id
        
        
        merchent_id = [NSString stringWithFormat:@"%ld",cell.BTN_calendar.tag]; //Getting Mer Id
        
        NSLog(@"id_m %@  id_p %@",product_id,merchent_id);
        
       
        @try {
            //subTtl = total + [price integerValue];
            [self  updating_cart_List_api:[NSString stringWithFormat:@"%@",item_count]];
            
        } @catch (NSException *exception) {
            
            //subTtl = total + [prev_price integerValue];
            [self  updating_cart_List_api:[NSString stringWithFormat:@"%@",item_count]];
            
        }
        
    }
}

//  Plus Action.........
-(void)plus_action:(UIButton*)btn
{
    CGPoint center= btn.center;
    CGPoint rootViewPoint = [btn.superview convertPoint:center toView:self.TBL_orders];
    NSIndexPath *indexPath = [self.TBL_orders indexPathForRowAtPoint:rootViewPoint];
    order_cell *cell = (order_cell*)[self.TBL_orders cellForRowAtIndexPath:indexPath];
    
    NSString *cnt = [NSString stringWithFormat:@"%ld",[cell._TXT_count.text integerValue]+1];
    
    item_count = cnt;
    
    product_id = [NSString stringWithFormat:@"%ld",(long)btn.tag];
    
    merchent_id = [NSString stringWithFormat:@"%ld",cell.BTN_calendar.tag];
    
    NSLog(@"id_m %@  id_p %@",product_id,merchent_id);
    
    
    @try {
        //subTtl = total + [price integerValue];
        [self  updating_cart_List_api:[NSString stringWithFormat:@"%@",item_count]];
        
    } @catch (NSException *exception) {
        
        //subTtl = total + [prev_price integerValue];
        [self  updating_cart_List_api:[NSString stringWithFormat:@"%@",item_count]];
        
    }
    
    
}

- (IBAction)back_action_clicked:(id)sender {
    
    if([title_page_str isEqualToString:@"ORDER DETAIL"])
    {
        
    /*    VW_overlay.hidden = YES;
        //            [activityIndicatorView startAnimating];
        
        [self performSelector:@selector(move_to_shipping) withObject:nil afterDelay:0.01];*/
        
        
        [self.navigationController popViewControllerAnimated:NO];
        
    }
    else  if([title_page_str isEqualToString:@"SHIPPING"])
    {
        _TBL_orders.hidden = NO;
       
      //  [self.view addSubview:_TBL_orders];
        _VW_shipping.hidden = YES;
         _Scroll_card.hidden = YES;
        title_page_str =  @"ORDER DETAIL";
        _TXT_first.backgroundColor = [UIColor clearColor];
        _LBL_shipping.backgroundColor =[UIColor clearColor];
        
        
        
            //  [self set_UP_VIEW];
        
        
    }
    
    else if ([title_page_str isEqualToString:@"PAYMENT"] && _VW_payment.hidden == NO) {
        
        _VW_payment.hidden = YES;
        VW_overlay.hidden = YES;
        _VW_pay_cards.hidden = YES;
          title_page_str =  @"SHIPPING";
        _TXT_second.backgroundColor = [UIColor clearColor];
        _LBL_Payment.backgroundColor =[UIColor clearColor];

        
         //            [activityIndicatorView startAnimating];
        [self performSelector:@selector(back_to_shipping) withObject:nil afterDelay:0.01];
        
        
        
    }

    
   // [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark text field delgates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self stope_animating_view_for_textField];
    
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger inte = _TXT_phone.text.length;
    if(textField == _TXT_phone)
    {
    if([_TXT_Cntry_code.text isEqualToString:@"+974"])
    {
        if(inte == 8)
        {
            if ([string isEqualToString:@""])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
    }
    else
    {
        if(inte >= 15)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    }
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString *resultString = [[_TXT_phone.text componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
    _TXT_phone.text = resultString;

    NSInteger intes = _TXT_ship_phone.text.length;
    if(textField == _TXT_ship_phone)
    {
    if([_TXT_ship_cntry_code.text isEqualToString:@"+974"])
    {
        if(intes == 8)
        {
            if ([string isEqualToString:@""])
            {
                return YES;
            }
            else
            {
                return NO;
            }
        }
        
    }
    else
    {
        if(intes >= 15)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
    }
    }

    NSCharacterSet *notAllowedChar = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString *resultStrin = [[_TXT_ship_phone.text componentsSeparatedByCharactersInSet:notAllowedChar] componentsJoinedByString:@""];
    
    _TXT_ship_phone.text = resultStrin;

    
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    /*
     TimeSlot
     StatesAndCountry
     Shipping
     */
    isPickerViewScrolled = NO;
  
    [textField becomeFirstResponder];
    
    if (textField == _TXT_ship_country) {
        pickerSelection = @"Shipping";
        [self.shipping_PickerView selectRow:0 inComponent:0 animated:YES];

    }
    
    if (textField == _TXT_Date ) {
        [self.pickerView selectRow:0 inComponent:0 animated:YES];

        pickerSelection = @"TimeSlot";
        [self delivarySlotDateRelated:textField];
       
    }
    if (textField == _TXT_Time ) {
        pickerSelection = @"TimeSlot";
        [self.pickerView selectRow:0 inComponent:0 animated:YES];
       [self delivary_slot_time_related:textField];
    }
    if (textField == _TXT_country|| textField == _TXT_state) {
        
        select_blng_ctry_state = YES;
    }
    if (textField == _TXT_ship_country || textField == _TXT_ship_state ) {
        
        select_blng_ctry_state = NO;

    }
    
    if (textField == _TXT_country) {
        isCountrySelected = YES;
        pickerSelection = @"StatesAndCountry";
        [self.staes_country_pickr selectRow:0 inComponent:0 animated:YES];

        

        [self performSelector:@selector(CountryAPICall) withObject:nil afterDelay:0];
      
    }

    if (textField.tag == 6) {
        
        pickerSelection = @"StatesAndCountry";
                isCountrySelected = NO;

        
        [self.staes_country_pickr selectRow:0 inComponent:0 animated:YES];
        [self.pickerView becomeFirstResponder];
        [self performSelector:@selector(stateApiCall) withObject:nil afterDelay:0];
        
    }
    
    if(textField == _TXT_phone ||textField == _TXT_Cntry_code || textField ==_TXT_ship_cntry_code || textField ==_TXT_country || textField ==_TXT_state||textField == _TXT_ship_phone||textField == _TXT_city||textField == _TXT_zip||textField == _TXT_ship_zip||textField == _TXT_ship_city||textField == _TXT_ship_country||textField == _TXT_ship_state||textField == _TXT_ship_addr2 )//|| textField == _TXT_instructions
    {

        
        [self view_animation:-190];

    }
    if(textField == _TXT_cupon)
    {
        
        [self view_animation:-150];
    }
    if ( textField == _TXT_message_field) {

          [self view_animation:-40];
    }
    if (textField == _TXT_ship_cntry_code || textField == _TXT_Cntry_code) {
      pickerSelection = @"Phone";
        [self.country_code_Pickerview selectRow:0 inComponent:0 animated:YES];
    }
    

 
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
   
    [self stope_animating_view_for_textField];
    [textField resignFirstResponder];
    
    if (textField == _TXT_ship_cntry_code) {
        textField.text = flag;
    }
    if (textField == _TXT_Cntry_code) {
         textField.text = flag;
    }
    
    if (textField.tag == 6) {
        
        textField.text = state_selection;
        
    }
    if (textField == _TXT_country) {
        
        
        textField.text = cntry_selection;
        
        

        
        if ([textField.text isEqualToString:@""]) {
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
            [HttpClient createaAlertWithMsg:@"الرجاء تحديد البلد" andTitle:@""];
            }
            else{
              [HttpClient createaAlertWithMsg:@"Please Select Country " andTitle:@""];
            }
       }
}
    
}

#pragma mark - textView Delegates
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
   // [textView becomeFirstResponder];
    return YES;
}
-(void)textViewDidBeginEditing:(UITextView *)textView{
     [self view_animation:-190];
    [textView becomeFirstResponder];
}


- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        NSLog(@"Return pressed, do whatever you like here");
        [textView resignFirstResponder];
        [self stope_animating_view_for_textField];
        return NO; // or true, whetever you's like
    }
    
    return YES;
}


#pragma mark View Animations While TextField Editing Time
-(void)view_animation:(CGFloat)yaxis{
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,yaxis,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}
-(void)stope_animating_view_for_textField{
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

#pragma mark Delivary Slot DATE Related Code....
-(void)delivarySlotDateRelated:(UITextField*)textfield{
    
    @try {
        
        is_Txt_date = YES;
        [deliverySlotPickerArray removeAllObjects];
        
        NSDate *day_date;
        if ([[delivary_slot_dic valueForKey:@"days"] isKindOfClass:[NSDictionary class]]) {
            
            slot_keys_arr = [[delivary_slot_dic valueForKey:@"days"]allKeys];
            
            
            // Getting DateString from  Response...
            for (int slot = 0; slot< slot_keys_arr.count; slot++) {
                
                NSString *str = [[delivary_slot_dic valueForKey:@"days"] valueForKey:[slot_keys_arr objectAtIndex:slot]];
                NSRange startRange = [str rangeOfString:@"(" options:NSBackwardsSearch];
                str= [str substringFromIndex:startRange.location+startRange.length];
                str = [str stringByReplacingOccurrencesOfString:@")" withString:@""];
                
                dateFormatter.dateFormat = @"MMM d,yyyy";
                
                // Converting String(Eg.. Jan 29,2018) To Date
                day_date = [dateFormatter dateFromString:str];
                [deliverySlotPickerArray addObject: @{@"key1":day_date,@"key2":[[delivary_slot_dic valueForKey:@"days"] valueForKey:[slot_keys_arr objectAtIndex:slot]],@"key3":[slot_keys_arr objectAtIndex:slot]}];
                
            }
            // Sorting By Using Date
            NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"key1" ascending:YES];
            NSArray *descriptors=[NSArray arrayWithObject: descriptor];
            NSArray *reverseOrder=[deliverySlotPickerArray sortedArrayUsingDescriptors:descriptors];
            NSLog(@" After sorting%@",reverseOrder);
            [deliverySlotPickerArray removeAllObjects];
            [deliverySlotPickerArray addObjectsFromArray:reverseOrder];
            
        }
        
        if (!deliverySlotPickerArray.count) {
            NSLog(@"Sorry! There is no options." );
        }else{
            [self.pickerView becomeFirstResponder];
            [self.pickerView reloadAllComponents];
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
#pragma mark Delivary Slot TIME Related

-(void)delivary_slot_time_related:(UITextField*)textfield{
    
   NSString *str_zone =   [[NSUserDefaults standardUserDefaults]  valueForKey:@"time_zone"];
    if([str_zone isEqualToString:@"(null)"]||[str_zone isEqualToString:@"<null>"]||[str_zone isEqualToString:@""])
    {
        str_zone = [[NSTimeZone localTimeZone] abbreviation];
    }
   // NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:str_zone];
      [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:str_zone]];
    
    [deliverySlotPickerArray removeAllObjects];
    
    is_Txt_date= NO;
    if ([[delivary_slot_dic valueForKey:@"delivery"] isKindOfClass:[NSDictionary class]]) {
        
        slot_keys_arr = [[delivary_slot_dic valueForKey:@"delivery"]allKeys];
        
        //            NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:@"UTC"];
        dateFormatter.dateFormat = @"hh:mm a";
        
        
        for (int slot = 0; slot< slot_keys_arr.count; slot++) {
            
            
            
            NSString *str = [[delivary_slot_dic valueForKey:@"delivery"] valueForKey:[slot_keys_arr objectAtIndex:slot]];
            NSRange equalRange = [str rangeOfString:@"-" options:NSBackwardsSearch];
            
            
            if (equalRange.location != NSNotFound) {
                
                @try{
                 
                      NSString *result_before = [str substringWithRange:NSMakeRange(0, equalRange.location)];
                      NSDate *time1 = [dateFormatter dateFromString:result_before];
                
                     [deliverySlotPickerArray addObject: @{@"time":[[delivary_slot_dic valueForKey:@"delivery"] valueForKey:[slot_keys_arr objectAtIndex:slot]],@"id":[slot_keys_arr objectAtIndex:slot],@"strt_time_to_sort":time1}];
                 }@catch(NSException *exception){
                    NSLog(@"delivery slot picker exception for time ....");
                }
            }//Close If
            
        }//close for
        
        // Sorting By Using Date
        NSSortDescriptor *descriptor=[[NSSortDescriptor alloc] initWithKey:@"strt_time_to_sort" ascending:YES];
        NSArray *descriptors=[NSArray arrayWithObject: descriptor];
        NSArray *reverseOrder=[deliverySlotPickerArray sortedArrayUsingDescriptors:descriptors];
        NSLog(@" After sorting%@",reverseOrder);
        [deliverySlotPickerArray removeAllObjects];
        [deliverySlotPickerArray addObjectsFromArray:reverseOrder];
    }
    
    // Comparing Current time with below time(API Response)
    if ([_TXT_Date.text containsString:@"Today"]) {
        
        
        

        NSDate *now = [NSDate date];
        dateFormatter.dateFormat = @"hh:mm a";
        
       //ADDING EXTRA TIME
//        NSTimeInterval secondsInEightHours = 3 * 60 * 60;
//        NSDate *datethreeHoursAhead=[now dateByAddingTimeInterval:secondsInEightHours];
//        
//        [dateFormatter setTimeZone:[NSTimeZone systemTimeZone]];
//        
//        NSLog(@"The Current Time is %@",[dateFormatter stringFromDate:now]);
//        
//        NSString *current_date = [dateFormatter stringFromDate:datethreeHoursAhead];
//        NSDate *current_time= [dateFormatter dateFromString:current_date];
         //NSLog(@"current_time After Adding time %@",[dateFormatter stringFromDate:datethreeHoursAhead]);
        
        
        // WITH OUT ADDING EXTRA TIME
 [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:str_zone]];        NSString *current_date = [dateFormatter stringFromDate:now];
        NSDate *current_time= [dateFormatter dateFromString:current_date];

        
       
        
        NSMutableArray *data_arr = [[NSMutableArray alloc]initWithArray:deliverySlotPickerArray];
        
        for (int b=0; b<deliverySlotPickerArray.count; b++) {
            
            NSString *str = [[deliverySlotPickerArray objectAtIndex:b] valueForKey:@"time"];
            NSRange equalRange = [str rangeOfString:@"-" options:NSBackwardsSearch];
            
            
            if (equalRange.location != NSNotFound) {
                
                //NSString *result_after = [str substringFromIndex:equalRange.location + equalRange.length];
                NSString *result_before = [str substringWithRange:NSMakeRange(0, equalRange.location)];
                // NSLog(@"The result%@ = %@",result_before,result_after);
                
                
                //Converting starting time into NSDate
                NSDate *time1 = [dateFormatter dateFromString:result_before];
                NSLog(@" %d::::b  %@  ------- %@",b,time1,current_time);
                
                @try {
                    NSComparisonResult result = [current_time compare:time1];
                    
                    //Comparing Starting Time with Current time
                    if(result == NSOrderedDescending)
                    {
                        NSLog(@"Current Time %@ is later than time1 %@",current_date,result_before);
                        
                        //[deliverySlotPickerArray removeObjectAtIndex:b];
                        [data_arr removeObject:[deliverySlotPickerArray objectAtIndex:b]];
                    }
                    else if (result == NSOrderedAscending){
                        
                        NSLog(@"Current Time %@ is less than time1 %@",current_date,result_before);
                    }
                    else{
                        NSLog(@"Current Time %@  time1 %@ are equal",current_date,result_before);
                    }
                } @catch (NSException *exception) {
                    NSLog(@"**********");
                }
                
                
            } else {
                NSLog(@"There is no = in the string");
            } //eof If
            
            
        }
        [deliverySlotPickerArray removeAllObjects];
        [deliverySlotPickerArray addObjectsFromArray:data_arr];
    }
    if (!deliverySlotPickerArray.count) {
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
//            [HttpClient createaAlertWithMsg:@"لا تتوفر فتحات لهذا اليوم." andTitle:@""];
            [HttpClient createaAlertWithMsg:@"لاتتوفر فترات تسليم لهذا اليوم" andTitle:@""];

        }
        else
        {
            [HttpClient createaAlertWithMsg:@"No Slots Available For This Day." andTitle:@""];
 
        }
        NSLog(@"Sorry! There is no options,Please Select Another Day" );
        [textfield resignFirstResponder];
    }else{
        [self.pickerView becomeFirstResponder];
        [self.pickerView reloadAllComponents];
    }
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)order_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"order_to_cart" sender:self];
}

- (IBAction)order_to_wishListPage:(id)sender {
    [self performSegueWithIdentifier:@"order_to_wish" sender:self];
}
#pragma mark filtering Shipping_charge,PickUpFrom_merchant_Location,Merchnat_id  paramaters for place order method

-(void)filtering_MerchantId{
    
    
    charge_ship = 0;
    for(int g=0;g<[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] count];g++)
    {
    if([[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] objectAtIndex:g] isKindOfClass:[NSDictionary class]])
    {
        
        NSString *shipChrge,*shipMethod;
        
        NSArray *keys_arr = [[[[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"] objectAtIndex:g] allKeys];
        
        NSSortDescriptor *sortDescriptor;
        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:nil
                                                     ascending:YES];
       keys_arr = [keys_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
        
        for (int k=0; k<keys_arr.count; k++) {
            
            
            @try {
                shipChrge = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[keys_arr objectAtIndex:k]] valueForKey:@"charge"]];
                
                charge_ship = charge_ship+[shipChrge floatValue];
                
              shipMethod = [NSString stringWithFormat:@"%@",[[[jsonresponse_dic valueForKey:@"shipcharge"] valueForKey:[keys_arr objectAtIndex:k]] valueForKey:@"methodid"]];
            } @catch (NSException *exception) {
            
                shipChrge = @"";
                shipMethod = @"";
                
            }
            NSDictionary *dic = @{@"mer_id":[keys_arr objectAtIndex:k],@"time":@"",@"date":@"",@"ship_chrge":shipChrge,@"ship_method":shipMethod,@"pickMethod":@"0"};
            [date_time_merId_Arr addObject:dic];
            
            
        }
    }
      [_TBL_orders reloadData];
     [self set_data_to_product_Summary_View];
    
    //Product Summary View setting Ship Charge
   // self.LBL_shipping_charge.text = [NSString stringWithFormat:@"%@ %f",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],charge_ship];
    
    NSLog(@"charge for all products %.2f %@",charge_ship,date_time_merId_Arr);
    }
}

#pragma mark order_detail_API_call

-(void)order_detail_API_call
{
    @try {
        [Helper_activity animating_images:self];
        date_time_merId_Arr = [NSMutableArray array];
        jsonresponse_dic  = [[NSMutableDictionary alloc]init];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/orderdetailsapi/%@/%@/%@/iOS.json",SERVER_URL,user_id,languge,country];
        NSLog(@"order_detail_API URL::::::%@",urlGetuser);
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                        [Helper_activity stop_activity_animation:self];
                        
                    }
                    if (data) {
                        
                        [Helper_activity stop_activity_animation:self];
                        @try {
                            
                            
                            if ([data isKindOfClass:[NSDictionary class]]) {
                               
                                jsonresponse_dic = data;
                                
                                NSLog(@"order_detail_API Response:::%@*********",data);
                                
                                
                               
                                @try {
                                    ARR_pdts = [[jsonresponse_dic valueForKey:@"data"]valueForKey:@"pdts"];
                                    if (!ARR_pdts.count) {
                                        NSLog(@" .................................");
                                        
                                        NSString *msg;
                                        NSString *ok_btn;
                                        
                                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                                            {
                                                //[HttpClient createaAlertWithMsg:@"آسف لا مزيد من المنتجات الرجاء تحديث الصفحة" andTitle:@""];
                                                msg = @"آسف لا مزيد من المنتجات، يرجى تحديث الصفحة";
                                                ok_btn = @"حسنا";
                                                
                                            }
                                            else{
                                                  msg = @"Sorry No More Products, Please Refresh the Page";
                                                ok_btn = @"OK";

                                                //[HttpClient createaAlertWithMsg:@"Sorry No More Products Please Refresh the Page" andTitle:@""];
                                            }
                                        
                                        
                                                   UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:ok_btn otherButtonTitles:nil, nil];
                                                   alert.tag = 3;
                                                   [alert show];
                                        
                                        
                                    }
                                    
                            } @catch (NSException *exception) {
                                    NSLog(@"Excepton In Order Details API %@",exception);
                                }
                                
                                
                                [self filtering_MerchantId];
                                [self Shipp_address_API];
                                [self set_UP_VIEW];
                                // [self next_page];
                                
                                
                                
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read It is not in correct format" andTitle:@""];
                            }
                            
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                            
                            
                        }
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
        }
    } @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
        
        
        
    }
}

#pragma mark Shipp_address_API_Call

-(void)Shipp_address_API
{
    @try {
        
        [Helper_activity animating_images:self];
        jsonresponse_dic_address = [[NSMutableDictionary alloc]init];
        
        //isAddClicked = NO;
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressessapi/%@/%@/%@.json",SERVER_URL,user_id,country,languge];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [Helper_activity stop_activity_animation:self];
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        
                        [Helper_activity stop_activity_animation:self];
                        
                        @try {
                            
                            
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                jsonresponse_dic_address = data;
                                [self radioButton_values];
                                [self set_DATA];
                                [_TBL_address reloadData];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        NSLog(@"Shipp_address_API:::%@*********",data);
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
        }
        
       
    }
    @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];

        NSLog(@"%@",exception);
    }
    
}


#pragma mark updating_cart_API
/*
 Update cart
 apis/updatecartapi.json
 Parameters :
 {quantity=1, merchantId=6, customerId=6, subttl=1050.0, productId=10}
 
 Method : POST
 
 
 */

-(void)updating_cart_List_api:(NSString *)sbttl{
    
    
    @try {
        
        [Helper_activity animating_images:self];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
        
       
        
        NSDictionary *parameters = @{@"productId":product_id,@"customerId":custmr_id,@"quantity":item_count,@"merchantId":merchent_id,@"subttl":sbttl};
        
        
        NSLog(@"******************** %@",parameters);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/updateqtycheckoutapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        
        [HttpClient api_with_post_params:urlGetuser andParams:parameters completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"%@",data);
                     [Helper_activity stop_activity_animation:self];
                    @try {
                        if ([[NSString stringWithFormat:@"%@",[data valueForKey:@"success"]] isEqualToString:@"1"]) {
                            [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                            [self order_detail_API_call];
                        }
                        else{
                            [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                        }
                    
                    } @catch (NSException *exception) {
                        NSLog(@"exception:: %@",exception);
                    }
                    
                    
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        
         [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
    }
    
}
#pragma mark Delivary_slot_API

-(void)delivary_slot_API{
    
    @try {
        
        
        [Helper_activity animating_images:self];
        delivary_slot_dic = [[NSMutableDictionary alloc]init];
        deliverySlotPickerArray = [NSMutableArray array];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/deliveryslotapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    
                    @try {
                        NSLog(@"%@",data);
                       
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            [delivary_slot_dic addEntriesFromDictionary:data];
                            
                        }
                        
                    } @catch (NSException *exception) {
                        
                        
                    }
                    
                  [Helper_activity stop_activity_animation:self];
                }
                
            });
        }];
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
         [Helper_activity stop_activity_animation:self];
    }
//    VW_overlay.hidden = YES;
//    [activityIndicatorView stopAnimating];
}
#pragma mark CountryAPI Call
//http://192.168.0.171/dohasooq/'apis/countriesapi.json
-(void)CountryAPICall{
    @try {
        
         [Helper_activity animating_images:self];
        
        response_countries_dic = [NSMutableDictionary dictionary];
         NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/countriesapi/%@.json",SERVER_URL,country];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                         [Helper_activity stop_activity_animation:self];
                        
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        @try {
                            if ([data isKindOfClass:[NSArray class]]) {
                                [countryStatesArray removeAllObjects];
                                NSLog(@".............%@",data);
                                [countryStatesArray addObjectsFromArray:data];
                                
                                [_staes_country_pickr reloadAllComponents];
                                
                               
                                NSLog(@"%@",countryStatesArray);
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                     [Helper_activity stop_activity_animation:self];
                    
                });
                
            }];
        } @catch (NSException *exception) {
             [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
         [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
    }
   
    
}

#pragma mark Shipping Country API Call (For Shipping Address)


-(void)ShippingCountryAPICall{
    //http://localhost/dohasooq/apis/countiresShipapi.json
    
    
    @try {
        
        shipping_Countries_array = [NSMutableArray array];
        [Helper_activity animating_images:self];
        
         response_countries_dic = [NSMutableDictionary dictionary];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/countiresShipapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    
                    @try {
                        NSLog(@"%@",data);
                        
                        if ([data isKindOfClass:[NSArray class]]) {
                           
                            [shipping_Countries_array removeAllObjects];
                            
                            
                            [shipping_Countries_array addObjectsFromArray:data];
                            
                        [_shipping_PickerView reloadAllComponents];

                        }
                        
                    } @catch (NSException *exception) {
                        
                        
                    }
                    
                    [Helper_activity stop_activity_animation:self];
                }
                
            });
        }];
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        [Helper_activity stop_activity_animation:self];
    }

    
}





#pragma mark StateAPI Call

//http://192.168.0.171/dohasooq/'apis/getstatebyconapi/countryid.json
-(void)stateApiCall{
    
    @try {
        
        
//        arr_states = [NSMutableArray array];
        NSLog(@"%ld",(long)cntry_ID);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/getstatebyconapi/%ld.json",SERVER_URL,(long)cntry_ID];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [Helper_activity animating_images:self];
            
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                        [Helper_activity stop_activity_animation:self];
                    }
                    if (data) {
                        [Helper_activity stop_activity_animation:self];
                        @try {
                            if ([data isKindOfClass:[NSArray class]]) {
                               // [arr_states addObjectsFromArray:data];
                                [countryStatesArray removeAllObjects];
                                
                                [countryStatesArray addObjectsFromArray:data];
                                
                                [_staes_country_pickr reloadAllComponents];
                                
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            [Helper_activity stop_activity_animation:self];
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
         [Helper_activity stop_activity_animation:self];
        
    }
   
    
}




#pragma mark UIPickerViewDelegate and UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (pickerView == _staes_country_pickr) {
        return countryStatesArray.count;
    }
    else if (pickerView == _country_code_Pickerview){
        return phone_code_arr.count;
    }
    else if (pickerView == _shipping_PickerView){
        return  shipping_Countries_array.count;
    }
    
    
    else{
        return deliverySlotPickerArray.count;
    }
    
    
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == _staes_country_pickr) {
        
        if (isCountrySelected) {
            return [[countryStatesArray objectAtIndex:row] valueForKey:@"name"];
        }
        else{
            
            return [[countryStatesArray objectAtIndex:row] valueForKey:@"value"];
        }
    }
    else if (pickerView == _shipping_PickerView){ // Shipping Address Country
        
        
        return [[shipping_Countries_array objectAtIndex:row] valueForKey:@"name"];
    }

    else if (pickerView ==_country_code_Pickerview){
       
        @try {
              return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"code"]];
            
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
        
        }
    else{
          if (is_Txt_date) {
        return [[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"key2"];
          }
          else{
              return  [[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"time"];
          }
    }
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    isPickerViewScrolled = YES;
    
    [self PickerCustomSelection:row];
    
  /*  if (pickerView == _country_code_Pickerview) {
        
        flag = [NSString stringWithFormat:@"%@ ",[phone_code_arr[row] valueForKey:@"code"]];
    }
    
    else if (pickerView == _shipping_PickerView){    // For Shipping Address
      
        @try {
            _TXT_ship_country.text = [[shipping_Countries_array objectAtIndex:row] valueForKey:@"cntry_name"];
            cntry_ID = [[[shipping_Countries_array objectAtIndex:row] valueForKey:@"cntry_id"] integerValue];
            ship_cntry_ID = [[shipping_Countries_array objectAtIndex:row] valueForKey:@"cntry_id"];
            _TXT_ship_state.text = nil;
        } @catch (NSException *exception) {
            NSLog(@"Selection of Shipping Country");
        }
        
    }
    if (pickerView == _pickerView) {
        
        @try {
            if (is_Txt_date) {
                _TXT_Date.text = [[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"key2"];
                date_str = [NSString stringWithFormat:@"%@",[[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"key3"]];
                _TXT_Time.text = nil;
                _TXT_Time.placeholder = @"Select Time";
                
            }
            else{
                _TXT_Time.text = [[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"time"];
                time_str = [NSString stringWithFormat:@"%@",[[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"id"]];
                
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
    }
    if (pickerView == _staes_country_pickr) {
        
        if (isCountrySelected) {
            @try {
                
                cntry_selection = [[countryStatesArray objectAtIndex:row] valueForKey:@"cntry_name"];
                    cntry_ID = [[[countryStatesArray objectAtIndex:row] valueForKey:@"cntry_id"] integerValue];
                state_selection = @"";
                
                if (select_blng_ctry_state) {
                    _TXT_state.text = nil;
                    blng_cntry_ID = [[countryStatesArray objectAtIndex:row] valueForKey:@"cntry_id"];
                }

                
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        else{
            @try {
                state_selection = [[countryStatesArray objectAtIndex:row] valueForKey:@"value"];
                
                if (select_blng_ctry_state) {
                    blng_state_ID = [[countryStatesArray objectAtIndex:row] valueForKey:@"key"];
                }
                else{
                    ship_state_ID = [[countryStatesArray objectAtIndex:row] valueForKey:@"key"];
                }
                
            } @catch (NSException *exception) {
                state_selection = @"";
            }
            
        }
    }
*/
}
-(void)PickerCustomSelection:(NSInteger )row{
 //*********************************  Delivary Slot Picker Related *********************************
    if ([pickerSelection isEqualToString:@"TimeSlot"]) {
        @try {
            if (is_Txt_date) {
                _TXT_Date.text = [[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"key2"];
                date_str = [NSString stringWithFormat:@"%@",[[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"key3"]];
                _TXT_Time.text = nil;
                //_TXT_Time.placeholder = @"Select Time";
                
            }
            else{
                _TXT_Time.text = [[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"time"];
                time_str = [NSString stringWithFormat:@"%@",[[deliverySlotPickerArray objectAtIndex:row] valueForKey:@"id"]];
                
            }
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    }
//*********************************  States And Country Picker Related *********************************

    else if ([pickerSelection isEqualToString:@"StatesAndCountry"]){
        
        if (isCountrySelected) {
            @try {
                
                cntry_selection = [[countryStatesArray objectAtIndex:row] valueForKey:@"name"];
                cntry_ID = [[[countryStatesArray objectAtIndex:row] valueForKey:@"id"] integerValue];
                state_selection = @"";
                
                if (select_blng_ctry_state) {
                    
                    if (![blng_cntry_ID isEqualToString:[NSString stringWithFormat:@"%@",[[countryStatesArray objectAtIndex:row] valueForKey:@"id"]]]) {
                        _TXT_state.text = nil;
                        blng_cntry_ID = [NSString stringWithFormat:@"%@",[[countryStatesArray objectAtIndex:row] valueForKey:@"id"]];
                    }
                   
                }
                
                
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        else{
            @try {
                state_selection = [[countryStatesArray objectAtIndex:row] valueForKey:@"value"];
                
                if (select_blng_ctry_state) {
                    blng_state_ID = [[countryStatesArray objectAtIndex:row] valueForKey:@"key"];
                }
                else{
                    ship_state_ID = [[countryStatesArray objectAtIndex:row] valueForKey:@"key"];
                }
                
            } @catch (NSException *exception) {
                state_selection = @"";
            }
            
        }

        
    }
    //*********************************  For Shipping Country Picker Related *********************************
    
    else if ([pickerSelection isEqualToString:@"Shipping"]){     //For Shipping Country
       
        @try {
            
            _TXT_ship_country.text = [[shipping_Countries_array objectAtIndex:row] valueForKey:@"name"];
            cntry_ID = [[[shipping_Countries_array objectAtIndex:row] valueForKey:@"id"] integerValue];
            ship_cntry_ID = [NSString stringWithFormat:@"%@",[[shipping_Countries_array objectAtIndex:row] valueForKey:@"id"]];
            
            state_selection = @"";
            _TXT_ship_state.text = nil;
            
        } @catch (NSException *exception) {
            
            NSLog(@"Selection of Shipping Country %@",exception);
        }
        
    }
//*********************************  For Phone Code Picker Related *********************************
    
    else if ([pickerSelection isEqualToString:@"Phone"]){
        
        @try {
            flag = [NSString stringWithFormat:@"%@ ",[phone_code_arr[row] valueForKey:@"code"]];
        } @catch (NSException *exception) {
            NSLog(@"Phone Code ::%@",exception);
        }
        
  
    }
    
}



#pragma mark picker_done_btn_action
-(void)picker_done_btn_action:(id)sender{
    
    if (!isPickerViewScrolled) {
        [self PickerCustomSelection:0];
    }
    
    
    [self.view endEditing:YES];
    
    //[textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}
#pragma mark picker_close_action
-(void)picker_close_action{
    [self.view endEditing:YES];
}



#pragma mark Payment method API Types

-(void)payment_methods_API{
    
    @try {
        
        
        [Helper_activity animating_images:self];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/paymentmethapi.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [Helper_activity stop_activity_animation:self];
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        [Helper_activity stop_activity_animation:self];
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                NSLog(@"Payment Methods %@",data);
                                
                         // Checking Cash on Delivary is Available or Not
                              //////////////
                               if (isCash_on_delivary) {
                                    _BTN_cod.hidden = NO;
                                    _LBL_cash_on_Delivary.hidden = NO;

                                   
                                }
                                else{
                                    _BTN_cod.hidden = YES;
                                    _LBL_cash_on_Delivary.hidden = YES;

                                     //_LBL_cash_on_Delivary.hidden = YES;
                                }
                               
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
    }
    
}

#pragma mark Apply apply_promo_Code  API
/*Applycoupon
 Function Name : apis/applycouponapi.json
 Parameters :customerId,couponcode,subtotal,country_id
 Method : GET*/
-(void)apply_promo_Code{
    
    
    @try {
        
        NSString *ctr_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        [Helper_activity animating_images:self];
        NSString *sub_total = [NSString stringWithFormat:@"%@",[jsonresponse_dic valueForKey:@"subsum"]];
        sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
        
        NSString *prome_value = [NSString stringWithFormat:@"%@",self.TXT_cupon.text];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/applycouponapi/%@/%@/%@/%@.json",SERVER_URL, [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],prome_value,sub_total,ctr_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        [Helper_activity stop_activity_animation:self];
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        [Helper_activity stop_activity_animation:self];
                        @try {
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                
                                NSLog(@"%@",data);

                                if ([[NSString stringWithFormat:@"%@",[data valueForKey:@"success"]] isEqualToString:@"1"]) {
                                    
                                    float   promo_discount_value = [[data valueForKey:@"discountamount"] floatValue];
                                    
                                    total = [[data valueForKey:@"afterdiscount"] floatValue];
                                    
                                    total = total +charge_ship;
                                    
                                    promo_codeStr =prome_value;
                                    
                                    // Updating Data In Labels After PromoCode
                                    [self after_applying_PromoCodeDiscount:promo_discount_value andTotalAmountAfterDiscount:total];
                                    
                                    _TXT_cupon.text=nil;
                                    
//                                    [HttpClient createaAlertWithMsg:arabicLabels.cuponInvalid andTitle:@"Cupon Alert"];
    
                                   [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];                                }
                                
                                else{
                                    promo_codeStr = @"";
                                  [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                                     // [HttpClient createaAlertWithMsg:arabicLabels.cuponInvalid andTitle:@"Cupon Alert"];
                                    
                                    
                                    
                                }
                            
                                
                               
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            [Helper_activity stop_activity_animation:self];
            NSLog(@"%@",exception);
        }
       
    } @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",exception);
    }
   
    
}

#pragma mark After Applying Promo Code
-(void)after_applying_PromoCodeDiscount:(float )discount_amount andTotalAmountAfterDiscount:(float )totalAmt{
   
    self.title_Discount.hidden = NO;
    _LBL_Promo_discount.hidden = NO;
    
    @try {
    
    
    NSString *discount = [HttpClient currency_seperator: [NSString stringWithFormat:@"%.2f",discount_amount]];
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
        
        self.LBL_Promo_discount.text = [NSString stringWithFormat:@"-%@ %@",discount,[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        }
        else{
              self.LBL_Promo_discount.text = [NSString stringWithFormat:@"%@ -%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],discount];
        }
    
    [self fill_value_to_Lbl_product_summary:@" "];
    
    [self LBl_dohamilesAndTotalAmount:total];
    
    } @catch (NSException *exception) {
        NSLog(@"After Applying PromoCode %@", exception);
    }
    
}

#pragma mark validatingTextField

-(void)validatingTextField
{
   
    
    [Helper_activity animating_images:self];
    
    
    
    NSString *msg;
    _TXT_Cntry_code.text = [_TXT_Cntry_code.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if ([_TXT_fname.text isEqualToString:@""])
    {
        [_TXT_fname becomeFirstResponder];
      
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى تعبئة حقل الاسم الأول";
        }
        else{
              msg = @"Please Enter First Name field";
        }
        
    }
    else if(_TXT_fname.text.length < 3 )
    {
        [_TXT_fname becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يقل الاسم الأول عن 3 حروف";
        }
        else{
            msg = @"First Name should not be less than 3 characters";

        }
    }
    else if(_TXT_fname.text.length >30)
    {
        [_TXT_fname becomeFirstResponder];
      
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يزيد الاسم الأول عن 30 حرفاً";
        }
        else{
              msg = @"First name should not be more than 30 characters";
        }
        
    }
    else if ([_TXT_lname.text isEqualToString:@""])
    {
        [_TXT_lname becomeFirstResponder];
      
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى تعبئة حقل الاسم الأخير ";
        }
        else{
              msg = @"Please Enter Last Name field";
        }
        
    }
    else if(_TXT_lname.text.length < 1)
    {
        [_TXT_lname becomeFirstResponder];
       
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"الكنية ألا يقل الاسم الأول عن 1 حروف";
        }else{
             msg = @"Last Name should not be less than 1 character";
        }
        
        
    }
    else if(_TXT_lname.text.length >30)
    {
        [_TXT_lname becomeFirstResponder];
       
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"ألا يزيد اسم العائلة عن 30 حرفا";
        }else{
             msg = @"Last name should not be more than 30 characters";
        }
        
        
    }
    
    else if([_TXT_addr1.text isEqualToString:@""])
    {
        [_TXT_addr1 becomeFirstResponder];
       
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب  1 عدم ترك حقل العنوان فارغا";
        }else{
             msg = @"Address1 Should Not be Empty";
        }
        
    }
    else if(_TXT_addr1.text.length > 200)
    {
        [_TXT_addr1 becomeFirstResponder];
      
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يزيد العنوان عن 200 رمز";
        }else{
              msg = @"Address should not be more than 200 characters";
        }
        
        
    }
    else if([_TXT_city.text isEqualToString:@""])
    {
        [_TXT_city becomeFirstResponder];
       
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب عدم إبقاء خانة المدينة خالية ";
        }
        else{
             msg = @"City Should Not be Empty";
        }
        
        
    }
    else if (_TXT_city.text.length < 3)
    {
        [_TXT_city becomeFirstResponder];
              if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يقل حقل المدينة عن 3 أحرف";
        }else{
            msg = @"City should not be less than 3 characters";

        }
        
    }
    else if (_TXT_city.text.length > 30)
    {
        [_TXT_city becomeFirstResponder];
      
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يزيد حقل المدينة عن 30 حرفاً";
        }
        else{
              msg = @"City should not be more than 30 characters";
        }
        
    }
   
    else if([_TXT_country.text isEqualToString:@""])
    {
        [_TXT_country becomeFirstResponder];
               if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى تحديد البلد";
        } else{
                   msg = @"Please Select Country";

               }
        
    }
    else if([_TXT_state.text isEqualToString:@""])
    {
        [_TXT_state becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg =@"يرجى تحديد الولاية";
        }
        else{
            msg = @"Please Select State";//يرجى تحديد البلد

        }
        
    }
    else if ([_TXT_phone.text isEqualToString:@""])
    {
        [_TXT_phone becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
        msg = @"رقم الهاتف ترك حقل المدينة فارغاً";
        }else{
             msg = @"Please Enter Phone Number";
        }
        
        
    }
    else if([_TXT_Cntry_code.text  isEqualToString:@"+974"])
    {
        if (_TXT_phone.text.length < 8)
        {
            [_TXT_phone becomeFirstResponder];
           if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg =@"رقم الهاتف لا يمكن أن يكون أقل من 8 أرقام ";
                
            }
        else{
                  msg = @"Phone Number cannot be less than 8 digits";

            }
        
        }
        else if(_TXT_phone.text.length > 8)
        {
            [self.TXT_phone becomeFirstResponder];
            
           
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"رقم الهاتف لا يمكن أن يكون أكثر من 8 أرقام";
                ;
            }
            else{
                 msg = @"Phone Number cannot be more than 8 digits";
            }
        }
        
        
    }
    else
    {
        if (_TXT_phone.text.length < 5)
        {
            [_TXT_phone becomeFirstResponder];
          
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg =@"رقم الهاتف لا يمكن أن يكون أقل من 5 أرقام ";
            }
            else{
                  msg = @"Phone Number cannot be less than 5 digits";
            }
            
            
        }
        else if(_TXT_phone.text.length>15)
        {
            [_TXT_phone becomeFirstResponder];
           
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"لا يجب أن يتجاوز رقم الهاتف 15 أرقام";
            }
            else{
                 msg = @"Phone Number cannot be more than 15 digits";
            }
            
        }
        
        if([_TXT_phone.text isEqualToString:@" "])
        {
            [_TXT_phone becomeFirstResponder];
             if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"رقم الهاتف ترك حقل المدينة فارغاً";
            }
             else{
                 msg = @"Phone Number  Should Not be Empty";

             }
            
            
        }
    }
    if ([_TXT_Cntry_code.text isEqualToString:@""])
    {
        [_TXT_Cntry_code becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"رمز البلد ورقم الهاتف مطلوبين";
        }
        else{
            msg = @"Country Code and Phone Number is required";

        }
        
    }

    
// Validating Shipping Address
    
    if (_VW_SHIIPING_ADDRESS.hidden == NO )
    {
        
        _TXT_ship_cntry_code.text = [_TXT_ship_cntry_code.text stringByReplacingOccurrencesOfString:@" " withString:@""];
        
        if ([_TXT_ship_fname.text isEqualToString:@""])
        {
            [_TXT_ship_fname becomeFirstResponder];
          
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يرجى تعبئة حقل الاسم الأول";
            }
            else{
                  msg = @"Please Enter First Name field";
            }
            
        }
        else if(_TXT_ship_fname.text.length < 3)
        {
            [_TXT_ship_fname becomeFirstResponder];
              if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يقل الاسم الأول عن 3 حروف";
            }
              else{
                  msg = @"First Name should not be less than 3 characters";

              }
            
        }
        else if(_TXT_ship_fname.text.length > 30)
        {
            [_TXT_ship_fname becomeFirstResponder];
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يزيد الاسم الأول عن 30 حرفاً";
            }
            else{
                msg = @"First name should not be more than 30 characters";

            }
            
        }
        else if ([_TXT_ship_lname.text isEqualToString:@""])
        {
            [_TXT_ship_lname becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يرجى تعبئة حقل الاسم الأخير ";
            }
            else{
                msg = @"Please Enter Last Name field";

            }
        }
        else if(_TXT_ship_lname.text.length < 1)
        {
            [_TXT_ship_lname becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"الكنية ألا يقل الاسم الأول عن 1 حروف";
            }
            else{
                msg = @"Last name should not be less than 1 characters";

            }
        }
        else if(_TXT_ship_lname.text.length>30)
        {
            [_TXT_ship_lname becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"ألا يزيد اسم العائلة عن 30 حرفا";
            }
            else{
                msg = @"Last name should not be more than 30 characters";

            }
            
            
        }
        else if([_TXT_ship_addr1.text isEqualToString:@""])
        {
            [_TXT_ship_addr1 becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب  1 عدم ترك حقل العنوان فارغا";
            }
            else{
                msg = @"Address1 Should Not be Empty";

            }
        }
        else if(_TXT_ship_addr1.text.length < 3)
        {
            [_TXT_ship_addr1 becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب1 ألا يقل العنوان عن 10 رموز";
            }
            else{
                msg = @"Address1 should not be less than 3characters";

            }
            
        }
        
        else if(_TXT_ship_addr1.text.length > 200)
        {
            [_TXT_ship_addr1 becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يزيد العنوان عن 200 رمز";
            }
            else{
                msg = @"Address should not be more than 200 characters";

            }
            
        }
        else if([_TXT_ship_city.text isEqualToString:@""])
        {
            [_TXT_ship_city becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب عدم ترك حقل المدينة فارغاً";
            }
            else{
                msg = @"City Should Not be Empty";

            }
            
        }
        else if (_TXT_ship_city.text.length < 3)
        {
            [_TXT_ship_city becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يقل حقل المدينة عن 3 أحرف";
            }else{
                msg = @"City should not be less than 3 characters";

            }
            
        }
        else if (_TXT_ship_city.text.length > 30)
        {
            [_TXT_ship_city becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب ألا يزيد حقل المدينة عن 30 حرفاً";
            }
            else{
                msg = @"City should not be more than 30 characters";

            }
            
        }
        
        else if([_TXT_ship_state.text isEqualToString:@""])
        {
            [_TXT_ship_state becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
               msg = @"يرجى تحديد الولاية";
            }
            else{
                msg = @"Please Select State";//يرجى تحديد البلد

            }
            
            
        }
        else if([_TXT_ship_country.text isEqualToString:@""])
        {
            [_TXT_ship_country becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يرجى تحديد البلد";
            }
            else{
                msg = @"Please Select Country";

            }
            
            
        }
        else if(![_TXT_ship_country.text isEqualToString:@"Qatar"])
        {
            [_TXT_ship_country becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"عذراً، لا يمكننا شحن هذه المنتجات خارج قطر";
                
            }
            else{
                msg = @"Sorry We cannot ship products Outside of Qatar ";

            }
            
            
        }
        
//      else if(![ship_cntry_ID isEqualToString:@"173"])
//        {
//            NSString *mesagesg = @"Sorry we cannot ship products out side Qatar, Please enter different shipping address to proceed";
//            
//            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//            {
//                msg = @"عذراً، لا يمكننا شحن هذه المنتجات خارج قطر,للاستمرار، يرجى إدخال عنوان آخر للتسليم ";
//                
//                
//            }
//            
//            
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:mesagesg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            alert.tag = 2;
//            [alert show];
//            
//        }
        else if ([_TXT_ship_phone.text isEqualToString:@""])
        {
            [_TXT_ship_phone becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"رقم الهاتف ترك حقل المدينة فارغاً";
            }
            else{
                msg = @"Phone Number  Should Not be Empty";

            }
        }
        else if([_TXT_ship_cntry_code.text  isEqualToString:@"+974"])
        {
            if  (_TXT_ship_phone.text.length < 8)
            {
                [_TXT_ship_phone becomeFirstResponder];
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    msg = @"لا يجب ألا يقلّ رقم الجوال عن 8 أرقام ";
                }
                else{
                    msg = @"Phone Number cannot be less than 8 digits";

                }
                
                
                
            }
            else if(_TXT_ship_phone.text.length > 8)
            {
                [self.TXT_phone becomeFirstResponder];
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    msg = @"رقم الهاتف لا يمكن أن يكون أكثر من 8 أرقام";
                }
                else{
                    msg = @"Phone Number cannot be more than 8 digits";

                }
            }
        }
        else
        {
            
            if (_TXT_ship_phone.text.length < 5)
            {
                
                [_TXT_ship_phone becomeFirstResponder];
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    msg = @"لا يجب ألا يقلّ رقم الجوال عن 5 أرقام ";
                }
                else{
                    msg = @"Phone Number cannot be less than 5 digits";

                }
               
            }
            else if(_TXT_ship_phone.text.length > 15)
            {
                [_TXT_ship_phone becomeFirstResponder];
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    msg = @"لا يجب أن يتجاوز رقم الهاتف 15 أرقام";
                }
                else{
                    msg = @"Phone Number cannot be more than 15 digits";

                }
                
            }
            
        }
        if ([_TXT_ship_cntry_code.text isEqualToString:@""])
        {
            [_TXT_ship_cntry_code becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"رمز البلد ورقم الهاتف مطلوبين";
            }
            else{
                msg = @"Country Code and Phone Number is required";

            }
            
            
        }
        
        
    }
    
    if(msg)
    {
        [HttpClient createaAlertWithMsg:msg andTitle:@""];
        
    }
    
    else{
        if(![blng_cntry_ID isEqualToString:ship_cntry_ID] && [billcheck_clicked isEqualToString:@"0"])
        {
            NSString *mesagesg ;
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                mesagesg = @"عذراً، لا يمكننا شحن هذه المنتجات خارج قطر,للاستمرار، يرجى إدخال عنوان آخر للتسليم ";
                
                
            }
            else{
                mesagesg = @"Sorry we cannot ship products out side Qatar, Please enter different shipping address to proceed";
            }
            
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:mesagesg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            alert.tag = 2;
            [alert show];
            
        }
        else{
            _VW_pay_cards.hidden = NO;
            _Scroll_card.hidden = NO;
            [self move_to_payment_types];
        }
    }
    
    [Helper_activity stop_activity_animation:self];
    
}
#pragma mark radioButton Actions
// Payment Type Radio Buttons Setting
-(void)credit_cerd_action
{
    
    if(_BTN_credit.tag == 1)
    {
         payment_type_str = @"1";
        [_BTN_credit setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_credit.tag = 0;
        
    }
    else
    {
         payment_type_str = @"0";
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_credit.tag = 1;
        _BTN_debit_card.tag = 1;
        _BTN_doha_bank_account.tag = 1;
        _BTN_doha_miles.tag = 1;
        _BTN_cod.tag = 1;
        
    }

    
}
-(void)debit_card_action
{
    
    
    if(_BTN_debit_card.tag == 1)
    {
        payment_type_str = @"2";
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_debit_card.tag = 0;
        
    }
    else
    {
         payment_type_str = @"0";
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_debit_card.tag = 1;
        _BTN_credit.tag = 1;
        _BTN_doha_bank_account.tag = 1;
        _BTN_doha_miles.tag = 1;
        _BTN_cod.tag = 1;
        
    }

    
}
-(void)doha_bank_action
{
    
    
    payment_type_str = @"3";
    if(_BTN_doha_bank_account.tag == 1)
    {
          payment_type_str = @"3";
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_doha_bank_account.tag = 0;
        
    }
    else
    {
         payment_type_str = @"0";
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_doha_bank_account.tag = 1;
        _BTN_debit_card.tag = 1;
        _BTN_credit.tag = 1;
        _BTN_doha_miles.tag = 1;
        _BTN_cod.tag = 1;
        
        
        
    }
 
}

-(void)doha_miles_action
{
    
    
   
    if(_BTN_doha_miles.tag == 1)
    {
         payment_type_str = @"4";
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_cod setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_doha_miles.tag = 0;
        
    }
    else
    {
         payment_type_str = @"0";
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_doha_miles.tag = 1;
        _BTN_doha_bank_account.tag = 1;
        _BTN_debit_card.tag = 1;
        _BTN_credit.tag = 1;
        _BTN_cod.tag = 1;
        
    }

}
-(void)cod_action
{
    if(_BTN_cod.tag == 1)
    {
        payment_type_str = @"5";
        [_BTN_cod setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_credit setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_debit_card setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_doha_bank_account setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_doha_miles setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_cod.tag = 0;
        
    }
    else
    {
        payment_type_str = @"0";

        [_BTN_cod setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_cod.tag = 1;
        _BTN_doha_miles.tag = 1;
        _BTN_doha_bank_account.tag = 1;
        _BTN_debit_card.tag = 1;
        _BTN_credit.tag = 1;
        
    }

}

#pragma mark Place Order API Grouping Parameters for Integration

-(void)place_oredr_parameters_parsing{
    @try {
        
       
        
        [Helper_activity animating_images:self];
        
        //Special Instruction
        NSString *SpecialInstruction = _TXT_instructions.text;
        if ([SpecialInstruction isEqualToString:@""]) {
            SpecialInstruction = @"";
        }
        NSDictionary *special_instr_dic=@{@"SpecialInstruction":SpecialInstruction};
        
        NSData *data = [NSJSONSerialization dataWithJSONObject:special_instr_dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *SpecialInstruction_str = [[NSString alloc] initWithData:data
                                                                encoding:NSUTF8StringEncoding];
        
        //order_mode
         NSDictionary *order_mode_dic=@{@"order_mode":@"Iphone"};
        
        data = [NSJSONSerialization dataWithJSONObject:order_mode_dic options:NSJSONWritingPrettyPrinted error:nil];
        NSString *order_mode_str = [[NSString alloc] initWithData:data
                                                                 encoding:NSUTF8StringEncoding];
        
        
        
        NSString *ctry_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *lan_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        
        //language_id
        
        
        NSString *sub_total = [NSString stringWithFormat:@"%.2f",total];
        
        sub_total = [sub_total stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
        
        NSDictionary *Formpaymenthidden;
        @try {
            
           NSString*language_code =  [[NSUserDefaults standardUserDefaults] valueForKey:@"code_language"];
            if ([language_code isKindOfClass:[NSNull class]]|| [language_code isEqualToString:@""]|| language_code == nil) {
                language_code = @"en";
            }
            
            //Formpaymenthidden = @{@"amount":sub_total,@"locale":@"en",@"version":@"1"};
            Formpaymenthidden = @{@"amount":sub_total,@"locale":language_code,@"version":@"1"};

            
        } @catch (NSException *exception) {
            
        }
        
        data = [NSJSONSerialization dataWithJSONObject:Formpaymenthidden options:NSJSONWritingPrettyPrinted error:nil];
        NSString *Formpaymenthidden_str = [[NSString alloc] initWithData:data
                                                                encoding:NSUTF8StringEncoding];
        
        
        //        NSDictionary *params = @{@"b_user_firstname":@"",@"b_user_lastname":@"",@"b_user_address1":@"",@"b_user_address2":@"",@"b_user_city":@"",@"b_user_zip_code":@"",@"b_user_phone":@"",@"b_user_country":@"",@"b_user_state":@""};
        
        /*Formshipping = {
         "FirstName1": "Venu",
         "LastName1": "Reddy",
         "address11": "Doha",
         "address12": "",
         "city1": "Doha",
         "state": "15",
         "country": "1",
         "phone1": "9742803092",
         "zipcode1": "34567"
         }*/
        
        NSString *fname,*lname,*addr1,*addr2,*city,*state,*zip_code,*country,*phone,*str_code;
        
        fname =_TXT_fname.text;
        lname = _TXT_lname.text;
        addr1 =_TXT_addr1.text;
        addr2 = _TXT_addr2.text;
        city =_TXT_city.text;
        state = blng_state_ID;
        zip_code = _TXT_zip.text;
        country = blng_cntry_ID;
        phone = _TXT_phone.text;
        str_code = _TXT_Cntry_code.text;
        
        str_code = [str_code stringByReplacingOccurrencesOfString:@"+" withString:@""];
        
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *str_id = @"user_id";
        NSString *user_id;
        for(int h = 0;h<[[dict allKeys] count];h++)
        {
            if([[[dict allKeys] objectAtIndex:h] isEqualToString:str_id])
            {
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                break;
            }
            else
            {
                
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            }
            
        }
        
        
        
        NSDictionary *FormBilling;
        @try {
            FormBilling = @{@"FirstName":fname,@"LastName":lname,@"address1":addr1,@"address2":addr2,@"city":city,@"state":state,@"country":country,@"phone":phone,@"phonecode":str_code,@"zipcode":zip_code,@"userId":user_id};
        } @catch (NSException *exception) {
            
        }
        
        
        data = [NSJSONSerialization dataWithJSONObject:FormBilling options:NSJSONWritingPrettyPrinted error:nil];
        NSString *form_billing_str = [[NSString alloc] initWithData:data
                                                           encoding:NSUTF8StringEncoding];
        
        
      
        
        NSDictionary *Formshipping;
        if ([billcheck_clicked isEqualToString:@"0"] && [blng_cntry_ID isEqualToString:ship_cntry_ID]) {
            
            
            @try {
                
                Formshipping = @{@"FirstName1":fname,@"LastName1":lname,@"address11":addr1,@"address12":addr2,@"city1":city,@"state":state,@"country":country,@"phone1":phone,@"zipcode1":zip_code,@"phonecode":str_code,@"newaddressinput":newaddressinput};
            } @catch (NSException *exception) {
                
            }
            
        }
        else{
            
            @try {
                fname =_TXT_ship_fname.text;
                lname = _TXT_ship_lname.text;
                addr1 =_TXT_ship_addr1.text;
                addr2 = _TXT_ship_addr2.text;
                city =_TXT_ship_city.text;
                state = ship_state_ID;
                zip_code = _TXT_ship_zip.text;
                country = ship_cntry_ID;
                phone = _TXT_ship_phone.text;
                str_code = _TXT_ship_cntry_code.text;
                str_code = [str_code stringByReplacingOccurrencesOfString:@"+" withString:@""];
                
                Formshipping = @{@"FirstName1":fname,@"LastName1":lname,@"address11":addr1,@"address12":addr2,@"city1":city,@"state":state,@"country":country,@"phone1":phone,@"zipcode1":zip_code,@"phonecode":str_code,@"newaddressinput":newaddressinput};
            } @catch (NSException *exception) {
                
            }
            
            
            
        }
        
        ///NSLog(@"..............%@",[[NSDictionary alloc]initWithDictionary:Formshipping copyItems:YES]);
        
        
        data = [NSJSONSerialization dataWithJSONObject:Formshipping options:NSJSONWritingPrettyPrinted error:nil];
        NSString *form_shipping_str = [[NSString alloc] initWithData:data
                                                            encoding:NSUTF8StringEncoding];
        
        
        
        
        // NSLog(@"THe single string:Form shipping%@",[form_arr componentsJoinedByString:@","]);
        
        
        
        
        /* FormBilling = {
         "FirstName": "Venu",
         "LastName": "Reddy",
         "address1": "Doha",
         "address2": "",
         "city": "Doha",
         "state": "15",
         "country": "1",
         "phone": "9742803092",
         "zipcode": "34567",
         "userId": "17"
         },
         */
        
        
        // Ship charge , ship method ,time and Date
        NSString *shiip_charge,*ship_method,*deliveydate,*deliveytime,*pickMethod;
        
        
        @try {
            
            if (date_time_merId_Arr.count != 0) {
                if ([[date_time_merId_Arr objectAtIndex:0] isKindOfClass:[NSDictionary class]]) {
                    //NSArray *param_keys = [[date_time_merId_Arr objectAtIndex:0] allKeys];
                    
                    NSMutableArray *chrg_array = [NSMutableArray array];
                    NSMutableArray *ship_array = [NSMutableArray array];
                    NSMutableArray *deliveydate_arr = [NSMutableArray array];
                    NSMutableArray *deliveytime_arr = [NSMutableArray array];
                    NSMutableArray *pickMethod_arr = [NSMutableArray array];
                    
                    for (int b= 0; b<date_time_merId_Arr.count; b++) {
                        
                        
                        NSString *str = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"ship_chrge"]];
                        
                        str = [str stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        str = [str stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        
                        NSString *method = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"ship_method"]];
                        
                        method = [method stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        method = [method stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        NSString *date = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"date"]];
                        date =[date stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        date = [date stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        
                        
                        NSString *time = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"time"]];
                        time = [time stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        time = [time stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        
                        NSString *pic_meth = [NSString stringWithFormat:@"%@",[[date_time_merId_Arr objectAtIndex:b] valueForKey:@"pickMethod"]];
                        pic_meth = [pic_meth stringByReplacingOccurrencesOfString:@"<nil>" withString:@" "];
                        pic_meth = [pic_meth stringByReplacingOccurrencesOfString:@"(null)" withString:@" "];
                        
                        [pickMethod_arr addObject:pic_meth];
                        [deliveydate_arr addObject:date];
                        [deliveytime_arr addObject:time];
                        [chrg_array addObject:str];
                        [ship_array addObject:method];
                        
                        NSLog(@" ::::: %@ :::::%@ ",str,method);
                        
                    }
                    shiip_charge = [chrg_array componentsJoinedByString:@","];
                    ship_method = [ship_array componentsJoinedByString:@","];
                    deliveydate = [deliveydate_arr componentsJoinedByString:@","];
                    deliveytime = [deliveytime_arr componentsJoinedByString:@","];
                    pickMethod = [pickMethod_arr componentsJoinedByString:@","];
                    
                    
                    shiip_charge = [shiip_charge stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    shiip_charge = [shiip_charge stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
                    
                    ship_method = [ship_method stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    ship_method = [ship_method stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
                    
                    deliveydate = [deliveydate stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    deliveydate = [deliveydate stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
                    
                    pickMethod = [pickMethod stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                    pickMethod = [pickMethod stringByReplacingOccurrencesOfString:@"<nil>" withString:@""];
                    
                    
                    
                    NSLog(@"%@",deliveytime);
                    
                    
                }
            }
        } @catch (NSException *exception) {
             [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"%@",exception);
        }
        NSDictionary *FormpickupMethod = @{@"pickMethod":pickMethod};
        
        data = [NSJSONSerialization dataWithJSONObject:FormpickupMethod options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormpickupMethod_str = [[NSString alloc] initWithData:data
                                                               encoding:NSUTF8StringEncoding];
        
        
        
        
        NSDictionary *FormPayment = @{@"paymenttype":payment_type_str};
        data = [NSJSONSerialization dataWithJSONObject:FormPayment options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormPayment_str = [[NSString alloc] initWithData:data
                                                          encoding:NSUTF8StringEncoding];
        
        
        
        NSDictionary  *FormshipMethod = @{@"charge":shiip_charge,@"shipmethod":ship_method};
        
        data = [NSJSONSerialization dataWithJSONObject:FormshipMethod options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormshipMethod_str = [[NSString alloc] initWithData:data
                                                             encoding:NSUTF8StringEncoding];
        
        
        
        
        NSDictionary *FormDeliverySlot = @{@"deliveydate":deliveydate,@"deliveytime":deliveytime};
        data = [NSJSONSerialization dataWithJSONObject:FormDeliverySlot options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormDeliverySlot_str = [[NSString alloc] initWithData:data
                                                               encoding:NSUTF8StringEncoding];
        
        if ([billcheck_clicked isEqualToString:@"0"]) {
            billcheck_clicked = @"1";
        }
        else{
            billcheck_clicked = @"0";
        }
        
        NSDictionary *FormSameasBilling = @{@"check":billcheck_clicked};
        data = [NSJSONSerialization dataWithJSONObject:FormSameasBilling options:NSJSONWritingPrettyPrinted error:nil];
        NSString *FormSameasBilling_str = [[NSString alloc] initWithData:data
                                                                encoding:NSUTF8StringEncoding];
        NSLog(@"%@",promo_codeStr);
        
        NSDictionary *Formcouponcode = @{@"couponcode":promo_codeStr};
        data = [NSJSONSerialization dataWithJSONObject:Formcouponcode options:NSJSONWritingPrettyPrinted error:nil];
        NSString *Formcouponcode_str = [[NSString alloc] initWithData:data
                                                             encoding:NSUTF8StringEncoding];
        
        
        
        
        //[shippinglatlog_dic removeAllObjects];
        
        //data = [NSJSONSerialization dataWithJSONObject:shippinglatlog_dic options:NSJSONWritingPrettyPrinted error:nil];
        //        NSString *shippinglatlog_str = [[NSString alloc] initWithData:data
        //                                                             encoding:NSUTF8StringEncoding];
        NSString *shippinglatlog_str = [NSString stringWithFormat:@"{}"];
        
        
        
        //        [billiinglatlog_dic removeAllObjects];
        //
        //        data = [NSJSONSerialization dataWithJSONObject:billiinglatlog_dic options:NSJSONWritingPrettyPrinted error:nil];
        //        NSString *billiinglatlog_str = [[NSString alloc] initWithData:data
        //                                                             encoding:NSUTF8StringEncoding];
        NSString *billiinglatlog_str = [NSString stringWithFormat:@"{}"];
        
        NSDictionary *params;
        
        @try {
            
            
            
            params = @{@"countryId":ctry_id,@"lanId":lan_id,@"Formpaymenthidden":Formpaymenthidden_str,@"FormpickupMethod":FormpickupMethod_str,@"FormPayment":FormPayment_str,@"Formshipping":form_shipping_str,@"FormshipMethod":FormshipMethod_str,@"FormBilling":form_billing_str,@"billinglatlog":billiinglatlog_str,@"FormDeliverySlot":FormDeliverySlot_str,@"FormSameasBilling":FormSameasBilling_str,@"shippinglatlog":shippinglatlog_str,@"Formcouponcode":Formcouponcode_str,@"SpecialInstruction":SpecialInstruction_str,@"order_mode":order_mode_str};//@"order_mode":order_mode_str
            
            
            
        } @catch (NSException *exception) {
            [Helper_activity stop_activity_animation:self];
             [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"Some values are missing in dic");
            //NSLog(@"%@",exception);
        }
        
        /******************Calling Place Order API*******************/
        [self placeOrderApiCalling:params];
        
        
        
    } @catch (NSException *exception) {
          [Helper_activity stop_activity_animation:self];
        NSLog(@"Parsing Exception ");
        //NSLog(@"%@",exception);
    }
    
    
}

 #pragma mark - Navigation

 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     
     if ([segue.identifier isEqualToString:@"move_to_pay"]) {
         VC_DS_Checkout *check_out_cntroller = [segue destinationViewController];
         check_out_cntroller.rec_dic = sender;
     }
     
 }
-(void)close_ACTION
{
    VW_overlay.hidden = YES;
    _VW_delivery_slot.hidden = YES;
}

#pragma mark Place Order Method API Implementation

-(void)placeOrderApiCalling:(NSDictionary *)params{
    @try
        {
            [Helper_activity animating_images:self];
            NSError *error;
            NSError *err;
            NSHTTPURLResponse *response = nil;
    
            NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:NSASCIIStringEncoding error:&err];
            NSLog(@"the posted data is:%@",params);
            //NSString *urlString =[NSString stringWithFormat:@"%@apis/placeorderapi.json",SERVER_URL];

            NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/placeorderapi.json",SERVER_URL];
             urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@"" withString:@"%20"];
    
    
    
            NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:urlProducts];
            [request setHTTPMethod:@"POST"];
            
    
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
            [request addValue:@"application/json" forHTTPHeaderField:@"Accept"];
            
            // set Cookie and awllb......
            if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isKindOfClass:[NSNull class]] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isEqualToString:@"<nil>"] || ![[NSUserDefaults standardUserDefaults] valueForKey:@"(null)"]) {
                
                NSString *awlllb = [[NSUserDefaults standardUserDefaults] valueForKey:@"Aws"];
                
                if (![awlllb containsString:@"(null)"]) {
                    awlllb = [NSString stringWithFormat:@"%@;%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"],awlllb];
                    [request addValue:awlllb forHTTPHeaderField:@"Cookie"];
                }
                else{
                    [request addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
                }
                
            }
            
            

            [request setHTTPBody:postData];
            //[request setHTTPShouldHandleCookies:NO];
            NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (response) {
                [HttpClient filteringCookieValue:response];
            }
            if (err) {
                [Helper_activity stop_activity_animation:self];
                [err localizedDescription];
            }
            
    
            if(aData)
            {
                [Helper_activity stop_activity_animation:self];
               
                NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&error];
                NSLog(@"%@",error);
                NSLog(@"The response Api   sighn up API %@",json_DATA);
                NSString *msg = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
                
                if ([msg isEqualToString:@"1"]) {
                   
                    NSLog(@"%@",msg);
                    [self performSegueWithIdentifier:@"move_to_pay" sender:json_DATA];
                }
                else{
                    
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:@"حسنا" otherButtonTitles:@"إلغاء", nil];
                        alert.tag = 1;
                        [alert show];
                        
                    }
                    else
                    {
                       
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATA valueForKey:@"message"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel", nil];
                        alert.tag = 1;
                        [alert show];
                        
                    }
                    
                    
                    
                    
                }
                
            }
            else
            {
               
    
                
                [HttpClient createaAlertWithMsg:@"Something Went to Wrong Please Try Again Later" andTitle:@""];
                
            }
            
        }
        
        @catch(NSException *exception)
        {
              [Helper_activity stop_activity_animation:self];
            NSLog(@"The error is:%@",exception);
        }
   }
#pragma mark gettingCountryCodeForMobilenumber from JSON File
-(void)gettingCountryCodeForMobile
{
       
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"countries" ofType:@"json"]];
    NSError *localError = nil;
    NSDictionary *parsedObject = [NSJSONSerialization JSONObjectWithData:data options:0 error:&localError];
    
    if (localError != nil) {
        NSLog(@"%@", [localError userInfo]);
    }
    phone_code_arr = (NSMutableArray *)[parsedObject valueForKey:@"countries"];
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    [phone_code_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
    
   // NSLog(@"%@",phone_code_arr);
    
}

#pragma mark go_To_Home:
-(void)go_To_Home{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
}
#pragma mark Getting One Time Password For Cash On Delivary (API CALLING)
//http://dohasooq.carmatec.com/apis/productOtpOfCod
//user_id
-(void)gettingOtpForCashOnDelivary{
    @try {
        
        [Helper_activity animating_images:self];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *str_id = @"user_id";
        NSString *user_id;
        for(int h = 0;h<[[dict allKeys] count];h++)
        {
            if([[[dict allKeys] objectAtIndex:h] isEqualToString:str_id])
            {
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                break;
            }
            else
            {
                
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            }
            
        }
        
        
        NSString *urlString =[NSString stringWithFormat:@"%@apis/productOtpOfCod",SERVER_URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:[NSURL URLWithString:urlString]];
        
        
        // set Cookie and awllb......
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isKindOfClass:[NSNull class]] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isEqualToString:@"<nil>"] || ![[NSUserDefaults standardUserDefaults] valueForKey:@"(null)"]) {
            
            NSString *awlllb = [[NSUserDefaults standardUserDefaults] valueForKey:@"Aws"];
            
            if (![awlllb containsString:@"(null)"]) {
                awlllb = [NSString stringWithFormat:@"%@;%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"],awlllb];
                [request addValue:awlllb forHTTPHeaderField:@"Cookie"];
            }
            else{
                [request addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
            }
            
        }
        
        
        
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        
        
        //User_id
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",user_id]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //mobilenumber
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mobilenumber\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@-%@",_TXT_Cntry_code.text,_TXT_phone.text]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"................%@",[NSString stringWithFormat:@"%@-%@",_TXT_Cntry_code.text,_TXT_phone.text]);
        
        NSError *er;
        
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        NSURLResponse *response = nil;
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&er];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        if (er) {
            [Helper_activity stop_activity_animation:self];
            
            VW_overlay.hidden = YES;
            _VW_otp_vw.hidden = YES;
             
            
            }
        
        if (returnData) {
            
            [Helper_activity stop_activity_animation:self];
            
            NSMutableDictionary   *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
            
            if (er) {  //Error While getting Data...
               
                 [Helper_activity stop_activity_animation:self];
                VW_overlay.hidden = YES;
                _VW_otp_vw.hidden = YES;
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"رقم الجوال غير صالح" delegate:self cancelButtonTitle:@"حسنا" otherButtonTitles:nil, nil];
                    alert.tag = 1;
                    [alert show];
                    
                }
                else
                {
                    
                    
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Invalid Mobile Number" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alert.tag = 1;
                    [alert show];
                    
                }
            }
           else{
               @try {
                   timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerFired) userInfo:nil repeats:YES];
                   otp_str = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"otp"]];

               } @catch (NSException *exception) {
                   NSLog(@"OTP Exception...........");
               }
               
               
                          }

                       NSLog(@"%@", [NSString stringWithFormat:@"OneTimePWD %@", json_DATA]);
            
        }

        
        
    } @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];
    }
}


#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            
            [self.navigationController popViewControllerAnimated:YES];
        }
        else{
            
            
            NSLog(@"cancel:");
            
        }
    }
    
    else if (alertView.tag ==2){
        [self BTN_check_clickd];
        NSLog(@"*****************Select Checkbox*****************");
        
    }else if (alertView.tag == 3){
        // [self performSegueWithIdentifier:@"checkout_home" sender:self];
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    
    
}
-(void)begin_responder
{
    //Did Begin Editing
    
    [self textFieldDidBeginEditing:_TXT_fname];
    [self textFieldDidBeginEditing:_TXT_lname];
    [self textFieldDidBeginEditing:_TXT_addr1];
    [self textFieldDidBeginEditing:_TXT_addr2];
    [self textFieldDidBeginEditing:_TXT_city];
    [self textFieldDidBeginEditing:_TXT_zip];
   // [self textFieldDidBeginEditing:_TXT_country];
    //[self textFieldDidBeginEditing:_TXT_state];
    
    //Did End Editing
    [self textFieldDidEndEditing:_TXT_fname];
    [self textFieldDidEndEditing:_TXT_lname];
    [self textFieldDidEndEditing:_TXT_addr1];
    [self textFieldDidEndEditing:_TXT_addr2];
    [self textFieldDidEndEditing:_TXT_city];
    [self textFieldDidEndEditing:_TXT_zip];
    //[self textFieldDidEndEditing:_TXT_country];
    //[self textFieldDidEndEditing:_TXT_state];



 /*   [_TXT_fname becomeFirstResponder];
    [_TXT_lname becomeFirstResponder];
    [_TXT_addr1 becomeFirstResponder];
    [_TXT_addr2 becomeFirstResponder];
    [_TXT_city becomeFirstResponder];
    [_TXT_zip becomeFirstResponder];
    [_TXT_country becomeFirstResponder];
    [_TXT_state becomeFirstResponder];
    
    
    [_TXT_fname resignFirstResponder];
    [_TXT_lname resignFirstResponder];
    [_TXT_addr1 resignFirstResponder];
    [_TXT_addr2 resignFirstResponder];
    [_TXT_city resignFirstResponder];
    [_TXT_zip resignFirstResponder];
    [_TXT_country resignFirstResponder];
    [_TXT_state resignFirstResponder];*/
    
}
-(void)begin_ship_responder
{
    // Did begin Editing.
    
    [self textFieldDidBeginEditing:_TXT_ship_fname];
    [self textFieldDidBeginEditing:_TXT_ship_lname];
    [self textFieldDidBeginEditing:_TXT_ship_addr1];
    [self textFieldDidBeginEditing:_TXT_ship_addr2];
    [self textFieldDidBeginEditing:_TXT_ship_city];
    [self textFieldDidBeginEditing:_TXT_ship_zip];
    //[self textFieldDidBeginEditing:_TXT_ship_country];
    //[self textFieldDidBeginEditing:_TXT_ship_state];
    
    
    //Did End Editing
    
    [self textFieldDidEndEditing:_TXT_ship_fname];
    [self textFieldDidEndEditing:_TXT_ship_lname];
    [self textFieldDidEndEditing:_TXT_ship_addr1];
    [self textFieldDidEndEditing:_TXT_ship_addr2];
    [self textFieldDidEndEditing:_TXT_ship_city];
    [self textFieldDidEndEditing:_TXT_ship_zip];
   // [self textFieldDidEndEditing:_TXT_ship_country];
   // [self textFieldDidEndEditing:_TXT_ship_state];

  
}

#pragma arguments
- (IBAction)apply_coupon:(id)sender {
    [self.view addSubview:VW_overlay];
    [self  sumary_VIEW];
}

@end
