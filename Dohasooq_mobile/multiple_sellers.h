//
//  multiple_sellers.h
//  Dohasooq_mobile
//
//  Created by Test User on 19/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GIBadgeView.h"
#import <GoogleAnalytics/GAITrackedViewController.h>

@protocol sellersprotocol <NSObject>

-(void)call_detail_api:(NSString *)str_url;

@end


@interface multiple_sellers : GAITrackedViewController
@property(nonatomic,weak) IBOutlet UITableView *TBL_sellers;
@property(nonatomic,strong) IBOutlet GIBadgeView *badge_view;
@property(nonatomic,assign) id <sellersprotocol>delegate;




@end
