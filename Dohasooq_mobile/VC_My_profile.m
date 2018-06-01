//
//  VC_My_profile.m
//  Dohasooq_mobile
//
//  Created by Test User on 28/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_My_profile.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import  <AssetsLibrary/AssetsLibrary.h>
#import <Photos/Photos.h>
#import "HttpClient.h"
#import "Helper_activity.h"

@interface VC_My_profile ()<UITextFieldDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    float scroll_ht;
    NSMutableArray *statepicker,*phone_code_arr, *required_format;
    NSDictionary *grouppicker;
    NSDictionary *user_dictionary;
//    UIView *VW_overlay;
//    UIActivityIndicatorView *activityIndicatorView;
    NSString *state_val,*country_val,*state_id,*country_id;
    
    NSArray *json_DATA;
    NSData *pngData;
    NSData *syncResData;
    NSMutableURLRequest *requesti;
    NSMutableArray *temp_arr ;
    NSDictionary *country_dict;
    NSString *cntry_code;
    
    BOOL isPickerViewScrolled;
    NSString *pickerViewSelection;
    }

@end

@implementation VC_My_profile

- (void)viewDidLoad {
    [super viewDidLoad];
    phone_code_arr = [[NSMutableArray alloc]init];
    self.screenName = @"MyProfile screen";

    // Do any additional setup after loading the view.
    
//    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    VW_overlay.clipsToBounds = YES;
//    //    VW_overlay.layer.cornerRadius = 10.0;
//    
//    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
//    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
//    activityIndicatorView.center = VW_overlay.center;
//    [VW_overlay addSubview:activityIndicatorView];
//    VW_overlay.center = self.view.center;
//    [self.view addSubview:VW_overlay];
//    VW_overlay.hidden = YES;
//    
//    VW_overlay.hidden = NO;
//    [activityIndicatorView startAnimating];
    [Helper_activity animating_images:self];
    [self performSelector:@selector(View_user_data) withObject:nil afterDelay:0.01];
    [self gettingCountryCodeForMobile];
    [self set_UP_VIEW];
}
-(void)viewWillAppear:(BOOL)animated{
    
    
    self.navigationItem.hidesBackButton =  YES;

    
}

-(void)set_UP_VIEW
{
    _BTN_save.hidden = YES;
    _BTN_save_billing.hidden = YES;
    
    CGRect frameset = _VW_profile.frame;
    //frameset.size.height = _BTN_male.frame.origin.y + _BTN_male.frame.size.height;
    frameset.size.width = _scroll_contents.frame.size.width;
    _VW_profile.frame = frameset;
    [self.scroll_contents addSubview:_VW_profile];
    
    frameset = _VW_layer.frame;
    frameset.size.height = _BTN_male.frame.origin.y + _BTN_male.frame.size.height + 12;
    _VW_layer.frame = frameset;
    
    frameset = _VW_login.frame;
    frameset.origin.y =_VW_layer.frame.origin.y+ _VW_layer.frame.size.height;
    frameset.size.width = _scroll_contents.frame.size.width;
    _VW_login.frame = frameset;
    [self.scroll_contents addSubview:_VW_login];
    
    frameset = _VW_billing.frame;
    frameset.origin.y =_VW_login.frame.origin.y+ _VW_login.frame.size.height;
    frameset.size.width = _scroll_contents.frame.size.width;
    _VW_billing.frame = frameset;
    [self.scroll_contents addSubview:_VW_billing];
    
    frameset = _VW_layer_billing.frame;
    frameset.size.height = _TXT_zipcode.frame.origin.y + _TXT_zipcode.frame.size.height + 12;
    _VW_layer_billing.frame = frameset;

    
    scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;
    _BTN_bank_customer.tag = 0;
    _BTN_bank_employee.tag = 1;
    _BTN_male.tag = 1;
    _BTN_feamle.tag = 1;
    
    _TXT_country_fld.delegate = self;

    [_BTN_edit addTarget:self action:@selector(Button_edit_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_edit_billing addTarget:self action:@selector(Button_edit_billing_action) forControlEvents:UIControlEventTouchUpInside];

    [_BTN_bank_customer addTarget:self action:@selector(BTN_bank_customer_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_bank_employee addTarget:self action:@selector(BTN_bank_employee_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_male addTarget:self action:@selector(BTN_male_action) forControlEvents:UIControlEventTouchUpInside];
     [_BTN_feamle addTarget:self action:@selector(BTN_female_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_camera addTarget:self action:@selector(take_Picture) forControlEvents:UIControlEventTouchUpInside];
    _BTN_camera.layer.cornerRadius = _BTN_camera.frame.size.width/2;
    _BTN_camera.layer.masksToBounds = YES;
    
    _VW_layer.layer.borderWidth = 0.4f;
    _VW_layer.layer.borderColor =[UIColor lightGrayColor].CGColor;
    _VW_layer_login.layer.borderWidth = 0.4f;
    _VW_layer_login.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    _VW_layer_billing.layer.borderWidth = 0.4f;
    _VW_layer_billing.layer.borderColor =[UIColor lightGrayColor].CGColor;
    
    _VW_profile_pic.layer.cornerRadius = self.VW_profile_pic.frame.size.width/2;
    _VW_profile_pic.layer.masksToBounds = YES;
    
    _IMG_Profile_pic.layer.cornerRadius = self.IMG_Profile_pic.frame.size.width/2;
    _IMG_Profile_pic.layer.masksToBounds = YES;
    
    [_BTN_save addTarget:self action:@selector(Save_button_clicked) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_save_billing addTarget:self action:@selector(Save_button_Billing_clicked) forControlEvents:UIControlEventTouchUpInside];

    [self picker_SET_UP];
    [self TEXT_hidden];
    [self TEXT_billing_hidden];
    [self  View_user_data];
    [self CountryAPICall];



}
-(void)picker_SET_UP    //Picker_set
{
    _contry_pickerView = [[UIPickerView alloc] init];
    _contry_pickerView.delegate = self;
    _contry_pickerView.dataSource = self;
    
    _state_pickerView = [[UIPickerView alloc] init];
    _state_pickerView.delegate = self;
    _state_pickerView.dataSource = self;
    
//    _group_pickerVIEW = [[UIPickerView alloc] init];
//    _group_pickerVIEW.delegate = self;
    //_group_pickerVIEW.dataSource = self;
    
    _date_picker = [[UIDatePicker alloc] init];
    _date_picker.datePickerMode = UIDatePickerModeDate;
    
    
    _flag_contry_pickerCiew = [[UIPickerView alloc]init];
    _flag_contry_pickerCiew.delegate = self;
    _flag_contry_pickerCiew.dataSource=self;
    
    
    
    
    UIToolbar  *phone_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    phone_close.barStyle = UIBarStyleBlackTranslucent;
    [phone_close sizeToFit];
    
//    UIButton *done=[[UIButton alloc]init];
//    done.frame=CGRectMake(phone_close.frame.size.width - 100, 0, 100, phone_close.frame.size.height);
//    [done setTitle:@"Done" forState:UIControlStateNormal];
//    [done addTarget:self action:@selector(picker_done_btn_action) forControlEvents:UIControlEventTouchUpInside];
//    [phone_close addSubview:done];
//
//
//    UIButton *close=[[UIButton alloc]init];
//    close.frame=CGRectMake(phone_close.frame.origin.x -20, 0, 100, phone_close.frame.size.height);
//    [close setTitle:@"Close" forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(close_ACTION) forControlEvents:UIControlEventTouchUpInside];
//    [phone_close addSubview:close];
//
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(picker_done_btn_action)];
    [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(close_ACTION)];
    [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    NSMutableArray *barItems = [NSMutableArray arrayWithObjects:cancelBtn,flexibleItem,doneBtn, nil];
    [phone_close setItems:barItems animated:YES];

    
    
    _TXT_country_fld.inputAccessoryView = phone_close;
    _TXT_country.inputAccessoryView=phone_close;
    _TXT_state.inputAccessoryView=phone_close;
    _TXT_group.inputAccessoryView=phone_close;
    _TXT_Dob.inputAccessoryView =phone_close;

    _TXT_country_fld.inputView=_flag_contry_pickerCiew;
    self.TXT_country.inputView = _contry_pickerView;
    self.TXT_state.inputView=_state_pickerView;
   // _TXT_group.inputView = _group_pickerVIEW;
     _TXT_Dob.inputView = _date_picker;

    _TXT_country.tintColor=[UIColor clearColor];
    _TXT_state.tintColor=[UIColor clearColor];
    _TXT_group.tintColor=[UIColor clearColor];
    _TXT_Dob.tintColor=[UIColor clearColor];

    

    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    
    
    NSDate *min_date = [[NSDate alloc] init];
    NSString  *min = [NSString stringWithFormat:@"%@",[formatter stringFromDate:min_date]];
    min_date = [formatter dateFromString:min];
    [_date_picker setMaximumDate:min_date];
    [_date_picker addTarget:self action:@selector(fromdateTextField) forControlEvents:UIControlEventValueChanged];

    //[self CountryAPICall];
//   temp_arr = [[NSMutableArray alloc]init];
//    countrypicker = [[NSMutableArray alloc]init];
//     temp_arr = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
//    for(int i =0 ;i < temp_arr.count;i++)
//    {
//        [countrypicker addObject:[[temp_arr objectAtIndex:i]valueForKey:@"name"]];
//    }
//    
//    for(int i = 0;i<temp_arr.count;i++)
//    {
//        if([_TXT_country.text isEqualToString:[[temp_arr objectAtIndex:i]valueForKey:@"name"]])
//        {
//            country_id =[NSString stringWithFormat:@"%@",[[temp_arr objectAtIndex:i]valueForKey:@"id"]];
//        }
//    }
   
   // [self customer_GROUP_API];
    
    // = [[NSUserDefaults standardUserDefaults] valueForKey:@"country_arr"];
}

-(void)close_ACTION
{
    [_TXT_country_fld resignFirstResponder];
    [_TXT_state resignFirstResponder];
    [_TXT_country resignFirstResponder];
    [_TXT_group resignFirstResponder];
    [_TXT_Dob resignFirstResponder];
    [_TXT_Dob resignFirstResponder];
    
}
-(void)picker_done_btn_action
{
    if (!isPickerViewScrolled) {
     [self pickerViewCustomAction:0];
    }
   
    
    [_TXT_country resignFirstResponder];
    [_TXT_group resignFirstResponder];
    [_TXT_Dob resignFirstResponder];
    [_TXT_state resignFirstResponder];
    [_TXT_country_fld resignFirstResponder];

    
    
}
#pragma mark CountryAPICall
-(void)CountryAPICall
{
    @try {
        required_format = [NSMutableArray array];

       NSMutableArray *countrypicker = [[NSMutableArray alloc]init];
        NSString *country_ID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/countriesapi/%@.json",SERVER_URL,country_ID];
        @try
        {
            NSError *error;
            // NSError *err;
            NSHTTPURLResponse *response = nil;
            
            
            // NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/login/1.json",SERVER_URL];
            // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:urlProducts];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
           
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
            

            
            
            [request setHTTPShouldHandleCookies:NO];
            NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
            if (response) {
                [HttpClient filteringCookieValue:response];
            }
            if(aData)
            {
                
                required_format = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&error];

                
              /*  for (int x=0; x<[[country_dict allKeys] count]; x++) {
                    NSDictionary *dic = @{@"cntry_id":[[country_dict allKeys] objectAtIndex:x],@"cntry_name":[country_dict valueForKey:[[country_dict allKeys] objectAtIndex:x]]};
                    
                    [countrypicker addObject:dic];
                }
                
                
                NSSortDescriptor *sortDescriptor;
                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"cntry_name"
                                                             ascending:YES];
                NSArray *sortedArr = [countrypicker sortedArrayUsingDescriptors:@[sortDescriptor]];
                
                
             required_format = [NSMutableArray array];
                for (int l =0; l<sortedArr.count; l++) {
                    
                    if ([[[sortedArr objectAtIndex:l] valueForKey:@"cntry_name"] isEqualToString:@"Qatar"] ) {
                        
                        [required_format addObject:[sortedArr objectAtIndex:l]];
                        
                    }
                    
                }
                for (int l =0; l<sortedArr.count; l++) {
                    
                    if ([[[sortedArr objectAtIndex:l] valueForKey:@"cntry_name"] isEqualToString:@"India"]) {
                        
                        [required_format addObject:[sortedArr objectAtIndex:l]];
                        
                    }
                    
                }
                
                for (int m =0; m<sortedArr.count; m++) {
                    
                    if (![[[sortedArr objectAtIndex:m] valueForKey:@"cntry_name"] isEqualToString:@"Qatar"] && ![[[sortedArr objectAtIndex:m] valueForKey:@"cntry_name"] isEqualToString:@"India"]) {
                        
                        [required_format addObject:[sortedArr objectAtIndex:m]];
                        
                    }
                    
                }
//                
//                for(int i = 0;i<required_format.count;i++)
//                {
//                    if([[[user_dictionary valueForKey:@"detail"] valueForKey:@"country_name"] isEqualToString:[[required_format objectAtIndex:i] valueForKey:@"cntry_name"]])
//                    {
//                        country_id =[NSString stringWithFormat:@"%@",[[required_format objectAtIndex:i] valueForKey:@"cntry_id"]];
//                        [self states_API:country_id];
//                        
//                    }
//                }
//
                
                
//                for (int l =0; l<required_format.count; l++) {
//                    
//                    if ([[[required_format objectAtIndex:l] valueForKey:@"cntry_name"] isEqualToString:@"Qatar"] ) {
//                        
//                        country_ID = []
//                        
//                        [required_format addObject:[sortedArr objectAtIndex:l]];
//                        
//                    }
//                    
//                }*/
//
                
                //[countrypicker removeAllObjects];
                //[countrypicker addObjectsFromArray:required_format];
                [_contry_pickerView reloadAllComponents];
               // NSLog(@"The response Api post sighn up API %@",countrypicker);
                
                //  NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
            }
            else
            {
                [Helper_activity stop_activity_animation:self];
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    [HttpClient createaAlertWithMsg:@"خطأ في الإتصال" andTitle:@""];
                }
                else{
                    [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
                }

            }
            
        }
        
        @catch(NSException *exception)
        {
            NSLog(@"The error is:%@",exception);
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width,scroll_ht);
}
#pragma Button Actions
-(void)Button_edit_action
{
  if([_BTN_edit.titleLabel.text isEqualToString:@""])
  {
      [_BTN_edit setTitle:@"" forState:UIControlStateNormal];
      _BTN_save.hidden = YES;
      [self set_DATA];
      CGRect frameset = _VW_profile.frame;
     // frameset.size.height = _BTN_male.frame.origin.y + _BTN_male.frame.size.height;
      _VW_profile.frame = frameset;
      
      frameset = _VW_layer.frame;
      frameset.size.height = _BTN_male.frame.origin.y + _BTN_male.frame.size.height + 12;
      _VW_layer.frame = frameset;

      
      frameset = _VW_login.frame;
      frameset.origin.y =_VW_layer.frame.origin.y+ _VW_layer.frame.size.height;
      frameset.size.width = _scroll_contents.frame.size.width;
      _VW_login.frame = frameset;
      
      frameset = _VW_billing.frame;
      frameset.origin.y =_VW_login.frame.origin.y+ _VW_login.frame.size.height;
      frameset.size.width = _scroll_contents.frame.size.width;
      _VW_billing.frame = frameset;
      
      
      
       scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;

      _TXT_first_name.backgroundColor = [UIColor whiteColor];
      _TXT_last_name.backgroundColor = [UIColor whiteColor];
     
      
  }
  else
  {
      [_BTN_edit setTitle:@"" forState:UIControlStateNormal];
      _BTN_save.hidden = NO;
      
      CGRect frameset = _VW_profile.frame;
      //frameset.size.height = _BTN_save.frame.origin.y + _BTN_save.frame.size.height;
      _VW_profile.frame = frameset;
      
      frameset = _VW_layer.frame;
      frameset.size.height = _BTN_save.frame.origin.y + _BTN_save.frame.size.height + 12;
      _VW_layer.frame = frameset;
      
      frameset = _VW_login.frame;
      frameset.origin.y =_VW_layer.frame.origin.y+ _VW_layer.frame.size.height;
      frameset.size.width = _scroll_contents.frame.size.width;
      _VW_login.frame = frameset;
      
     frameset = _VW_billing.frame;
      frameset.origin.y =_VW_login.frame.origin.y+ _VW_login.frame.size.height;
      frameset.size.width = _scroll_contents.frame.size.width;
      _VW_billing.frame = frameset;
      
      if(_BTN_save_billing.hidden == YES)
      {
      frameset = _VW_layer_billing.frame;
      frameset.size.height = _TXT_zipcode.frame.origin.y + _TXT_zipcode.frame.size.height + 12;
      _VW_layer_billing.frame = frameset;
      }
      else
      {
          frameset = _VW_layer_billing.frame;
          frameset.size.height = _BTN_save_billing.frame.origin.y + _BTN_save_billing.frame.size.height + 12;
          _VW_layer_billing.frame = frameset;
      }
      

   
     scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;
      


      _TXT_first_name.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
      _TXT_last_name.backgroundColor = [UIColor colorWithRed:240.0/255.0 green:240.0/255.0 blue:240.0/255.0 alpha:1];
      
     //  [self viewDidLayoutSubviews];
      
  }
    [self viewDidLayoutSubviews];
     [self TEXT_hidden];
  
}
-(void)Button_edit_billing_action
{
    if([_BTN_edit_billing.titleLabel.text isEqualToString:@""])
    {
        [_BTN_edit_billing setTitle:@"" forState:UIControlStateNormal];
        _BTN_save_billing.hidden = YES;
        
        [self set_DATA];
        
        CGRect frameset = _VW_layer_billing.frame;
        frameset.size.height = _TXT_zipcode.frame.origin.y + _TXT_zipcode.frame.size.height + 12;
        _VW_layer_billing.frame = frameset;

        if(_BTN_save.hidden == YES)
        {
            scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height+50;
            
        }
        else
        {
            
            scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height +_BTN_save.frame.size.height+50;
        }

    }
    else
    {
        [_BTN_edit_billing setTitle:@"" forState:UIControlStateNormal];
        _BTN_save_billing.hidden = NO;
        
        CGRect frameset = _VW_billing.frame;
        frameset.size.height = _BTN_save_billing.frame.origin.y + _BTN_save_billing.frame.size.height;
        _VW_billing.frame = frameset;
        
        
        frameset = _VW_layer_billing.frame;
        frameset.size.height = _BTN_save_billing.frame.origin.y + _BTN_save_billing.frame.size.height + 12;
        _VW_layer_billing.frame = frameset;
        
        if(_BTN_save.hidden == YES)
        {
            scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height +_BTN_save.frame.size.height;
 
        }
        else
        {
        scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height+80;

        }


    }
  //  [self viewDidLayoutSubviews];
    [self TEXT_billing_hidden];
}

-(void)scroll_HANDLER
{
    if(_BTN_save.hidden == YES && _BTN_save_billing.hidden == YES)
    {
        scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;
    }
    else if(_BTN_save.hidden ==  YES && _BTN_save_billing.hidden == NO)
    {
        scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;

    }
    else if(_BTN_save_billing.hidden == NO && _BTN_save.hidden == YES)
    {
        scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;

    }
    
}
-(void)BTN_bank_customer_action
{
    if(_BTN_bank_customer.tag == 0)
    {
        [_BTN_bank_customer setBackgroundImage:[UIImage imageNamed:@"checked_order"] forState:UIControlStateNormal];
        _BTN_bank_customer.tag = 1;
    }
    else
    {
        [_BTN_bank_customer setBackgroundImage:[UIImage imageNamed:@"uncheked_order"] forState:UIControlStateNormal];
        _BTN_bank_customer.tag = 0;
    }

    
}
-(void)BTN_bank_employee_action
{
    if(_BTN_bank_employee.tag == 1)
    {
    [_BTN_bank_employee setBackgroundImage:[UIImage imageNamed:@"checked_order"] forState:UIControlStateNormal];
        _BTN_bank_employee.tag = 0;
    }
    else
    {
    [_BTN_bank_employee setBackgroundImage:[UIImage imageNamed:@"uncheked_order"] forState:UIControlStateNormal];
        _BTN_bank_employee.tag = 1;
    }

}
-(void)BTN_male_action
{
    if(_BTN_male.tag == 1)
    {
        [_BTN_male setBackgroundImage:[UIImage imageNamed:@"radiobtn"] forState:UIControlStateNormal];
        _BTN_male.tag = 0;
          _BTN_feamle.tag = 1;
        [_BTN_feamle setBackgroundImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];

    }
    else
    {
        [_BTN_male setBackgroundImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_male.tag = 1;
        _BTN_feamle.tag = 0;
    }

    
}
-(void)BTN_female_action
{
    if(_BTN_feamle.tag == 1)
    {
        [_BTN_feamle setBackgroundImage:[UIImage imageNamed:@"radiobtn"] forState:UIControlStateNormal];
        [_BTN_male setBackgroundImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];

        _BTN_feamle.tag = 0;
        _BTN_male.tag = 1;
    }
    else
    {
        [_BTN_feamle setBackgroundImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_feamle.tag = 1;
        _BTN_male.tag = 0;
    }
    

}

#pragma mark  Textfield delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    NSInteger inte = _TXT_mobile_phone.text.length;
    if([_TXT_country_fld.text isEqualToString:@"+974"])
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
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@"1234567890"] invertedSet];
    NSString *resultString = [[_TXT_mobile_phone.text componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    

    _TXT_mobile_phone.text = resultString;
    

    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    isPickerViewScrolled = NO;
    
    if (textField == _TXT_Dob) {
        pickerViewSelection = @"DOB";
    }
    
    
    if(textField == _TXT_city )
    {
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];

    }
    else if(textField  == _TXT_address1)
    {
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-140,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];

        
    }
    else if(textField == _TXT_zipcode)
    {
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,-150,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
    }
    
    if (textField == _TXT_country) {
        pickerViewSelection = @"Country";
        [self.contry_pickerView selectRow:0 inComponent:0 animated:YES];
        [_contry_pickerView reloadAllComponents];
    }
    if (textField == _TXT_state) {
        
        [self states_API:country_id];
        pickerViewSelection = @"State";
        [self.state_pickerView selectRow:0 inComponent:0 animated:YES];
        [_state_pickerView reloadAllComponents];
    }
    if (textField == _TXT_country_fld) {
        pickerViewSelection = @"Phone";

    }
    
   
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if(textField == _TXT_city || textField == _TXT_zipcode ||textField  == _TXT_address1)
    {
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];

    }
    
}
#pragma mark Picker_Actions

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if (pickerView == _contry_pickerView) {
        return 1;
    }if(pickerView==_state_pickerView)
    {
        return 1;
    }
//    if(pickerView == _group_pickerVIEW)
//    {
//        return 1;
//    }
    if (pickerView == _flag_contry_pickerCiew) {
        return 1;
    }
    
    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (pickerView == _contry_pickerView) {
        return [required_format count];
    }
    if (pickerView == _state_pickerView) {
        return [statepicker count];
    }
//    if(pickerView == _group_pickerVIEW)
//    {
//        return [[grouppicker allValues] count];
//    }
    if (pickerView == _flag_contry_pickerCiew) {
        return phone_code_arr.count;
    }
    
    return 0;
}
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    if (pickerView == _contry_pickerView) {
        return [required_format[row] valueForKey:@"name"];
    }
    if (pickerView == _state_pickerView) {
        return [[statepicker objectAtIndex:row] valueForKey:@"value"];
    }
   
    if (pickerView == _flag_contry_pickerCiew) {
        return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"code"]];
    }
    
    return nil;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    isPickerViewScrolled = YES;
   
    [self pickerViewCustomAction:row];
   /* if (pickerView == _contry_pickerView) {
        
        self.TXT_country.text = country_val;

        country_val = [required_format[row] valueForKey:@"cntry_name"];
        
        country_id = [NSString stringWithFormat:@"%@",[required_format[row] valueForKey:@"cntry_id"]];
        NSLog(@"the text is:%@",temp_arr);

       // [self states_API:[NSString stringWithFormat:@"%@",[required_format[row] valueForKey:@"cntry_id"]]];
        self.TXT_state.enabled=YES;
    }
    if (pickerView == _state_pickerView) {
        
        self.TXT_email.enabled=YES;
        state_val = [[statepicker objectAtIndex:row] valueForKey:@"value"];


        _TXT_state.text = state_val;
        
        state_id = [[statepicker objectAtIndex:row] valueForKey:@"key"];

    }
    if (pickerView == _flag_contry_pickerCiew) {
       self.TXT_country_fld.text = [phone_code_arr[row] valueForKey:@"code"];
    } */
}
-(void)pickerViewCustomAction:(NSInteger )row{
    
//************ Country PickerView ************
    if ([pickerViewSelection isEqualToString:@"Country"]) {
        
        country_val = [required_format[row] valueForKey:@"name"];
        self.TXT_country.text = country_val;

        
        country_id = [NSString stringWithFormat:@"%@",[required_format[row] valueForKey:@"id"]];
        NSLog(@"the text is:%@",temp_arr);
        
        // [self states_API:[NSString stringWithFormat:@"%@",[required_format[row] valueForKey:@"cntry_id"]]];
        self.TXT_state.enabled=YES;
        _TXT_state.text = nil;
        
    }
//************ State PickerView ************

    else if ([pickerViewSelection isEqualToString:@"State"]){
        
        self.TXT_email.enabled=YES;
        state_val = [[statepicker objectAtIndex:row] valueForKey:@"value"];
        
        
        _TXT_state.text = state_val;
        
        state_id = [[statepicker objectAtIndex:row] valueForKey:@"key"];
    }
//************ Phone PickerView ************
    else if ([pickerViewSelection isEqualToString:@"Phone"]){
        
        self.TXT_country_fld.text = [phone_code_arr[row] valueForKey:@"code"];

    }
    
}


#pragma mark states API
-(void)states_API :(NSString *)country_ids
{
    //http://192.168.0.171/dohasooq/apis/getstatebyconapi/countryid.json
    @try
    {
        NSError *error;
        // NSError *err;
        NSHTTPURLResponse *response = nil;
        //   Languages/getLangByCountry/"+countryid+".json
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/getstatebyconapi/%@.json",SERVER_URL,country_ids];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
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
        

        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        if(aData)
        {
           json_DATA = (NSArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            statepicker = [[NSMutableArray alloc]init];
            
            @try {
                if ([json_DATA isKindOfClass:[NSArray class]]) {
                    [statepicker addObjectsFromArray:json_DATA];
                }
            } @catch (NSException *exception) {
                
            }
            
//            for(int i= 0;i<json_DATA.count;i++)
//            {
//                [statepicker addObject:[[json_DATA objectAtIndex:i] valueForKey:@"value"]];
//            }
//            NSString *str_state;
//           @try
//            {
//                str_state = [[user_dictionary valueForKey:@"detail"] valueForKey:@"state_name"];
//                str_state  = [str_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
//
//                for(int j = 0;j<json_DATA.count;j++)
//                {
//                    if([str_state isEqualToString:[[json_DATA objectAtIndex:j]valueForKey:@"value"]])
//                    {
//                        state_id =[NSString stringWithFormat:@"%@",[[json_DATA objectAtIndex:j]valueForKey:@"key"]];
//                        
//                    }
//                    
//                }
//
//            }
//            @catch(NSException *Exception)
//            {
//                str_state = @"";
//                for(int j = 0;j<json_DATA.count;j++)
//                {
//                    if([str_state isEqualToString:[[json_DATA objectAtIndex:j]valueForKey:@"value"]])
//                    {
//                        state_id =[NSString stringWithFormat:@"%@",[[json_DATA objectAtIndex:j]valueForKey:@"key"]];
//                        
//                    }
//                    
//                }

                
         //   }
            
            
//            for(int j = 0;j<json_DATA.count;j++)
//            {
//                if([str_state isEqualToString:[[json_DATA objectAtIndex:j]valueForKey:@"value"]])
//                {
//                    state_id =[NSString stringWithFormat:@"%@",[[json_DATA objectAtIndex:j]valueForKey:@"key"]];
//                    
//                }
//                
//            }
//
            
            
        }
    }
    
    @catch(NSException *exception)
    {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            [HttpClient createaAlertWithMsg:@"خطأ في الإتصال" andTitle:@""];
        }
        else{
            [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
        }

    }

}

#pragma mark customer_GROUP_API
-(void)customer_GROUP_API
{
    //http://192.168.0.171/dohasooq/apis/getstatebyconapi/countryid.json
    @try
    {
        NSError *error;
        // NSError *err;
        NSHTTPURLResponse *response = nil;
        //   Languages/getLangByCountry/"+countryid+".json
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/customerGroupapi.json",SERVER_URL];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
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
        

        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        if(aData)
        {
            grouppicker = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API 11111 %@",grouppicker);
            
          //  [grouppicker addObject:[json_DATA allValues]];
            
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            [HttpClient createaAlertWithMsg:@"خطأ في الإتصال" andTitle:@""];
        }
        else{
            [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
        }

    }
    
}
#pragma API VIEW user data
-(void)View_user_data
{
    //http://192.168.0.171/dohasooq/apis/getstatebyconapi/countryid.json
    @try
    {
        NSError *error;
        // NSError *err;
        NSHTTPURLResponse *response = nil;
       
       NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *str_id = @"user_id";
        NSString *user_id;
        for(int i = 0;i<[[dict allKeys] count];i++)
        {
            if([[[dict allKeys] objectAtIndex:i] isEqualToString:str_id])
            {
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                break;
            }
            else
            {
                
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            }
            
        }
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/my-account/1/%@.json",SERVER_URL,user_id];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
        
     
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        if(aData)
        {
            
           user_dictionary = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"User Data..... %@",user_dictionary);
            
            [self set_DATA];
            
            [Helper_activity stop_activity_animation:self];
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            [HttpClient createaAlertWithMsg:@"خطأ في الإتصال" andTitle:@""];
        }
        else{
            [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
        }

        [Helper_activity stop_activity_animation:self];

    }
    
}
-(void)set_DATA
{
    NSString *STR_fname = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"firstname"]];
     NSString *STR_lname = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"lastname"]];
     NSString *STR_land_phone = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"lnumber"]];
     NSString *STR_mobile = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"mob_no"]];
    cntry_code =  [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"country_code"]];
    NSString *STR_dob = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"bdate"]];
    
    NSArray *temp_arrs = [STR_dob componentsSeparatedByString:@"T"];
      STR_dob = [temp_arrs objectAtIndex:0];
     STR_dob = [self setdata_string:STR_dob];
     NSString *STR_customer_group = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"customer_grp_name"]];
     NSString *STR_bank_customer = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"doha_bank_customer"]];
     NSString *STR_bank_employee = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"doha_bank_employee"]];
     NSString *STR_gender = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"gender"]];
     NSString *STR_city = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"city"]];
     NSString *STR_address = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"address"]];
     NSString *STR_country = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"country_name"]];
     NSString *STR_state= [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"state_name"]];
    
    state_id = [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"state_id"]];
    country_id =[NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"country_id"]];
    
    
    NSString *STR_zip_code= [NSString stringWithFormat:@"%@",[[user_dictionary valueForKey:@"detail"] valueForKey:@"zipcode"]];
    
    
    STR_fname = [STR_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_fname = [STR_fname stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_lname = [STR_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_lname = [STR_lname stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_land_phone = [STR_land_phone stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_land_phone = [STR_land_phone stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_mobile = [STR_mobile stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_mobile = [STR_mobile stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
   
    
    if ([cntry_code containsString:@"<null>"]||[cntry_code containsString:@"<nil>"]||[cntry_code isEqualToString:@""]) {
        cntry_code = @"974";
    }
    
    NSString *unfilteredString =STR_mobile;
    NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@",1234567890"] invertedSet];
    NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    STR_mobile =  resultString;

    STR_dob = [STR_dob stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_dob = [STR_dob stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_customer_group = [STR_customer_group stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_customer_group = [STR_customer_group stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_bank_customer = [STR_bank_customer stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_bank_customer = [STR_bank_customer stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_bank_employee = [STR_bank_customer stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_bank_employee = [STR_bank_customer stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_gender = [STR_gender stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_gender = [STR_gender stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_city = [STR_city stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_city = [STR_city stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_address = [STR_address stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_address = [STR_address stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    

    
    
    STR_state = [STR_state stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_state = [STR_state stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    STR_zip_code = [STR_zip_code stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    STR_zip_code = [STR_zip_code stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    if ([STR_zip_code containsString:@"null"] ||[STR_zip_code isEqualToString:@"<nill>"] || [STR_zip_code isKindOfClass:[NSNull class]] || [STR_zip_code isEqualToString:@"(null)"]) {
        STR_zip_code = @"";
         }
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Images_path"];

    
    NSString *img_url = [NSString stringWithFormat:@"%@%@%@",[dict valueForKey:@"awsPath"],[[user_dictionary valueForKey:@"detail"] valueForKey:@"profile_path"],[[user_dictionary valueForKey:@"detail"] valueForKey:@"profile_img"]];
    
    [_IMG_Profile_pic sd_setImageWithURL:[NSURL URLWithString:img_url]
                        placeholderImage:[UIImage imageNamed:@"upload-27.png"]
                                 options:SDWebImageRefreshCached];
    
//    STR_country = [STR_country stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
//    STR_country = [STR_country stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    if ([STR_country containsString:@"<null>"] || [STR_country containsString:@"<nil>"] ||[STR_country isEqualToString:@"<null>"]) {
        _TXT_country.text = @"";
    }
    else{
         _TXT_country.text = STR_country;
    }
    
    
    _TXT_first_name.text = STR_fname;
    _TXT_last_name.text = STR_lname;
    _TXT_land_phone.text = STR_land_phone;
    _TXT_mobile_phone.text = STR_mobile;
    _TXT_country_fld.text =[NSString stringWithFormat:@"+%@",cntry_code];
    _TXT_Dob.text = STR_dob;
    _TXT_group.text = STR_customer_group;
    _TXT_name.text = [NSString stringWithFormat:@"%@ %@",STR_fname,STR_lname];
   
    _TXT_state.text = STR_state;
    _TXT_address1.text = STR_address;
    _TXT_city.text = STR_city;
    _TXT_zipcode.text = STR_zip_code;
    _TXT_email.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"user_email"];
    
    
    if([STR_bank_customer isEqualToString:@"No"])
    {
        
        _BTN_bank_customer.tag = 1;
    }
    else if([STR_bank_customer isEqualToString:@"Yes"])
    {
        _BTN_bank_customer.tag = 0;
    }
    [self BTN_bank_customer_action];
    
    if([STR_bank_employee isEqualToString:@"No"])
    {
        
        _BTN_bank_employee.tag = 0;
    }
    else if([STR_bank_employee isEqualToString:@"Yes"])
    {
        _BTN_bank_employee.tag = 1;
    }
    [self BTN_bank_employee_action];
    
    if([STR_gender isEqualToString:@"Male"])
    {
       
        _BTN_male.tag = 1;
        
    }
    else
    {
        _BTN_male.tag = 0;
    }
    [self BTN_male_action];
    if([STR_gender isEqualToString:@"Female"])
    {
        
        _BTN_feamle.tag = 1;
        
        
    }
    else
    {
        _BTN_feamle.tag = 0;
    }
   [self BTN_female_action];


    
   // [HttpClient stop_activity_animation:self];
    
}

-(void)TEXT_hidden
{
    if(_BTN_save.hidden == YES )
    {
        _LBL_arrow .hidden = YES;
        _TXT_first_name.enabled = NO;
        _TXT_last_name.enabled = NO;
        _TXT_name.enabled = NO;
        _TXT_land_phone.enabled = NO;
        _TXT_mobile_phone.enabled = NO;
        _TXT_country_fld.enabled = NO;
        _TXT_group.enabled = NO;
        _TXT_Dob.enabled = NO;
        _TXT_email.enabled = NO;
        _BTN_male.enabled = NO;
        _BTN_feamle.enabled = NO;
        _BTN_bank_customer.enabled = NO;
        _TXT_mobile_phone.borderActiveColor = [UIColor whiteColor];
        _TXT_land_phone.borderActiveColor  = [UIColor whiteColor];
        _TXT_Dob.borderActiveColor  = [UIColor whiteColor];
        _TXT_first_name.borderActiveColor  = [UIColor whiteColor];
        _TXT_last_name.borderActiveColor  = [UIColor whiteColor];


    }
    else{
         _LBL_arrow .hidden = NO;
        _TXT_first_name.enabled = NO;
        _TXT_last_name.enabled = NO;
        _TXT_name.enabled = NO;
        _TXT_land_phone.enabled = YES;
        _TXT_mobile_phone.enabled = YES;
        _TXT_country_fld.enabled = YES;

        _TXT_group.enabled = YES;
        _TXT_Dob.enabled = YES;
        _TXT_email.enabled = NO;
        _BTN_male.enabled = YES;
        _BTN_feamle.enabled = YES;
        _BTN_bank_customer.enabled = YES;
        _TXT_mobile_phone.borderActiveColor = [UIColor lightGrayColor];
        _TXT_land_phone.borderActiveColor  = [UIColor lightGrayColor];
        _TXT_Dob.borderActiveColor  = [UIColor lightGrayColor];
        _TXT_first_name.borderActiveColor  = [UIColor whiteColor];
        _TXT_last_name.borderActiveColor  = [UIColor whiteColor];

        
    }
}
-(void)TEXT_billing_hidden
{
    if(_BTN_save_billing.hidden == YES)
    {
    _TXT_country.enabled = NO;
    _TXT_state.enabled = NO;
    _TXT_city.enabled = NO;
    _TXT_address1.enabled = NO;
    _TXT_address2.enabled = NO;
    _TXT_zipcode.enabled = NO;
        
        _TXT_country.borderActiveColor = [UIColor whiteColor];
        _TXT_state.borderActiveColor  = [UIColor whiteColor];
        _TXT_city.borderActiveColor  = [UIColor whiteColor];
        _TXT_address1.borderActiveColor  = [UIColor whiteColor];
        _TXT_address2.borderActiveColor  = [UIColor whiteColor];
        _TXT_zipcode.borderActiveColor  = [UIColor whiteColor];


    }
    else
    {
    _TXT_country.enabled = YES;
    _TXT_state.enabled = YES;
    _TXT_city.enabled = YES;
    _TXT_address1.enabled = YES;
    _TXT_address2.enabled = YES;
    _TXT_zipcode.enabled = YES;
        _TXT_country.borderActiveColor = [UIColor lightGrayColor];
        _TXT_state.borderActiveColor  = [UIColor lightGrayColor];
        _TXT_city.borderActiveColor  = [UIColor lightGrayColor];
        _TXT_address1.borderActiveColor  = [UIColor lightGrayColor];
        _TXT_address2.borderActiveColor  = [UIColor lightGrayColor];
        _TXT_zipcode.borderActiveColor  = [UIColor lightGrayColor];


    }
}
-(void)fromdateTextField
{
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    NSDate *eventDate = _date_picker.date;
     [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
    _TXT_Dob.text = [NSString stringWithFormat:@"%@",dateString];
}
-(NSString *)setdata_string:(NSString *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"YYYY-MM-dd"];
    NSDate *eventDate = [formatter dateFromString:date];
     NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"MMM dd, yyyy"];
    
    
    NSString *dateString = [dateFormat stringFromDate:eventDate];
   // _TXT_Dob.text = [NSString stringWithFormat:@"%@",dateString];
    return dateString;
}
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma Post Data
-(void)Save_button_clicked
{
    NSString *msg;
//    if ([_TXT_land_phone.text isEqualToString:@""])
//    {
//        [_TXT_land_phone becomeFirstResponder];
//        msg = @"Please enter Phone Number";
//        
//        
//        
//    }
//    
//    else if (_TXT_land_phone.text.length < 5)
//    {
//        [_TXT_land_phone becomeFirstResponder];
//        msg = @"Phone Number cannot be less than 5 digits";
//        
//        
//        
//    }
//    else if(_TXT_land_phone.text.length>15)
//    {
//        [_TXT_land_phone becomeFirstResponder];
//        msg = @"Phone Number should not be more than 15 characters";
//        
//        
//    }
//    else if([_TXT_land_phone.text isEqualToString:@" "])
//    {
//        [_TXT_land_phone becomeFirstResponder];
//        msg = @"Blank space are not allowed";
//        
//        
//    }

     if ([_TXT_mobile_phone.text isEqualToString:@""])
    {
        [_TXT_mobile_phone becomeFirstResponder];
        msg = @"Please enter Mobile Number";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"الرجاء إدخال رقم الجوال";
        }
    }
    if([_TXT_country_fld.text isEqualToString:@"+974"])
    {
        if (_TXT_mobile_phone.text.length < 8)
        {
            [_TXT_mobile_phone becomeFirstResponder];
            
            msg = @"Mobile Number cannot be less than 8 digits";
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg =@"لا يمكن أن يكون رقم الجوال أقل من 8 أرقام";
            }
        }
        else
        {
            if (_TXT_mobile_phone.text.length > 8)
            {
                [_TXT_mobile_phone becomeFirstResponder];
                
                msg = @"Mobile Number cannot be more than 8 digits";
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    msg =@"رقم الجوال لا يمكن أن يكون أكثر من 8 أرقام";
                }
            }

        }
        
    }
        
    else
    {
         if (_TXT_mobile_phone.text.length < 5)
         {
        [_TXT_mobile_phone becomeFirstResponder];
        
        msg = @"Mobile Number cannot be less than 5 digits";
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg =@" لا يمكن أن يكون رقم الجوال أقل من 5 أرقام";
        }

        
        
        
    }
    else if(_TXT_mobile_phone.text.length>15)
    {
        [_TXT_mobile_phone becomeFirstResponder];
        msg = @"Mobile Number should not be more than 15 characters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg =@"يجب ألا يزيد رقم الجوال عن 15 حرفا";

        }

        
        
    }
    
     if([_TXT_mobile_phone.text isEqualToString:@""])
    {
        [_TXT_mobile_phone becomeFirstResponder];
        msg = @"Blank space are not allowed";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"لا يسمح بترك مسافات فارغة";
        }

        
        
    }
    }
     if([_TXT_Dob.text isEqualToString:@""])
    {
        [_TXT_Dob becomeFirstResponder];
        msg = @"Please enter Date of birth";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى إدخال تاريخ الميلاد";
        }
        
        
    }

    else if([_TXT_Dob.text isEqualToString:@" "])
    {
        [_TXT_Dob becomeFirstResponder];
        msg = @"Blank space are not allowed";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى إدخال تاريخ الميلاد";
        }
        
        
    }
   
   
  else if( _BTN_male.tag == 1 && _BTN_feamle.tag == 1)
   {
    msg = @"Please select Gender";
       
       if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
       {
           msg = @"يرجى تحديد الجنس";

       }
   }
     
    if(msg)
    {
        [HttpClient createaAlertWithMsg:msg andTitle:@""];
        
    }
    else
    {
        [Helper_activity animating_images:self];
        
        [self performSelector:@selector(Edit_user_data) withObject:nil afterDelay:0.01];
        
    }


    
    
}
-(void)Edit_user_data
{
    @try
    {
        NSString *gender;
        if(_BTN_male.tag == 0 && _BTN_feamle.tag == 1)
        {
            gender = @"Male";
        }
        else if(_BTN_feamle.tag == 0 && _BTN_male.tag == 1)
        {
            gender = @"Female";
        }
        
        NSString *fname = _TXT_first_name.text;
        NSString *lname = _TXT_last_name.text;
      //  NSString *email = _TXT_email.text;
        NSString *phone_num = _TXT_land_phone.text;
        NSString *mobile_num = _TXT_mobile_phone.text;
        NSString *customer_group = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"groupid"]];
        NSString *dob = _TXT_Dob.text;
        NSString *dohabank_customer;
        NSString *str = _TXT_country_fld.text;
        str = [str stringByReplacingOccurrencesOfString:@"+" withString:@""];
       
        dohabank_customer = [NSString stringWithFormat:@"%ld",(long)_BTN_bank_customer.tag];
        
        NSString *dohabank_employee = @"0";

        
        NSError *error;//[NSString stringWithFormat:@"%@",cntry_code]
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSDictionary *parameters = @{ @"first_name": fname,
                                      @"last_name": lname,
                                      @"phone": phone_num,
                                      @"mobile": mobile_num,
                                      @"dob":dob,
                                      @"customer_group_id":customer_group,
                                      @"dohabank_customer":dohabank_customer,
                                      @"dohabank_employee":dohabank_employee,
                                      @"gender":gender,@"countrycode_sel":str
                                      };
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *str_id = @"user_id";
        NSString *user_id;
        for(int i = 0;i<[[dict allKeys] count];i++)
        {
            if([[[dict allKeys] objectAtIndex:i] isEqualToString:str_id])
            {
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                break;
            }
            else
            {
                
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            }
        }
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/my-account/2/%@.json",SERVER_URL,user_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
      
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
        

        
        
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        if (error) {
            [Helper_activity stop_activity_animation:self];
        }
        
        if(aData)
        {
           [Helper_activity stop_activity_animation:self];
            
            NSMutableDictionary *json_DATAs = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATAs valueForKey:@"success"]];
            if([status isEqualToString:@"1"])
            {
                NSString *str = @"Ok";
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    str = @"حسنا";
                }
    
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATAs valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:str, nil];
                [alert show];
                _BTN_save.hidden = YES;
                [_BTN_edit setTitle:@"" forState:UIControlStateNormal];
                [self TEXT_hidden];
               // [self Edit_user_data];
                [self scroll_HANDLER];
                
                
            }
            else{
                NSString *str = @"Ok";
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    str = @"حسنا";
                }

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[json_DATAs valueForKey:@"message"] delegate:self cancelButtonTitle:nil otherButtonTitles:str, nil];
                [alert show];
                
            }
            [self View_user_data];
        }
        else
        {
             [Helper_activity stop_activity_animation:self];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                [HttpClient createaAlertWithMsg:@"خطأ في الإتصال" andTitle:@""];
            }
            else{
                [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
            }

        }
    }
    @catch(NSException *exception)
    {
        [Helper_activity stop_activity_animation:self];
    }
    
}
-(void)Save_button_Billing_clicked
{
    NSString *msg;
    
    
    if ([_TXT_state.text isEqualToString:@""])
    {
        [_TXT_state becomeFirstResponder];
        msg = @"Please select State";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى تحديد الدولة";
        }
        
    }
    
    else if ([_TXT_country.text isEqualToString:@""])
    {
        [_TXT_country becomeFirstResponder];
        msg = @"Please select Country";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى تحديد البلد";
        }
        
        
        
    }
    else if(_TXT_city.text.length < 3)
    {
        [_TXT_city becomeFirstResponder];
        msg = @"City should not be less than 3 characters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يقل حقل المدينة عن 3 أحرف";
        }
        
        
    }
    else if(_TXT_city.text.length < 1)
    {
        [_TXT_city becomeFirstResponder];
        msg = @"City Should Not be Empty";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب عدم ترك حقل المدينة فارغاً";
        }
        
        
    }
    else if(_TXT_address1.text.length < 3)
    {
        [_TXT_address1 becomeFirstResponder];
        msg = @"Address name should be more than 3 characters";//يجب أن يكون اسم العنوان أكثر من 3 أحرف

        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب أن يكون اسم العنوان أكثر من 3 أحرف";
        }
        
    }
    else if (_TXT_address1.text.length > 200)
    {
        [_TXT_address1 becomeFirstResponder];
        msg = @"Address should not be more than 200 characters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يزيد العنوان عن 200 رمز";
        }
        
    }

    else if(_TXT_address1.text.length < 1)
    {
        [_TXT_address1 becomeFirstResponder];
        msg = @"Address1 Should Not be Empty";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب  1 عدم ترك حقل العنوان فارغا";
        }
        
        
    }

   /* else if(_TXT_zipcode.text.length < 3)
    {
        [_TXT_zipcode becomeFirstResponder];
        msg = @"Zip code should not be less than 3 characters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يقل حقل الرمز البريدي عن 3 أرقام";
        }
        
    }
    else if(_TXT_zipcode.text.length < 1)
    {
        [_TXT_zipcode becomeFirstResponder];
        msg = @"Zipcode Should not be Empty";
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب عدم ترك حقل الرمز البريدي فارغاً";
        }
        
        
    }*/
    else
    {
        
        [Helper_activity animating_images:self];
        [self performSelector:@selector(Edit_billing_addres) withObject:nil afterDelay:0.01];
    }
    if(msg)
    {
        NSString *str = @"Ok";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str = @"حسنا";
        }
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:str, nil];
        [alert show];

        
    }

}
-(void)Edit_billing_addres
{
    @try
    {
        NSError *error;
        
       // NSString *country = country_id;
       // NSString *state = state_id;
        NSString *city = _TXT_city.text;
        NSString *address = _TXT_address1.text;
        NSString *zipcode = _TXT_zipcode.text;
        NSString *str_fname = _TXT_first_name.text;
        NSString *str_lname = _TXT_last_name.text;
        
        str_fname = [str_fname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        str_lname = [str_lname stringByReplacingOccurrencesOfString:@"<null>" withString:@""];

        
        
        
       // last_name=Bb, address1=Fhgjhg, state_id=3963, country_id=173, first_name=Aaa
        
        //    NSDictionary *parameters = @{ @"country_id": country,
        //                                  @"state_id": state,
        //                                  @"city": city,
        //                                  @"address1": address,
        //                                  @"zip_code":zipcode
        //                                  };
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *str_id = @"user_id";
        NSString *user_id;
        for(int i = 0;i<[[dict allKeys] count];i++)
        {
            if([[[dict allKeys] objectAtIndex:i] isEqualToString:str_id])
            {
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                break;
            }
            else
            {
                
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            }
            
        }
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/my-account/3/%@.json",SERVER_URL,user_id];     NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlGetuser]];
        [request setHTTPMethod:@"POST"];
        
        
        // set Cookie and awllb......
        if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isKindOfClass:[NSNull class]] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isEqualToString:@"<nil>"] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] isEqualToString:@"(null)"]) {
            
            NSString *awlllb = [[NSUserDefaults standardUserDefaults] valueForKey:@"Aws"];
            
            if (![awlllb containsString:@"(null)"]) {
                awlllb = [NSString stringWithFormat:@"%@;%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"],awlllb];
                [request addValue:awlllb forHTTPHeaderField:@"Cookie"];
            }
            else{
                [request addValue:[[NSUserDefaults standardUserDefaults] valueForKey:@"Cookie"] forHTTPHeaderField:@"Cookie"];
            }
            
        }
        

        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"first_name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",str_fname]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"last_name\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",str_lname]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"country_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",country_id]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"state_id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",state_id]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        // another text parameter
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",city]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address1\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",address]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address2\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",@""]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

        
       
        
        
        
        //Phnumber
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"zip_code\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",zipcode]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
       
        NSHTTPURLResponse *response = nil;
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        
        if (returnData)
            
        {
            [Helper_activity stop_activity_animation:self];
            NSMutableDictionary *json_DATAs = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&error];
            NSLog(@"Saving Billing Address.... %@",json_DATAs);
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATAs valueForKey:@"success"]];
            //NSString *status = [json_DATA valueForKey:@"message"];
            
            [Helper_activity stop_activity_animation:self];
            if([status isEqualToString:@"1"])
            {
               
                
                //scroll_ht = _VW_layer_billing.frame.origin.y + _VW_layer_billing.frame.size.height+100;
                 scroll_ht = _VW_billing.frame.origin.y + _VW_billing.frame.size.height;
           
                [self viewDidLayoutSubviews];
                [HttpClient createaAlertWithMsg:[json_DATAs valueForKey:@"message"] andTitle:@""];
                [self View_user_data];
                _BTN_save_billing.hidden = YES;
                [_BTN_edit_billing setTitle:@"" forState:UIControlStateNormal];
                //[self Edit_billing_addres];
                [self TEXT_billing_hidden];
                [self scroll_HANDLER];

               // [self Button_edit_billing_action];
              //  [self Button_edit_billing_action];
                
            }
            else
            {
                 [Helper_activity stop_activity_animation:self];
            }
            
        }
        else
        {
            [Helper_activity stop_activity_animation:self];
        }
        
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [Helper_activity stop_activity_animation:self];
    }
    

    

}

-(void)take_Picture
{
    UIActionSheet *actionSheet;

    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"اختار من"
                                                                 delegate:self
                                                        cancelButtonTitle:@"إلغاء"
                                                   destructiveButtonTitle:nil
                                                        otherButtonTitles:@"الة تصوير", @"صالة عرض", nil];
    }
    else{
        actionSheet = [[UIActionSheet alloc] initWithTitle:@"Pick From"
                                                  delegate:self
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil
                                         otherButtonTitles:@"Camera", @"Gallery", nil];
 
    }
     [actionSheet showInView:self.view];
}
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.allowsEditing = YES;
    if (buttonIndex == 0)
    {
        
        if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            [self presentViewController:picker animated:YES completion:NULL];

        }
        else{              [HttpClient createaAlertWithMsg:@"Camera is not Available" andTitle:@""];
        }
        
           }
    else if (buttonIndex == 1)
    {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:picker animated:YES completion:nil];
    }
}



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(nullable NSDictionary<NSString *,id> *)editingInfo
{
    _IMG_Profile_pic.image = image;
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    UIImage *chosenImage = _IMG_Profile_pic.image;
    _IMG_Profile_pic.image = chosenImage;
    
   [self uploadImage:image];
    
    }



- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [picker dismissViewControllerAnimated:YES completion:nil];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 */

#pragma mark Post Image To Server

-(void)uploadImage:(UIImage *)yourImage
{
    
    
    [Helper_activity animating_images:self];
    NSLog(@"%@",yourImage);
    
   
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *str_id = @"user_id";
    NSString *user_id;
    for(int i = 0;i<[[dict allKeys] count];i++)
    {
        if([[[dict allKeys] objectAtIndex:i] isEqualToString:str_id])
        {
            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
            break;
        }
        else
        {
            
            user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        }
        
    }
    
    
    
    NSString *image_Name = [NSString stringWithFormat:@"%@.jpg",[dict valueForKey:@"firstname"]];

    NSData *imageData = UIImageJPEGRepresentation(yourImage, 1.0);//UIImagePNGRepresentation(yourImage);
    
    NSString *urlString =  [NSString stringWithFormat:@"%@customers/my-account/4/%@.json",SERVER_URL,user_id];

    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
    
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

    
    NSString *boundary = @"---------------------------14737809831466499882746641449";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
    
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"logo\"; filename=\"%@\"\r\n", @"serser.jpg"]] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"logo\"; filename=\"%@\"\r\n", image_Name]] dataUsingEncoding:NSUTF8StringEncoding]];

    
    
    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [request setHTTPBody:body];
    
    NSError *err;
    NSURLResponse *response;
    
   NSData *data= [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&err];
    if (response) {
        [HttpClient filteringCookieValue:response];
    }
    if (err) {
        
        [Helper_activity stop_activity_animation:self];
        NSLog(@"%@",[err localizedDescription]);
    }
    
    if (data) {
        NSMutableDictionary *jsonObject=[NSJSONSerialization
                                  JSONObjectWithData:data
                                  options:NSJSONReadingMutableLeaves
                                  error:nil];
        NSLog(@"jsonObject  %@",jsonObject);
        NSString *str_image_profile = [NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"path_detail"]];
        
        if ([[NSString stringWithFormat:@"%@",[jsonObject valueForKey:@"success"]] isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults] setObject:str_image_profile forKey:@"profile_image"];
            [[NSUserDefaults standardUserDefaults]synchronize];
        }
        
    }
    
    [Helper_activity stop_activity_animation:self];
}

#pragma mark PhoneCodeView
-(void)gettingCountryCodeForMobile
{
    // Getting Countries from JSON File
    
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
    

    
    }

- (IBAction)home_action:(id)sender {
     [self.navigationController popViewControllerAnimated:NO];
}



@end
