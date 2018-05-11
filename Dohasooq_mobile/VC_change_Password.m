//
//  VC_change_Password.m
//  Dohasooq_mobile
//
//  Created by Test User on 27/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_change_Password.h"
#import "HttpClient.h"
#import "ViewController.h"
#import "Helper_activity.h"

@interface VC_change_Password ()<UITextFieldDelegate>
{
//    UIView *VW_overlay;
//    UIActivityIndicatorView *activityIndicatorView;

}
@end

@implementation VC_change_Password

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Change password screen";

    _TXT_old_pwd.delegate= self;
    _TXT_new_pwd.delegate = self;
    _TXT_confirm_pwd.delegate = self;
    
    //_vw_align.center = self.view.center;
    
}
-(void)viewWillAppear:(BOOL)animated
{
    self.navigationItem.hidesBackButton = YES;
}
#pragma textfield delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    
    if( textField == _TXT_new_pwd ||textField ==  _TXT_confirm_pwd)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height <= 480)
        {
            [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
            [UIView beginAnimations:nil context:NULL];
            self.view.frame = CGRectMake(0,-70,self.view.frame.size.width,self.view.frame.size.height);
            [UIView commitAnimations];
            
            
        }
        else if(result.height <= 568)
        {
            [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
            [UIView beginAnimations:nil context:NULL];
            self.view.frame = CGRectMake(0,-70,self.view.frame.size.width,self.view.frame.size.height);
            [UIView commitAnimations];
            
        }
    }
    else
    {
        [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
  //  [UIView beginAnimations:nil context:NULL];
    
    if (textField == _TXT_old_pwd && textField.text.length > 1)
    {
        BOOL lowerCaseLetter = false,upperCaseLetter = false,digit = false,specialCharacter = 0;
       
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
            
            if( digit && lowerCaseLetter && upperCaseLetter)
            {
                NSLog(@"Valid Password");
            }
            else
            {
                NSString *str;//

                NSString *str_ok;
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    str = @"يجب أن تحتوي كلمة المرور على رقم واحد و 8 رموز على الأقل";
                    str_ok = @"حسنا";
                }
                else
                {
                    str =  @"The password must contain one number, one capital letter and 8 char minimum";
                    str_ok = @"Ok";
                }
                
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:str_ok, nil];
                [alert show];
                
                //[HttpClient createaAlertWithMsg:@"The password must contain one number and 8 char minimum" andTitle:@""];
                [textField becomeFirstResponder];
            }
            
        
      /*  else
        {
            NSString *str =  @"he password must contain one number and 8 char minimum";//
            
            NSString *str_ok = @"Ok";
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                str = @"يجب أن تحتوي كلمة المرور على رقم واحد و 8 رموز على الأقل";
                str_ok = @"حسنا";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:str_ok, nil];
            [alert show];
            [textField becomeFirstResponder];
        }*/
        
        
        
    }
    if (textField == _TXT_new_pwd && textField.text.length > 1)
    {
        
        BOOL lowerCaseLetter = false,upperCaseLetter = false,digit = false,specialCharacter = 0;
       
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
                NSString *str =  @"The password must contain one number, one capital letter and 8 char minimum";//
                
                NSString *str_ok = @"Ok";
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    str = @"يجب أن تحتوي كلمة المرور على رقم واحد و 8 رموز على الأقل";
                    str_ok = @"حسنا";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:str_ok, nil];
                [alert show];
                [textField becomeFirstResponder];
            }
            
        
       /* else
        {
            NSString *str =  @"he password must contain one number and 8 char minimum";//
            
            NSString *str_ok = @"Ok";
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                str = @"يجب أن تحتوي كلمة المرور على رقم واحد و 8 رموز على الأقل";
                str_ok = @"حسنا";
            }
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:str_ok, nil];
            [alert show];
            [textField becomeFirstResponder];
        }*/
        
        
    }
    if (textField == _TXT_confirm_pwd && textField.text.length > 1)
    {
        BOOL lowerCaseLetter = false,upperCaseLetter = false,digit = false,specialCharacter = 0;
       
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
            
            if( digit && lowerCaseLetter && upperCaseLetter)
            {
                NSLog(@"Valid Password");
            }
            else
            {
                NSString *str =  @"The password must contain one number, one capital letter and 8 char minimum";//
                
                NSString *str_ok = @"Ok";
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    str = @"يجب أن تحتوي كلمة المرور على رقم واحد و 8 رموز على الأقل";
                    str_ok = @"حسنا";
                }
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str delegate:self cancelButtonTitle:nil otherButtonTitles:str_ok, nil];
                [alert show];
                [textField becomeFirstResponder];
            }
            
        
        
    }
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height <= 480)
    {
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];

    }
    else if(result.height <= 568)
    {
        [UIView beginAnimations:nil context:NULL];
        self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
        [UIView commitAnimations];

    }
    else
    {
    }


//    if( textField == _TXT_confirm_pwd || _TXT_new_pwd)
//    {
      //  //    }
    
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{ if (textField == _TXT_old_pwd)
{
    NSInteger inte = textField.text.length;
    if(inte >= 64)
    {
        if ([string isEqualToString:@""]) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    return YES;
}
    if (textField == _TXT_new_pwd)
    {
        
        
        NSInteger inte = textField.text.length;
        if(inte >= 64)
        {
            if ([string isEqualToString:@""]) {
                return YES;
            }
            else
            {
                return NO;
            }
            
        }
        
        return YES;
    }
    if (textField == _TXT_confirm_pwd)
    {
        NSInteger inte = textField.text.length;
        if(inte >= 64)
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
    return YES;

}

- (IBAction)BTN_save_action:(id)sender {
    
    [UIView beginAnimations:nil context:NULL];
    
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];

    
    NSString *msg;

     if([_TXT_old_pwd.text isEqualToString:@""])
    {
        [_TXT_old_pwd becomeFirstResponder];
        msg = @"Please enter Password";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى إدخال كلمة المرور";
        }
        
        
    }
    else if(_TXT_old_pwd.text.length < 8)
    {
        [_TXT_old_pwd becomeFirstResponder];
        msg = @"Short passwords are easy to guess. Try one with at least 8 characters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يسهل تخمين كلمات المرور القصيرة، يرجى محاولة إنشاء كلمة مرور لا تقلّ عن 8 رموز";
        }
        

        
    }
    else if(_TXT_old_pwd.text.length > 64)
    {
        [_TXT_old_pwd becomeFirstResponder];
        msg = @"Password field cannot be more than 64 charcaters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"لا يجوز أن يزيد حقل كلمة المرور عن 64 رمزاً";
        }
    }
   else if([_TXT_new_pwd.text isEqualToString:@""])
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Please enter New Password";//يرجى إدخال كلمة مرور جديدة
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى إدخال كلمة مرور جديدة";
        }

        
        
    }
    else if(_TXT_new_pwd.text.length < 8)
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Short Passwords are easy to guess. Try one with at least 8 characters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يسهل تخمين كلمات المرور القصيرة، يرجى محاولة إنشاء كلمة مرور لا تقلّ عن 8 رموز";
        }
        
    }
    else if(_TXT_new_pwd.text.length > 64)
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Password field cannot be more than 64 charcaters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"لا يجوز أن يزيد حقل كلمة المرور عن 64 رمزاً";
        }
    }
    else if([_TXT_confirm_pwd.text isEqualToString:@""])
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Please enter Confirm Password";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى تأكيد كلمة المرور";
        }
        
        
    }
    else if(_TXT_confirm_pwd.text.length < 8)
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Short passwords are easy to guess. Try one with at least 8 characters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يسهل تخمين كلمات المرور القصيرة، يرجى محاولة إنشاء كلمة مرور لا تقلّ عن 8 رموز";
        }
        
    }
    else if(_TXT_confirm_pwd.text.length > 64)
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"Password field cannot be more than 64 charcaters";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"لا يجوز أن يزيد حقل كلمة المرور عن 64 رمزاً";
        }

    }
    else if(![_TXT_new_pwd.text  isEqualToString:_TXT_confirm_pwd.text])
    {
        [_TXT_new_pwd becomeFirstResponder];
        msg = @"These passwords don't match. Try again";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"كلمات المرور غير متطابقة، يرجى المحاولة مرة أخرى.";
        }

    }
    else
    {
        [Helper_activity animating_images:self];
        
        [self performSelector:@selector(API_CALL) withObject:nil afterDelay:0.01];
        
    }
    if(msg)
    {
    
        
        NSString *str_ok = @"Ok";
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
                     str_ok = @"حسنا";
        }
       

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:str_ok, nil];
        [alert show];

    }
}

#pragma mark Calling change-password API

-(void)API_CALL
{
    
 
    @try
    {
        NSString *old_pwd = [NSString stringWithFormat:@"%@",_TXT_old_pwd.text];
        NSString *new_pwd = [NSString stringWithFormat:@"%@",_TXT_new_pwd.text];
        NSString *confirm_pwd = [NSString stringWithFormat:@"%@",_TXT_confirm_pwd.text];

        NSDictionary *parameters = @{
                                     @"old_password":old_pwd,
                                     @"password":new_pwd,
                                     @"confirm_password":confirm_pwd
                                     
                                     };
        NSError *error;
      //  NSError *err;
        NSHTTPURLResponse *response = nil;
        
     //   NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
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

        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/change-password/1/%@.json",SERVER_URL,user_id];
        // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
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
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"old_password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",old_pwd]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",new_pwd]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        
        [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"confirm_password\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]]; //venu1@carmatec.com
        [body appendData:[[NSString stringWithFormat:@"%@",confirm_pwd]dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
        [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
        
        // set request body
        [request setHTTPBody:body];
        
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
               [Helper_activity stop_activity_animation:self];
                NSString *str_ok = @"Ok";
                
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    str_ok = @"حسنا";
                                }

                
                //تم حفظ كلمة المرور الجديدة

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:str_ok otherButtonTitles:nil, nil];
                [alert show];
//                ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
//                [self presentViewController:login animated:NO completion:nil];
               // [self performSegueWithIdentifier:@"cahnge_password_identofier" sender:self];
                 [self.navigationController popViewControllerAnimated:YES];
                
            }
            else
            {
                 [Helper_activity stop_activity_animation:self];
                NSString *str_ok = @"Ok";
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    str_ok = @"حسنا";
                }

                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:str_ok, nil];
                [alert show];
             
            }
            
        }
        
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
    }

    
}

- (IBAction)back_action:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)home_action:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
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
