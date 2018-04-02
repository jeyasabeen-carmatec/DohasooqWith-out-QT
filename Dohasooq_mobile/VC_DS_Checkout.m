//
//  VC_DS_Checkout.m
//  Dohasooq_mobile
//
//  Created by Test User on 07/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_DS_Checkout.h"
#import "VC_cart_list.h"
#import "Helper_activity.h"
#import "HttpClient.h"

@interface VC_DS_Checkout ()<UIWebViewDelegate>
{
    
        UIView *loadingView;
    
//    UIView *loadingView;
//    UIActivityIndicatorView *activityView;
    int tag;
   

}

@end

@implementation VC_DS_Checkout

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.hidesBackButton = YES;
    self.navigationController.navigationBar.hidden = NO;
    tag = 0;
    loadingView = [[UIView alloc]init];
    CGRect loadframe = loadingView.frame;
    loadframe.size.width = 100;
    loadframe.size.height = 100;
    loadingView.frame = loadframe;
    loadingView.center = self.view.center;
    
    loadingView.backgroundColor = [UIColor colorWithWhite:0. alpha:0.6];
    loadingView.layer.cornerRadius = 5;
    
    UIActivityIndicatorView *activityView=[[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    activityView.center = CGPointMake(loadingView.frame.size.width / 2.0, 35);
    [activityView startAnimating];
    activityView.tag = 100;
    [loadingView addSubview:activityView];
    
    UILabel* lblLoading = [[UILabel alloc]initWithFrame:CGRectMake(10, 48, 80, 30)];
    lblLoading.text = @"Loading...";
    lblLoading.textColor = [UIColor whiteColor];
    lblLoading.font = [UIFont fontWithName:lblLoading.font.fontName size:15];
    lblLoading.textAlignment = NSTextAlignmentCenter;
    [loadingView addSubview:lblLoading];
    
    [self.view addSubview:loadingView];

    
    
    NSString *html_str;
    self.web_pay.delegate = self;
    
    if ([[self.rec_dic valueForKey:@"payment_method"] isEqualToString:@"CrediCard"] || [[self.rec_dic valueForKey:@"payment_method"] isEqualToString:@"COD"] ) {
        
         html_str = [self.rec_dic valueForKey:@"url"];
        NSURL *url = [[NSURL alloc]initWithString:html_str];
//        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
        request.timeoutInterval = 60;
        [self.web_pay loadRequest:request];
       
    }
    else  {
       
         html_str = [self.rec_dic valueForKey:@"formstring"];
       // [_web_pay loadHTMLString:[html_str stringByReplacingOccurrencesOfString:@"\n" withString:@"<br/>"] baseURL:nil];
      
        [_web_pay loadHTMLString:html_str baseURL:nil];
        
    }
    

    
    
   

    
    
}
//- (IBAction)back_action:(id)sender {
//    //    [self dismissViewControllerAnimated:NO completion:nil];
//  //  [self.navigationController popViewControllerAnimated:NO];
//    [self performSegueWithIdentifier:@"payment_cart" sender:self];
//}
- (void)webViewDidStartLoad:(UIWebView *)webView {
    [loadingView setHidden:NO];

    // [Helper_activity animating_images:self];

    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    
    [loadingView setHidden:YES];
    [self cart_count_intail];

    
   //[Helper_activity stop_activity_animation:self];
    NSLog(@"Loading Successful ");
    
    
//    [activityView stopAnimating];
//    [loadingView setHidden:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)back_action:(id)sender {
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController popToRootViewControllerAnimated:NO];
    

    //VC_cart_list *list = [self.storyboard instantiateViewControllerWithIdentifier:@"cart_identifir"];
    //direct_checkout_home
    
  /*  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Payment Alert" message:@"Going back might cancel the order.Are you sure you want to go back?" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:@"Cancel", nil];
    alert.tag = 1;
    [alert show];*/
  /*  [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
   self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController popToRootViewControllerAnimated:NO];*/
    
    
    // [self performSegueWithIdentifier:@"direct_checkout_home" sender:self];
}
    

-(void)cart_count_intail{
    
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
- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            
            [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                          forBarMetrics:UIBarMetricsDefault];
            self.navigationController.navigationBar.shadowImage = [UIImage new];
            self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
            self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
            [self.navigationController popToRootViewControllerAnimated:NO];

            
        }
        else
        {
            NSLog(@"cancel:");
            
        }
        
        
    }
    
    
    
}

-(void)viewDidDisappear:(BOOL)animated
{
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    [self.navigationController popToRootViewControllerAnimated:NO];
}

@end
