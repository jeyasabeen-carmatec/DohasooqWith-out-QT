//
//  VC_intial.m
//  Dohasooq_mobile
//
//  Created by Test User on 24/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_intial.h"
#import "HttpClient.h"
#import "Helper_activity.h"
#import "ViewController.h"
#import "Home_page_Qtickets.h"
#import "Reachability.h"

@interface VC_intial ()<UIPickerViewDelegate,UIPickerViewDataSource,UIAlertViewDelegate>
{
    NSMutableArray *country_arr,*lang_arr;
    NSMutableDictionary *temp_dict;
    NSString *country_ID;
    Home_page_Qtickets *QT;
    NSTimer *timer;
    UIView *VW_overlay;
    UIImageView *activityIndicatorView;
    Reachability *internetReachableFoo;
}

@end

@implementation VC_intial

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    //****************  Checking the Appstore Version by calling itunes API ****************//
    
    self.screenName = @"Splash Screen";
    
    NSString *str_code = [[NSLocale autoupdatingCurrentLocale] objectForKey:NSLocaleCountryCode];
    NSURL *url = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"http://itunes.apple.com/%@/lookup?id=1352963798",str_code]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                               if (!error) {
                                   NSError* parseError;
                                   NSDictionary *appMetadataDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&parseError];
                                   NSArray *resultsArray = (appMetadataDictionary)?[appMetadataDictionary objectForKey:@"results"]:nil;
                                   NSDictionary *resultsDic = [resultsArray firstObject];
                                   if (resultsDic) {
                                       // compare version with your apps local version
                                       NSString *iTunesVersion = [resultsDic objectForKey:@"version"];
                                       
                                       NSString *appVersion = @"1.2";
                                       
                                       NSLog(@"itunes version = %@\nAppversion = %@",iTunesVersion,appVersion);
                                       
//                                       UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"New version available" message:[NSString stringWithFormat:@"%@",appMetadataDictionary] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                                       [alert show];
//                                       
//                                       float itnVer = [iTunesVersion floatValue];
//                                       float apver = [appVersion floatValue];
//                                       
//                                       NSLog(@"The val floet itune %f\nThe val float appver%f",itnVer,apver);
                                       
                                       if (iTunesVersion && [appVersion compare:iTunesVersion] != NSOrderedSame) {
                                           
                                           
//                                           UIAlertView *alert = [UIAlertView bk_showAlertViewWithTitle:@"Doha Sooq Online Shopping" message:[NSString stringWithFormat:@"New version available. Update required."] cancelButtonTitle:@"update" otherButtonTitles:nil handler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                                           
                                               
                                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Version Updated %@",iTunesVersion] message:[resultsDic valueForKey:@"releaseNotes"] delegate:self cancelButtonTitle:nil otherButtonTitles:@"Update",@"Cancel", nil];
                                           alert.tag = 123456;
                                           [alert show];
//                                           }];
//                                           [alert show];
                                       }
                                   }
                               } else {
                                   // error occurred with http(s) request
                                   NSLog(@"error occurred communicating with iTunes");
                               }
                           }];
    
    
    self.view.hidden = NO;
   // self.VW_ceter.hidden =NO;
   // self.IMG_logo.hidden = NO;
    
    
    // Checking SessionId is Not null
    NSString *sessionId = [[NSUserDefaults standardUserDefaults]valueForKey:@"Cookie"];
    
    if (!sessionId ||[sessionId isKindOfClass:[NSNull class]] || [sessionId isEqualToString:@"<nil>"] || [sessionId isEqualToString:@"(null)"] || [sessionId isEqualToString:@""]) {
        [self getSessionIDAPICalling];
    }
    else{
        [self testInternetConnection];
    }
    
   
  
}

- (void)testInternetConnection
{
    
    //****************** Chceking the Internet Connection If Internet there calling coutry API
    
    
    
    internetReachableFoo = [Reachability reachabilityWithHostname:@"www.google.com"];
    
    // Internet is reachable
    internetReachableFoo.reachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *lang = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
            NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
            lang = [lang stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            lang = [lang stringByReplacingOccurrencesOfString:@"null" withString:@""];
            lang = [lang stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            country = [country stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
            country = [country stringByReplacingOccurrencesOfString:@"null" withString:@""];
            country = [country stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
            if([lang isEqualToString:@""] || [country isEqualToString:@""])
            {
                
                VW_overlay.hidden = NO;
             
            }
            else if([lang isEqualToString:@"()"] || [country isEqualToString:@"()"])
            {
                VW_overlay.hidden = NO;
                [self performSelector:@selector(country_API_call) withObject:activityIndicatorView afterDelay:0.01];
                
            }
            else
            {
                    [self start];
                
                
            }
            

        });
    };
    
    internetReachableFoo.unreachableBlock = ^(Reachability*reach)
    {
        // Update the UI on the main thread
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSString *str_alert = @"No Internet Connection!";
            NSString *str_ok = @"Ok";
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                str_alert = @"لا يوجد اتصال بالإنترنت!";
                str_ok = @"حسنا";
            }


            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_alert delegate:self cancelButtonTitle:nil otherButtonTitles:str_ok, nil];
            [alert show];
        });
    };
    
    [internetReachableFoo startNotifier];
}
-(void)start
{
     
    //***************************** If App is not  loading First time This method is calling  *************************//
    timer = [NSTimer scheduledTimerWithTimeInterval:1
                                             target:self
                                           selector:@selector(targetMethod)
                                           userInfo:nil
                                            repeats:NO];
}
-(void)targetMethod
{
    [timer invalidate];
    VW_overlay.hidden = NO;
    //****************************** calling Image path API *****************************//
    [self cart_count];
    [self performSelector:@selector(IMAGE_PATH_API) withObject:activityIndicatorView afterDelay:0.01];
   
    
}
-(void)viewWillAppear:(BOOL)animated
{
    //*************************** Creating Invisible Overlay view *************************//
    
    VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    VW_overlay.clipsToBounds = YES;
    VW_overlay.layer.cornerRadius = 10.0;
    VW_overlay.hidden = YES;
    
}

#pragma country_api_integration Method Calling

-(void)country_API_call
{
    @try
    {
        
        [Helper_activity animating_images:self];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@countries/index.json",SERVER_URL];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    VW_overlay.hidden = YES;
                    [Helper_activity stop_activity_animation:self];

                  
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check Your Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    NSMutableDictionary *json_DATA = data;
                    if(json_DATA)
                    {
                        [Helper_activity stop_activity_animation:self];

                        
                    country_arr = [[NSMutableArray alloc]init];
                    NSMutableArray *temp_arr = [json_DATA valueForKey:@"countries"];
                        
                        NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
                        sortedArray = temp_arr;
                        
                        
                        NSSortDescriptor *sortDescriptor;
                        sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                     ascending:YES];
                        NSArray *srt_arr = [sortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                        [country_arr addObjectsFromArray:srt_arr];
                        for(int i=0;i<country_arr.count;i++)
                        {
                            if([[[country_arr objectAtIndex:i] valueForKey:@"name"] isEqualToString:@"Qatar"])
                            {
                                country_ID = [NSString stringWithFormat:@"%@",[[country_arr objectAtIndex:i] valueForKey:@"id"]];
                                [[NSUserDefaults standardUserDefaults] setInteger:[country_ID integerValue] forKey:@"country_id"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                
                              //  [self hotCodingLanguages];
                                
                                [self  language_API_calling:country_ID];
                                
                                

                            }
                        }

                        
                    [[NSUserDefaults standardUserDefaults] setObject:country_arr forKey:@"country_arr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                 
                        
                        
                   // [_TBL_list_coutry reloadData];
                    }
                    else{
                      
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                        [alert show];
                        VW_overlay.hidden = YES;
                        [Helper_activity stop_activity_animation:self];

                      //  [activityIndicatorView stopAnimating];


                    }
                    
                }
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please check Your Internet Connection" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
        VW_overlay.hidden = YES;
        [Helper_activity stop_activity_animation:self];


    }
    
}

#pragma mark Language API Integration
//https://www.dohasooq.com/languages/getLangByCountryMultilingual/173.json
-(void)language_API_calling : (NSString *)country_id{
  
    @try
    {
        [Helper_activity animating_images:self];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@languages/getLangByCountryMultilingual/%@.json",SERVER_URL,country_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                    VW_overlay.hidden = YES;
                    
                    [Helper_activity stop_activity_animation:self];


                    NSMutableDictionary *json_DATA = data;
                    //                        lang_arr = [NSMutableArray array];
                    //                        lang_arr = [json_DATA valueForKey:@"languages"];
                    lang_arr = [[NSMutableArray alloc]init];
                    NSMutableArray *temp_arr = [json_DATA valueForKey:@"languages"];
                    
                    NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
                    sortedArray = temp_arr;
                    
                    
                    NSSortDescriptor *sortDescriptor;
                    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"language_name"
                                                                 ascending:YES];
                    NSArray *srt_arr = [sortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
                    
                    //   NSMutableDictionary *dictMutable = [srt_arr mutableCopy];
                    for(int i = 0;i<srt_arr.count;i++)
                    {
                        NSMutableDictionary *dictMutable = [[srt_arr objectAtIndex:i] mutableCopy];
                        [dictMutable removeObjectsForKeys:[[srt_arr objectAtIndex:i] allKeysForObject:[NSNull null]]];
                        [lang_arr addObject:dictMutable];
                            }
                    
                    for(int j=0;j<lang_arr.count;j++)
                    {
                        if([[[lang_arr objectAtIndex:j] valueForKey:@"language_name"] isEqualToString:@"English (US)"])
                        {
                            [[NSUserDefaults standardUserDefaults] setInteger:[[[lang_arr objectAtIndex:j]valueForKey:@"id"] integerValue] forKey:@"language_id"];
                            [[NSUserDefaults standardUserDefaults] setValue: [[lang_arr  objectAtIndex:j]valueForKey:@"language_name"] forKey:@"language"];
                            [[NSUserDefaults standardUserDefaults] setObject:[[lang_arr objectAtIndex:j] valueForKey:@"language_code"] forKey:@"code_language"];
                            
                            
                            [[NSUserDefaults standardUserDefaults] synchronize];
                            
                              [self performSelector:@selector(IMAGE_PATH_API) withObject:activityIndicatorView afterDelay:0.01];
                          
                            
                            
                            
                        }
                    }

                    
                    [[NSUserDefaults standardUserDefaults] setObject:lang_arr forKey:@"language_arr"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                }
                else{
                    [Helper_activity stop_activity_animation:self];

                    VW_overlay.hidden = YES;
                   // [activityIndicatorView stopAnimating];

                }
            });
        }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
        VW_overlay.hidden = YES;
        [Helper_activity stop_activity_animation:self];

        //[activityIndicatorView stopAnimating];

        
    }
    
    
}

/*
-(void)hotCodingLanguages{
    
    
    NSDictionary *dic =  @{@"country_id" : @"173",
                           @"created" : @"2017-10-11T04:56:30+00:00",
                           @"id" : @"2",
                           @"language_code" : @"ar",
                           @"language_default" : @"No",
                           @"language_locale" : @"ar",
                           @"language_name" : @"Arabic",
                           @"language_name_localized" : @"عربى",
                           @"modified" : @"2018-04-24T10:58:45+00:00",
                           @"sort_order" : @"2",
                           @"status" : @"A"};
    NSDictionary *dic2 = @{
                           @"country_id":@"173",
                           @"created" : @"2017-10-11T04:55:31+00:00",
                           @"id":@"1",
                           @"language_code":@"en",
                           @"language_default":@"Yes",
                           @"language_locale":@"en_US",
                           @"language_name":@"English (US)",
                           @"language_name_localized":@"English (US)",
                           @"modified" : @"2018-03-27T12:57:07+00:00",
                           @"sort_order" :@"1",
                           @"status": @"A"
                           };
    
    
    NSArray *temp_arr = [[NSArray alloc]initWithObjects:dic,dic2, nil];
     lang_arr = [[NSMutableArray alloc]init];

    
    NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
    [sortedArray addObjectsFromArray:temp_arr]; ;
    
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"language_name"
                                                 ascending:YES];
    NSArray *srt_arr = [sortedArray sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    //   NSMutableDictionary *dictMutable = [srt_arr mutableCopy];
    for(int i = 0;i<srt_arr.count;i++)
    {
        NSMutableDictionary *dictMutable = [[srt_arr objectAtIndex:i] mutableCopy];
        [dictMutable removeObjectsForKeys:[[srt_arr objectAtIndex:i] allKeysForObject:[NSNull null]]];
        [lang_arr addObject:dictMutable];
    }
    
    for(int j=0;j<lang_arr.count;j++)
    {
        if([[[lang_arr objectAtIndex:j] valueForKey:@"language_name"] isEqualToString:@"English (US)"])
        {
            [[NSUserDefaults standardUserDefaults] setInteger:[[[lang_arr objectAtIndex:j]valueForKey:@"id"] integerValue] forKey:@"language_id"];
            [[NSUserDefaults standardUserDefaults] setValue: [[lang_arr  objectAtIndex:j]valueForKey:@"language_name"] forKey:@"language"];
            [[NSUserDefaults standardUserDefaults] setObject:[[lang_arr objectAtIndex:j] valueForKey:@"language_code"] forKey:@"code_language"];
            
            
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            [self performSelector:@selector(IMAGE_PATH_API) withObject:activityIndicatorView afterDelay:0.01];
            
            
            
            
        }
    }
    
    
    [[NSUserDefaults standardUserDefaults] setObject:lang_arr forKey:@"language_arr"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}*/


#pragma ImagePath API calling

-(void)IMAGE_PATH_API
{
    @try
    {
        
        [Helper_activity animating_images:self];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/allImagePaths",SERVER_URL];
        
        
        
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                    
                    [Helper_activity stop_activity_animation:self];
                }
                @try
                {
                    if (data) {
                        
                        [self language_switch_API];
                        
                        
                        
                        [Helper_activity stop_activity_animation:self];
                        
                        //Storing Image Paths
                        [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Images_path"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
//
//                        //  [self MENU_api_call];
//                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//                        {
//                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Arabic" bundle:nil];
//                            
//                            Home_page_Qtickets *controller = [storyboard instantiateViewControllerWithIdentifier:@"Home_page_Qtickets"];
//                            UINavigationController *navigationController =
//                            [[UINavigationController alloc] initWithRootViewController:controller];
//                            navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
//                            navigationController.navigationBar.barTintColor = [UIColor whiteColor];
//                            [self  presentViewController:navigationController animated:NO completion:nil];
//                            
//                        }
//                        
//                        else{
//                            [self performSegueWithIdentifier:@"home_page_identifier" sender:self];
//                        }
//                        
//                        
//                        
//                    }
//                    else
//                    {
//                        
//                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                        [alert show];
//                        
//                        
//                        
                    }
                }
                @catch(NSException *exception)
                {
                    
                }
                
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        
    }
    
}


#pragma mark Cart Count API calling

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
            //            VW_overlay.hidden = YES;
            //            [activityIndicatorView stopAnimating];
            [Helper_activity stop_activity_animation:self];

            
            
        }
        if (data) {
            [Helper_activity stop_activity_animation:self];

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
                
                [Helper_activity stop_activity_animation:self];

                NSLog(@"asjdas dasjbd asdas iccxv %@",exception);
            }
            
        }
    }];
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


#pragma mark - Alertview deligate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 123456) {
        switch (buttonIndex) {
            case 0:
            {
                NSString *iTunesLink = [NSString stringWithFormat:@"itms://itunes.apple.com/us/app/apple-store/id1352963798?mt=8"];
                [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
            }
                break;
                
            case 1:
            
                NSLog(@"1");
                break;
            
                
                
            default:
                break;
        }
    }
}
#pragma mark language_switch_API
-(void)language_switch_API{
    @try
    {
        
        [Helper_activity animating_images:self];
        
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge_str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *code_language = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"code_language"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@users/switch-language/%@/%@/%@/Mobile",SERVER_URL,country,languge_str,code_language];
        
        
        
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                    
                    [Helper_activity stop_activity_animation:self];
                }
                @try
                {
                    if (data) {
                        
                        NSLog(@"%@",data);
                        
                        if ([[data valueForKey:@"status"] isEqualToString:@"Success"]) {
                            
                            
                            
                            [Helper_activity stop_activity_animation:self];
                            
                            
                            
                            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                            {
                                UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Arabic" bundle:nil];
                                
                                Home_page_Qtickets *controller = [storyboard instantiateViewControllerWithIdentifier:@"Home_page_Qtickets"];
                                UINavigationController *navigationController =
                                [[UINavigationController alloc] initWithRootViewController:controller];
                                navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
                                navigationController.navigationBar.barTintColor = [UIColor whiteColor];
                                [self  presentViewController:navigationController animated:NO completion:nil];
                                
                            }
                            
                            else{
                                [self performSegueWithIdentifier:@"home_page_identifier" sender:self];
                            }
                            
                            
                            
                        }
                        
//                           [self performSelector:@selector(IMAGE_PATH_API) withObject:activityIndicatorView afterDelay:0.01];
                        }
                        else{
                            [HttpClient createaAlertWithMsg:@"The Data Couldn't be read." andTitle:@""];
                            [Helper_activity stop_activity_animation:self];
                        }
                        
                        
                    
                }
                @catch(NSException *exception)
                {
                    
                }
                
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        
    }
    
}
#pragma mark Get Session ID API CAlling
-(void)getSessionIDAPICalling{
    @try
    {
    [Helper_activity animating_images:self];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/get-session-id",SERVER_URL];
    
    
    
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                
                [Helper_activity stop_activity_animation:self];
            }
            @try
            {
                if (data) {
                   
                    
                    if ([[data valueForKey:@"status"] isEqualToString:@"Success"]) {
                        
                        NSLog(@"%@",data);
                        NSString *cookieValue = [NSString stringWithFormat:@"CAKEPHP=%@",[data valueForKey:@"response"]];
                        
                        [[NSUserDefaults standardUserDefaults]setObject:cookieValue forKey:@"Cookie"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        
                         [self testInternetConnection];
                        
 
                    }
                    else{
                        [HttpClient createaAlertWithMsg:@"The data couldn't be read." andTitle:@""];
                        [Helper_activity stop_activity_animation:self];
                    }
                    
                    
                }
                else
                {
                    
                    
                }
            }
            @catch(NSException *exception)
            {
                
            }
            
            
        });
    }];
}
@catch(NSException *exception)
{
    NSLog(@"Session ID Exception........");
}

}

@end
