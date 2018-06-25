//
//  VC_cart_list.m
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_cart_list.h"
#import "Cart_cell.h"
#import "tbl_amount.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewController.h"
#import "Helper_activity.h"

@interface VC_cart_list ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *cart_array;
    NSDictionary *json_dict;
    NSInteger product_count;
    
    UITapGestureRecognizer *tapGesture1;
    NSString *currency_code,*product_id,*item_count;
    UIImageView *image_empty;
    BOOL status;
  
    NSString *variantCombinationID,*cartCustomOptionId;
    

}

@end

@implementation VC_cart_list

- (void)viewDidLoad {
    [super viewDidLoad];
    self.screenName = @"Cart list screen";

    // Do any additional setup after loading the view.
    _TBL_cart_items.hidden = YES;
       [self set_UP_VIEW];
    [self.BTN_clear_cart addTarget:self action:@selector(clear_cart_action:) forControlEvents:UIControlEventTouchUpInside];

    
   }
-(void)viewWillAppear:(BOOL)animated{
    
    self.navigationItem.hidesBackButton = YES;
    status = NO;
    
    [Helper_activity animating_images:self];
    [self performSelector:@selector(cartList_api_calling) withObject:nil afterDelay:0.01];
}
-(void)set_UP_VIEW
{
    currency_code = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];

    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    //_BTN_fav  = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain  target:self action:
            //     @selector(btnfav_action)];
    _BTN_cart = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStylePlain   target:self action:@selector(btn_cart_action)];
    
    CGRect frameset = _VW_empty.frame;
    frameset.size.width = 200;
    frameset.size.height = 200;
    _VW_empty.frame = frameset;
    _VW_empty.center = self.view.center;
    [self.view addSubview:_VW_empty];
    _VW_empty.hidden = YES;
    
    
    _BTN_empty.layer.cornerRadius = self.BTN_empty.frame.size.width / 2;
    _BTN_empty.layer.masksToBounds = YES;

    NSString *next = @"";
    
    NSString *next_text = [NSString stringWithFormat:@"NEXT %@",next];
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        next  = @"";
        next_text = [NSString stringWithFormat:@"%@ التالي ",next];
    }    if ([_LBL_next respondsToSelector:@selector(setAttributedText:)]) {
        
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
    
    UIImage *newImage = [_IMG_cart.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(_IMG_cart.image.size, NO, newImage.scale);
    [[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0] set];
    [newImage drawInRect:CGRectMake(0, 0, _IMG_cart.image.size.width, newImage.size.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _IMG_cart.image = newImage;

    

    

}
#pragma table view delegates
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    {
    return cart_array.count;
    }
    else
    {
        return 1;
    }
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section == 0)
    {
        NSString *identifier;
        NSInteger index;
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
            identifier = @"QCart_cell";
            index = 1;
            
        }
        else{
            identifier = @"Cart_cell";
            index = 0;
            
            
        }
        Cart_cell *cell = (Cart_cell *)[tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"Cart_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }
        @try
        {
        
        cell._TXT_count.delegate = self;
            
            NSString *pName = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"pname"]];
            
            if ([pName isKindOfClass:[NSNull class]] || [pName isEqualToString:@"(null)"] || [pName isEqualToString:@"<null>"]) {
                pName = @"";
            }
            
            cell.LBL_item_name.text = pName;
            
            
        NSString *img_url = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"product_image_path"]];
        @try
        {
        NSString *str_variant =  [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"variantCombinationStatus"]];
        str_variant = [str_variant stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
         str_variant = [str_variant stringByReplacingOccurrencesOfString:@"" withString:@""];
            str_variant = [str_variant stringByReplacingOccurrencesOfString:@"Null" withString:@""];
            NSString *str_custom = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"customerr"]];
            str_custom = [str_custom stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            str_custom = [str_custom stringByReplacingOccurrencesOfString:@"" withString:@""];
            str_custom = [str_custom stringByReplacingOccurrencesOfString:@"Null" withString:@""];
            
        if([str_variant isKindOfClass:[NSNull class]] || [str_custom isKindOfClass:[NSNull class]])
        {
            cell.LBL_error.text = @"";
        }

         if([str_variant isEqualToString:@"A"])
         {
             cell.LBL_combo.text = [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"variantCombination"];
              cell.LBL_error.text =@"";

         }
            
        
         else{
             
              BOOL variant = NO;
              BOOL custom =  NO;
             if([str_variant isEqualToString:@""] || [str_variant isKindOfClass:[NSNull class]])
             {
                 variant =  NO;
                 
             }
             else
             {
                 variant =  YES;
                 cell.LBL_combo.text = [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"variantCombination"];
             }
             if([str_custom isEqualToString:@"0"])
             {
                 NSString *str_custom_data = [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"customoption"];
                 str_custom_data = [str_custom_data stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                 str_custom_data = [str_custom_data stringByReplacingOccurrencesOfString:@"" withString:@""];
                 str_custom_data = [str_custom_data stringByReplacingOccurrencesOfString:@"Null" withString:@""];
                 if([str_custom_data isKindOfClass:[NSNull class]]|| [str_custom_data isEqualToString:@""])
                 {
                     custom = NO;
                     
                 }
                                else
                 {
                     custom = YES;
                     cell.LBL_combo.text =str_custom_data;
                     
                 }
             }
             else
             {
                 status =  YES;
                 NSString *str_custom_data = [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"customoption"];
                 @try
                 {
                 str_custom_data = [str_custom_data stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                 str_custom_data = [str_custom_data stringByReplacingOccurrencesOfString:@"" withString:@""];
                 str_custom_data = [str_custom_data stringByReplacingOccurrencesOfString:@"Null" withString:@""];
                     if([str_custom_data isKindOfClass:[NSNull class]]|| [str_custom_data isEqualToString:@""])
                     {
                         custom = YES;
                         
                     }
                     else
                     {
                         custom = YES;
                         cell.LBL_combo.text =str_custom_data;
                         
                     }
                     

                 }
                 @catch(NSException *exception)
                 {
                     if([str_custom_data isKindOfClass:[NSNull class]]|| [str_custom_data isEqualToString:@""])
                     {
                         custom = YES;
                         
                     }
                     else
                     {
                         custom = YES;
                         cell.LBL_combo.text =str_custom_data;
                         
                     }

                 }
                
               
                 
             }
               if ([[NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"StockStatus"]] isEqualToString:@"Out of stock"])
             {
                 status = YES;
             }

            
            if((variant == NO && custom == YES) )
             {
                   cell.LBL_error.text = [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"customerrmsg"];

             }
            else if(custom == NO && variant == YES)
             {
                 status =  YES;
                 cell.LBL_error.text = [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"variantCombinationStatmsg"];


             }
             else
             {
                 cell.LBL_error.text =@"";
                 cell.LBL_combo.text= @"";

             }
             
         }
            
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        
        
        [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                         placeholderImage:[UIImage imageNamed:@"logo.png"]
                                  options:SDWebImageRefreshCached];
        
        cell._TXT_count.text = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"qty"]];
            
        NSString *qnty = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"qty"]];
        
        currency_code = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"currency"]];
            
        NSString *current_price = [NSString stringWithFormat:@"%@", [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"special_price"]];
        
        NSString *prec_price = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"product_price"]];
        
            
            
            // Calculating Dohamiles Value and Prices Based on Quantity
            
            @try {
                int quantity = [qnty intValue];
                
                
                @try {
                    //Product Price Multiplication
                    
                    float productprice = [prec_price floatValue];
                    productprice = quantity*productprice;
                    
                    prec_price = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",productprice]];
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                         prec_price = [NSString stringWithFormat:@"%@ %@",prec_price,currency_code];
                    }else{
                    prec_price = [NSString stringWithFormat:@"%@ %@",currency_code,prec_price];
                    }
                    
                    
                    if([current_price isEqualToString:@""]|| [current_price isEqualToString:@"null"]||[current_price isEqualToString:@"<null>"])
                    {
                        
                    }
                    else{
                        float spcl_prc = [current_price floatValue];
                        
                         spcl_prc = quantity*spcl_prc;
                        
                        //current_price = [NSString stringWithFormat:@"%.2f",spcl_prc];
                        current_price = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",spcl_prc]];
                    }
                    
                    
                } @catch (NSException *exception) {
                    
                }
                
            } @catch (NSException *exception) {
                
            }
  
            
        NSString *text;
        
        
        if ([cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
            
            
            if ([current_price isEqualToString:@""]|| [current_price isEqualToString:@"null"]||[current_price isEqualToString:@"<null>"]||[current_price isEqualToString:@"0"] || [[NSString stringWithFormat:@"%@", [[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"special_price"]] isEqualToString:[NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"product_price"]]]) {
                
                
                text = [NSString stringWithFormat:@"%@",prec_price];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                  [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor],}range:[text rangeOfString:currency_code] ];
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                        range:[text rangeOfString:prec_price]];
                //cell.LBL_current_price.text = [NSString stringWithFormat:@"QR %@",prec_price];
                cell.LBL_current_price.attributedText = attributedText;
                cell.LBL_discount.text = nil;
                
            }
            else{
                

                NSString *str_discount =[NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"discount"]];
                str_discount = [str_discount stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                str_discount = [str_discount stringByReplacingOccurrencesOfString:@"%" withString:@""];
                
                
                NSString *str;
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    
                     str = @"خصم %";
                    cell.LBL_discount.text = [NSString stringWithFormat:@"%@%@",str,str_discount];
                }
                else{
                    
                    str = @"% off";
                   cell.LBL_discount.text =[NSString stringWithFormat:@"%@%@",str_discount,str];
                    
                }

               
               // cell.LBL_discount.text =[NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"discount"]];
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    current_price = [NSString stringWithFormat:@"%@ %@",current_price,currency_code];
                    text = [NSString stringWithFormat:@"%@ %@",prec_price,current_price];
                }
                else{
                    current_price = [NSString stringWithFormat:@"%@ %@",currency_code,current_price];
                    
                text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
                }
                
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                
//                  [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0],}range:[text rangeOfString:currency_code] ];
                
                
                
                NSRange ename = [text rangeOfString:current_price];
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0],NSForegroundColorAttributeName:[UIColor redColor]}
                                            range:ename];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                            range:ename];
                }
                NSRange cmp = [text rangeOfString:prec_price];
        
                if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                            range:cmp];
                }
                else
                {
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:13.0],NSForegroundColorAttributeName:[UIColor grayColor],}
                                            range:cmp ];
                }
                @try {
                   
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                         [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [prec_price length])];
                    }
                    else{
                         [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(current_price.length+1, [prec_price length]+2)];
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
                
                cell.LBL_current_price.attributedText = attributedText;
                
            }
        }
        else
        {
            cell.LBL_current_price.text = text;
        }
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            cell.LBL_current_price.textAlignment = NSTextAlignmentRight;
        }
       
            //[NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"pname"]];
        // Stock Status
            if ([[NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"StockStatus"]] isEqualToString:@"Out of stock"]) {
                cell.LBL_stockStatus.text = @"OUT OF STOCK";
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    cell.LBL_stockStatus.text =  @"غير متوفّر";
                }
                

            }
            else{
                cell.LBL_stockStatus.text = @"";

            }
            
        
            
        UIImage *newImage = [cell.BTN_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        UIGraphicsBeginImageContextWithOptions(cell.BTN_close.image.size, NO, newImage.scale);
        [[UIColor darkGrayColor] set];
        [newImage drawInRect:CGRectMake(0, 0, cell.BTN_close.image.size.width, newImage.size.height)];
        newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        cell.BTN_close.image = newImage;
        
        cell.BTN_close .userInteractionEnabled = YES;
        
        tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close:)];
        
        tapGesture1.numberOfTapsRequired = 1;
        
        [tapGesture1 setDelegate:self];
        
        [cell.BTN_close addGestureRecognizer:tapGesture1];
        
        
        
        
        [cell.BTN_plus addTarget:self action:@selector(plus_action:) forControlEvents:UIControlEventTouchUpInside];
        [cell.BTN_minus addTarget:self action:@selector(minus_action:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        cell.BTN_plus.tag = indexPath.row;
        cell.BTN_minus.tag = indexPath.row;
        cell._TXT_count.tag = indexPath.row;
        cell.BTN_close.tag = indexPath.row;
        
        cell._TXT_count.layer.borderWidth = 0.4f;
        cell._TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
        cell.BTN_plus.layer.borderWidth = 0.4f;
        cell.BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
        cell.BTN_minus.layer.borderWidth = 0.4f;
        cell.BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
        }
        @catch(NSException *exception)
        {
            
        }
        return cell;
        
        
    }
    else
    {
        //QTbl_amount
        NSString *identifier;
        NSInteger index;
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
            identifier = @"Qtbl_amount";
            index = 1;
            
        }
        else{
            identifier = @"tbl_amount";
            index = 0;
            
            
        }
        tbl_amount *cell = (tbl_amount *)[tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"tbl_amount" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }
        
       // cell.redempion_lbl.hidden = YES;
        //cell.redemption_amt.hidden = YES;
        
        NSString *total_amt = [NSString stringWithFormat:@"%@",[json_dict valueForKey:@"sub_total"]];
        
        if ([total_amt isEqualToString:@"(null)"]|| [total_amt isEqualToString:@"<null>"]) {
            // NSString *code = @"QR";
            total_amt = @"0";
            
            NSString *text;
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"]){
                  text = [NSString stringWithFormat:@"%@ %@",total_amt,currency_code];
            }else{
                text = [NSString stringWithFormat:@"%@ %@",currency_code,total_amt];
            }

          
            
           
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor]}
                                    range:[text rangeOfString:total_amt]];
            
            cell.LBL_amount.text = text;
            cell.LBL_total_amount.attributedText = attributedText;
        }
        else{
            NSString *miles = [NSString stringWithFormat:@"%@",[json_dict valueForKey:@"dohamiles"]];
            miles = [HttpClient doha_currency_seperator:miles];
            
            NSString *str_or ;
            NSString *str_miles ;
            
             total_amt = [HttpClient currency_seperator:total_amt];
             NSString *text;
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {   str_or = @"(أو)";
                str_miles = [NSString stringWithFormat:@"%@\n أميال الدوحة %@",str_or,miles];
                text = [NSString stringWithFormat:@"%@ %@",total_amt,currency_code];
            }
            else{
                str_or = @"(OR)";
                str_miles = [NSString stringWithFormat:@"%@\nDoha Miles %@",str_or,miles];
                text = [NSString stringWithFormat:@"%@ %@",currency_code,total_amt];
            }


           
           
            
            
            
            //cell.LBL_dohamiles.text = str_miles;
            
            if ([cell.LBL_total_amount respondsToSelector:@selector(setAttributedText:)]) {
                
                // Define general attributes for the entire text
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:cell.LBL_total_amount.textColor,
                                          NSFontAttributeName:cell.LBL_total_amount.font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
                
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                        range:[text rangeOfString:currency_code] ];

                NSRange cmp = [text rangeOfString:total_amt];
              
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                            range:cmp ];
            
                cell.LBL_amount.text = text;
                cell.LBL_total_amount.attributedText = attributedText;
            }
            else
            {
                cell.LBL_total_amount.text = text;
            }
            
            if ([cell.LBL_dohamiles respondsToSelector:@selector(setAttributedText:)])
            {
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:cell.LBL_dohamiles.textColor,
                                          NSFontAttributeName:cell.LBL_dohamiles.font                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_miles attributes:attribs];
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                        range:[str_miles rangeOfString:str_or] ];

                
                NSRange cmp = [str_miles rangeOfString:miles];
                 [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor blackColor],}
                                        range:cmp ];
                
                
                
               cell.LBL_dohamiles.text = str_miles;
                //cell.LBL_dohamiles.attributedText = attributedText;
               
            }
            else
            {
                cell.LBL_dohamiles.text = str_miles;
            }
            
            

        }
        
        
        return cell;
        
    }
    
    
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath 
{
    if(indexPath.section ==0)
    {
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"]valueForKey:@"productid"]] forKey:@"product_id"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[[[cart_array objectAtIndex:indexPath.row]valueForKey:@"productDetails"] valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
    [[NSUserDefaults standardUserDefaults] setValue:[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"]valueForKey:@"merchantid"]forKey:@"Mercahnt_ID"];
    
    Cart_cell *cell = (Cart_cell *)[self.TBL_cart_items cellForRowAtIndexPath:indexPath];
    
    if (cell._TXT_count.tag == indexPath.section) {
        //NSString *items=cell._TXT_count.text;
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",cell._TXT_count.text] forKey:@"item_count"];
        
        
    }

    
    [self performSegueWithIdentifier:@"cart_list_product_detail" sender:self];
    }
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height <= 480)
        {
            return 230;
        }
        else if(result.height <= 568)
        {
            return 250;
        }
        else
        {
            return 210;
        }
        
        
    }
    else{
        return 200;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        return UITableViewAutomaticDimension;
        
    }
    else{
        return 180;
    }
    
}


#pragma mark text field delgates

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    [textField becomeFirstResponder];
}

#pragma button_actions
-(void)btnfav_action
{
    NSLog(@"fav_clicked");
}
-(void)btn_cart_action
{
     NSLog(@"cart_clicked");
}

#pragma mark Delete Item From Cart

-(void)tapGesture_close:(UITapGestureRecognizer *)tapgstr{
    CGPoint location = [tapgstr locationInView:_TBL_cart_items];
    NSIndexPath *indexPath = [_TBL_cart_items indexPathForRowAtPoint:location];

   product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];
    
    @try {
        
        cartCustomOptionId = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"cartCustomOptionId"]];
        
        
        if ([cartCustomOptionId isKindOfClass:[NSNull class]] || [cartCustomOptionId isEqualToString:@""] || [cartCustomOptionId isEqualToString:@"<null>"]) {
            cartCustomOptionId = @"0";
        }
        
        
        
        variantCombinationID = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"variantCombinationID"]];

        if ([variantCombinationID isKindOfClass:[NSNull class]] || [variantCombinationID isEqualToString:@""] || [variantCombinationID isEqualToString:@"<null>"]) {
            variantCombinationID = @"0";
        }
        
        
      //  NSLog(@"cartCustomOptionId :: %@  variantCombinationID :: %@ ",cartCustomOptionId,variantCombinationID);
        
        
    } @catch (NSException *exception) {
        
    }
    
    
    
    [Helper_activity animating_images:self];
  
    [self delete_from_cart];
    
    

    NSLog(@"the cancel clicked");
}
//-(void)remove_from_cart:(UIButton*)sender{
//    @try {
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:sender.tag inSection:0];
//        product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:indexPath.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];
////        [[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
//        [self performSelector:@selector(delete_from_cart) withObject:activityIndicatorView afterDelay:0.01];
//    } @catch (NSException *exception) {
//        NSLog(@"%@",exception);
//    }
//   
//}
-(void)minus_action:(UIButton*)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    Cart_cell *cell = (Cart_cell *)[_TBL_cart_items cellForRowAtIndexPath:index];
    
    product_count = [cell._TXT_count.text integerValue];
    if ([cell._TXT_count.text isEqualToString:@"1"]) {
 if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"]){
     [HttpClient createaAlertWithMsg:@"يجب أن يكون الحد الأدنى من الكمية 1." andTitle:@""];
 }
 else{
     [HttpClient createaAlertWithMsg:@"Minimum Quantity Should be 1." andTitle:@""];
 }
       
    }

    else{
    
    product_count = product_count-1;
    product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:index.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];
    item_count = [NSString stringWithFormat:@"%ld",(long)product_count];
        [Helper_activity animating_images:self];
        
        //[self updating_cart_List_api];
        [self performSelector:@selector(updating_cart_List_api) withObject:nil afterDelay:0.01];
    }
    
}
-(void)plus_action:(UIButton*)btn
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag inSection:0];
    Cart_cell *cell = (Cart_cell *)[self.TBL_cart_items cellForRowAtIndexPath:index];
    product_count = [cell._TXT_count.text integerValue];
    product_count = product_count+1;
    
    product_id = [NSString stringWithFormat:@"%@",[[[cart_array objectAtIndex:index.row] valueForKey:@"productDetails"] valueForKey:@"productid"]];
    item_count = [NSString stringWithFormat:@"%ld",(long)product_count];
    

    // Update cart Api method calling
    
    [Helper_activity animating_images:self];
    
    //[self updating_cart_List_api];
     [self performSelector:@selector(updating_cart_List_api) withObject:nil afterDelay:0.01];
    
    
}

- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)BTN_next_action:(id)sender {
    @try {
        if(status ==  YES)
        {if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"]){
            [HttpClient createaAlertWithMsg:@"يرجى حذف المنتجات التي لا تتوفر" andTitle:@""];
        }
        else{
            
            [HttpClient createaAlertWithMsg:@"Please delete the products which are not available." andTitle:@""];
        }
        }
        else{
            [self performSegueWithIdentifier:@"order_detail_segue" sender:self];

        }
    } @catch (NSException *exception) {
        NSLog(@"Exception %@",exception);
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)wishListAction:(id)sender {
    [self performSegueWithIdentifier:@"cart_to-wishList" sender:self];
}

/*
 apis/shoppingcartapi.json
 POST
params.put("customerId",customerid);
                 params.put("languageId",  language_val);
                 params.put("countryId",  country_val);
 
 */
#pragma mark cartList_api_calling
-(void)cartList_api_calling{
    
    @try {
        
       // [HttpClient animating_images:self];
        
        cart_array = [[NSMutableArray alloc]init];
        
        NSError *error;
        NSHTTPURLResponse *response = nil;
      
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
            NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
            NSString *langId = [[NSUserDefaults standardUserDefaults]valueForKey:@"language_id"];
            NSString *cntrId = [[NSUserDefaults standardUserDefaults]valueForKey:@"country_id"];

        NSDictionary *parameters = @{@"customerId":custmr_id,@"languageId":langId,@"countryId":cntrId};
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
        
        
        NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@apis/shoppingcartapi.json",SERVER_URL]];
     
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setHTTPBody:postData];
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
        
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
            
//            VW_overlay.hidden=YES;
//            [activityIndicatorView stopAnimating];
        }
        
        if(aData)
        {
            json_dict = [NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            @try {
            
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self performSelector:@selector(cart_count) withObject:nil afterDelay:0.01];
                });

              //  NSLog(@"cart details are ::%@",json_dict);
                if ([json_dict isKindOfClass:[NSDictionary class]]) {
                    if([[json_dict valueForKey:@"data"] isKindOfClass:[NSDictionary class]])
                    {
                    NSArray *allkeysArr = [[json_dict valueForKey:@"data"] allKeys];
                    
                    for (int i = 0; i<allkeysArr.count; i++) {
                        
                        [cart_array addObject:[[json_dict valueForKey:@"data"] valueForKey:[allkeysArr objectAtIndex:i]]];
                    }
                        @try {
                           // doha_miles_value = [[json_dict valueForKey:@"dohamiles"] integerValue];
                            //qr_dm_value = [[json_dict valueForKey:@"oneQARtoDM"] integerValue] ;
                            
                        } @catch (NSException *exception) {
                            NSLog(@"doha_miles_value & qr_dm_value  COULD NOT BE READ%@",exception);
                        }
                        

//                    VW_overlay.hidden=YES;
//                    [activityIndicatorView stopAnimating];
                        
                        
                         _TBL_cart_items.hidden =  NO;
                         self.VW_filter.hidden =NO;
                        [self.TBL_cart_items reloadData];
                         [self set_UP_VIEW];
                        [self custom_text_view_price_details];
                        self.VW_filter.hidden =NO;
                         _VW_empty.hidden = YES;
                   
                    }
                    else{
                        
//                        VW_overlay.hidden=YES;
//                        [activityIndicatorView stopAnimating];
                        
                        _TBL_cart_items.hidden =  YES;
                       
                            
                            self.TBL_cart_items.hidden = YES;
                            _VW_empty.hidden = NO;
                            
                            
                       
                        self.VW_filter.hidden =YES;

                        
                    }
                    NSString *str_header_title = [NSString stringWithFormat:@"MY CART(%lu)",(unsigned long)cart_array.count];
                    [_BTN_header setTitle:str_header_title forState:UIControlStateNormal];
                  
                }
                else{
//                    VW_overlay.hidden=YES;
//                    [activityIndicatorView stopAnimating];

                  
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"]){
                    [HttpClient createaAlertWithMsg:@"لا يمكن قراءة البيانات" andTitle:@""];
                    }
                    else{
                          [HttpClient createaAlertWithMsg:@"The Data Could Not be Read" andTitle:@""];
                    }
                }
                
                
                
            } @catch (NSException *exception) {
                NSLog(@"%@",exception);
                
//                VW_overlay.hidden=YES;
//                [activityIndicatorView stopAnimating];
                
            }
            
            
        
        }

    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        
//        VW_overlay.hidden=YES;
//        [activityIndicatorView stopAnimating];
    }
    
    [Helper_activity stop_activity_animation:self];
    
}
/*
 Clear cart/ Empty cart
 Function Name : apis/clearcartapi.json
 Parameters :$customerId
 Method : GET

 */
-(void)clear_cart_action:(UIButton*)sender{
    
     [Helper_activity animating_images:self];
    [self clear_cart_api];
    
    
    [self performSelector:@selector(cart_count) withObject:nil afterDelay:0.01];
}
#pragma mark clear_cart_api_calling
-(void)clear_cart_api{
    
   
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/clearcartapi/%@.json",SERVER_URL,custmr_id];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                  //  NSLog(@"%@",data);
                    [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                    
                    if ([[NSString stringWithFormat:@"%@",[data valueForKey:@"success"]]isEqualToString:@"1"]) {
                        [self cartList_api_calling];
                        [self.TBL_cart_items reloadData];
                    }
                   
                    
//                    
//                    VW_overlay.hidden=YES;
//                    [activityIndicatorView stopAnimating];
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
//        VW_overlay.hidden=YES;
//        [activityIndicatorView stopAnimating];
    }
    
    [Helper_activity stop_activity_animation:self];
}
#pragma mark  cart_count_api
-(void)cart_count{
    NSString *user_id;
    @try
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        if(dict.count == 0)
        {
            user_id = @"(null)";
        }
        else
        {
            NSString *str_id = @"user_id";
            // NSString *user_id;
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
        }
    }
    @catch(NSException *exception)
    {
        user_id = @"(null)";
        
    }
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             ];
            //            VW_overlay.hidden = YES;
            //            [activityIndicatorView stopAnimating];
            
            
        }
        if (data) {
           // NSLog(@"cart count sadas %@",data);
            NSDictionary *dict = data;
            @try {
                
                NSString *badge_value = [NSString stringWithFormat:@"%@",[dict valueForKey:@"cartcount"]];
                //   NSString *wishlist = [NSString stringWithFormat:@"%@",[dict valueForKey:@"wishlistcount"]];
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"cart_count"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                [[NSUserDefaults standardUserDefaults] setValue:badge_value forKey:@"cart_count"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
            } @catch (NSException *exception) {
                //                 VW_overlay.hidden = YES;
                //                [activityIndicatorView stopAnimating];
                
                
                NSLog(@"asjdas dasjbd asdas iccxv %@",exception);
            }
            
        }
    }];
}

-(void)custom_text_view_price_details{
    
    
    @try {
        NSString *qr = [[NSUserDefaults standardUserDefaults] valueForKey:@"currency"];
        NSString *price = [NSString stringWithFormat:@"%@",[json_dict valueForKey:@"sub_total"]];
       
        float total = [price floatValue];
        
        
        if ([price isEqualToString:@""]||[price isEqualToString:@"null"]||[price isEqualToString:@"<null>"]) {
            price = @"0";
        }
       
        price = [HttpClient currency_seperator:[NSString stringWithFormat:@"%.2f",total]];
       
        NSString *text;
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        { text =  [NSString stringWithFormat:@"%@ %@",price,qr];

        }
        else{
            text =  [NSString stringWithFormat:@"%@ %@",qr,price];
        }
        
        
//
//        NSLog(@"Value  %@",text);
//        NSLog(@"%@",_LBL_price);
        
        // Price label text Set Up
        if ([_LBL_price respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:_LBL_price.textColor,
                                      NSFontAttributeName:_LBL_price.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
            
            
            
            NSRange ename = [text rangeOfString:qr];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                        range:ename];
          NSRange cmp = [text rangeOfString:price];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:cmp ];
//            
//            NSRange prc = [text rangeOfString:plans];
//          [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
//                                        range:prc ];
//        
            
            
            
            _LBL_price.attributedText = attributedText;
        }
        else
        {
            _LBL_price.text = text;
        }
        
        
        
        
         NSString *plans = [NSString stringWithFormat:@"Doha Miles %@",[json_dict valueForKey:@"dohamiles"]];
        plans = [HttpClient doha_currency_seperator:plans];
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"]){
            
            plans =[NSString stringWithFormat:@"%@ أميال الدوحة",plans];//أميالالدوحة
        }
        
        
        // Miles label text Set Up
        if ([_LBL_miles respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:_LBL_miles.textColor,
                                      NSFontAttributeName:_LBL_miles.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:plans attributes:attribs];
            
            
            
//            NSRange ename = [plans rangeOfString:plans];
//            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
//                                    range:ename];
            
            //NSRange cmp = [plans rangeOfString:[NSString stringWithFormat:@"%ld",(long)doha_miles_value]];
            
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:NSMakeRange(0, plans.length) ];
            //
            //            NSRange prc = [text rangeOfString:plans];
            //          [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
            //                                        range:prc ];
            //
            
            
            
            _LBL_miles.attributedText = attributedText;
        }
        else
        {
            _LBL_miles.text = plans;
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
}
#pragma delete_from_cart_API_calling

-(void)delete_from_cart{
    /*
     
     Delete product from cart
     
     Function Name : apis/deletepdtcartapi.json
     Parameters :$productID,$customerId
     Method : GET

     */
   [Helper_activity animating_images:self];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/deletepdtcartapi/%@/%@/%@/%@.json",SERVER_URL,product_id,custmr_id,variantCombinationID,cartCustomOptionId];
    
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
  //  NSLog(@"******** %@",urlGetuser);
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    NSLog(@"%@",[error localizedDescription]);
                }
                if (data) {
                    [Helper_activity stop_activity_animation:self];
                  //  NSLog(@"%@",data);
                    @try {
                        
                        if ([[NSString stringWithFormat:@"%@",[data valueForKey:@"success"]] isEqualToString:@"1"]) {
                            [self cartList_api_calling];
                            [self.TBL_cart_items reloadData];
                        }
                        
                        [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                        
                        status = NO;
                        
//                        VW_overlay.hidden=YES;
//                        [activityIndicatorView stopAnimating];
                        
                    } @catch (NSException *exception) {
                        [Helper_activity stop_activity_animation:self];

                        NSLog(@"%@",exception);
                    }
                   
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        [Helper_activity stop_activity_animation:self];

//        VW_overlay.hidden=YES;
//        [activityIndicatorView stopAnimating];
    }
}
#pragma mark updating_cart_API
/*
 Update cart
 apis/updatecartapi.json
 Parameters :
 
 quantity,
 productId,
 customerId
 
 Method : POST
 */

-(void)updating_cart_List_api{
    
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSDictionary *parameters = @{@"quantity":item_count,@"productId":product_id,@"customerId":custmr_id};
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/updatecartapi.json",SERVER_URL];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];

    
    [HttpClient api_with_post_params:urlGetuser andParams:parameters completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                 [Helper_activity stop_activity_animation:self];
                NSLog(@"%@",[error localizedDescription]);
            }
            if (data) {
                 [Helper_activity stop_activity_animation:self];
               // NSLog(@"%@",data);
                @try {
                    NSString  *str = [NSString stringWithFormat:@"%@",[data valueForKey:@"success"]];
                    if ([str isEqualToString:@"1"]) {
                        [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                        [self cartList_api_calling];
                    }
                    else{
                       [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                    }
                    
                } @catch (NSException *exception) {
            
                    NSLog(@"The Data Couldn't be read");
                }
                
              
            }
            
        });
        
    }];
   
}

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            NSLog(@"cancel:");
            
        }
        else{
            [[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"];
            [[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
            [self presentViewController:login animated:NO completion:nil];
            
            
        }
    }
}




@end
