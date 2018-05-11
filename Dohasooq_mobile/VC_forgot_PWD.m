//
//  VC_forgot_PWD.m
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_forgot_PWD.h"
#import "HttpClient.h"
#import "Helper_activity.h"

@interface VC_forgot_PWD ()<UITextFieldDelegate,UIGestureRecognizerDelegate>
{
//    UIView *VW_overlay;
//    UIActivityIndicatorView *activityIndicatorView;
}
@end

@implementation VC_forgot_PWD

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.screenName = @"Forgot password screen";

    //_lbl_forgot_pwd.text = @"We just need your registered merchant\nemail address to send you password reset";
    //[_lbl_forgot_pwd sizeToFit];
    _vw_align.center = self.view.center;
    CGRect set_frame = _BTN_close.frame;
    set_frame.origin.x = self.view.frame.size.width / 2 - _BTN_close.frame.size.width/2 +10;;
    _BTN_close.frame = set_frame;

    UIImage *newImage = [_BTN_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(_BTN_close.image.size, NO, newImage.scale);
    [[UIColor darkGrayColor] set];
    [newImage drawInRect:CGRectMake(0, 0, _BTN_close.image.size.width/2, newImage.size.height/2)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _BTN_close.image = newImage;
    
    _BTN_close .userInteractionEnabled = YES;
    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close)];
    
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    
    [_BTN_close addGestureRecognizer:tapGesture1];
    [_BTN_reset_PWD addTarget:self action:@selector(forgot_action) forControlEvents:UIControlEventTouchUpInside];
    
    }
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma button action
-(void)forgot_action
{
    
    NSString *msg;
    NSString *text_to_compare_email = _TXT_forgot_pwd.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if([_TXT_forgot_pwd.text isEqualToString:@""])
    {
        [_TXT_forgot_pwd becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى إدخال البريد الإلكتروني";
        }
        else{
            msg = @"Please enter Email";
        }
    }
    
    else if([emailTest evaluateWithObject:text_to_compare_email] == NO)
    {
        [_TXT_forgot_pwd becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"الرجاء إدخال عنوان بريد إلكتروني صالح";
        }
        else{
            msg = @"Please enter valid email address";
        }
        
    }
    else
    {
        [self.view endEditing:TRUE];
        [Helper_activity animating_images:self];
        [self performSelector:@selector(Forgot_api_integration) withObject:nil afterDelay:0.01];
        
    }
    if(msg)
    {

        [HttpClient createaAlertWithMsg:msg andTitle:@""];
        
    }
    
    

}

-(void)tapGesture_close
{
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (IBAction)home_action:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma textfield delegates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if(textField)
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        
    }
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
//    [UIView beginAnimations:nil context:NULL];
    
//    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
//    [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
}
#pragma API Call
-(void)Forgot_api_integration
{
    @try
    {
        NSString *email = _TXT_forgot_pwd.text;
        NSDictionary *parameters = @{
                                     @"email": email
                                     
                                     };
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/forgotPassword/1.json",SERVER_URL];
        // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
        }
        else if(aData)
        {
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
            NSString *msg = [json_DATA valueForKey:@"message"];
            
            if([status isEqualToString:@"1"])
            {
                
                [[NSUserDefaults standardUserDefaults] setObject:[json_DATA valueForKey:@"detail"] forKey:@"userdata"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"user_email"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                
                 [Helper_activity stop_activity_animation:self];
                
                [self dismissViewControllerAnimated:YES completion:nil];
                

                [HttpClient createaAlertWithMsg:msg andTitle:@""];
                
            }
            else
            {
                [Helper_activity stop_activity_animation:self];
                
                [HttpClient createaAlertWithMsg:msg andTitle:@""];
            }
            
        }
        
        
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
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

@end
