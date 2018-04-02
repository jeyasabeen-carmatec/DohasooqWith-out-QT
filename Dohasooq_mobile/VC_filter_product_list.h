//
//  VC_filter_product_list.h
//  Dohasooq_mobile
//
//  Created by Test User on 30/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TTRangeSlider.h>
#import <GoogleAnalytics/GAITrackedViewController.h>

@protocol filter_protocol <NSObject>

-(void)filetr_URL:(NSString *)str;

@end

@interface VC_filter_product_list : GAITrackedViewController

@property(nonatomic,weak) IBOutlet UIView *VW_contents;
@property(nonatomic,weak) IBOutlet UIScrollView *scroll_contents;


@property(nonatomic,weak) IBOutlet UILabel *LBL_min;
@property(nonatomic,weak) IBOutlet UILabel *LBL_max;

@property(nonatomic,weak) IBOutlet TTRangeSlider *LBL_slider;
@property(nonatomic,weak) IBOutlet UIButton *BTN_ten;
@property(nonatomic,weak) IBOutlet UIButton *BTN_twenty;
@property(nonatomic,weak) IBOutlet UIButton *BTN_thirty;
@property(nonatomic,weak) IBOutlet UIButton *BTN_forty;
@property(nonatomic,weak) IBOutlet UIButton *BTN_fifty;
@property(nonatomic,weak) IBOutlet UIButton *BTN_check;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_produtcs;
@property(nonatomic,weak) IBOutlet UIView *Vw_line1;
@property(nonatomic,weak) IBOutlet UIView *VW_radio;
@property(nonatomic,weak) IBOutlet UIButton *BTN_submit;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_back_ground;
@property(nonatomic,weak) IBOutlet UILabel *LBL_brands;
@property(nonatomic,weak) IBOutlet UIView *vw_line;



@property(nonatomic,assign) id<filter_protocol>delegate;








@end
