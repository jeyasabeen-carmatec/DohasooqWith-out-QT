//
//  ViewController.m
//  Dohasooq_mobile
//
//  Created by Test User on 22/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "ViewController.h"
#import "HttpClient.h"
#import <Google/SignIn.h>
#import "Helper_activity.h"


@interface ViewController ()<UITextFieldDelegate,FBSDKLoginButtonDelegate,GIDSignInUIDelegate,GIDSignInDelegate>
{
   UIView *VW_overlay;
    UIImageView *activityIndicatorView;
    NSDictionary *social_dictl;
    NSString *first_name,*last_name,*emails;
    
    
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    /*************** Google SignIn ***************/
    // Receive signed user information from AppDelegate.m
//    [[NSNotificationCenter defaultCenter] addObserverForName:@"GoogleUserInfo" object:nil queue:nil usingBlock:^(NSNotification *note) {
//        NSString *userId = [note.userInfo objectForKey:@"userId"];
//        NSString *idToken = [note.userInfo objectForKey:@"idToken"];
//        NSString *accessToken = [note.userInfo objectForKey:@"accessToken"];
//        NSString *userName = [note.userInfo objectForKey:@"userName"];
//        NSString *userEmail = [note.userInfo objectForKey:@"userEmail"];
//        
//        NSLog(@"ISUGoogleViewController ===> [1] ID : %@ | [2] idToken : %@ | [3] accessToken : %@ | [4] name : %@ | [5] email : %@",
//              userId, idToken, accessToken, userName, userEmail);
//        
//          }];
//    
    
    
    // Region start
    [GIDSignIn sharedInstance].uiDelegate = self;
    
    // Create google button instance
    
    // Uncomment to automatically sign in the user.
    //[[GIDSignIn sharedInstance] signInSilently];
    // Region end
    self.screenName = @"Login screen";
    [self set_UP_View];
    
}
- (void)signInWillDispatch:(GIDSignIn *)signIn error:(NSError *)error {
    
   //[Helper_activity animating_images:self];
}

-(void)viewWillAppear:(BOOL)animated
{
       //********************* Status bar view **********************//
    
        VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
        VW_overlay.clipsToBounds = YES;
        
    //********************* Loader image array creation **********************//

        VW_overlay.hidden = NO;
        activityIndicatorView = [[UIImageView alloc] initWithImage:[UIImage new]];
        activityIndicatorView.frame = CGRectMake(0, 0, 60, 60);
        activityIndicatorView.center = VW_overlay.center;
        
        activityIndicatorView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"],[UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"],[UIImage imageNamed:@"loader14.png"],[UIImage imageNamed:@"loader15.png"],[UIImage imageNamed:@"loader16.png"],[UIImage imageNamed:@"loader17.png"],[UIImage imageNamed:@"loader18.png"],nil];
        
        activityIndicatorView.animationDuration = 3.0;
        [activityIndicatorView startAnimating];
        activityIndicatorView.center = VW_overlay.center;
        
        [VW_overlay addSubview:activityIndicatorView];
        
        [self.view addSubview:VW_overlay];
        
        VW_overlay.hidden = YES;

    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:0.98 green:0.69 blue:0.19 alpha:1.0];
    [self.navigationController.view addSubview:view];
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
-(void)set_UP_View
{
    
    //*********************  **********************//

    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.tintColor = [UIColor clearColor];
    self.navigationItem.hidesBackButton = YES;
    
    _BTN_guest.layer.cornerRadius = self.BTN_guest.frame.size.width/2;
    _BTN_guest.layer.masksToBounds  = YES;
    
    _VW_fields.center = self.view.center;
    
    
    //********************* sign up text fitting **********************//

    
    @try {
        
        NSString *need_sign = @"NEED AN ACCOUNT ?";
        
        NSString *sign_UP = @"SIGN UP";

        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
          need_sign = @"هل تحتاج إلى إنشاء حساب؟";
            sign_UP = @"تفضّل بالتسجيل";
        }
        
        
        
        NSString *text = [NSString stringWithFormat:@"%@ %@",need_sign,sign_UP];
        if ([_LBL_sign_up respondsToSelector:@selector(setAttributedText:)]) {
            
            // Define general attributes for the entire text
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:_LBL_sign_up.textColor,
                                      NSFontAttributeName: _LBL_sign_up.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:attribs];
            
            
            CGSize result = [[UIScreen mainScreen] bounds].size;
            
            NSRange ename = [text rangeOfString:need_sign];
            
            
            if(result.height <= 480)
            {
                // iPhone Classic
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
                                        range:ename];
                [_TXT_username setFont:[UIFont fontWithName:@"Poppins-Medium" size:14]];
                [_TXT_password setFont:[UIFont fontWithName:@"Poppins-Medium" size:14]];
            }
            else if(result.height <= 568)
            {
                // iPhone 5
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:13.0]}
                                        range:ename];
                
                [_TXT_username setFont:[UIFont fontWithName:@"Poppins-Medium" size:14]];
                [_TXT_password setFont:[UIFont fontWithName:@"Poppins-Medium" size:14]];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:17.0]}
                                        range:ename];
                [_TXT_username setFont:[UIFont fontWithName:@"Poppins-Medium" size:19]];
                [_TXT_password setFont:[UIFont fontWithName:@"Poppins-Medium" size:19]];
            }
            
            
            NSRange cmp = [text rangeOfString:sign_UP];
            
            if(result.height <= 480)
            {
                // iPhone Classic
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                        range:cmp];
            }
            else if(result.height <= 568)
            {
                // iPhone 5
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15.0]}
                                        range:cmp];
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:20.0]}
                                        range:cmp];
            }
            
            
            
            self.LBL_sign_up.attributedText = attributedText;
        }
        else
        {
            _LBL_sign_up.text = text;
        }
    }
    @catch(NSException *exception)
    {
        NSLog(@"the exception:%@",exception);
    }
    
    
    
    _BTN_sign_up.layer.cornerRadius = _BTN_sign_up.frame.size.height / 2;
    _BTN_sign_up.layer.masksToBounds = YES;
    [_BTN_sign_up addTarget:self action:@selector(sign_up_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_login addTarget:self action:@selector(login_home) forControlEvents:UIControlEventTouchUpInside];
    
    _TXT_username.text = @"";
    _TXT_password.text = @"";
    
    [_BTN_facebook addTarget:self action:@selector(facebook_action:) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Google_PLUS addTarget:self action:@selector(Google_PLUS_ACTIOn) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_guest addTarget:self action:@selector(guest_action) forControlEvents:UIControlEventTouchUpInside];
    
}


#pragma textfield delgates
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
    [textField resignFirstResponder];
   
    return YES;
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{

    [textField setTintColor:[UIColor colorWithRed:0.00 green:0.18 blue:0.35 alpha:1.0]];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,-110,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
}

-(void)textFieldDidEndEditing:(UITextField *)textField
{
   // [UIView beginAnimations:nil context:NULL];
    
   // self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
   // [UIView commitAnimations];
    [UIView beginAnimations:nil context:NULL];
    self.view.frame = CGRectMake(0,0,self.view.frame.size.width,self.view.frame.size.height);
    [UIView commitAnimations];
    
}

#pragma BUTTON ACTIONS
-(void)Google_PLUS_ACTIOn
{
    //********************* Assigning google sign in delegates **********************//

    [GIDSignIn sharedInstance].delegate = self;
    [GIDSignIn sharedInstance].uiDelegate = self;
    [[GIDSignIn sharedInstance] signIn];
}
- (void)signIn:(GIDSignIn *)signIn presentViewController:(UIViewController *)viewController
{
    [self presentViewController:viewController animated:YES completion:nil];
}
- (void)signIn:(GIDSignIn *)signIn dismissViewController:(UIViewController *)viewController {
  
  [self dismissViewControllerAnimated:YES completion:nil];
    
}
- (void)signIn:(GIDSignIn *)signIn didSignInForUser:(GIDGoogleUser *)user withError:(NSError *)error {
    
    // Perform any operations on signed in user here.
    
    [[GIDSignIn sharedInstance] signOut];

    NSString *userId = user.userID;                  // For client-side use only!
    NSString *idToken = user.authentication.idToken; // Safe to send to the server
    NSString *accessToken = user.authentication.accessToken;
    NSString *name = user.profile.name;
    NSString *email = user.profile.email;
    // ...
    NSLog(@"AppDelegate ===> [1] ID : %@ | [2] idToken : %@ | [3] accessToken : %@ | [4] name : %@ | [5] email : %@", user.userID,user.authentication.idToken, user.authentication.accessToken, user.profile.name, user.profile.email);
    
    
    // Notify to ISUGoogleViewController class to regist
    
    NSDictionary* dict = [NSDictionary dictionaryWithObjectsAndKeys:
                          userId, @"userId",
                          idToken, @"idToken",
                          accessToken, @"accessToken",
                          name, @"userName",
                          email, @"userEmail",
                          nil];
    
  


    VW_overlay.hidden = NO;
    [activityIndicatorView startAnimating];
    
    if (![dict count]) {
        
        
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        
    }
    else{
        
        //********************* Getting the data from google server **********************//

        
        NSString *str = [dict valueForKey:@"userName"];
        NSArray *arr = [str componentsSeparatedByString:@" "];
        NSLog(@"The first name is:%@",[arr objectAtIndex:0]);
        first_name = [NSString stringWithFormat:@"%@",[arr objectAtIndex:0]];
        last_name = [NSString stringWithFormat:@"%@",[arr objectAtIndex:1]];
        emails = [NSString stringWithFormat:@"%@",[dict valueForKey:@"userEmail"]];
        
        
        [self performSelector:@selector(Google_plus_login) withObject:nil afterDelay:0.01];
        
        
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GoogleUserInfo" object:[UIApplication sharedApplication].keyWindow.rootViewController userInfo:dict];
    }
    
    
    
    
  
    
}

- (void)signIn:(GIDSignIn *)signIn didDisconnectWithUser:(GIDGoogleUser *)user withError:(NSError *)error {
    // Perform any operations when the user disconnects from app here.
    // ...
}
/***************** Google Sign In ******************/


- (IBAction)forgot_pwd_action:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"login_forgot_pwd" sender:self];
}
-(void)sign_up_action
{
    [self performSegueWithIdentifier:@"sign_up_segue" sender:self];
}
-(void)facebook_action:(UIButton*)sender{
    
    //********************* Facebook on click Action **********************//

    
  /*  NSString *fbAccessToken = [FBSDKAccessToken currentAccessToken].tokenString;
    NSLog(@"Token:%@",fbAccessToken);
    if([[NSUserDefaults standardUserDefaults]  objectForKey:@"login_details"])
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_details"];
        NSLog(@"dict ------ %@",dict);
        NSString *str_id =  [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
         [self getFacebookProfileInfo:str_id];
        
    }
    else{*/
   
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    login.loginBehavior = FBSDKLoginBehaviorWeb;
    [login logOut];
    [login
     logInWithReadPermissions: @[@"email",@"public_profile"]
     fromViewController:self
     handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
         if (error)
         {
             NSLog(@"Process error");
         }
         else if (result.isCancelled)
         {
             NSLog(@"Cancelled");
             [login logOut];
             //[FBSDKProfile setCurrentProfile:nil];

         }
         else
         {
              NSLog(@"RESULT - %@",result.token.userID);
             [self getFacebookProfileInfo:result.token.userID];

         }
     }];
  //  }
}
-(void)getFacebookProfileInfo:(NSString *)user_ID {
    
    
    //********************* Getting Profile Information **********************//

    
//    
//    NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
//    [parameters setValue:@"id,name,email" forKey:@"fields"];
//    
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:parameters]
//     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection,
//                                  id result, NSError *error) {
//         NSLog(@"result:%@",result);
//        // aHandler(result, error);
//     }];
//    
  //if([FBSDKAccessToken currentAccessToken])
   // {
        [[[FBSDKGraphRequest alloc]initWithGraphPath:@"me" parameters:@{@"fields":@"id,name,first_name,last_name,picture,email"}] startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error)
        {
            if(!error)
            {
                NSLog(@"THE RESPOBSE - :%@",result);
                [[NSUserDefaults standardUserDefaults] setObject:result forKey:@"login_details"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                social_dictl = [[NSUserDefaults standardUserDefaults] objectForKey:@"login_details"];
                NSLog(@"dict ------ %@",social_dictl);
                VW_overlay.hidden = NO;
                [activityIndicatorView startAnimating];
                [self performSelector:@selector(Facebook_login) withObject:nil afterDelay:0.01];

               // [self Facebook_login];
                

                
            }
        }];
        
   // }
    
        
}
    - (void)  loginButton:(FBSDKLoginButton *)loginButton
didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result
error:(NSError *)error{
    NSLog(@"LOGGED IN TO FACEBOOK");
   // [self fetchUserInfo];
}

#pragma Passing the Google profile values Doha sooq login API

-(void)Google_plus_login
{
    
    //********************* Passing the Google profile values Doha sooq login API **********************//

   
        NSString *type = @"Google_Plus";
        NSString *first_names = first_name;
        NSString *last_names = last_name;
        NSString *email = emails;

        NSDictionary *parameters = @{
                                     @"login_type": type,
                                     @"email": email,
                                     @"first_name": first_names,
                                     @"last_name": last_names

                                     };
        
        @try
        {
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/login/1.json",SERVER_URL];
        // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
            
           json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
            NSString *msg = [json_DATA valueForKey:@"message"];
            
            
            if([status isEqualToString:@"1"])
            {
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
                
                //********************* Removing Null Values form Dictionary **********************//

                
                NSMutableDictionary *dictMutable = [[json_DATA valueForKey:@"detail"] mutableCopy];
                [dictMutable removeObjectsForKeys:[[json_DATA valueForKey:@"detail"] allKeysForObject:[NSNull null]]];
                
                 [[NSUserDefaults standardUserDefaults] setValue:dictMutable forKey:@"userdata"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                //[self MENU_api_call];
                
                [self cart_count];
                
                
                
            }
            else
            {
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
                if ([msg isEqualToString:@"User already exists"])
                {
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                    
                    msg = @"عنوان البريد الإلكتروني المستخدم بالفعل ، يرجى المحاولة باستخدام بريد إلكتروني مختلف.";
                    }else{
                        msg = @"Email address already in use, Please try with different email.";

                    }
                }
//                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                [alert show];
                [HttpClient createaAlertWithMsg:msg andTitle:@""];
            }
            
        }
        else
        {
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
            
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//            [alert show];
            [HttpClient createaAlertWithMsg:@"Connection Failed" andTitle:@""];
        }
        
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
    }

    
}

#pragma Passing the Facebook profile values Doha sooq login API


-(void)Facebook_login
{
    @try
    {
       
        NSString *type = @"Facebook";
        NSString *first_nam = [NSString stringWithFormat:@"%@",[social_dictl valueForKey:@"first_name"]];
        NSString *last_nam = [NSString stringWithFormat:@"%@",[social_dictl valueForKey:@"last_name"]];
        NSString *email = [NSString stringWithFormat:@"%@",[social_dictl valueForKey:@"email"]];
        email =  [email stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
        
        NSDictionary *parameters = @{
                                     @"login_type": type,
                                     @"email": email,
                                     @"first_name": first_nam,
                                     @"last_name": last_nam
                                     
                                     };
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/login/1.json",SERVER_URL];
        // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            NSMutableDictionary *json_DATA = [[NSMutableDictionary alloc]init];
            
            json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
            NSString *msg = [json_DATA valueForKey:@"message"];
            
            
            if([status isEqualToString:@"1"])
            {
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
                
                //********************* Removing Null Values form Dictionary **********************//

                NSMutableDictionary *dictMutable = [[json_DATA valueForKey:@"detail"] mutableCopy];
                [dictMutable removeObjectsForKeys:[[json_DATA valueForKey:@"detail"] allKeysForObject:[NSNull null]]];
                
                [[NSUserDefaults standardUserDefaults] setValue:dictMutable forKey:@"userdata"];
                [[NSUserDefaults standardUserDefaults] synchronize];

               // [self MENU_api_call];
                
                [self cart_count];
                
                
                
            }
            else
            {
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
               
                if ([msg isEqualToString:@"User already exists"])
                {
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        
                        msg = @"عنوان البريد الإلكتروني المستخدم بالفعل ، يرجى المحاولة باستخدام بريد إلكتروني مختلف.";
                    }else{
                        msg = @"Email address already in use, Please try with different email.";
                        
                    }
                }
                

                [HttpClient createaAlertWithMsg:msg andTitle:@""];
            }
            
        }
        else
        {
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
    }
    
    
}

#pragma Checking the validations
-(void)login_home
{
     [_TXT_username resignFirstResponder];
     [_TXT_password resignFirstResponder];
    NSString *msg;
    NSString *text_to_compare_email = _TXT_username.text;
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegEx];
    if([_TXT_username.text isEqualToString:@""])
    {
       // [_TXT_username resignFirstResponder];
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
       // [_TXT_username resignFirstResponder];
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
        
//        [_TXT_password resignFirstResponder];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            msg = @"يرجى إدخال كلمة المرور";
        }
        else{
        msg = @"Please enter Password";
        }
    }
    //  [self performSegueWithIdentifier:@"logint_to_home" sender:self];
    
    
    else
    {
        [self.view endEditing:TRUE];
        VW_overlay.hidden = NO;
        [activityIndicatorView startAnimating];
        [self performSelector:@selector(LOGIN_up_api_integration) withObject:nil afterDelay:0.01];
        
    }
    if(msg)
    {
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//        [alert show];
        [HttpClient createaAlertWithMsg:msg andTitle:@""];
        
    }
    
}
#pragma LOGIN API calling
-(void)LOGIN_up_api_integration
{
    @try
    {
        NSString *email = _TXT_username.text;
        NSString *password = _TXT_password.text;
        NSDictionary *parameters = @{
                                     @"username": email,
                                     @"password": password
                                     
                                     };
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@customers/login/1.json",SERVER_URL];
        // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
            NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            NSString *status = [NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"success"]];
            NSString *msg = [json_DATA valueForKey:@"message"];
            
            
            if([status isEqualToString:@"1"])
            {
               
                
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];

                
                NSMutableDictionary *dictMutable = [[json_DATA valueForKey:@"detail"] mutableCopy];
                [dictMutable removeObjectsForKeys:[[json_DATA valueForKey:@"detail"] allKeysForObject:[NSNull null]]];
                
                [[NSUserDefaults standardUserDefaults] setObject:dictMutable forKey:@"userdata"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [[NSUserDefaults standardUserDefaults]setObject:self.TXT_username.text forKey:@"email"];
                [[NSUserDefaults standardUserDefaults] setObject:email forKey:@"user_email"];
                [[NSUserDefaults standardUserDefaults] synchronize];
               // [self MENU_api_call];

                [self cart_count];
                
                
                
                
            }
            else
            {
                VW_overlay.hidden = YES;
                [activityIndicatorView stopAnimating];
                
                if ([msg isEqualToString:@"User already exists"])
                {
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        
                        msg = @"عنوان البريد الإلكتروني المستخدم بالفعل ، يرجى المحاولة باستخدام بريد إلكتروني مختلف.";
                    }else{
                        msg = @"Email address already in use, Please try with different email.";
                        
                    }
                }
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:msg delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                [alert show];
                [HttpClient createaAlertWithMsg:msg andTitle:@""];
            }
            
        }
        else
        {
            VW_overlay.hidden = YES;
            [activityIndicatorView stopAnimating];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
    }
    
    @catch(NSException *exception)
    {
        VW_overlay.hidden = YES;
        [activityIndicatorView stopAnimating];
        NSLog(@"The error is:%@",exception);
    }
    
    
}
#pragma Cart count API calling
-(void)cart_count{
    
    [Helper_activity animating_images:self];
    
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
        [Helper_activity stop_activity_animation:self];
        
    }
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             ];
           
            [Helper_activity stop_activity_animation:self];
            
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
                
                
                 [Helper_activity stop_activity_animation:self];
                
                [self dismissViewControllerAnimated:NO completion:nil];
                
                
            } @catch (NSException *exception) {
                
                 [Helper_activity stop_activity_animation:self];
                
                NSLog(@"asjdas dasjbd asdas iccxv %@",exception);
                
            }
            
        }
    }];
}



#pragma guest button action

-(void)guest_action
{
      [self dismissViewControllerAnimated:NO completion:nil];

    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
