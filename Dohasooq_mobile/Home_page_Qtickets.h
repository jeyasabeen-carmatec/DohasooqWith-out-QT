//
//  Home_page_Qtickets.h
//  Dohasooq_mobile
//
//  Created by Test User on 17/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MIBadgeButton.h"
#import "GIBadgeView.h"
#import <GoogleAnalytics/GAITrackedViewController.h>

@interface Home_page_Qtickets : GAITrackedViewController
{
    NSTimer *TIMER_countdown;
    NSTimer *best_deals_Timer;
}

@property(nonatomic,strong) NSArray *items;

@property(nonatomic,weak)IBOutlet UITabBar *Tab_MENU;

//side bar
@property (nonatomic, strong) IBOutlet UIView *VW_swipe;
@property (readonly, nonatomic) int menyDraw_X,menuDraw_width;
@property(nonatomic,weak) IBOutlet UIButton *BTN_myorder;
@property(nonatomic,weak) IBOutlet UIButton *BTN_wishlist;
@property(nonatomic,weak) IBOutlet UIButton *BTN_address;
@property(nonatomic,weak) IBOutlet UILabel *LBL_order_icon;
@property(nonatomic,weak) IBOutlet UILabel *LBL_order;
@property(nonatomic,weak) IBOutlet UILabel *LBL_wish_list_icon;
@property(nonatomic,weak) IBOutlet UILabel *LBL_wish_list;
@property(nonatomic,weak) IBOutlet UILabel *LBL_address_icon;
@property(nonatomic,weak) IBOutlet UILabel *LBL_address;
@property(nonatomic,strong) UIPickerView *lang_pickers;
@property(nonatomic,weak) IBOutlet UILabel *invisible_LBL;
@property (nonatomic, strong) GIBadgeView *badgeView;



@property(nonatomic,weak) IBOutlet UIImageView *IMG_profile;
@property(nonatomic,weak) IBOutlet UITableView *TBL_menu;

@property(nonatomic,weak) IBOutlet UIScrollView *Scroll_contents;

//view navigation bar
@property(nonatomic,weak) IBOutlet UIButton *BTN_menu;
@property(nonatomic,weak) IBOutlet UILabel *LBL_hot_deals;
@property(nonatomic,weak) IBOutlet UIView *VW_nav;
@property(nonatomic,weak) IBOutlet UIButton *logo;


@property(nonatomic,strong) IBOutlet UIBarButtonItem *BTN_fav;
@property(nonatomic,weak) IBOutlet UIButton *BTN_cart;
@property(nonatomic,weak) IBOutlet UIButton *BTN_QT_view;
@property(nonatomic,weak) IBOutlet UITextField *TXT_search;
@property(nonatomic,weak) IBOutlet UITableView *TBL_search_results;
@property(nonatomic,weak) IBOutlet UILabel *LBL_badge;
@property(nonatomic,weak) IBOutlet UIButton *BTN_search;


//view First View

//QTICKETS MENU
@property(nonatomic,weak) IBOutlet UICollectionView *collection_showing_movies;
@property(nonatomic,weak) IBOutlet UIPageControl *page_controller_movies;
@property(nonatomic,weak) IBOutlet UIImageView *Banner_MOvies;
@property(nonatomic,weak) IBOutlet UIImageView *BAnner_feature_offers;
@property(nonatomic,weak) IBOutlet UIButton *BTN_Movie_left;
@property(nonatomic,weak) IBOutlet UIButton *BTN_Movie_right;
@property(nonatomic,weak) IBOutlet UICollectionView *Collection_QT_menu;

// shop menu
@property(nonatomic,weak) IBOutlet UIView *VW_First;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_images;
@property(nonatomic,weak) IBOutlet UIPageControl *custom_story_page_controller;
@property(nonatomic,weak) IBOutlet UILabel *LBL_featured;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_features;
@property(nonatomic,weak) IBOutlet UIButton *BTN_left;
@property(nonatomic,weak) IBOutlet UIButton *BTN_right;



@property(nonatomic,weak) IBOutlet UILabel *LBL_best_selling;
@property(nonatomic,weak) IBOutlet UILabel *LBL_fashio;
@property(nonatomic,weak) IBOutlet UIButton *BTN_log_out;



//Second view
@property(nonatomic,weak) IBOutlet UIView *VW_second;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_hot_deals;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_hot_deals_banner;
@property(nonatomic,weak) IBOutlet UILabel *Hot_deals_banner;

@property(nonatomic,weak) IBOutlet UILabel *Hot_deals;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_hot_deals;
//Third view
@property(nonatomic,weak) IBOutlet UIImageView *IMG_best_deals;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_best_deals_banner;

@property(nonatomic,weak) IBOutlet UIView *VW_third;
@property(nonatomic,weak) IBOutlet UILabel *LBL_Best_deals;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_best_deals;
@property(nonatomic,weak) IBOutlet UIButton *hot_deals_more;
@property(nonatomic,weak) IBOutlet UIButton *best_deals_more;



//Fourth  view
@property(nonatomic,weak) IBOutlet UIView *VW_Fourth;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_fashion;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_fashion_banner;

@property(nonatomic,weak) IBOutlet UILabel *LBL_fashion_categiries;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_fashion_categirie;
@property(nonatomic,weak) IBOutlet UIView *VW_profile;
@property(nonatomic,weak) IBOutlet UILabel *LBL_profile;
@property(nonatomic,weak) IBOutlet UICollectionView *collection_brands;

@property(nonatomic,weak) IBOutlet UIButton *BTN_fashion;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_Person_banner;
@property(nonatomic,weak) IBOutlet UIImageView *IMG_Things_banner;
@property(nonatomic,weak) IBOutlet UIButton *BTN_TOP;





//Movies Tab
@property(nonatomic,weak) IBOutlet UICollectionView *Collection_movies;
@property(nonatomic,weak) IBOutlet UIView *VW_line;
@property(nonatomic,weak) IBOutlet UIView *VW_segment;
@property(nonatomic,weak) IBOutlet UIView *VW_Movies;
@property(nonatomic,weak) IBOutlet UITextField *BTN_all_lang;
@property(nonatomic,weak) IBOutlet UITextField *BTN_all_halls;

@property(nonatomic,weak) IBOutlet UIView *VW_filter;

@property (nonatomic, strong) UIPickerView *lang_picker;
@property (nonatomic, strong) UIPickerView *halls_picker;


//events tab
@property(nonatomic,weak) IBOutlet UITableView *TBL_event_list;
@property(nonatomic,weak) IBOutlet UIView *VW_event;
@property(nonatomic,weak) IBOutlet UITextField *BTN_venues;
@property (nonatomic, strong) UIPickerView *venue_picker;


//sports tab

@property(nonatomic,weak) IBOutlet UITableView *TBL_sports_list;
@property(nonatomic,weak) IBOutlet UIView *VW_sports;
@property(nonatomic,weak) IBOutlet UIView *VW_sports_filter;

@property(nonatomic,weak) IBOutlet UITextField *BTN_sports_venues;
@property (nonatomic, strong) UIPickerView *sports_venue_picker;

// Leisure Tab
@property(nonatomic,weak) IBOutlet UITableView *TBL_lisure_list;
@property(nonatomic,weak) IBOutlet UIView *VW_Leisure;
@property(nonatomic,weak) IBOutlet UITextField *BTN_leisure_venues;
@property (nonatomic, strong) UIPickerView *leisure_venues;
@property(nonatomic,weak) IBOutlet UIView *VW_leisure_filter;

//Brands Arrows
@property(nonatomic,weak) IBOutlet UIButton *BTN_brand_left;
@property(nonatomic,weak) IBOutlet UIButton *BTN_brand_right;


@end
