//
//  VC_abouy_us.m
//  Dohasooq_mobile
//
//  Created by Test User on 23/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_about_us.h"
#import "Helper_activity.h"

@interface VC_about_us ()<UIWebViewDelegate>
//{
//    UIView *loadingView;
//}

@end

@implementation VC_about_us

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Aboutus screen";

    
    
    
  // Load URL with  WebView
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];

    NSString *urlStr = [NSString stringWithFormat:@"%@/Pages/contentApi/about-us/%@/%@",SERVER_URL,languge,country];
     NSURL *url = [[NSURL alloc]initWithString:urlStr];
     NSURLRequest *request = [NSURLRequest requestWithURL:url];
     
     [self.about_us_VW loadRequest:request];
    self.about_us_VW.delegate = self;

     
}
-(void)viewWillAppear:(BOOL)animated
{
     self.navigationItem.hidesBackButton = YES;
}
- (IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)home_action:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    
    [Helper_activity animating_images:self];
    
}
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [Helper_activity stop_activity_animation:self];
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
