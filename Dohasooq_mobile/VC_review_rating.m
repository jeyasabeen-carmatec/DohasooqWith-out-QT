//
//  VC_review_rating.m
//  Dohasooq_mobile
//
//  Created by Test User on 05/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_review_rating.h"
#import <SDWebImage/UIImageView+WebCache.h>


@interface VC_review_rating ()<UITextFieldDelegate>
{
    HCSStarRatingView *lbl_review;
    UIView *VW_overlay;
    UIActivityIndicatorView *activityIndicatorView;
    NSDictionary  *json_DATA;
}

@end

@implementation VC_review_rating

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    CGRect frameset = _LBL_rating.frame;
//    frameset.origin.y = _LBL_item_name.frame.origin.y + _LBL_item_name.frame.size.height;
//    _LBL_rating.frame = frameset;
//    
//     frameset = _LBL_my_review.frame;
//    frameset.origin.y = _LBL_item_name.frame.origin.y + _LBL_item_name.frame.size.height;
//    _LBL_my_review.frame = frameset;
//    
//    frameset = _TXT_review_title.frame;
//    frameset.origin.y = _LBL_my_review.frame.origin.y + _LBL_my_review.frame.size.height;
//    _TXT_review_title.frame = frameset;
//    
//    frameset = _TXT_review_review.frame;
//    frameset.origin.y = _TXT_review_title.frame.origin.y + _TXT_review_title.frame.size.height;
//    _TXT_review_review.frame = frameset;
//    
//    frameset = _BTN_save.frame;
//    frameset.origin.y = _TXT_review_review.frame.origin.y + _TXT_review_review.frame.size.height;
//    _BTN_save.frame = frameset;
    
    lbl_review = [[HCSStarRatingView alloc] init];
    lbl_review.frame = CGRectMake(_LBL_my_review.frame.origin.x + _LBL_my_review.frame.size.width+3 ,_LBL_my_review.frame.origin.y-15  ,150.0f,_LBL_my_review.frame.size.height + 20);
    lbl_review.maximumValue = 5;
    lbl_review.minimumValue = 0;
    lbl_review.value = 0;
    
    lbl_review.tintColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    [lbl_review addTarget:self action:@selector(didChangeValue) forControlEvents:UIControlEventValueChanged];
    lbl_review.allowsHalfStars = YES;
    [self.view addSubview:lbl_review];
    
    NSString *item_name =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"review_item_name"]];
    
    item_name = [item_name stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
    NSString *item_seller =[NSString stringWithFormat:@"Seller:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"review_item_seller_name"]];
    item_seller = [item_seller stringByReplacingOccurrencesOfString:@"<null>" withString:@"not mentioned"];
    
    NSString *image_url =[NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"review_item_image_name"]];
    image_url = [image_url stringByReplacingOccurrencesOfString:@"  " withString:@"%20"];

    
    
    [_Item_image sd_setImageWithURL:[NSURL URLWithString:image_url]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
    _LBL_item_name.text = item_name;
     _LBL_seller.text = item_seller;

    
    _LBL_item_name.numberOfLines = 0;
    [_BTN_save addTarget:self action:@selector(SAVE_ACTION) forControlEvents:UIControlEventTouchUpInside];
    _TXT_review_review.layer.cornerRadius = 2.0f;
    _TXT_review_review.layer.borderColor = [UIColor lightGrayColor].CGColor;
    _TXT_review_review.layer.borderWidth = 0.5f;
    _TXT_review_review.layer.masksToBounds = YES;
    
    


}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationController.navigationBar.hidden = NO;
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    
    activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityIndicatorView.frame = CGRectMake(0, 0, activityIndicatorView.bounds.size.width, activityIndicatorView.bounds.size.height);
    activityIndicatorView.center = VW_overlay.center;
    [VW_overlay addSubview:activityIndicatorView];
    VW_overlay.center = self.view.center;
    [self.view addSubview:VW_overlay];
    VW_overlay.hidden = YES;

    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
    
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
     if(result.height <= 568)
     {
    
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
     }

}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGSize result = [[UIScreen mainScreen] bounds].size;
    if(result.height <= 568)
    {
    [UIView beginAnimations:nil context:NULL];
    
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    }
    
}
- (IBAction)back_ACTIon:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (IBAction)wish_list_action:(id)sender {
    [self performSegueWithIdentifier:@"rating_to_wish_lsit" sender:self];
}
- (IBAction)cart_action:(id)sender {
    [self performSegueWithIdentifier:@"rating_to_cart_lsit" sender:self];

}
-(void)SAVE_ACTION
{
    //product-reviews/add-review/"+product_id+"/"+userid+"/
   
    if(_TXT_review_review.text.length < 32)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Length should be More " delegate:self cancelButtonTitle:@"cancel" otherButtonTitles:@"Ok", nil];
        alert.tag = 1;
        [alert show];
    }
    else
    {
    
    @try
    {
        
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        NSString *rating_text = [NSString stringWithFormat:@"%@",_TXT_review_review.text];
        NSString *rating = [NSString stringWithFormat:@"%f",lbl_review.value];
        NSString *prodID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"review_Prod_ID"]];

//        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
//        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
//        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
//        NSString *ORDER_ID = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"order_ID"]];
        
        
        NSString *urlString =[NSString stringWithFormat:@"%@Apis/oproduct-reviews/add-review/%@/%@/1.json",SERVER_URL,user_id,prodID];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlString]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        //    [request setHTTPBody:body];
        
        // text parameter
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"comment\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",rating_text]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        // another text parameter
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"rating\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",rating]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
//        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"langId\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[[NSString stringWithFormat:@"%@",languge]dataUsingEncoding:NSUTF8StringEncoding]];
//        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        //    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"id\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[[NSString stringWithFormat:@"%@",GET_prof_ID]dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //
        //
        //    NSData *webData = UIImageJPEGRepresentation(_img_Profile.image, 100);
        //    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        //    NSString *documentsDirectory = [paths objectAtIndex:0];//@"sample.png"
        //    NSString *localFilePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.jpg",[self randomStringWithLength:7]]];
        //    [webData writeToFile:localFilePath atomically:YES];
        //    NSLog(@"localFilePath.%@",localFilePath);
        //
        //    [[NSUserDefaults standardUserDefaults]setValue:localFilePath forKey:@"new_PP"];
        //    [[NSUserDefaults standardUserDefaults]synchronize];
        //
        //    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: multipart/form-data; name=\"uploaded_file\"; filename=\"%@\"\r\n",localFilePath] dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[@"Content-Type: application/octet-stream\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        //    [body appendData:[NSData dataWithData:imageData]];
        //    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        //
        NSError *er;
        //    NSHTTPURLResponse *response = nil;
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        if (returnData) {
            json_DATA = [[NSMutableDictionary alloc]init];
            json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&er];
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
            NSLog(@"%@", [NSString stringWithFormat:@"JSON DATA OF ORDER DETAIL: %@", json_DATA]);
        }
    }
    @catch(NSException *exception)
    {
        
    }
    }

    
    
    
//    
//    @try
//    {
//        
//        NSDictionary *parameters = @{
//                                     @"comment": rating_text,
//                                     @"rating":rating
//                                     };
//        NSError *error;
//        NSError *err;
//        NSHTTPURLResponse *response = nil;
//        
//        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
//        NSLog(@"the posted data is:%@",parameters);
//        NSString *urlGetuser =[NSString stringWithFormat:@"%@Apis/oproduct-reviews/add-review/%@/%@/1.json",SERVER_URL,user_id,prodID];
//        // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
//        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
//        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
//        [request setURL:urlProducts];
//        [request setHTTPMethod:@"POST"];
//        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
//        [request setHTTPBody:postData];
//        //[request setAllHTTPHeaderFields:headers];
//        [request setHTTPShouldHandleCookies:NO];
//        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
//        if(aData)
//        {
//            json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
//            NSLog(@"The response Api post sighn up API %@",json_DATA);
//            [activityIndicatorView stopAnimating];
//            VW_overlay.hidden = YES;
//            
//            
//        }
//        else
//        {
//            [activityIndicatorView stopAnimating];
//            VW_overlay.hidden = YES;
//            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//            [alert show];
//        }
//        
//    }
//    
//    @catch(NSException *exception)
//    {
//        NSLog(@"The error is:%@",exception);
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
//    }

}
-(void)didChangeValue
{
    NSLog(@"The rating is:%f",lbl_review.value);
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

@end
