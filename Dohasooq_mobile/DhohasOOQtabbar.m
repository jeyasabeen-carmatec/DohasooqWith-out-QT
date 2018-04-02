//
//  DhohasOOQtabbar.m
//  customTabbarExample
//
//  Created by Test User on 17/10/17.
//  Copyright © 2017 Carmatec IT Solutions. All rights reserved.
//

#import "DhohasOOQtabbar.h"

@implementation DhohasOOQtabbar

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

*/
#define kTabBarHeight  70// Input the height we want to set for Tabbar here
-(CGSize)sizeThatFits:(CGSize)size
{
    CGSize sizeThatFits = [super sizeThatFits:size];
    sizeThatFits.height = kTabBarHeight;
    
    return sizeThatFits;
}



@end
