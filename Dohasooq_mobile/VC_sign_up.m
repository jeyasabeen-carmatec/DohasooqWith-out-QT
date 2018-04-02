//
//  VC_sign_up.m
//  Dohasooq_mobile
//
//  Created by Test User on 22/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_sign_up.h"
#import "Home_page_Qtickets.h"
#import "HttpClient.h"
#import "Helper_activity.h"

@interface VC_sign_up ()<UIGestureRecognizerDelegate,UITextFieldDelegate,UIAlertViewDelegate,UIPickerViewDelegate,UIPickerViewDataSource>
{
    float scroll_height;
    UIView *VW_overlay;
    UIImageView *activityIndicatorView;
    UIPickerView *phone_picker;
    NSMutableArray *phone_code_arr;
     UIToolbar *accessoryView;
    NSString *flag;
}
@end

@implementation VC_sign_up

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   
    
    
}

-(void)viewWillAppear:(BOOL)animated
{
    //********************* creating status bar **********************//

    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    VW_overlay.clipsToBounds = YES;
    
    //********************* creating invisble Overlay view **********************//

    VW_overlay.hidden = NO;
    activityIndicatorView = [[UIImageView alloc] initWithImage:[UIImage new]];
    activityIndicatorView.frame = CGRectMake(0, 0, 60, 60);
    activityIndicatorView.center = VW_overlay.center;
    
    //********************* loader creation with images **********************//

    
    activityIndicatorView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"],[UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"],[UIImage imageNamed:@"loader14.png"],[UIImage imageNamed:@"loader15.png"],[UIImage imageNamed:@"loader16.png"],[UIImage imageNamed:@"loader17.png"],[UIImage imageNamed:@"loader18.png"],nil];
    
    activityIndicatorView.animationDuration = 3.0;
    [activityIndicatorView startAnimating];
    activityIndicatorView.center = VW_overlay.center;
    
    [VW_overlay addSubview:activityIndicatorView];
    
    [self.view addSubview:VW_overlay];
    
    VW_overlay.hidden = YES;
    
     [self set_UP_View];

}
-(void)set_UP_View
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    
    
    CGRect setup_frame  = _VW_contents.frame;
    setup_frame.size.width = _Scroll_contents.frame.size.width;
    setup_frame.size.height = _BTN_close.frame.origin.y + _BTN_close.frame.size.height+ 20;
    _VW_contents.frame = setup_frame;
    [self.Scroll_contents addSubview:_VW_contents];
    
    setup_frame = _BTN_close.frame;
    setup_frame.origin.x = self.view.frame.size.width / 2 - _BTN_close.frame.size.width/2 + 10;
    _BTN_close.frame = setup_frame;
    
     scroll_height =_VW_contents.frame.origin.y+ _VW_contents.frame.size.height;
    
    UIImage *newImage = [_BTN_close.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    UIGraphicsBeginImageContextWithOptions(_BTN_close.image.size, NO, newImage.scale);
    [[UIColor darkGrayColor] set];
    [newImage drawInRect:CGRectMake(0, 0, _BTN_close.image.size.width/2, newImage.size.height/2)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    _BTN_close.image = newImage;
    
    _BTN_close .userInteractionEnabled = YES;
    
    
    //********************* Adding tap gesture to close image **********************//

    
    UITapGestureRecognizer *tapGesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(tapGesture_close)];
    
    tapGesture1.numberOfTapsRequired = 1;
    
    [tapGesture1 setDelegate:self];
    
    //********************* creating tool bar for picker view **********************//

    
    accessoryView = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    accessoryView.barStyle = UIBarStyleBlackTranslucent;
    [accessoryView sizeToFit];
    
    
    //********************* adding buttons for toolbar **********************//

    UIButton *done=[[UIButton alloc]init];
    done.frame=CGRectMake(accessoryView.frame.size.width - 100, 0, 100, accessoryView.frame.size.height);
    [done setTitle:@"Done" forState:UIControlStateNormal];
    [done addTarget:self action:@selector(picker_done_btn_action:) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:done];
    
    
    UIButton *close=[[UIButton alloc]init];
    close.frame=CGRectMake(accessoryView.frame.origin.x -20 , 0, 100, accessoryView.frame.size.height);
    [close setTitle:@"Close" forState:UIControlStateNormal];
    [close addTarget:self action:@selector(close_ACTION) forControlEvents:UIControlEventTouchUpInside];
    [accessoryView addSubview:close];
    
    
    _TXT_prefix.inputAccessoryView = accessoryView;
    _TXT_prefix.inputView = phone_picker;

    [self gettingCountryCodeForMobile];

    [_BTN_close addGestureRecognizer:tapGesture1];
    [_BTN_submit addTarget:self action:@selector(submit_Action) forControlEvents:UIControlEventTouchUpInside];
    
}
-(void)picker_done_btn_action:(id)sender{
    
    [self.view endEditing:YES];
    //[textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
    
    
}
-(void)close_ACTION{
    [self.view endEditing:YES];
}

-(void)tapGesture_close
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,scroll_height);

    
}
#pragma textfield delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _TXT_email ||textField == _TXT_phone ||textField ==_TXT_password)
    {
        scroll_height = scroll_height + 120;
        [self viewDidLayoutSubviews];

    }
    if(textField == _TXT_con_password)
    {
        scroll_height = scroll_height + 140;
        [self viewDidLayoutSubviews];
    }
    
}
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    
    if(textField == _TXT_email ||textField == _TXT_phone ||textField ==_TXT_password)
    {
        [textField resignFirstResponder];
        scroll_height = scroll_height - 120;
        [self viewDidLayoutSubviews];
        
    }
    if(textField == _TXT_con_password)
    {
         [textField resignFirstResponder];
        scroll_height = scroll_height - 160;
        [self viewDidLayoutSubviews];
    }
    
    if (textField == _TXT_password) {
        
        BOOL lowerCaseLetter = false,upperCaseLetter = false,digit = false,specialCharacter = 0;
       // if([textField.text length] >= 8)
        //{
        
        //********************* Passowrd Format checking **********************//
        
            for (int i = 0; i < [textField.text length]; i++)
            {
                unichar c = [textField.text characterAtIndex:i];
                if(!lowerCaseLetter)
                {
                    lowerCaseLetter = [[NSCharacterSet lowercaseLetterCharacterSet] characterIsMember:c];
                }
                if(!upperCaseLetter)
                {
                    upperCaseLetter = [[NSCharacterSet uppercaseLetterCharacterSet] characterIsMember:c];
                }
                if(!digit)
                {
                    digit = [[NSCharacterSet decimalDigitCharacterSet] characterIsMember:c];
                }
                if(!specialCharacter)
                {
                    specialCharacter = [[NSCharacterSet symbolCharacterSet] characterIsMember:c];
                }
            }
            
            if( digit && lowerCaseLetter && upperCaseLetter )
            {
                NSLog(@"Valid Password");
            }
            else
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    [HttpClient createaAlertWithMsg:@"يجب أن تحتوي كلمة المرور على رقم واحد وحرف واحد كبير و 8 أحرف كحد أدنى" andTitle:@""];
                }
                else{

                [HttpClient createaAlertWithMsg:@"The password must contain one number, one capital letter and 8 char minimum" andTitle:@""];
                }
                //[textField becomeFirstResponder];
            }
            
       // }
        
        
        
        
        
    }
    
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField.tag==1)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 30)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return string;
    }
    if(textField.tag==2)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 30)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
        }
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz "] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return string;
    }
    
    if(textField.tag==3)
    {
        NSInteger inte = textField.text.length;
        if([_TXT_prefix.text isEqualToString:@"+974"])
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
//        NSCharacterSet *invalidCharSet = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789()+- "] invertedSet];
//        NSString *filtered = [[string componentsSeparatedByCharactersInSet:invalidCharSet] componentsJoinedByString:@""];
        return string;
        
    }
 return YES;
}
#pragma Button Actions and Validations for TExtfields

-(void)submit_Action
{
    NSString *text_to_compare_email = _TXT_email.text;
    NSString *text_phone  = _TXT_phone.text;

    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
     NSString *msg;
    if ([_TXT_F_name.text isEqualToString:@""])
    {
         [_TXT_F_name becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى إدخال الاسم الأول";
        }
        else{
           msg = @"Please enter First Name";
        }
       
    }
    else if(_TXT_F_name.text.length < 3)
    {
        [_TXT_F_name becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يجب ألا يكون الاسم الأول أقل من 3 أحرف";
        }
        else{
            msg = @"First name should not be less than 3 characters";

        }
        
    }
      else if([_TXT_F_name.text isEqualToString:@" "])
    {
        [_TXT_F_name becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"مساحة فارغة غير مسموح بها";
        }
        else{
            msg = @"Blank space are not allowed";
            
        }
        
   }
    else if ([_TXT_L_name.text isEqualToString:@""])
    {
        [_TXT_L_name becomeFirstResponder];
        msg = @"Please enter Last Name";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg =@"يرجى إدخال اسم العائلة";
        }
        else{
        }
        
    }
    else if(_TXT_L_name.text.length < 1)
    {
        [_TXT_L_name becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg =@"يجب ألا يكون اسم العائلة أقل من حرف واحد";
        }
        else{
            msg = @"Last name should not be less than 1 character";

        }
      
        
    }
      else if([_TXT_L_name.text isEqualToString:@" "])
    {
        [_TXT_L_name becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"مساحة فارغة غير مسموح بها";
        }
        else{
            msg = @"Blank space are not allowed";
            
        }
        
        
    }
   
     else if ([_TXT_phone.text isEqualToString:@""])
     {
          [_TXT_phone becomeFirstResponder];
         if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
         {
             msg = @"يرجى إدخال رقم الهاتف";
         }
         else{
             msg = @"Please enter Phone Number";

         }
        
        
         
     }
   else if([_TXT_prefix.text isEqualToString:@"+974"])
    {
        if(_TXT_phone.text.length < 8)
        {
            _TXT_phone.text = text_phone;
            [_TXT_phone becomeFirstResponder];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                msg = @"يجب أن يكون رقم الهاتف 8 أحرف";
            }
            else{
                msg = @"Phone Number should be 8 characters";

            }
            
            
        }

    }
    else  if (_TXT_phone.text.length < 5)
    {
         [_TXT_phone becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"لا يمكن أن يكون رقم الهاتف أقل من 5 أرقام";
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
            msg = @"يجب ألا يزيد رقم الهاتف عن 15 حرفًا";
        }
        else{
            msg = @"Phone Number should not be more than 15 characters";

        }
       
      
    }
  
   
    else if([_TXT_email.text isEqualToString:@""])
    {
        [_TXT_email becomeFirstResponder];
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
        [_TXT_email becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"الرجاء إدخال عنوان بريد إلكتروني صالح";
        }
        else{
            msg = @"Please enter valid email address";
            
        }
        
        
        
    }
    else if([_TXT_password.text isEqualToString:@""])
    {
         [_TXT_password becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى إدخال كلمة المرور";
        }
        else{
            msg = @"Please enter Password";

        }
       
        
    }
    else if(_TXT_password.text.length < 8)
    {
         [_TXT_password becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"من السهل تخمين كلمات المرور القصيرة. جرب واحدة مع ما لا يقل عن 8 أحرف";
        }
        else{
            msg = @"Short passwords are easy to guess. Try one with at least 8 characters";

        }
       
    }
    else if(_TXT_password.text.length > 64)
    {
        [_TXT_password becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"لا يمكن أن يكون حقل كلمة المرور أكثر من 64 مقسماً";
        }
        else{
            msg = @"Password field cannot be more than 64 charcaters";

        }
    }
    else if(_TXT_con_password.text.length == 0)
    {
        [_TXT_password becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
           msg = @"من فضلك أدخل كلمة مرور تأكيد";
        }
        else{
            msg = @"Please enter confirm password";

        }
    }
    else if(![_TXT_con_password.text isEqualToString:_TXT_password.text])
    {
        [_TXT_con_password becomeFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"كلمات المرور غير متطابقة. حاول مرة أخرى؟";
        }
        else{
            msg = @"These passwords don't match. Try again?";

        }
    }
    
        
    
    if(msg)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
        [HttpClient createaAlertWithMsg:msg andTitle:@""];
        
    }
    else
    {
        //        [HttpClient animating_images:self];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(_sign_up_api_integration) withObject:activityIndicatorView afterDelay:0.01];
        
    }


   // [self performSegueWithIdentifier:@"" sender:self];
    
   
}
#pragma API call For SIGN UP
-(void)_sign_up_api_integration
{
   
    @try
    {
//    [HttpClient animating_images:self.navigationController];
        
    NSString *fname = _TXT_F_name.text;
    NSString *lname = _TXT_L_name.text;
    NSString *email = _TXT_email.text;
    NSString *phone_num = _TXT_phone.text;
    NSString *password = _TXT_password.text;
    NSString *confirm_apssword = _TXT_con_password.text;
        NSString *prefix = _TXT_prefix.text;
        prefix = [prefix stringByReplacingOccurrencesOfString:@"+" withString:@""];

    NSError *error;
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/signup/1.json",SERVER_URL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:[NSURL URLWithString:urlGetuser]];
        [request setHTTPMethod:@"POST"];
        
        NSString *boundary = @"---------------------------14737809831466499882746641449";
        NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
        [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
        
        NSMutableData *body = [NSMutableData data];
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"firstname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",fname]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"lastname\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",lname]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];

        
        // another text parameter
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"email\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",email]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"mobile\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",phone_num]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //Phnumber
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",password]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //message
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password2\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",confirm_apssword]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        //organization
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"countrycode_sel\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"%@",prefix]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        
        
        //
   
        //    NSHTTPURLResponse *response = nil;
        
        // close form
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
        NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
        
        if (returnData)
        
    {
       // [HttpClient stop_activity_animation:self];
        NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:returnData options:NSASCIIStringEncoding error:&error];
        NSLog(@"The response Api post sighn up API %@",json_DATA);
        NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
        NSString *msg = [json_DATA valueForKey:@"message"];

       
        if([status isEqualToString:@"1"])
        {
           
            NSMutableDictionary *dictMutable = [[json_DATA valueForKey:@"detail"] mutableCopy];
            [dictMutable removeObjectsForKeys:[[json_DATA valueForKey:@"detail"] allKeysForObject:[NSNull null]]];
            
            [[NSUserDefaults standardUserDefaults] setObject:dictMutable forKey:@"userdata"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [[NSUserDefaults standardUserDefaults]setObject:self.TXT_email.text forKey:@"email"];
            [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"user_email"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Your Registration has been Successful" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            alert.tag = 1;
            [alert show];

            
            [self.view endEditing:TRUE];

            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;

            
        }
        else
        {
            [activityIndicatorView stopAnimating];
            VW_overlay.hidden = YES;
//             [HttpClient stop_activity_animation:self];
            if ([msg isEqualToString:@"User already exists"])
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    
                    msg = @"عنوان البريد الإلكتروني المستخدم بالفعل ، يرجى المحاولة باستخدام بريد إلكتروني مختلف.";
                }else{
                    msg = @"Email address already in use, Please try with different email.";
                    
                }
            }
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            
            [alert show];
        }
       
    }
    else
    {
//      [HttpClient stop_activity_animation:self];
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
       
        [alert show];
    }

    }
        
    @catch(NSException *exception)
    {
//         [HttpClient stop_activity_animation:self];
        [activityIndicatorView stopAnimating];
        VW_overlay.hidden = YES;
        NSLog(@"The error is:%@",exception);
        
    }
    
//    [HttpClient stop_activity_animation:self];
    
}
#pragma Alert View Delegate
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            NSLog(@"cancel:");
            
            
        }
        
        else{
            
//            Home_page_Qtickets *intial = [self.storyboard instantiateViewControllerWithIdentifier:@"QT_controller"];
//            [self presentViewController:intial animated:NO completion:nil];
            [self cart_count];
            [self performSegueWithIdentifier:@"signUP_home" sender:self];

            
           
            
            
        }
    }
}
#pragma Cart Count API calling
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
                [self dismissViewControllerAnimated:NO completion:nil];
                
                
            } @catch (NSException *exception) {
                //                 VW_overlay.hidden = YES;
                //                [activityIndicatorView stopAnimating];
                
                
                NSLog(@"asjdas dasjbd asdas iccxv %@",exception);
            }
            
        }
    }];
}
// Retriving Country Code for Phone number from JSON File
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
    
    NSLog(@"%@",sorted_arr);
    
    for(int k = 0; k < phone_code_arr.count;k++)
    {
        if([[[sorted_arr objectAtIndex:k] valueForKey:@"name"] isEqualToString:@"Qatar"])
        {
            [phone_picker selectRow:k inComponent:0 animated:NO];
            
            [self pickerView:phone_picker didSelectRow:k inComponent:0];
            
            
        }
    }
    
    
    phone_picker = [[UIPickerView alloc] init];
    phone_picker.delegate = self;
    phone_picker.dataSource = self;
    _TXT_prefix.inputAccessoryView = accessoryView;
    _TXT_prefix.inputView = phone_picker;
    
}
#pragma PICKER VIEW DELEGATES

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    
    
        return phone_code_arr.count;
        
    
}
- (nullable NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    
    
  
        
    return [NSString stringWithFormat:@"%@   %@",[phone_code_arr[row] valueForKey:@"name"],[phone_code_arr[row] valueForKey:@"code"]];
    
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
  
        flag = [NSString stringWithFormat:@"%@",[phone_code_arr[row] valueForKey:@"code"]];
        _TXT_prefix.text = flag;
        
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
