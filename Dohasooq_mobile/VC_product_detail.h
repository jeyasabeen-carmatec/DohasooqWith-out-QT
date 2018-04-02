//
//  VC_product_detail.h
//  Dohasooq_mobile
//
//  Created by Test User on 26/09/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "MIBadgeButton.h"
#import "GIBadgeView.h"
#import <GoogleAnalytics/GAITrackedViewController.h>

#import "multiple_sellers.h"


@interface VC_product_detail : GAITrackedViewController<sellersprotocol>
{
    NSTimer *TIMER_countdown;
}

@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_content;


@property(nonatomic,strong) IBOutlet UIButton *BTN_cart;
@property(nonatomic,strong) IBOutlet MIBadgeButton *BTN_fav;
@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_back;
@property(nonatomic,weak) IBOutlet UIButton *BTN_back_modal;
@property(nonatomic,weak) IBOutlet UIButton *BTN_cart_list;
@property(nonatomic,weak) IBOutlet UIButton *BTN_wish_list;
@property(nonatomic,strong) IBOutlet GIBadgeView *badge_view;
//@property(nonatomic,weak) IBOutlet UIButton *header_name;


//first view
@property(nonatomic,weak) IBOutlet UIView *VW_First;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_images;
@property(nonatomic,weak) IBOutlet UIPageControl *custom_story_page_controller;
@property(nonatomic,strong) IBOutlet UIButton *BTN_share;
@property(nonatomic,strong) IBOutlet UIButton *BTN_wish;



//second view
@property(nonatomic,weak) IBOutlet UIView *VW_second;
//@property(nonatomic,weak) IBOutlet UILabel *LBL_prices;
@property(nonatomic,weak) IBOutlet UITextView *LBL_prices;

@property(nonatomic,weak) IBOutlet UILabel *LBL_discount;
@property(nonatomic,weak) IBOutlet UILabel *LBL_item_name;
@property (weak, nonatomic) IBOutlet UILabel *LBL_dohaMiles;


//third view
@property(nonatomic,weak) IBOutlet UIView *VW_third;
@property(nonatomic,weak) IBOutlet UITextField *TXT_count;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionview_variants;
@property(nonatomic,weak) IBOutlet UIButton *BTN_minus;
@property(nonatomic,weak) IBOutlet UIButton *BTN_plus;
@property (nonatomic, strong) UIPickerView *variant_picker;

@property(nonatomic,weak) IBOutlet UILabel *LBL_stock;
@property(nonatomic,weak) IBOutlet UILabel *LBL_delivery_cod;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_merchant;
@property(nonatomic,weak) IBOutlet UILabel *QTY;
@property(nonatomic,weak) IBOutlet UIButton *LBL_more_sellers;
@property(nonatomic,weak) IBOutlet UILabel *LBL_sold_by;

@property(nonatomic,weak) IBOutlet UITextView *LBL_merchant_sellers;
@property(nonatomic,weak) IBOutlet UILabel *BTN_left;
@property(nonatomic,weak) IBOutlet UILabel *BTN_right;




//fourth view
@property(nonatomic,weak) IBOutlet UIView *VW_fourth;
@property(nonatomic,retain) IBOutlet UIView *VW_segemnt;

//fifth_view
@property(nonatomic,retain) IBOutlet UIView *VW_fifth;

@property(nonatomic,retain) IBOutlet UICollectionView  *collection_related_products;

@property(nonatomic,weak) IBOutlet UIWebView *TXTVW_description;
@property(nonatomic,weak) IBOutlet UILabel *LBL_colection;

@property(nonatomic,weak) IBOutlet UIView *VW_filter;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_cart;
@property(nonatomic,weak) IBOutlet UITableView *TBL_reviews;
@property(nonatomic,weak) IBOutlet UIButton *BTN_buy_now;
@property(nonatomic,weak)IBOutlet UIButton *BTN_top;



//- (IBAction)productdetail_to_cartPage:(id)sender;
//- (IBAction)productDetail_to_wishPage:(id)sender;
//- (IBAction)order_to_cartPage:(id)sender;
//- (IBAction)order_to_wishListPage:(id)sender;

- (IBAction)add_to_wih_list:(id)sender;
- (IBAction)product_detail_cart_page:(id)sender;

//@property(nonatomic,weak) IBOutlet UILabel *LBL_review;













@end
