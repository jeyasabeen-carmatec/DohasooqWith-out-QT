//
//  VC_wish_list.m
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_wish_list.h"
#import "wish_list_cell.h"
#import "HttpClient.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "ViewController.h"
#import "Helper_activity.h"
@interface VC_wish_list ()<UITableViewDelegate,UITableViewDataSource,UIGestureRecognizerDelegate,UIAlertViewDelegate>
{
    NSMutableArray *response_Arr;
    NSInteger product_count;
    UITapGestureRecognizer *tapGesture1 ;
    
//   UIView *VW_overlay;
//    UIImageView *actiIndicatorView;
    
//    UIActivityIndicatorView *activityIndicatorView;
    NSString *product_id;
    UIImageView *image_empty;

}


@end

@implementation VC_wish_list

- (void)viewDidLoad {
    [super viewDidLoad];
    _TBL_wish_list_items.hidden = YES;
    self.screenName = @"Wishlist screen";

//    UINib *nib = [UINib nibWithNibName:@"wish_list_cell" bundle:nil];
//    [_TBL_wish_list_items registerNib:nib forCellReuseIdentifier:@"wish_list_cell"];
//    [_TBL_wish_list_items registerNib:nib forCellReuseIdentifier:@"Qwish_list_cell"];
    
    [self set_UP_VIEW];
}
-(void)viewWillAppear:(BOOL)animated{
    
     self.navigationItem.hidesBackButton = YES;
    
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
    [self performSelector:@selector(wish_list_api_calling) withObject:nil afterDelay:0.01];
    
  
    
    //[self wish_list_api_calling];

}

-(void)set_UP_VIEW
{
  //  [self wish_list_api_calling];
    
//    CGRect set_frame = _TBL_wish_list_items.frame;
//    set_frame.origin.y =  - self.navigationController.navigationBar.frame.origin.y+20;
//    set_frame.size.height = self.view.frame.size.height - set_frame.origin.y;
//    _TBL_wish_list_items.frame = set_frame;
    
    

    
       [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    
    CGRect frameset = _VW_empty.frame;
    frameset.size.width = 200;
    frameset.size.height = 200;
    _VW_empty.frame = frameset;
    _VW_empty.center = self.view.center;
    [self.view addSubview:_VW_empty];
    _VW_empty.hidden = YES;
    
    _BTN_empty.layer.cornerRadius = self.BTN_empty.frame.size.width / 2;
    _BTN_empty.layer.masksToBounds = YES;

}

#pragma tableview delagates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
     return response_Arr.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
    //return arr_product.count;
    
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier;
    NSInteger index;

    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        identifier = @"Qwish_list_cell";
        index = 1;

    }
    else{
        identifier = @"wish_list_cell";
        index = 0;


    }
     wish_list_cell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"wish_list_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }

     #pragma Webimage URl Cachee
    @try
    {
    
    NSString *img_url = [NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"image"]];
    [cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:img_url]
                         placeholderImage:[UIImage imageNamed:@"logo.png"]
                                  options:SDWebImageRefreshCached];
    cell.LBL_item_name.text = [[response_Arr objectAtIndex:indexPath.section] valueForKey:@"product_name"];
        
    NSString *str;
        NSString *str_discount = [NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"product_discount"]];
    
    if([str_discount isEqualToString:@"0"])
    {
        cell.LBL_discount.text = [NSString stringWithFormat:@""];

    }
    else
    {
    
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            
            str = @"خصم %";
            cell.LBL_discount.text = [NSString stringWithFormat:@"%@%@",str,[[response_Arr objectAtIndex:indexPath.section]valueForKey:@"product_discount"]];
        }
        else{
            
            str = @"% off";
          cell.LBL_discount.text = [NSString stringWithFormat:@"%@%@",[[response_Arr objectAtIndex:indexPath.section]valueForKey:@"product_discount"],str];
            
        }
        
    }
    
       

        
        if([[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"stock_status"] isEqualToString:@"Out of stock"] )
        {
            cell.Btn_add_cart.enabled = NO;
           
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                cell.outOfStock_LBL.text = @"غير متوفّر";
            }
            else{
                 cell.outOfStock_LBL.text = @"Out Of Stock";
            }
            
            [cell.Btn_add_cart setBackgroundImage:[UIImage imageNamed:@"out-of-stock-2.png"] forState:UIControlStateNormal];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                [cell.Btn_add_cart setBackgroundImage:[UIImage imageNamed:@"arbic_wish.png"] forState:UIControlStateNormal];

            }
        }
        else
        {
            cell.outOfStock_LBL.text = @"";
            cell.Btn_add_cart.enabled = YES;
            [cell.Btn_add_cart setBackgroundImage:[UIImage imageNamed:@"Add-to-cart.png"] forState:UIControlStateNormal];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                [cell.Btn_add_cart setBackgroundImage:[UIImage imageNamed:@"arbic_gray.png"] forState:UIControlStateNormal];
                
            }
            

        }
    
    
    
    NSString *currency_code = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
         NSString *current_price = [NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"special_price"] ];
        
        NSString *prec_price;
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            current_price = [NSString stringWithFormat:@"%@ %@",current_price,currency_code];

             prec_price = [NSString stringWithFormat:@"%@ %@", [[response_Arr objectAtIndex:indexPath.section] valueForKey:@"product_price"] ,currency_code];
        }
        else{
            current_price =[NSString stringWithFormat:@"%@ %@",[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"special_price"] ,currency_code];
            prec_price = [NSString stringWithFormat:@"%@ %@", currency_code,[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"product_price"] ];
        }
        
        
    
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setAlignment:NSTextAlignmentCenter];

      NSString *text ;

        if ([cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
//            NSDictionary *attribs = @{
//                                      NSForegroundColorAttributeName:cell.LBL_current_price.textColor,
//                                      NSFontAttributeName:cell.LBL_current_price.font
//                                      };
           

            
            if ([current_price isEqualToString:@""] || [current_price isEqualToString:@"<null>"]||[current_price isEqualToString:@"0"]||[current_price isEqualToString:prec_price]||[[NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"special_price"]]  isEqualToString:@"0"]) {
                
                
                NSString *text = [NSString stringWithFormat:@"%@",prec_price];
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                 [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:currency_code] ];
                
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:prec_price] ];
                
//                [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                //NSParagraphStyleAttributeName
                cell.LBL_current_price.attributedText = attributedText;
                
                
            }
            else{
             
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                  //  current_price = [NSString stringWithFormat:@"%@ %@",current_price,currency_code];

                    text = [NSString stringWithFormat:@"%@ %@",prec_price,current_price];

                }
                else{
                    
                  //  current_price = [NSString stringWithFormat:@"%@ %@",currency_code,current_price];
                    text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];

                }
       
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
//              [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0],}range:[text rangeOfString:currency_code] ];
            
            
            NSRange ename = [text rangeOfString:current_price];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                        range:ename];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:13.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                        range:ename];
            }
            NSRange cmp = [text rangeOfString:prec_price];
            //        [attributedText addAttribute: NSStrikethroughStyleAttributeName value:[NSNumber numberWithInteger: NSUnderlineStyleSingle] range: NSMakeRange(0, [prec_price length])];
            //
            
            
            //        NSRange range_event_desc = [text rangeOfString:<#(nonnull NSString *)#>];
            if ( UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad )
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:15.0],NSForegroundColorAttributeName:[UIColor grayColor]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:12.0],NSForegroundColorAttributeName:[UIColor grayColor],}
                                        range:cmp ];
            }
            @try {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                     [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(0, [prec_price length])];
                }
                else{
                     [attributedText addAttribute:NSStrikethroughStyleAttributeName value:@2 range:NSMakeRange(current_price.length+1, [prec_price length])];
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
    
 
        [cell.Btn_add_cart addTarget:self action:@selector(btn_add_cart_action:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.BTN_plus addTarget:self action:@selector(plus_action:) forControlEvents:UIControlEventTouchUpInside];
//        [cell.BTN_minus addTarget:self action:@selector(minus_action:) forControlEvents:UIControlEventTouchUpInside];
    
    cell._TXT_count.tag = indexPath.row;
//    cell.BTN_plus.tag = indexPath.row;
//    cell.BTN_minus.tag = indexPath.row;
    cell.Btn_add_cart.tag = indexPath.row;
    cell.Btn_add_cart.tag =  [[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"product_id"] integerValue];
    
//        cell._TXT_count.layer.borderWidth = 0.4f;
//        cell._TXT_count.layer.borderColor = [UIColor grayColor].CGColor;
//        
//        cell.BTN_plus.layer.borderWidth = 0.4f;
//        cell.BTN_plus.layer.borderColor = [UIColor grayColor].CGColor;
//        cell.BTN_minus.layer.borderWidth = 0.4f;
//        cell.BTN_minus.layer.borderColor = [UIColor grayColor].CGColor;
    
    
//    CGSize result = [[UIScreen mainScreen] bounds].size;
//         if(result.height >= 480)
//        {
//            
//            [[cell LBL_ad_to_cart] setFont:[UIFont systemFontOfSize:10]];
//            
//            
//        }
//        else if(result.height >= 667)
//        {
//            
//             [[cell LBL_ad_to_cart] setFont:[UIFont systemFontOfSize:14]];
//            
//        }
    }
    @catch(NSException *exception)
    {
        
    }
        return cell;
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //return 147.0;
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}




- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"id"]] forKey:@"product_id"];
    
    [[NSUserDefaults standardUserDefaults]setObject:[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
    [[NSUserDefaults standardUserDefaults] setValue:[[response_Arr objectAtIndex:indexPath.section] valueForKey:@"merchant_id"]forKey:@"Mercahnt_ID"];
   
    wish_list_cell *cell = (wish_list_cell *)[self.TBL_wish_list_items cellForRowAtIndexPath:indexPath];

    if (cell._TXT_count.tag == indexPath.section) {
        //NSString *items=cell._TXT_count.text;
        [[NSUserDefaults standardUserDefaults]setObject:[NSString stringWithFormat:@"%@",cell._TXT_count.text] forKey:@"item_count"];


    }
    [self performSegueWithIdentifier:@"wish_product_detail" sender:self];
}


#pragma button_actions
-(void)btnfav_action
{
    NSLog(@"fav_clicked");
}
-(void)btn_cart_action:(UIBarButtonItem *)btn
{
    NSLog(@"cart_clicked");
}
-(void)tapGesture_close:(UITapGestureRecognizer *)tapgstr
{
    CGPoint location = [tapgstr locationInView:_TBL_wish_list_items];
    NSIndexPath *index = [_TBL_wish_list_items indexPathForRowAtPoint:location];
    
    NSLog( @".......%ld",(long)index.row);
    product_id = [NSString stringWithFormat:@"%@",[[response_Arr objectAtIndex:index.section] valueForKey:@"product_id"]];
    
//      [self performSelector:@selector(delete_from_wishLis:@"") withObject:nil afterDelay:0.01];
    [self delete_from_wishLis:@"delete"];
    
}
//-(void)minus_action:(UIButton*)btn
//{
//    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag inSection:0];
//    wish_list_cell *cell = (wish_list_cell *)[self.TBL_wish_list_items cellForRowAtIndexPath:index];
//    product_count = [cell._TXT_count.text integerValue];
//    if (product_count<= 0) {
//       
//        product_count = 0;
//        
//    }
//    else{
//        product_count = product_count-1;
//        cell._TXT_count.text = [NSString stringWithFormat:@"%ld",product_count];
//    }
//
//}
//-(void)plus_action:(UIButton*)btn
//{
//    NSIndexPath *index = [NSIndexPath indexPathForRow:btn.tag inSection:0];
//    wish_list_cell *cell = (wish_list_cell *)[self.TBL_wish_list_items cellForRowAtIndexPath:index];
//    product_count = [cell._TXT_count.text integerValue];
//    product_count = product_count+1;
//    cell._TXT_count.text = [NSString stringWithFormat:@"%ld",product_count];
//
//}
- (IBAction)back_action_clicked:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma wish_list_api_calling

-(void)wish_list_api_calling{
    
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    @try {
        
                
    response_Arr = [[NSMutableArray alloc]init];

    //http://192.168.0.171/dohasooq/apis/customerWishList/46/1/1
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/customerWishList/%@/%@/%@.json",SERVER_URL,user_id,country,languge];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                    [Helper_activity stop_activity_animation:self];

                    NSLog(@"%@",[error localizedDescription]);
                }
                  @try {

                if (data) {
                  
                       response_Arr = data;
                    
                        image_empty.hidden = YES;
                     _VW_empty.hidden = YES;
                        
                        if (response_Arr.count == 0)
                        {
                             _VW_empty.hidden = NO;
                            _TBL_wish_list_items.hidden =  YES;
                            [Helper_activity stop_activity_animation:self];
                            
                            
                        }
                        else{
                            response_Arr = data;
                            
                            NSLog(@"Wish List Data*******%@*********",response_Arr);
                            
                            _TBL_wish_list_items.hidden =  NO;
                             [Helper_activity stop_activity_animation:self];
                            [self.TBL_wish_list_items reloadData];
                           }
                       }
                        else{
                            
                            [Helper_activity stop_activity_animation:self];
                            
//                            VW_overlay.hidden=YES;
//                            [activityIndicatorView stopAnimating];

                            [HttpClient createaAlertWithMsg:@"The data is in Unknown format" andTitle:@""];
                        }
                      
                      NSString *str_header_title = [NSString stringWithFormat:@"MY WISHLIST(%lu)",(unsigned long)response_Arr.count];
                      [_BTN_header setTitle:str_header_title forState:UIControlStateNormal];
                       [Helper_activity stop_activity_animation:self];
                      
                      
                    }
                @catch (NSException *exception) {
                    
                    [Helper_activity stop_activity_animation:self];
//                    VW_overlay.hidden=YES;
//                    [activityIndicatorView stopAnimating];
                    _TBL_wish_list_items.hidden =  YES;
                    _VW_empty.hidden = NO;


                        NSLog(@"%@",exception);
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
#pragma mark  add_to_cart_API_calling

-(void)add_to_cart_API_calling{
    
    @try {
        
        [Helper_activity animating_images:self];
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        NSString *items_count =@"1";
        
        
        
        NSError *error;
        NSHTTPURLResponse *response = nil;
        //NSString *pdId = [[NSUserDefaults standardUserDefaults] valueForKey:@"product_id"];
        NSDictionary *parameters = @{@"pdtId":product_id
                                     ,@"userId":user_id,@"quantity":items_count,@"custom":@"",@"variant":@""};
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&error];
        NSURL *urlProducts=[NSURL URLWithString:[NSString stringWithFormat:@"%@apis/addcartapi.json",SERVER_URL]];
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
            [Helper_activity stop_activity_animation:self];
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
        }
        
        if(aData)
        {
            [Helper_activity stop_activity_animation:self];
            NSMutableDictionary *dict = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            
            if (![dict count]) {
                
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                
            }
            else{
                if ([[dict valueForKey:@"success"] isEqualToString:@"1"]) {
                    
                    //[self set_Data_to_badge_value:[NSString stringWithFormat:@"%@",[dict valueForKey:@"count"]]];
                    [HttpClient createaAlertWithMsg:[dict valueForKey:@"message"] andTitle:@""];
                    [self cart_count];
                    [self delete_from_wishLis:@"added"];
                    // [self performSegueWithIdentifier:@"wish_to_cart" sender:self];
                    
                }
                else{
                    [HttpClient createaAlertWithMsg:[dict valueForKey:@"message"] andTitle:@""];
                }
            }
            
        }
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        [Helper_activity stop_activity_animation:self];
    }
    
    
    
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
            NSLog(@"cart count sadas %@",data);
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

#pragma mark Set_Badge_value

//-(void)set_Data_to_badge_value:(NSString *)badge_value{
//    
//    
//    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//    {
//        
//        if(badge_value.length > 2)
//        {
//            self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
//            
//        }
//        else{
//            self.navigationItem.leftBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
//            
//        }
//    }
//    else{
//        if(badge_value.length > 2)
//        {
//            self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@+",badge_value];
//            
//        }
//        else{
//            self.navigationItem.rightBarButtonItem.badgeValue = [NSString stringWithFormat:@"%@",badge_value];
//            
//        }
//    }
//    
//}



#pragma mark delete_from_wishList_API_calling
/* Del WishList
 
 http://192.168.0.171/dohasooq/apis/delFromWishList/1/24.json
 
 example
 Product_id =1
 User_Id = 24
 
 */
-(void)delete_from_wishLis :(NSString *)fromDelete{
    
    
    @try {
        
        [Helper_activity animating_images:self];
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_ID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/delFromWishList/%@/%@.json",SERVER_URL,product_id,user_ID];
        
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
                        NSLog(@"%@",data);
                        
                        if ([[NSString stringWithFormat:@"%@",[data valueForKey:@"msg"]] isEqualToString:@"Removed from your Wishlist"]) {
                            [Helper_activity stop_activity_animation:self];
                            
                            if ([fromDelete isEqualToString:@"delete"]) { // for Direct calling of remove from wish list or from move to cart
                                
                                [HttpClient createaAlertWithMsg:[data valueForKey:@"multi_msg"] andTitle:@""];
                                
                            }
                            
                            
                            [self performSelector:@selector(wish_list_api_calling) withObject:nil afterDelay:0.01];
                            
                        }
                        else{
                            [HttpClient createaAlertWithMsg:[data valueForKey:@"multi_msg"] andTitle:@""];

                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                        /////////////
                        
                      /*  if([[data valueForKey:@"msg"] isEqualToString:@"Customer not found"])
                        {
                             [HttpClient createaAlertWithMsg:[data valueForKey:@"msg"] andTitle:@""];
                        }
                        
                        else
                        {
                        
                        @try {
                             [Helper_activity stop_activity_animation:self];
                            
                            if ([fromDelete isEqualToString:@"delete"]) { // for Direct calling of remove from wish list or from move to cart 
                                
                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                            {
                                
                                [HttpClient createaAlertWithMsg:@"تمت إزالة العنصر من قائمة المفضلات" andTitle:@""];
                            }else{
                                [HttpClient createaAlertWithMsg:@"Item Removed From Your Wishlist." andTitle:@""];
                                
                            }
                                
                            }
                            
                            
                            [self performSelector:@selector(wish_list_api_calling) withObject:nil afterDelay:0.01];
                    
                        } @catch (NSException *exception) {
                            NSLog(@"%@",exception);
                            
                        }
                       
                        }*/
                    
                    
                    }
                    
                });
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
            
            [Helper_activity stop_activity_animation:self];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                [HttpClient createaAlertWithMsg:@"خطأ في الإتصال" andTitle:@""];
            }
            else{
                [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
            }
            
        }
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
        [Helper_activity stop_activity_animation:self];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            [HttpClient createaAlertWithMsg:@"خطأ في الإتصال" andTitle:@""];
        }
        else{
            [HttpClient createaAlertWithMsg:@"Connection error" andTitle:@""];
        }    }
    
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)wishList_to_cartPage:(id)sender {
    [self performSegueWithIdentifier:@"wish_to_cart" sender:self];
}
-(void)btn_add_cart_action:(UIButton*)cart_btn{
    
    @try {
        
        
       // NSIndexPath *index = [NSIndexPath indexPathForRow:cart_btn.tag inSection:0];
        product_id = [NSString stringWithFormat:@"%ld",(long)cart_btn.tag];
        
        
        [self performSelector:@selector(add_to_cart_API_calling) withObject:nil afterDelay:0.01];
        
        //        [[NSUserDefaults standardUserDefaults]setObject:product_id forKey:@"product_id"];
        //        wish_list_cell *cell = (wish_list_cell *)[self.TBL_wish_list_items cellForRowAtIndexPath:index];
        //        [[NSUserDefaults standardUserDefaults]setObject:cell._TXT_count.text forKey:@"item_count"];
        
        
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
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
    
    @try {
        
        [Helper_activity animating_images:self];
        
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *custmr_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    
    NSDictionary *parameters = @{@"quantity":[[NSUserDefaults standardUserDefaults] valueForKey:@"item_count"],@"productId":[[NSUserDefaults standardUserDefaults]valueForKey:@"product_id"],@"customerId":custmr_id};
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/updatecartapi.json",SERVER_URL];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    
    [HttpClient api_with_post_params:urlGetuser andParams:parameters completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                NSLog(@"%@",[error localizedDescription]);
            }
            if (data) {
               
                
                
                @try {
                    [HttpClient createaAlertWithMsg:[data valueForKey:@"message"] andTitle:@""];
                } @catch (NSException *exception) {
                    NSLog(@"exception:: %@",exception);
                }
                
                
            }
            
        });
        
    }];
    } @catch (NSException *exception) {
        NSLog(@"%@",exception);
    }
   
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

