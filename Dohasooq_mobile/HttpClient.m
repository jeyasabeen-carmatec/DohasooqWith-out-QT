//
//  HttpClient.m
//  POSTWebserviceDemo
//
//  Created by cbonline on 27/07/17.
//  Copyright © 2017 CBOnline. All rights reserved.
//

#import "HttpClient.h"



@implementation HttpClient

// getMethod..........

+ (void)postServiceCall:(NSString*_Nullable)urlStr andParams:(NSDictionary*_Nullable)params completionHandler:(void (^_Nullable)(id  _Nullable data, NSError * _Nullable error))completionHandler{
    
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:70];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    // set Cookie VAlue as Header when it is not Null.........1
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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        
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

// PostMethod..........
+(void)api_with_post_params:(NSString *)urlStr andParams:(NSDictionary *)params completionHandler:(void (^)(id _Nullable, NSError * _Nullable))completionHandler{
    
    NSData *postData = [NSJSONSerialization dataWithJSONObject:params options:0 error:nil];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:70];
    [request setHTTPBody:postData];
    [request setValue:@"application/json" forHTTPHeaderField:@"content-type"];
    [request setValue:@"application/json" forHTTPHeaderField:@"accept"];
    
    // set Cookie VAlue as Header when it is not Null.........1
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
    
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    configuration.allowsCellularAccess = YES;
    configuration.HTTPMaximumConnectionsPerHost = 10;
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:request completionHandler:^(id  _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        
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
                    
                } @catch (NSException *exception) {
                    NSLog(@"%@",exception);
                }
            }
        }
    }];
    [dataTask resume];
}



// QR Currency Seperator........
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
        finalValue = [NSString stringWithFormat:@"%@.00",finalValue];
     
        }
    return finalValue;
    
}

// DohaMiles Currency Seperator.....
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

// Filtering CookieValue
+(void)filteringCookieValue:(NSURLResponse *)response{
    
    @try {
        
//      NSLog(@"@@@@@@@@@@@ %@",[[response valueForKey:@"allHeaderFields"] valueForKey:@"Set-Cookie"]);
//         NSLog(@"response........   %@",response);
        
        NSString *responseString = [[response valueForKey:@"allHeaderFields"] valueForKey:@"Set-Cookie"];
        //NSArray *responseArray = [responseString componentsSeparatedByString:@";"];
        NSArray *responseArray = [responseString componentsSeparatedByString:@";"];
        
       
        
        NSMutableArray *cookieArray = [NSMutableArray arrayWithArray:responseArray];
        
      
        NSString *awsStr;
        for (int i = 0; i<cookieArray.count; i++) {
            
            responseString = [cookieArray objectAtIndex:i];

                if ([responseString containsString:@"AWSALB"]){
                
                responseArray = [responseString componentsSeparatedByString:@"="];
                
                awsStr = [responseArray lastObject];
            }
            
        }
        //NSLog(@"AwsValue........   %@",awsStr);
        if (![awsStr isKindOfClass:[NSNull class]] || ![awsStr isEqualToString:@"<nil>"] || ![awsStr containsString:@"(null)"]||awsStr != nil) {
            awsStr = [NSString stringWithFormat:@"AWSALB=%@",awsStr];

            [[NSUserDefaults standardUserDefaults]setObject:awsStr forKey:@"Aws"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
        
        
    } @catch (NSException *exception) {
        NSLog(@"...........Cookie Exception............");
    }
}

@end
