//
//  Helper_activity.m
//  DohaSooqDriver
//
//  Created by jeya sabeen on 15/01/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import "Helper_activity.h"


@implementation Helper_activity

+(void)animating_images:(UIViewController *)my_controller
{
    UIView *VW_overlay = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    VW_overlay.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.0];
    VW_overlay.clipsToBounds = YES;
    VW_overlay.tag = 1234;
    
    
    VW_overlay.hidden = NO;
    UIImageView *actiIndicatorView = [[UIImageView alloc] initWithImage:[UIImage new]];
    actiIndicatorView.frame = CGRectMake(0, 0, 50, 60);
    actiIndicatorView.center = my_controller.view.center;
    actiIndicatorView.tag = 1235;
    
    actiIndicatorView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"loader1.png"],[UIImage imageNamed:@"loader2.png"],[UIImage imageNamed:@"loader3.png"],[UIImage imageNamed:@"loader4.png"],[UIImage imageNamed:@"loader5.png"],[UIImage imageNamed:@"loader6.png"],[UIImage imageNamed:@"loader7.png"],[UIImage imageNamed:@"loader8.png"],[UIImage imageNamed:@"loader9.png"],[UIImage imageNamed:@"loader10.png"],[UIImage imageNamed:@"loader11.png"],[UIImage imageNamed:@"loader12.png"],[UIImage imageNamed:@"loader13.png"],[UIImage imageNamed:@"loader14.png"],[UIImage imageNamed:@"loader15.png"],[UIImage imageNamed:@"loader16.png"],[UIImage imageNamed:@"loader17.png"],[UIImage imageNamed:@"loader18.png"],nil];
    
    actiIndicatorView.animationDuration = 2.0;
    [actiIndicatorView startAnimating];
    actiIndicatorView.center = VW_overlay.center;
    
    [VW_overlay addSubview:actiIndicatorView];
    [my_controller.view addSubview:VW_overlay];
}
+(void)stop_activity_animation:(UIViewController *)my_controller
{
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
}

@end
