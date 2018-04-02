//
//  HttpClient.h
//  POSTWebserviceDemo
//
//  Created by cbonline on 27/07/17.
// Copyright © 2017 CBOnline. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HttpClient : NSObject


//@property (strong, nonatomic, readwrite) UIImageView *actiIndicatorView;

//+(void)stop_activity_animation:(UIViewController *_Nullable)my_controller;

+ (void)postServiceCall:(NSString*_Nullable)urlStr andParams:(NSDictionary*_Nullable)params completionHandler:(void (^_Nullable)(id  _Nullable data, NSError * _Nullable error))completionHandler;


+(void)cart_count:(NSString*_Nullable)userId completionHandler:(void (^_Nullable)(id  _Nullable data, NSError * _Nullable error))completionHandler;

+(UIAlertView *_Nullable)createaAlertWithMsg:(NSString *_Nullable)msg andTitle:(NSString *_Nullable)title;

+(void)cart_count_value:(NSString *_Nullable)user_id;

+(void)api_with_post_params:(NSString*_Nullable)urlStr andParams:(NSDictionary*_Nullable)params completionHandler:(void (^_Nullable)(id  _Nullable data, NSError * _Nullable error))completionHandler;

//+(void)animating_images:(UIViewController *_Nullable)my_controller;

+(NSString *_Nullable)doha_currency_seperator:(NSString *_Nullable)Str;

+(NSString *_Nullable)currency_seperator:(NSString *_Nullable)Str;

@end
