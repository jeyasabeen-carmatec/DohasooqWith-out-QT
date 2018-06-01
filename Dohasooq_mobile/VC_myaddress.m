//
//  VC_myaddress.m
//  Dohasooq_mobile
//
//  Created by Test User on 18/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_myaddress.h"
#import "HttpClient.h"
#import "address_cell.h"
#import "billing_address.h"
#import "Helper_activity.h"

@interface VC_myaddress ()<UITableViewDataSource,UITableViewDataSource,UITextFieldDelegate,UIPickerViewDelegate,UIPickerViewDataSource,UIGestureRecognizerDelegate>
{
    
    NSMutableDictionary *jsonresponse_dic_address;
//    UIView *VW_overlay;
//    UIActivityIndicatorView *activityIndicatorView;
    int j ,i;
    BOOL is_add_new,isCountrySelected;
    NSInteger edit_tag,cntry_ID;
    NSMutableArray *stat_arr;
     NSString *country,*str_fname,*str_city,*str_lname,*str_addr1,*str_addr2,*str_zip_code,*str_phone,*str_country,*str_state,*ship_id,*new_address_input,*state_id,*code_cntry;
    UIToolbar *accessoryView;
    NSMutableDictionary *response_countries_dic;
    NSMutableArray *response_picker_arr,*phone_code_arr;
    NSString *cntry_selection,*state_selection,*shpid;//*selection_str,
    
    UITapGestureRecognizer *tapGesture1;
    NSString *flag;

    BOOL isPickerViewScrolled;
    NSString *pickerViewSelection;


}

@end

@implementation VC_myaddress

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"MyAddress screen";

    self.navigationItem.hidesBackButton = YES;
    
    self.navigationController.navigationBar.hidden = NO;
//    is_add_new = NO;
//    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
//    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    VW_overlay.clipsToBounds = YES;
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
    
    tapGesture1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tappedToSelectRow:)];
    tapGesture1.delegate= self;
    tapGesture1.numberOfTapsRequired = 1;
    [_staes_country_pickr addGestureRecognizer:tapGesture1];
    
    [Helper_activity animating_images:self];
    [self performSelector:@selector(Shipp_address_API) withObject:nil afterDelay:0.01];
    
 [self set_UP_VIEW];
   
}
-(void)viewWillAppear:(BOOL)animated
{
    
   
  self.navigationItem.hidesBackButton = YES;   
    
    
}
-(void)set_UP_VIEW
{
    j=0;i = 0;
    
    
    response_picker_arr = [[NSMutableArray alloc]init];
    
    
    jsonresponse_dic_address = [[NSMutableDictionary alloc]init];
    stat_arr = [[NSMutableArray alloc]init];
    stat_arr = [NSMutableArray arrayWithObjects:@"0", nil];
    
    
    //Picker View
    _staes_country_pickr = [[UIPickerView alloc]init];
    _staes_country_pickr.delegate = self;
    _staes_country_pickr.dataSource = self;
    
    accessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    accessoryView.barStyle = UIBarStyleBlackTranslucent;
    [accessoryView sizeToFit];
    
//    UIButton *done=[[UIButton alloc]init];
//    done.frame=CGRectMake(accessoryView.frame.size.width - 100, 0, 100, accessoryView.frame.size.height);
//    [done setTitle:@"Done" forState:UIControlStateNormal];
//    [done addTarget:self action:@selector(picker_done_btn_action) forControlEvents:UIControlEventTouchUpInside];
//    [accessoryView addSubview:done];
//
//
//    UIButton *close=[[UIButton alloc]init];
//    close.frame=CGRectMake(accessoryView.frame.origin.x -20 , 0, 100, accessoryView.frame.size.height);
//    [close setTitle:@"Close" forState:UIControlStateNormal];
//    [close addTarget:self action:@selector(close_ACTION) forControlEvents:UIControlEventTouchUpInside];
//    [accessoryView addSubview:close];
    
    UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(picker_done_btn_action)];
    [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(close_ACTION)];
    [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
    
    
    NSMutableArray *barItems = [NSMutableArray arrayWithObjects:cancelBtn,flexibleItem,doneBtn, nil];
    [accessoryView setItems:barItems animated:YES];
    
    
//
    
    [self gettingCountryCodeForMobile];
     [Helper_activity stop_activity_animation:self];
    

}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
//    NSArray *keys_arr = [[jsonresponse_dic_address valueForKey:@"billaddress"] allKeys];
//    return keys_arr.count;
//
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
        NSInteger ct = 0;
      if(section == 0)
      {
          @try {
              ct = [[[jsonresponse_dic_address valueForKey:@"billaddress"]allKeys]count] ;
 
          } @catch (NSException *exception) {
              ct = 0;
          }
          
          
          
      }
    else if(section == 1)
    {
        @try {
             ct = [[[jsonresponse_dic_address valueForKey:@"shipaddress"]allKeys]count] ;
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
       

    }
    else if(section == 2)
    {
        ct = i ;
        
    }
    
        return ct;
    
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *address_identifier,*billing_identifier;
    NSInteger index;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        address_identifier = @"Qaddress_cell";
        billing_identifier = @"Qbilling_address";
        index = 1;
        
    }
    else{
        address_identifier = @"address_cell";
        billing_identifier = @"billing_address";
        index = 0;
        
        
    }
    
    if(indexPath.section == 0)
    {
       
        address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:address_identifier];
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }

        
        
        
       // cell.VW_layer.layer.shadowColor = [UIColor lightGrayColor].CGColor;
       // cell.layer.shadowOffset = CGSizeMake(0.5, 0);
       // cell.layer.shadowOpacity = 1.0;
        //cell.layer.shadowRadius = 2.0;
        cell.VW_layer.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.VW_layer.layer.borderWidth = 0.5f;
        
        cell.Btn_close_width.constant = 0;
       
        cell.Btn_close.hidden = YES;
        
        if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
             cell.BTN_edit_addres.hidden = YES;
        }
        else{
             cell.BTN_edit_addres.hidden = NO;
        }
        
         [cell.BTN_edit_addres addTarget:self action:@selector(add_new_address:) forControlEvents:UIControlEventTouchUpInside];
        
        if ([[jsonresponse_dic_address valueForKey:@"billaddress"] isKindOfClass:[NSDictionary class]]) {
       
         NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"billaddress"];
        
        
        NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[dict  valueForKey:@"billingaddress"] valueForKey:@"firstname"],[[dict valueForKey:@"billingaddress"] valueForKey:@"lastname"]];
            

             name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
        
        cell.LBL_name.text = name_str;
        cell.LBL_address_type.text = @"BILLING ADDRESS";
        NSString *state = [NSString stringWithFormat:@"%@,",[[dict valueForKey:@"billingaddress"] valueForKey:@"state"]];
        country = [NSString stringWithFormat:@"%@,",[[dict valueForKey:@"billingaddress"] valueForKey:@"country"]];
        str_city = [NSString stringWithFormat:@"%@,",[[dict valueForKey:@"billingaddress"] valueForKey:@"city"]];
         
            if ([str_city containsString:@"<null>"] ||[str_city containsString:@"<nil>"] ) {
                str_city = @"";
            }
            
            if ([state containsString:@"<null>"] ||[state containsString:@"<nil>"] ) {
                state = @"";
            }
            if ([country containsString:@"<null>"]  ||[country containsString:@"<nil>"]) {
                country = @"";
            }
            NSString *addr1 =[NSString stringWithFormat:@"%@,",[[dict valueForKey:@"billingaddress"] valueForKey:@"address1"]];
            
            if ([addr1 containsString:@"<null>"]  ||[addr1 containsString:@"<nil>"] || [addr1 isEqualToString:@","]) {
                addr1 = @"";
            }
            str_zip_code = [[dict valueForKey:@"billingaddress"] valueForKey:@"zip_code"];
            if ([str_zip_code isEqualToString:@"<null>"]  ||[str_zip_code isEqualToString:@"<nil>"] || [str_zip_code isEqualToString:@"(null)"],[str_zip_code isKindOfClass:[NSNull class]]||[str_zip_code isEqualToString:@"null"]) {
                str_zip_code = @"";
            }
            
        
        NSString *address_str = [NSString stringWithFormat:@"%@\n%@ \n%@ %@ %@",addr1,str_city,state,country,str_zip_code];
        
        address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            
        cell.LBL_address.text = address_str;
        }
        
       [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd:) forControlEvents:UIControlEventTouchUpInside];
        cell.BTN_edit.tag =  999;
        
        return cell;

    }
    if(indexPath.section == 1)
    {
        
        
        address_cell *cell = (address_cell *)[tableView dequeueReusableCellWithIdentifier:address_identifier];
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"address_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }
        cell.Btn_close.hidden = NO;
        cell.Btn_close_width.constant = 30;
        cell.BTN_edit_addres.hidden = YES;
        cell.VW_layer.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.VW_layer.layer.borderWidth = 0.5f;

       // cell.layer.shadowColor = [UIColor lightGrayColor].CGColor;
       // cell.layer.shadowOffset = CGSizeMake(0.0, 0.0);
        //cell.layer.shadowOpacity = 1.0;
        //cell.layer.shadowRadius = 4.0;
        NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"shipaddress"];
        NSArray *keys_arr = [dict allKeys];
        
        
        if (keys_arr.count<3 && indexPath.row == keys_arr.count - 1) {
              cell.BTN_edit_addres.hidden = NO;
        }
//        if(indexPath.row == keys_arr.count - 1 )
//        {
//            cell.BTN_edit_addres.hidden = NO;
//        }
        
        
        
        NSString *name_str =[NSString stringWithFormat:@"%@ %@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"]];
        
       // name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
         name_str = [name_str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        
        cell.LBL_name.text = name_str;
        
        if (indexPath.row == 0) {
            cell.LBL_address_type.text = @"SHIPPING ADDRESS";

        }
        cell.LBL_address_type.text = @"";
        
        NSString *state = [NSString stringWithFormat:@"%@,",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state"]];
        
        NSString *country1 = [NSString stringWithFormat:@"%@,",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country"]];
        
        if ([state containsString:@"<null>"] ||[state containsString:@"<nil>"] ) {
            state = @"";
        }
        if ([country1 containsString:@"<null>"]  ||[country1 containsString:@"<nil>"]) {
            country1 = @"";
        }
       str_zip_code = [[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"];
        if ([str_zip_code isEqualToString:@"<null>"]  ||[str_zip_code isEqualToString:@"<nil>"] || [str_zip_code isEqualToString:@"(null)"],[str_zip_code isKindOfClass:[NSNull class]]||[str_zip_code isEqualToString:@"null"]) {
            str_zip_code = @"";
        }
        
        
        NSString *address_str = [NSString stringWithFormat:@"%@,\n%@, \n%@ %@ %@\n%@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"address1"],[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"city"],state,country1,str_zip_code,[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"phone"]];
        
        address_str = [address_str stringByReplacingOccurrencesOfString:@"<null>" withString:@","];
        
        cell.LBL_address.text = address_str;
        
        
        [cell.BTN_edit_addres addTarget:self action:@selector(add_new_address:) forControlEvents:UIControlEventTouchUpInside];
        [cell.BTN_edit addTarget:self action:@selector(BTN_edit_clickd:) forControlEvents:UIControlEventTouchUpInside];
        cell.BTN_edit.tag = indexPath.row;
        
        state_id =[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"state_id"];
        cntry_ID = [[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"country_id"] integerValue];
        
        
        
//        UIImage *newImage = [cell.Btn_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
//        UIGraphicsBeginImageContextWithOptions(cell.Btn_close.image.size, NO, newImage.scale);
//        [[UIColor darkGrayColor] set];
//        [newImage drawInRect:CGRectMake(0, 0, cell.Btn_close.image.size.width, newImage.size.height)];
//        newImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        cell.Btn_close.image = newImage;
        
        cell.Btn_close .userInteractionEnabled = YES;
        NSString *Id_ship = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:indexPath.row]] valueForKey:@"shippingaddress"] valueForKey:@"id"]];
        
        cell.Btn_close.tag = [Id_ship integerValue];
        
        tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close:)];
        
        tapGesture1.numberOfTapsRequired = 1;
        
        [tapGesture1 setDelegate:self];
        
        [cell.Btn_close addGestureRecognizer:tapGesture1];
        
        return cell;
        
    }
    else{
        
            billing_address *cell = (billing_address *)[tableView dequeueReusableCellWithIdentifier:billing_identifier];
            if (cell == nil)
            {
                NSArray *nib;
                nib = [[NSBundle mainBundle] loadNibNamed:@"billing_address" owner:self options:nil];
                cell = [nib objectAtIndex:index];
            }
        
        cell.TXT_cntry_code.hidden = NO;
        cell.TXT_phone.hidden = NO;
        
    
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
        cell.LBL_Blng_title.text = @"تعديل عنوان الشحن";
        }
        else{
             cell.LBL_Blng_title.text = @"EDIT SHIPPING ADDRESS";
        }
        
        
        cell.BTN_check.tag = 0;
        cell.TXT_first_name.delegate = self;
        cell.TXT_last_name.delegate = self;
        cell.TXT_address1.delegate = self;
        cell.TXT_address2.delegate = self;
        cell.TXT_city.delegate = self;
        
        cell.TXT_state.delegate = self;
        cell.TXT_country.delegate = self;
        cell.TXT_zip.delegate = self;
        cell.TXT_email.delegate = self;
        cell.TXT_phone.delegate = self;
        cell.TXT_cntry_code.delegate = self;
        
        
        @try {
            if ([[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] isKindOfClass:[NSDictionary class]]) {
                
                if (edit_tag == 999) {
                    
                   
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                     cell.LBL_Blng_title.text = @"تعديل عنوان الفاتورة ";
                    }
                    else{
                          cell.LBL_Blng_title.text = @"EDIT BILLING ADDRESS";
                    }
                    
                    
                country = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"country"]];
            str_fname = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"firstname"]];
            str_city = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"city"]];
              
              str_lname = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"lastname"]];
              str_addr1 = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address1"]];
              str_addr2 = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"address2"]];
              
              str_zip_code = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"zip_code"]];
             str_phone = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"phone"]];
              str_country = country;

              str_state = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"state"]];
        state_id = [NSString stringWithFormat:@"%@", [[[jsonresponse_dic_address valueForKey:@"billaddress"] valueForKey:@"billingaddress"] valueForKey:@"state_id"]];
                    
                    
                    
                    
                    
               //Hiding Phone NUmber
                    cell.TXT_cntry_code.hidden = YES;
                    cell.TXT_phone.hidden = YES;
                    
                  
                   
                    CGRect frame = cell.Btn_save.frame;
                    frame.origin.y= cell.TXT_phone.frame.origin.y+40;
                    
                    cell.Btn_save.frame= frame;
                    
                    
            }
            }

        
        if ([[jsonresponse_dic_address valueForKey:@"shipaddress"] isKindOfClass:[NSDictionary class]]) {
            
            NSMutableDictionary *dict = [jsonresponse_dic_address valueForKey:@"shipaddress"];
            
            NSArray *keys_arr = [dict allKeys];
        if (edit_tag != 999) {
            
            cell.TXT_cntry_code.hidden = NO;
            cell.TXT_phone.hidden = NO;
            
                country = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"country"]];
              
              //country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@"Not mentioned"];
              
              str_fname = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"firstname"]];
              
              str_lname =[NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"lastname"]];
              str_addr1 = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"address1"]];
              str_addr2 = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"address2"]];
              str_city = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"city"]];
              str_zip_code = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"zip_code"]];
              str_phone = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"phone"]];
            code_cntry = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"phonecode"]];
            if ([code_cntry containsString:@"<null>"]||[code_cntry containsString:@"<nil>"]||[code_cntry isEqualToString:@""] ) {
                code_cntry = @"974";
            }
            code_cntry=[NSString stringWithFormat:@"+%@",code_cntry];
            
              str_country = country;
              str_state =[NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"state"]];
            ship_id = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"id"]];
            //state_id = [NSString stringWithFormat:@"%@",[[[dict valueForKey:[keys_arr objectAtIndex:edit_tag]] valueForKey:@"shippingaddress"] valueForKey:@"state_id"]];
            new_address_input = @"0";
        }
            
      }
            
            
            if ([str_country isEqualToString:@""] || [str_country isEqualToString:@"<nil>"]  || [str_country isEqual:[NSNull class]] ||[str_country isEqualToString:@"<null>"]) {
                cell.TXT_country.text = @"";
            }
            else{
                cell.TXT_country.text = str_country;
            }
            
            
            if ([str_state isEqualToString:@""] || [str_state isEqualToString:@"<nil>"]  || [str_state isEqual:[NSNull class]]||[str_state isEqualToString:@"<null>"]) {
                cell.TXT_state.placeholder =@"";
            }
            else{
                cell.TXT_state.text = str_state;
            }
            
            if ([str_city isEqualToString:@"<null>"] || [str_city isEqualToString:@"<nil>"]  || [str_city isEqual:[NSNull class]]) {
               str_city = @"";
            }
            if ([str_addr1 isEqualToString:@"<null>"] || [str_addr1 isEqualToString:@"<nil>"]  || [str_addr1 isEqual:[NSNull class]]) {
                str_addr1 = @"";
            } if ([str_addr2 isEqualToString:@"<null>"] || [str_addr2 isEqualToString:@"<nil>"]  || [str_addr2 isEqual:[NSNull class]]) {
                str_addr2 = @"";
            }
            
            
            if ([str_zip_code isEqualToString:@"<null>"]  ||[str_zip_code isEqualToString:@"<nil>"] || [str_zip_code isEqualToString:@"(null)"],[str_zip_code isKindOfClass:[NSNull class]]||[str_zip_code isEqualToString:@"null"]) {
                str_zip_code = @"";
            }

            
            cell.TXT_first_name.text = str_fname;
            cell.TXT_last_name.text = str_lname;
            cell.TXT_address1.text = str_addr1;
            cell.TXT_address2.text = str_addr2;
            cell.TXT_city.text = str_city;
            
            
           
            cell.TXT_zip.text = str_zip_code;
            cell.TXT_phone.text = str_phone;
            cell.TXT_cntry_code.text = code_cntry;
        
        if (is_add_new) {
            
            cell.TXT_cntry_code.hidden = NO;
            cell.TXT_phone.hidden = NO;
            cell.Btn_save.hidden = NO;
            
            
            
            CGRect frame = cell.Btn_save.frame;
            frame.origin.y= cell.TXT_phone.frame.origin.y+50;
            
            cell.Btn_save.frame= frame;
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                cell.LBL_Blng_title.text = @"إضافة عنوان جديد";
            }
            else{
             cell.LBL_Blng_title.text = @"ADD NEW ADDRESS";
            }
            
            
            
            cell.TXT_first_name.text = @"";
            cell.TXT_last_name.text = @"";
            cell.TXT_address1.text = @"";
            cell.TXT_address2.text = @"";
            cell.TXT_city.text = @"";
            cell.TXT_state.text = @"";
            cell.TXT_country.text = @"";
            cell.TXT_zip.text = @"";
            cell.TXT_phone.text = @"";
            cell.TXT_cntry_code.text = @"+974";
            new_address_input = @"1";
        }
       
        cell.TXT_email.text = [[NSUserDefaults standardUserDefaults]valueForKey:@"email"];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
   
        
        
        [cell.Btn_save addTarget:self action:@selector(save_btn_action:) forControlEvents:UIControlEventTouchUpInside];
        
            return cell;
        
    }
    
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 0)
    {
        return @"BILLING ADDRESS";
    }
    if (section == 1)
     {
       return @"SHIPPING ADDRESS";
     }
     else{
         return @"";
     }
}
-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,_TBL_address.frame.size.width, 60)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *label = [[UILabel alloc] initWithFrame: CGRectMake(10,0, _TBL_address.frame.size.width-20, 30)];
    label.backgroundColor = [UIColor clearColor];
    label.autoresizingMask = UIViewAutoresizingFlexibleRightMargin;
    
    [headerView addSubview:label];
    label.textColor = [UIColor lightGrayColor];
    [label setFont:[UIFont fontWithName:@"Poppins-Regular" size:15]];
    if (section == 0)
    {
        label.text=@"BILLING ADDRESS";
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            label.text = @"عنوان الفاتورة ";
            label.textAlignment = NSTextAlignmentRight;
        }
        
    }
    else
    {
        label.text= @"SHIPPING ADDRESS";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            label.text = @"عنوان الشحن";
            label.textAlignment = NSTextAlignmentRight;
        }
    }
    
    
    return headerView;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section == 0 || section == 1)
    {
    return 30;
    }
    else{
        return 0;
    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
        if(indexPath.section == 2)
        {
            return 530.0;
            
            
        }
//    return UITableViewAutomaticDimension;
        else{
            return 155;
        }
    
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath

{
    if(indexPath.section == 2)
    {
        return 530.0;
        
        
    }
    //    return UITableViewAutomaticDimension;
    else{
        return UITableViewAutomaticDimension;

    }

}


#pragma mark delete shipping address action

-(void)tapGesture_close:(UITapGestureRecognizer *)tapgstr{
    
//    CGPoint location = [tapGesture1 locationInView:_TBL_address];
//    NSIndexPath *indexPath = [_TBL_address indexPathForRowAtPoint:location];
    //
    //    //Cart_cell *cell = (Cart_cell *)[_TBL_cart_items cellForRowAtIndexPath:indexPath];
    //    product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];

    
     UIView *view = tapgstr.view;
    shpid = [NSString stringWithFormat:@"%ld",(long)[view tag]];
    UIAlertView *alert;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        alert = [[UIAlertView alloc] initWithTitle:@"" message:@"هل أنت متأكد أنك تريد حذف" delegate:self cancelButtonTitle:@"حسنا" otherButtonTitles:@"إلغاء", nil];
       
    }
    else{
       alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Are you sure you want to Delete?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
       
    }
    
    alert.tag = 1;
    [alert show];
    NSLog(@"the cancel clicked");
}

- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
    if (tapRecognizer.state == UIGestureRecognizerStateEnded) {
        CGFloat rowHeight = [_staes_country_pickr rowSizeForComponent:0].height;
        CGRect selectedRowFrame = CGRectInset(_staes_country_pickr.bounds, 0.0, (CGRectGetHeight(_staes_country_pickr.frame) - rowHeight) / 2.0 );
        BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_staes_country_pickr]));
        if (userTappedOnSelectedRow) {
            NSInteger selectedRow = [_staes_country_pickr selectedRowInComponent:0];
            [self pickerView:_staes_country_pickr didSelectRow:selectedRow inComponent:0];
            
        }
        
    }
   
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return true;
}




#pragma mark Shipp_address_API
-(void)Shipp_address_API
{
    
    
    @try {
     [Helper_activity animating_images:self];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSString *country_id = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressessapi/%@/%@/%@.json",SERVER_URL,user_id,country_id,languge];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    
                    
                    [Helper_activity stop_activity_animation:self];
                    @try {
                        if ([data isKindOfClass:[NSDictionary class]]) {
                            jsonresponse_dic_address = data;
                           
                            [_TBL_address reloadData];
                            NSLog(@"*******%@*********",data);
                        }
                        else{
                            NSLog(@"The data is in unknown format");
                        }
                        
                       
                    } @catch (NSException *exception) {
                        [Helper_activity stop_activity_animation:self];

                        
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


-(void)BTN_check_clickd
{
    if([[stat_arr objectAtIndex:0] isEqualToString:@"1"])
    {
    [stat_arr replaceObjectAtIndex:0 withObject:@"0"];
    }
    else
    {
        [stat_arr replaceObjectAtIndex:0 withObject:@"1"];

    }
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:2];
    NSMutableArray *indexPaths = [[NSMutableArray alloc] initWithObjects:indexPath, nil];
    [self.TBL_address beginUpdates];
    [self.TBL_address reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationNone];
    [self.TBL_address endUpdates];
}

-(void)BTN_edit_clickd:(UIButton *)sender
{
    
    edit_tag = sender.tag ;
    is_add_new = NO;
    i = 1;
    [self.TBL_address reloadData];
}
-(void)add_new_address:(UIButton *)sender{
    is_add_new = YES;
    i = 1;
    [self.TBL_address reloadData];
}
-(void)save_btn_action:(UIButton *)sender{
    
    billing_address *cell = [self.TBL_address cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    
   str_fname = cell.TXT_first_name.text ;
     str_lname=cell.TXT_last_name.text ;
   str_addr1 =   cell.TXT_address1.text;
    str_addr2 =cell.TXT_address2.text  ;
     str_city = cell.TXT_city.text ;
    str_state = cell.TXT_state.text  ;
    str_country = cell.TXT_country.text ;
    str_zip_code = cell.TXT_zip.text ;
    str_phone =  cell.TXT_phone.text ;
    code_cntry = cell.TXT_cntry_code.text;
    code_cntry = [code_cntry stringByReplacingOccurrencesOfString:@"+" withString:@""];
    
    
    if ([str_zip_code isEqualToString:@""]) {
        str_zip_code = @" ";
    }
    
    NSString *msg;
    
    if ([str_fname isEqualToString:@""]) {
        
        [cell.TXT_first_name becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى تعبئة حقل الاسم الأول";
        }
        else{
            msg = @"Please enter First Name field";

        }
        
    }
    else if (str_fname.length<3 )
    {
        [cell.TXT_first_name becomeFirstResponder];
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يقل الاسم الأول عن 3 حروف";
        }else{
            msg = @"First name should not be less than 3 characters";

        }

    }
    else if (str_fname.length > 30)
    {
        [cell.TXT_first_name becomeFirstResponder];
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يزيد الاسم الأول عن 30 حرفاً";
        }
        else{
            msg = @"First name should not be more than 30 characters";

        }
        
    }

    
    else if ([str_lname isEqualToString:@""]) {
        
        [cell.TXT_last_name becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى تعبئة حقل الاسم الأخير ";
        }
        else{
            msg = @"Please enter Last Name field";

        }

        
    }
    else if(str_lname.length < 1)
    {
        [cell.TXT_last_name becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"الكنية ألا يقل الاسم الأول عن 3 حروف";
        }
        else{
            msg = @"Last name should not be less than 3 characters";

        }

        
    }
    else if (str_lname.length>30)
    {
        [cell.TXT_last_name becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"ألا يزيد اسم العائلة عن 30 حرفا";
        }
        else{
            msg = @"Last name should not be more than 30 characters";

        }

        
    }
    else if ([str_addr1 isEqualToString:@""]) {
        
        [cell.TXT_address1 becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب  1 عدم ترك حقل العنوان فارغا";
        }
        else{
            msg = @"Address1 Should Not be Empty";

        }
        
    }
    else if(str_addr1.length < 3)
    {
        [cell.TXT_address1 becomeFirstResponder];
   
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب أن يكون اسم العنوان أكثر من 3 أحرف";
        }
        else{
             msg = @"Address name should be more than 3 characters";//يجب أن يكون اسم العنوان أكثر من 3 أحرف
        }
        
    }
    else if (str_addr1.length > 200)
    {
        [cell.TXT_address1 becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يزيد العنوان عن 200 رمز";
        }
        else{
            msg = @"Address should not be more than 200 characters";

        }
        
    }

    
    else if ([str_city isEqualToString:@""]) {
        
        [cell.TXT_city becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب عدم ترك حقل المدينة فارغاً";
        }
        else{
            msg = @"City Should Not be Empty";

        }
        
    }
    else if (str_city.length<3)
    {
        [cell.TXT_city becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يقل حقل المدينة عن 3 أحرف";
        }
        else{
            msg = @"City should not be less than 3 characters";

        }

    }
    else if (str_city.length > 30)
    {
        [cell.TXT_city becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يزيد حقل المدينة عن 30 حرفاً";
        }
        else{
            msg = @"City should not be more than 30 characters";

        }
        
    }

//    else if ([str_zip_code isEqualToString:@""]) {
//        
//        [cell.TXT_zip becomeFirstResponder];
//        msg = @"Zipcode Should not be Empty";
//        
//        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//        {
//            msg = @"يجب عدم ترك حقل الرمز البريدي فارغاً";
//        }
//   
//        
//    }
//    else if (str_zip_code.length < 3)
//    {
//        [cell.TXT_zip becomeFirstResponder];
//        msg = @"Zip code should not be less than 3 characters";
//        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//        {
//            msg = @"يجب ألا يقل حقل الرمز البريدي عن 3 أرقام";
//        }
//        
//    }
//
//    else if (str_zip_code.length>10)
//    {
//        [cell.TXT_zip becomeFirstResponder];
//        msg = @"Zip code should not be more than 10 characters";
//        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//        {
//            msg = @"يجب ألا يزيد حقل الرمز البريدي عن 10 أرقام ";
//        }
//
//    }
    else if ([str_country isEqualToString:@""])
    {
        [cell.TXT_country becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى تحديد البلد";
        }
        else{
            msg = @"Please Select Country";

        }
    }
    
 
    else if ([str_state isEqualToString:@""])
    {
        [cell.TXT_state becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
          msg = @"يرجى تحديد الولاية";
        }
        else{
            msg = @"Please Select State";//يرجى تحديد البلد

        }
        
    }
       else if (edit_tag != 999)
       {
        
        if ([str_phone isEqualToString:@""])
        {
            
            [cell.TXT_phone becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"رقم الهاتف ترك حقل المدينة فارغاً";
            }
            else{
                msg = @"Phone Number  Should Not be Empty";

            }
            
        }
         if ([code_cntry isEqualToString:@"974"])
        {
            if(str_phone.length < 8)
            {
            [cell.TXT_phone becomeFirstResponder];
              
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    msg =@"رقم الهاتف لا يمكن أن يكون أقل من 8 أرقام ";
                    
                }
                else{
                    msg = @"Phone Number cannot be less than 8 digits";

                }
            }
            
            if(str_phone.length > 8)
            {
                [cell.TXT_phone becomeFirstResponder];
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    msg = @"رقم الهاتف لا يمكن أن يكون أكثر من 8 أرقام";
                    ;
                }
                else{
                    msg = @"Phone Number cannot be more than 8 digits";

                }
            }

            else
            {
                if (str_phone.length<5)
                {
                [cell.TXT_phone becomeFirstResponder];
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        msg =@"رقم الهاتف لا يمكن أن يكون أقل من 5 أرقام ";
                    }
                    else{
                        msg = @"Phone Number cannot be less than 5 digits";

                    }
                }
                else if (str_phone.length > 15)
                {
                [cell.TXT_phone becomeFirstResponder];
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        msg = @"لا يجب أن يتجاوز رقم الهاتف 15 أرقام";
                    }
                    else{
                        msg = @"Phone Number cannot be more than 15 digits";

                    }
                }
                

            }
                
            
        }

        else if (![str_country isEqualToString:@"Qatar"])
        {
            [cell.TXT_country becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يرجى تحديد البلد";
            }
            else{
                msg = @"Sorry! we cannot Ship Products Outside Qatar";

            }
        }

    }
    
    if (msg) {
        
        NSString *str = @"Ok";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str = @"حسنا";
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:str, nil];
        [alert show];
    }
    else if (edit_tag == 999) {
        
         [Helper_activity animating_images:self];
        [self performSelector:@selector(edit_Billing_address_API) withObject:nil afterDelay:0.01];
    }
    else if (is_add_new){
        
        [self add_new_ship_address];
    }
    else{
        
        [Helper_activity animating_images:self];

        [self performSelector:@selector(edit_Shipping_Address) withObject:nil afterDelay:0.01];
   
    }
    
}

- (IBAction)back_ACTIon:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark edit_Shipping_Address
/*http://192.168.0.171/dohasooq/apis/shipaddressadd.json*/

-(void)edit_Shipping_Address{
    @try {
        
        NSString *cntr_id = [NSString stringWithFormat:@"%ld",(long)cntry_ID];
         NSDictionary *params = @{@"FirstName":str_fname,@"LastName":str_lname,@"country":cntr_id,@"state":state_id,@"city":str_city,@"address1":str_addr1,@"address2":str_addr2,@"zipcode":str_zip_code,@"newaddressinput":@"0",@"customerId":[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],@"shipaddressId":ship_id,@"mobile":str_phone,@"mobilecode":code_cntry};
        
        
        NSLog(@"%@",params);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressadd.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient api_with_post_params:urlGetuser andParams:params completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
                     ];
                }
                if (data) {
                    [Helper_activity stop_activity_animation:self];
                    

                    NSLog(@"edit_Shipping_Address Response%@",data);
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        
                        
                        if ([[data valueForKey:@"success"] isEqualToString:@"success"]) {
                            i=i-1;
//                            NSString *str = @"Ok";
//                            NSString *str_msg = @"Shipping Address Updated Successfully.";
//                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//                            {
//                                str = @"حسنا";
//                                str_msg =  @"عنوان الشحن تم تحديثه بنجاح.";
//                            }
//                            
//                            
//                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_msg delegate:self cancelButtonTitle:nil otherButtonTitles:str, nil];
//                            [alert show];
                           
                              [HttpClient createaAlertWithMsg:[data valueForKey:@"msg"] andTitle:@""];
                            
                            [self Shipp_address_API];
                        }
                        else{
                             [HttpClient createaAlertWithMsg:[data valueForKey:@"msg"] andTitle:@""];
                        }
                        
                        
                        
                        
                    }
                   
                }
                
            });
        }];
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        [Helper_activity stop_activity_animation:self];

    }
}

#pragma mark edit_Billing_address_API
/*Edit billing api
 http://192.168.0.171/dohasooq/customers/my-account/3/userid.json */

-(void)edit_Billing_address_API{
    @try {
        

        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *str_id = @"user_id";
        NSString *user_id;
        for(int f = 0;f<[[dict allKeys] count];f++)
        {
            if([[[dict allKeys] objectAtIndex:f] isEqualToString:str_id])
            {
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:str_id]];
                break;
            }
            else
            {
                
                user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
            }
            
        }
        
        
        
        
         NSDictionary *params = @{@"first_name":str_fname,@"last_name":str_lname,@"country_id":[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"],@"state_id":state_id,@"city":str_city,@"address1":str_addr1,@"address2":str_addr2,@"zip_code":str_zip_code};
        
        NSLog(@"Billing params %@",params);
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/my-account/3/%@.json ",SERVER_URL,user_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient api_with_post_params:urlGetuser andParams:params completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
                     ];
                }
                if (data) {
                    
                    if ([data isKindOfClass:[NSDictionary class]]) {
                        
                        @try {
                            [Helper_activity stop_activity_animation:self];

                             NSLog(@"edit_Shipping_Address Response%@",[data valueForKey:@"success"]);
                            NSString *succs = [NSString stringWithFormat:@"%@",[data valueForKey:@"success"]];
                            if ([succs isEqualToString:@"success"] || [succs isEqualToString:@"1"] ) {
                                i=i-1;
                                
                                [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                                

                                 [self Shipp_address_API];
                               }
                            else{
                                 [Helper_activity stop_activity_animation:self];
                                 [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                            }
                            
                           

                            
                
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                            [Helper_activity stop_activity_animation:self];

                        }
                    }
                    
                    //NSLog(@"edit_Shipping_Address Response%@",[data valueForKey:@"success"]);
                    
                }
                
            });
        }];
        
        
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        [Helper_activity stop_activity_animation:self];

        
    }

}


#pragma mark text field delgates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    isPickerViewScrolled = NO;
    
    
    if (textField.tag == 3) {
        [self animatingViewWhileEditingTextField:-150 andTextField:textField];
    }
    
    if (textField.tag == 4 || textField.tag == 5 ||textField.tag == 6||textField.tag == 7||textField.tag == 8 ) {
//        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
//        [UIView beginAnimations:nil context:NULL];
//        self.navigationController.view.frame = CGRectMake(0,-270,self.view.frame.size.width,self.view.frame.size.height);
//        [UIView commitAnimations];
        
        [self animatingViewWhileEditingTextField:-250 andTextField:textField];

        
    }
    
    
    if (textField.tag == 10) {
        
//        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
//        [UIView beginAnimations:nil context:NULL];
//        self.navigationController.view.frame = CGRectMake(0,-200,self.view.frame.size.width,self.view.frame.size.height);
//        [UIView commitAnimations];
        [self animatingViewWhileEditingTextField:-200 andTextField:textField];


    }
    if (textField.tag == 8) {
        
        pickerViewSelection = @"country";

        
        isCountrySelected = YES;
        textField.inputView = _staes_country_pickr;
        
        textField.inputAccessoryView = accessoryView;
        
        
        if (edit_tag!=999) {
            [self ShippingCountryAPICall];
        }
        else{
             [self CountryAPICall];
        }
    
    }
    if (textField.tag == 6) {
        
        pickerViewSelection = @"country";
        
        isCountrySelected = NO;
        textField.inputView = _staes_country_pickr;
        textField.inputAccessoryView = accessoryView;
        [self stateApiCall];
    }
    if (textField.tag == 11) {
        
        pickerViewSelection = @"phone";
        
        textField.inputView = _phone_picker_view;
        textField.inputAccessoryView = accessoryView;
//        
//        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
//        [UIView beginAnimations:nil context:NULL];
//        self.navigationController.view.frame = CGRectMake(0,-200,self.view.frame.size.width,self.view.frame.size.height);
//        [UIView commitAnimations];
        [self animatingViewWhileEditingTextField:-200 andTextField:textField];

    }
    

}
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    billing_address *cell = [self.TBL_address cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:2]];
    str_phone =  cell.TXT_phone.text ;
    
    NSInteger inte = str_phone.length;
    
    
    NSLog(@"%@",str_phone);
    if([code_cntry isEqualToString:@"+974"])
    {
        if(textField.tag == 10)
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
    NSString *resultString = [[cell.TXT_phone.text componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
    
   cell.TXT_phone.text = resultString;

    
    return YES;
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
    if (textField.tag == 6) {
        textField.text = state_selection;
    }
    
if (textField.tag == 8) {
    
     billing_address *textFieldRowCell;
    textFieldRowCell = (billing_address *) textField.superview.superview.superview;
     NSIndexPath *indexPath = [self.TBL_address indexPathForCell:textFieldRowCell];
//    
//    NSLog(@"The index path is %@",indexPath);
//    
    textFieldRowCell = (billing_address *)[self.TBL_address cellForRowAtIndexPath:indexPath];
    textField.text = cntry_selection;
    [textFieldRowCell.TXT_state setText:state_selection];
    
    NSLog(@"%@",textFieldRowCell.TXT_state.text);
    if ([textField.text isEqualToString:@""]) {
        
       NSString  *msg = @"Please Select Country";
         NSString *str = @"Ok";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str = @"حسنا";
            msg = @"يرجى تحديد البلد";
        }

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:str, nil];
        [alert show];    }else{
        
    }
    //textFieldRowCell.TXT_state.placeholder = @" Select State";

}
    if (textField.tag == 11) {
        textField.text = flag;
    }
    
    
    
    if (textField.tag == 10 || textField.tag == 11||textField.tag == 4 || textField.tag == 5 ||textField.tag == 6||textField.tag == 7||textField.tag == 8) {
        [self animatingViewWhileEditingTextField:0 andTextField:textField];
//        
//        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
//        [UIView beginAnimations:nil context:NULL];
//        self.navigationController.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
//        [UIView commitAnimations];

    }
}

-(void)animatingViewWhileEditingTextField:(float)YAxis andTextField:(UITextField *)textField{
    
    [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
    [UIView beginAnimations:nil context:NULL];
    self.navigationController.view.frame = CGRectMake(0,YAxis,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}



#pragma mark CountryAPI Call
//http://192.168.0.171/dohasooq/'apis/countriesapi.json
-(void)CountryAPICall{
    @try {
        response_countries_dic = [NSMutableDictionary dictionary];
        NSString *country_ID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/countriesapi/%@.json",SERVER_URL,country_ID];
        @try
        {
            NSError *error;
           // NSError *err;
            NSHTTPURLResponse *response = nil;
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
            if (error) {
                
                
                 [Helper_activity stop_activity_animation:self];
               
            }
            
            if(aData)
            {
                
                response_picker_arr = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&error];
                //NSLog(@"The response Api post sighn up API %@",json_DATA);
                
                [_staes_country_pickr reloadAllComponents];
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


#pragma mark Shipping Country API Call (For Shipping Address)


-(void)ShippingCountryAPICall{
    //http://localhost/dohasooq/apis/countiresShipapi.json
    
    
    @try {
        
        
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
                            
                           [response_picker_arr removeAllObjects];
                           [response_picker_arr addObjectsFromArray:data];
                                
                           
                           }
                       else{
                           [HttpClient createaAlertWithMsg:@"The Data Could not be read" andTitle:@""];
                       }
                           
//
                            [_staes_country_pickr reloadAllComponents];
                            
                       // }
                        
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
        response_picker_arr = [NSMutableArray array];
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/getstatebyconapi/%ld.json",SERVER_URL,(long)cntry_ID];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        @try {
                            if ([data isKindOfClass:[NSArray class]]) {
                                
                                //[arr_states addObjectsFromArray:data];
                                [response_picker_arr removeAllObjects];
                                
                               // response_picker_arr = data;
                                
                                NSSortDescriptor *sortDescriptor;
                                sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"value"
                                                                             ascending:YES];
                                NSArray *sortedArr = [data sortedArrayUsingDescriptors:@[sortDescriptor]];
                                
                                NSLog(@"sortedArr %@",sortedArr);
                                
                              //  [response_picker_arr removeAllObjects];
                                [response_picker_arr addObjectsFromArray:sortedArr];
                                [_staes_country_pickr reloadAllComponents];
//                                [self.staes_country_pickr selectRow:0 inComponent:0 animated:NO];
//                                [self pickerView:self.staes_country_pickr didSelectRow:0 inComponent:0];
                                
                            }
                            else{
                                [HttpClient createaAlertWithMsg:@"The Data Could not be read" andTitle:@""];
                            }
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                        }
                        
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
}

#pragma mark UIPickerViewDelegate and UIPickerViewDataSource


/*-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
 {
 return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"dial_code"]];
 
 }*/


- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
   
    if (pickerView == self.phone_picker_view) {
        
        return phone_code_arr.count;
        
    }else{
        return response_picker_arr.count;
    }
    
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    

    if (pickerView == self.phone_picker_view) {
        
        return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"code"]];
    }
    else{
    
    @try {
        if (isCountrySelected) {
            return [[response_picker_arr objectAtIndex:row] valueForKey:@"name"];
        }
        else{
            
            return [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    }
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    isPickerViewScrolled = YES;
    
    [self PickerViewCustomSelection:row];
    
  /*  if (pickerView == self.phone_picker_view) {
        flag = [NSString stringWithFormat:@"%@",[phone_code_arr[row] valueForKey:@"code"]];
      
    }
    else{
        
        if (isCountrySelected) {
            @try {
                
                cntry_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_name"];
                
                cntry_ID = [[[response_picker_arr objectAtIndex:row] valueForKey:@"cntry_id"] integerValue];
            
                state_selection = @"";
                
                //  NSLog(@"country::%@",cntry_selection);
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        else{
            @try {
                
                state_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
                
                state_id = [[response_picker_arr objectAtIndex:row] valueForKey:@"key"];
                //NSLog(@"State::%@",state_selection);
            } @catch (NSException *exception) {
                state_selection = @"";
            }
            
        }
    } */
}


-(void)PickerViewCustomSelection:(NSInteger )row{
    
    if ([pickerViewSelection isEqualToString:@"phone"]) {
        NSLog(@"00000000000000");
     flag = [NSString stringWithFormat:@"%@",[phone_code_arr[row] valueForKey:@"code"]];
    }
    else if ([pickerViewSelection isEqualToString:@"country"]){
        NSLog(@"11111111111111");

        if (isCountrySelected) {
            @try {
                
                cntry_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"name"];
                
                cntry_ID = [[[response_picker_arr objectAtIndex:row] valueForKey:@"id"] integerValue];
                
                state_selection = @"";
                
                //  NSLog(@"country::%@",cntry_selection);
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }
        }
        else if([pickerViewSelection isEqualToString:@"countryship"])
        {
            @try {
                
                cntry_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"name"];
                
                cntry_ID = [[[response_picker_arr objectAtIndex:row] valueForKey:@"id"] integerValue];
                
                state_selection = @"";
                
                //  NSLog(@"country::%@",cntry_selection);
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
            }

        }
        else{
            @try {
                
                state_selection = [[response_picker_arr objectAtIndex:row] valueForKey:@"value"];
                
                state_id = [[response_picker_arr objectAtIndex:row] valueForKey:@"key"];
                //NSLog(@"State::%@",state_selection);
            } @catch (NSException *exception) {
                state_selection = @"";
            }
            
        }
    }
}


#pragma mark picker_done_btn_action
-(void)picker_done_btn_action{
    
    if (!isPickerViewScrolled) {
        
        NSLog(@"PickerViewCustomSelection");
        [self PickerViewCustomSelection:0];
    }
    
    [self.view endEditing:YES];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
}
-(void)close_ACTION{
    [self.view endEditing:YES];
}


/*
 Delete Shipping Address
 
 
 Function Name : Apis/shipaddressdelete.json
 Parameters :customerId,shipId
 Method : POST*/
#pragma mark DeleShippingAddress
-(void)deleteShipping_address:(NSString *)cust_id andShipID:(NSString *)shipid{
    
    @try {
        
        
        NSDictionary *params = @{@"customerId":cust_id,@"shipId":shipid};
        
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@Apis/shipaddressdelete.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        @try {
            
            [HttpClient api_with_post_params:urlGetuser andParams:params completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (error) {
                        NSLog(@"%@",[error localizedDescription]);
                    }
                    if (data) {
                        @try {
                            NSLog(@"%@",data);
                            
                            if ([data isKindOfClass:[NSDictionary class]]) {
                                
                                if ([[data valueForKey:@"msg"] isEqualToString:@"success"]) {
                                    
                                    [self Shipp_address_API];
                                    
                                }
                              
                                    [HttpClient createaAlertWithMsg:[data valueForKey:@"multi_msg"] andTitle:@""];
                             
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
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
    
    
}

#pragma mark add_new_shipping_address_API
/*Add shipping api
 http://192.168.0.171/dohasooq/apis/shipaddressadd.json
 [10:38 AM] Bindal Gami: params.put("FirstName", user_firstname);
                 params.put("LastName", user_lastname);
                 params.put("country", user_countrys);
                 params.put("state", user_state);
                 params.put("city", user_city);
                 params.put("address1", user_address1);
                 params.put("address2", user_address2);
                 params.put("zipcode", user_zip_code);
                 params.put("newaddressinput", user_address_token);
                 params.put("customerId", customerid);*/

-(void)add_new_ship_address{
    @try
    {
        NSString *cntr_id = [NSString stringWithFormat:@"%ld",(long)cntry_ID];
        
       NSDictionary *params = @{@"FirstName":str_fname,@"LastName":str_lname,@"country":cntr_id,@"state":state_id,@"city":str_city,@"address1":str_addr1,@"address2":str_addr2,@"zipcode":str_zip_code,@"newaddressinput":new_address_input,@"customerId":[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],@"mobile":str_phone,@"mobilecode":code_cntry};
        NSLog(@"%@",params);
        
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/shipaddressadd.json",SERVER_URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlGetuser]];
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
        //    [request setHTTPBody:body];
        
        
        
        
        
        // FirstName
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"FirstName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",str_fname]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //LastName
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"LastName\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_lname]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //address1
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address1\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_addr1]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //address2
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"address2\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_addr2]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //city
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"city\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_city]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        
        
        //country
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"country\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",cntr_id]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        
        //customerId
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"customerId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"]]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        NSLog(@"%@  * %@",[[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"],new_address_input);

        
        //newaddressinput
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"newaddressinput\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",new_address_input]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //state
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"state\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",state_id]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        

        //zipcode
    
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"zipcode\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_zip_code]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //mobile
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mobile\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",str_phone]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //
        NSError *er;
            NSHTTPURLResponse *response = nil;
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&er];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        if (er) {
            NSLog(@"%@",[er localizedDescription]);
        }
        
        if (returnData) {
            [Helper_activity stop_activity_animation:self];

            
            NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
            json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
            NSLog(@"%@", [NSString stringWithFormat:@"JSON DATA OF ORDER DETAIL: %@", json_DATA]);
            
           if ([[json_DATA valueForKey:@"success"] isEqualToString:@"success"]) {
               
                i= i-1;
//                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//                {  [HttpClient createaAlertWithMsg:@"تمت إضافة العنوان الجديد بنجاح." andTitle:nil];
//                }else{
//               
//                [HttpClient createaAlertWithMsg:@"New Address Added Successfully." andTitle:@""];
//                
//                }
                [HttpClient createaAlertWithMsg:[json_DATA valueForKey:@"msg"] andTitle:@""];

                 [self Shipp_address_API];
            }
            else{
                   [HttpClient createaAlertWithMsg:[json_DATA valueForKey:@"msg"] andTitle:@""];
            }
         
            
            
        }
        
    }
    @catch(NSException *exception)
    {
        [Helper_activity stop_activity_animation:self];

        NSLog(@"THE EXception:%@",exception);
        
    }
   

}

//gettingCountryCodeForMobile from JSon File

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
    NSArray *sorted_arr = [phone_code_arr sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    
           for(int k = 0; k < sorted_arr.count;k++)
            {
                if([[[sorted_arr objectAtIndex:k] valueForKey:@"name"] isEqualToString:@"Qatar"])
                        {
                          [self.phone_picker_view selectRow:k inComponent:0 animated:NO];
        
                            [self pickerView:self.phone_picker_view didSelectRow:k inComponent:0];
                            
        
                        }
                }
    
                                        

    
    //phone_code_arr = [NSMutableArray arrayWithArray:[codes allValues]];
    //   country_arr = [codes allKeys];
    //    [[NSUserDefaults standardUserDefaults] setObject:country_arr forKey:@"country_array"];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    
    _phone_picker_view = [[UIPickerView alloc] init];
    _phone_picker_view.delegate = self;
    _phone_picker_view.dataSource = self;
    
    
    
    
//    UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
//                                                                                 action:@selector(tappedToSelectRow:)];
//    tapToSelect.delegate = self;
//    [_phone_picker_view addGestureRecognizer:tapToSelect];
    
    
    
}



- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            NSString *customer_id =  [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"customer_id"];

            [self deleteShipping_address:customer_id andShipID:shpid ];
            
        }
        else{
            
            
            NSLog(@"cancel:");
            
            
        }
    }
}


- (IBAction)home_action:(id)sender {
    
    [self.navigationController popViewControllerAnimated:NO];

}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
