//
//  HttpClient.m
//  POSTWebserviceDemo
//
//  Created by cbonline on 27/07/17.
//  Copyright © 2017 CBOnline. All rights reserved.
//

#import "HttpClient.h"



@implementation HttpClient

//UIImageView *actiIndicatorView;
//UIView *VW_overlay;

+ (void)postServiceCall:(NSString*_Nullable)urlStr andParams:(NSDictionary*_Nullable)params completionHandler:(void (^_Nullable)(id  _Nullable data, NSError * _Nullable error))completionHandler{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:70];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil,error);

            NSLog(@"eror g1:%@",[error localizedDescription]);
        }else{
            NSError *err = nil;
            id resposeJSon = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&err];
            if (err) {
                completionHandler(nil,err);
                NSLog(@"eror g2:%@",[error localizedDescription]);
            }else{
                @try {
                    if (resposeJSon) {
                        completionHandler(resposeJSon,nil);

                    }

                } @catch (NSException *exception) {
                    NSLog(@" 3 %@",exception);
                }
                            }
        }
    }];
    [dataTask resume];
}

+(void)cart_count:(NSString *)userId completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler{
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/cartcountapi/%@.json",SERVER_URL,userId];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    NSURL *url = [NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setTimeoutInterval:70];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil,error);
            
            NSLog(@"eror c1:%@",[error localizedDescription]);
        }else{
            NSError *err = nil;
            id resposeJSon = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                
                completionHandler(nil,err);
                
                NSLog(@"eror c2:%@",[err localizedDescription]);
            }else{
                @try {
                    if (resposeJSon) {
                        completionHandler(resposeJSon,nil);
                        
                    }
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
            }
        }
    }];
    [dataTask resume];
}

+(UIAlertView *)createaAlertWithMsg:(NSString *)msg andTitle:(NSString *)title{
    NSString *ok_btn;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        ok_btn = @"حسنا";
    }
    else{
        ok_btn = @"Ok";

    }
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:title message:msg delegate:nil cancelButtonTitle:ok_btn otherButtonTitles:nil, nil];
    [alert show];
    return  alert;
}
+(void)api_with_post_params:(NSString *)urlStr andParams:(NSDictionary *)params completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler{
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:70];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (error) {
            completionHandler(nil,error);
            NSLog(@"eror :%@",[error localizedDescription]);
        }else{
            NSError *err = nil;
            id resposeJSon = [NSJSONSerialization JSONObjectWithData:data options:0 error:&err];
            if (err) {
                completionHandler(nil,error);

                NSLog(@"eror :%@",[err localizedDescription]);
            }else{
                @try {
                    if (resposeJSon) {
                        completionHandler(resposeJSon,nil);
                        
                    }
                    //                    if ([resposeJSon objectForKey:@"response"]) {
                    //                        NSError *er = [NSError errorWithDomain:[resposeJSon objectForKey:@"msg"] code:200 userInfo:nil];
                    //                        completionHandler(nil,er);
                    //                    }else{
                    //}
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
            }
        }
    }];
    [dataTask resume];
}

/*+(void)animating_images:(UIViewController *)my_controller{
    
    UIView *VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    VW_overlay.clipsToBounds = YES;
    VW_overlay.tag = 1234;
    
    
    VW_overlay.hidden = NO;
    UIImageView *actiIndicatorView = [[UIImageView alloc] initWithImage:[UIImage new]];
    actiIndicatorView.frame = CGRectMake(0, 0, 60, 60);
    actiIndicatorView.center = my_controller.view.center;
    actiIndicatorView.tag = 1235;
    
    actiIndicatorView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"],[UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"],[UIImage imageNamed:@"loader14.png"],[UIImage imageNamed:@"loader15.png"],[UIImage imageNamed:@"loader16.png"],[UIImage imageNamed:@"loader17.png"],[UIImage imageNamed:@"loader18.png"],nil];
    
    actiIndicatorView.animationDuration = 2.0;
    [actiIndicatorView startAnimating];
    actiIndicatorView.center = VW_overlay.center;
    
    [VW_overlay addSubview:actiIndicatorView];
    [my_controller.view addSubview:VW_overlay];
  }
+(void)stop_activity_animation:(UIViewController *)my_controller{
    
    for (UIImageView *activity in my_controller.view.subviews) {
        if (activity.tag == 1235) {
            [activity stopAnimating];
        }
    }
       for (UIView *VW_main in my_controller.view.subviews) {
           if (VW_main.tag == 1234) {
               VW_main.hidden = YES;
           }
        
       }
    
    
}*/

+(NSString*)currency_seperator:(NSString *)Str{
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init] ;
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setDecimalSeparator:@"."];
    
  

    
    // Decimal values read from any db are always written with no grouping separator and a comma for decimal.
    
    NSNumber *numberFromString = [formatter numberFromString:Str];
    
    [formatter setGroupingSeparator:@","]; // Whatever you want here
    [formatter setDecimalSeparator:@"."]; // Whatever you want here
    
    NSString *finalValue = [formatter stringFromNumber:numberFromString];
    if([finalValue containsString:@"."])
    {
        
    }
    else{
       // finalValue = [finalValue stringByReplacingOccurrencesOfString:@"," withString:@""];
        finalValue = [NSString stringWithFormat:@"%@.00",finalValue];
     
        }
    return finalValue;
    
}
+(NSString *)doha_currency_seperator:(NSString *)Str
{
    
    
    Str = [NSString stringWithFormat:@"%f",floor([Str floatValue])];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init] ;
    [formatter setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setGroupingSeparator:@","];
    [formatter setDecimalSeparator:@"."];
    
    // Decimal values read from any db are always written with no grouping separator and a comma for decimal.
    
    NSNumber *numberFromString = [formatter numberFromString:Str];
    
    [formatter setGroupingSeparator:@","]; // Whatever you want here
    [formatter setDecimalSeparator:@"."]; // Whatever you want here
    
    NSString *finalValue = [formatter stringFromNumber:numberFromString];
    return finalValue;
    
}
@end
