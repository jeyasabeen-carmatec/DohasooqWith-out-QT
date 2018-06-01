 //
//  Home_page_Qtickets.m
//  Dohasooq_mobile
//
//  Created by Test User on 17/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "Home_page_Qtickets.h"
#import "collection_img_cell.h"
#import "Fashion_categorie_cell.h"
#import "cell_features.h"
#import "cell_brands.h"
#import "categorie_cell.h"
#import "dynamic_categirie_cell.h"
#import "menu_cell.h"
#import "UIImageView+WebCache.h"
#import "XMLDictionary/XMLDictionary.h"
#import "HMSegmentedControl.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "HttpClient.h"
#import "product_cell.h"
#import "VC_intial.h"
#import "collection_MENU.h"
#import "ViewController.h"
#import "language_cellTableViewCell.h"
#import "Helper_activity.h"



@interface Home_page_Qtickets ()<UICollectionViewDelegate,UICollectionViewDataSource,UIScrollViewDelegate,UIGestureRecognizerDelegate,UITableViewDelegate,UITableViewDataSource,UITabBarDelegate,UIPickerViewDelegate, UIPickerViewDataSource,UIAlertViewDelegate,UITextFieldDelegate>
{
    NSMutableArray *temp_arr,*temp_hot_deals,*fashion_categirie_arr,*brands_arr,*ARR_category,*lang_arr,*image_Top_ARR,*deals_ARR,*hot_deals_ARR;
    NSIndexPath *INDX_selected;
    NSInteger j,lang_count;
    int tag,collection_tag,temp_test;
    
    BOOL isPickerViewScrolled;
    
    
    NSMutableDictionary *json_Response_Dic;
    float scroll_ht;
    NSMutableArray *Movies_arr,*Events_arr,*Sports_arr,*Leisure_arr;
    NSArray *langugage_arr,*halls_arr,*venues_arr,*sports_venues,*leisure_venues,*menu_arr;
    NSString *halls_text,*leng_text;
    int statusbar_HEIGHT;
    NSDictionary *temp_dicts;
    NSString *language,*language_str,*id_language,*language_code;
    
    int mn;

}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;


@property(nonatomic,strong) UIView *overlayView;

@end

@implementation Home_page_Qtickets


- (void)reloadTableViewData
{
    [_collection_best_deals reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
   // _BTN_menu.translatesAutoresizingMaskIntoConstraints =true;
    if (@available(iOS 9, *)) {
        [_BTN_menu.widthAnchor constraintEqualToConstant:20].active = YES;
        [_BTN_menu.heightAnchor constraintEqualToConstant:17].active = YES;
    }
    
    // Do any additional setup after loading the view.
    
    self.screenName = @"HomePage ";
    
    // Callling Language Switch APi First Time.......

    //[self language_switch_API];
        
    [self API_call];
    
    
}
-(void)view_appear
{
    

    
    CGRect frameset = _VW_nav.frame;
    frameset.size.width = self.navigationController.navigationBar.frame.size.width;
    _VW_nav.frame = frameset;
    
    self.badgeView = [GIBadgeView new];
    [_BTN_cart addSubview:self.badgeView];
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    self.Scroll_contents.hidden = YES;
    [self cart_count];
    [Helper_activity animating_images:self];
    
    [self performSelector:@selector(API_CALL_FETCH) withObject:nil afterDelay:0.01];
   // [self set_up_VIEW];


}
#pragma Logo Action

-(void)logo_api_call
{
    @try
    {
 
        json_Response_Dic = [[NSMutableDictionary alloc]init];
        [self performSelector:@selector(API_call_total) withObject:nil afterDelay:0.01];
   
    }
    @catch(NSException *exception)
    {
        
    }
}

-(void)viewWillAppear:(BOOL)animated
{
   
    self.navigationItem.hidesBackButton = YES;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];

    
    UIView *view=[[UIView alloc] initWithFrame:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, 20)];
    view.backgroundColor = [UIColor colorWithRed:0.98 green:0.69 blue:0.19 alpha:1.0];
    [self.navigationController.view addSubview:view];
    
    _overlayView.hidden =  YES;
    [self set_up_VIEW];
    [self menu_set_UP];
   // [self cart_count_intail];
    [self cart_count];
    
    
}

#pragma Menu Set uP

-(void)menu_set_UP
{
    // [self.TBL_menu reloadData];
    
    NSDictionary *user_data = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *str,*full_name;
    @try
    {
        str = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"firstname"]];
        full_name = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"firstname"]];
        if([str isEqualToString:@"(null)"])
            
        {
            str = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"fname"]];
            full_name = [NSString stringWithFormat:@"%@",[user_data valueForKey:@"fname"]];
        }
    }
    @catch(NSException *exception)
    {
        str = @"Guest User";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
             str = @"مستخدم ضيف";
        }
       
        
    }
    
    if([str isEqualToString:@"(null)"])
    {
        _LBL_profile.text = @"Guest User";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
             _LBL_profile.text = @"مستخدم ضيف";
        }

    }
    else
    {
        _LBL_profile.text = [NSString stringWithFormat:@"%@",full_name];
    }
    
    
    statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
    _menuDraw_width = [UIApplication sharedApplication].statusBarFrame.size.width * 0.80;
    _menyDraw_X = self.navigationController.view.frame.size.width; //- menuDraw_width;
    
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        //self.view.frame.size.width-_VW_swipe.frame.size.width
        _VW_swipe.frame = CGRectMake(self.view.frame.size.width-_VW_swipe.frame.size.width, self.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height-statusbar_HEIGHT);
    }
    else{
        
        _VW_swipe.frame = CGRectMake(0, self.view.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height - self.navigationController.navigationBar.frame.size.height-statusbar_HEIGHT);
    }
    
    
    _overlayView = [[UIView alloc] init];
    _overlayView.frame = CGRectMake(0, self.view.frame.origin.y+statusbar_HEIGHT, self.view.frame.size.width
                                    , self.view.frame.size.height);
    
    _overlayView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    [self.navigationController.view addSubview:_overlayView];
    [_overlayView addSubview:_VW_swipe];
    @try
    {
    NSString *url_Img_FULL;
    NSString *img_url = [[NSUserDefaults standardUserDefaults] valueForKey:@"profile_image"];
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Images_path"];

    if([img_url isEqualToString:@"(null)"])
    {
        @try
        {
        url_Img_FULL = [NSString stringWithFormat:@"%@%@",[dict valueForKey:@"awsPath"],[user_data valueForKey:@"profile_pic"]];
        }
        @catch(NSException *exception)
        {
            NSLog(@"image url Exception %@",exception);
        }
 
    }
    else
    {
        
        @try
        {
            url_Img_FULL = [NSString stringWithFormat:@"%@%@",[dict valueForKey:@"awsPath"],img_url];

        }
        @catch(NSException *exception)
        {
            NSLog(@"imag dgf url Exception %@",exception);
            url_Img_FULL = [NSString stringWithFormat:@"%@%@",[dict valueForKey:@"awsPath"],[user_data valueForKey:@"profile_pic"]];
 
        }


    }
    
    url_Img_FULL  =[url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [_IMG_profile sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                    placeholderImage:[UIImage imageNamed:@"upload-27.png"]
                             options:SDWebImageRefreshCached];
    
    
    _IMG_profile.layer.cornerRadius = _IMG_profile.frame.size.width / 2;
    _IMG_profile.layer.masksToBounds = YES;
    }
    @catch(NSException *exception)
    {
        
    }
    
  //  [_LBL_profile sizeToFit];
    
    CGRect frameset;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        frameset = _BTN_address.frame;
        frameset.size.width = (_VW_swipe.frame.size.width/3) - 2;
        _BTN_address.frame = frameset;
        
        frameset = _BTN_wishlist.frame;
        frameset.origin.x = _BTN_address.frame.origin.x + _BTN_address.frame.size.width + 1;
        frameset.size.width = (_VW_swipe.frame.size.width/3);
        _BTN_wishlist.frame = frameset;
        
        frameset = _BTN_myorder.frame;
        frameset.origin.x = _BTN_wishlist.frame.origin.x + _BTN_wishlist.frame.size.width + 1;
        frameset.size.width = (_VW_swipe.frame.size.width/3) - 1;
        _BTN_myorder.frame = frameset;
    }
    
    else{
        
        frameset = _BTN_myorder.frame;
        frameset.size.width = (_VW_swipe.frame.size.width/3) - 2;
        _BTN_myorder.frame = frameset;
        
        frameset = _BTN_wishlist.frame;
        frameset.origin.x = _BTN_myorder.frame.origin.x + _BTN_myorder.frame.size.width + 1;
        frameset.size.width = (_VW_swipe.frame.size.width/3);
        _BTN_wishlist.frame = frameset;
        
        frameset = _BTN_address.frame;
        frameset.origin.x = _BTN_wishlist.frame.origin.x + _BTN_wishlist.frame.size.width + 1;
        frameset.size.width = (_VW_swipe.frame.size.width/3) - 1;
        _BTN_address.frame = frameset;
    }
    
    frameset=_LBL_order_icon.frame;
    frameset.origin.x = _BTN_myorder.frame.origin.x;
    frameset.origin.y = _BTN_myorder.frame.origin.y + _LBL_order_icon.frame.size.height;
    frameset.size.width = _BTN_myorder.frame.size.width;
    _LBL_order_icon.frame = frameset;
    
    frameset = _LBL_order.frame;
    frameset.origin.x = _BTN_myorder.frame.origin.x;
    frameset.origin.y = _LBL_order_icon.frame.origin.y + _LBL_order_icon.frame.size.height;
    frameset.size.width = _BTN_myorder.frame.size.width;
    _LBL_order.frame = frameset;
    
    
    
    frameset=_LBL_wish_list_icon.frame;
    frameset.origin.x = _BTN_wishlist.frame.origin.x;
    frameset.origin.y = _BTN_wishlist.frame.origin.y + _LBL_wish_list_icon.frame.size.height;
    frameset.size.width = _BTN_wishlist.frame.size.width;
    _LBL_wish_list_icon.frame = frameset;
    
    frameset = _LBL_wish_list.frame;
    frameset.origin.x = _BTN_wishlist.frame.origin.x;
    frameset.origin.y = _LBL_wish_list_icon.frame.origin.y + _LBL_wish_list_icon.frame.size.height;
    frameset.size.width = _BTN_wishlist.frame.size.width;
    _LBL_wish_list.frame = frameset;
    
    
    frameset=_LBL_address_icon.frame;
    frameset.origin.x = _BTN_address.frame.origin.x;
    frameset.origin.y = _BTN_address.frame.origin.y + _LBL_address_icon.frame.size.height;
    frameset.size.width = _BTN_address.frame.size.width;
    _LBL_address_icon.frame = frameset;
    
    frameset = _LBL_address.frame;
    frameset.origin.x = _BTN_address.frame.origin.x;
    frameset.origin.y = _LBL_address_icon.frame.origin.y + _LBL_address_icon.frame.size.height;
    frameset.size.width = _BTN_address.frame.size.width;
    _LBL_address.frame = frameset;
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height <= 480)
    {
        [_LBL_order setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        [_LBL_wish_list setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        [_LBL_address setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
    }
    else if(result.height <= 568)
    {
        [_LBL_order setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        [_LBL_wish_list setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        [_LBL_address setFont:[UIFont fontWithName:@"Poppins-Medium" size:10]];
        
        [_LBL_profile setFont:[UIFont fontWithName:@"Poppins-Medium" size:13]];
        

    }
    else
    {
        [_LBL_order setFont:[UIFont fontWithName:@"Poppins-Medium" size:13]];
        [_LBL_wish_list setFont:[UIFont fontWithName:@"Poppins-Medium" size:13]];
        [_LBL_address setFont:[UIFont fontWithName:@"Poppins-Medium" size:13]];
        
    }
    
    
    
    _VW_swipe.layer.cornerRadius = 2.0f;
    _VW_swipe.layer.masksToBounds = YES;
    
    
    _overlayView.hidden = YES;
    ARR_category = [[NSMutableArray alloc]init];
    
    
    //********************** setting the Menu data ***********************************//
    
    
    @try {
        NSMutableDictionary *sortedArray = [[NSMutableDictionary alloc]init];
        sortedArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pho"] mutableCopy];
        NSMutableArray *arr = [NSMutableArray array];
        
        
        NSMutableSet *seenYears = [NSMutableSet set];
        for (NSDictionary *item in [sortedArray allValues]) {
            //Extract the part of the dictionary that you want to be unique:
            NSDictionary *yearDict = item ;
            if ([seenYears containsObject:yearDict]) {
                continue;
            }
            [seenYears addObject:yearDict];
            [arr addObject:item];
        }

        [ARR_category addObjectsFromArray:[arr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)]];
        [_TBL_menu reloadData];
        
        NSLog(@"Sorted Array :::%@",ARR_category);
    } @catch (NSException *exception) {
        NSLog(@"Array sort exception %@",exception);
    }
    
    
    //********************** setting the languages In language picker ***********************************//

    
    @try
    {
    
    j = ARR_category.count;
    NSArray *lan_arr = [[NSUserDefaults standardUserDefaults]  valueForKey:@"language_arr"];
    NSString *str_lang= [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    for(int i =0;i<lan_arr.count;i++)
    {
        NSString *ids = [NSString stringWithFormat:@"%@",[[lan_arr objectAtIndex:i] valueForKey:@"id"]];
        
        
        if([str_lang isEqualToString:ids])
        {
            language = [NSString stringWithFormat:@"%@",[[lan_arr objectAtIndex:i] valueForKey:@"language_name"]];
            language_str = [NSString stringWithFormat:@"%@",[[lan_arr objectAtIndex:i] valueForKey:@"language_name_localized"]];
            [[NSUserDefaults standardUserDefaults]setValue:language_str forKey:@"language-name"];

            [[NSUserDefaults standardUserDefaults]setValue:language forKey:@"story_board_language"];
            [[NSUserDefaults standardUserDefaults] synchronize];
           
            
        }
    }
    }
    @catch(NSException *exception)
    {
        
    }
     [_TBL_menu reloadData];
    
    //********************** Adding the Gestures to overlay view  ***********************************//

    
    UISwipeGestureRecognizer *SwipeLEFT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeLeft:)];
    SwipeLEFT.direction = UISwipeGestureRecognizerDirectionLeft;
    [_overlayView addGestureRecognizer:SwipeLEFT];
    UITapGestureRecognizer *close_menu = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeLeft:)];
    close_menu.delegate = self;
     [_overlayView addGestureRecognizer:close_menu];

    
    UISwipeGestureRecognizer *SwipeRIGHT = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(SwipeRight:)];
    SwipeRIGHT.direction = UISwipeGestureRecognizerDirectionRight;
    
    [_overlayView addGestureRecognizer:SwipeRIGHT];
    [_BTN_log_out addTarget:self action:@selector(BTN_log_outs) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_address addTarget:self action:@selector(btn_address_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_myorder addTarget:self action:@selector(btn_orders_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_wishlist addTarget:self action:@selector(_BTN_wishlist_action) forControlEvents:UIControlEventTouchUpInside];
  
}

-(void)set_up_VIEW
{
    self.segmentedControl4.selectedSegmentIndex =  0;
    
    [[UIBarButtonItem appearanceWhenContainedIn:[UINavigationBar class], nil] setTitleTextAttributes:
     @{NSForegroundColorAttributeName:[UIColor colorWithRed:0.00 green:0.00 blue:0.00 alpha:1.0],
       NSFontAttributeName:[UIFont fontWithName:@"FontAwesome" size:20.0f]
       } forState:UIControlStateNormal];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];
    if([user_id isEqualToString:@"(null)"])
    {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
             [_BTN_log_out setTitle:@"تسجيل الدخول" forState:UIControlStateNormal];
        }
        else
        {
            [_BTN_log_out setTitle:@"LOGIN" forState:UIControlStateNormal];
        }
    }
    else
    {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            [_BTN_log_out setTitle:@"تسجيل الخروج " forState:UIControlStateNormal];
        }
        else
        {
            [_BTN_log_out setTitle:@"LOGOUT" forState:UIControlStateNormal];
        }
    }

    _LBL_badge.layer.cornerRadius = self.LBL_badge.frame.size.width/2;
    _LBL_badge.layer.masksToBounds = YES;
    
    [self  cart_count];
    
    @try
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height <= 480)
        {
            [_LBL_best_selling setFont:[UIFont fontWithName:@"Poppins-Medium" size:12]];
            [_Hot_deals_banner setFont:[UIFont fontWithName:@"Poppins-Medium" size:12]];

            
        
        }
        else if(result.height <= 568)
        {
            [_LBL_best_selling setFont:[UIFont fontWithName:@"Poppins-Medium" size:14]];
            [_Hot_deals_banner setFont:[UIFont fontWithName:@"Poppins-Medium" size:14]];


        }
        else
        {
            [_LBL_best_selling setFont:[UIFont fontWithName:@"Poppins-Medium" size:17]];
            [_Hot_deals_banner setFont:[UIFont fontWithName:@"Poppins-Medium" size:17]];


        }

        

        }
    @catch(NSException *exception)
    {
        
    }

       @try
    {
       
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
             _LBL_fashion_categiries.text = @"إكسسوارات الموضة";
        }
        else
        {
             _LBL_fashion_categiries.text = @"FASHION ACCESSORIES";
        }
    
    }
    @catch(NSException *exception)
    {
        
    }
    @try
    {
  
    }
    @catch(NSException *exception)
    {
    }
    
    //********************** Adding the images To QTickets Collection view  ***********************************//


    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
  menu_arr = [NSArray arrayWithObjects:@"leisure-2_30x30",@"sports-2_30x30",@"events-2_1_30x30",@"movies-2_30x30",nil];
    }
    else{

  menu_arr = [NSArray arrayWithObjects:@"movies-2_30x30",@"events-2_1_30x30",@"sports-2_30x30",@"leisure-2_30x30",nil];
    }

    temp_hot_deals = [[NSMutableArray alloc]init];
    
       CGRect setupframe = _Scroll_contents.frame;
    setupframe.origin.y = self.navigationController.navigationBar.frame.origin.y +  self.navigationController.navigationBar.frame.size.height;
    
    _Scroll_contents.frame = setupframe;
    
     setupframe = _VW_First.frame;
    //setupframe.origin.y = _Tab_MENU.frame.origin.y + _Tab_MENU.frame.size.height ;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_First.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_First];
    
    //********************** Adding the tap gesture  To hot deals image  ***********************************//

    _IMG_hot_deals .userInteractionEnabled = YES;
    
    UITapGestureRecognizer *hot_deals_hesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(hot_deals_action)];
    
    hot_deals_hesture.numberOfTapsRequired = 1;
    
    [hot_deals_hesture setDelegate:self];
    
    [_IMG_hot_deals addGestureRecognizer:hot_deals_hesture];
    
    //********************** Adding the tap gesture  To Best deals image  ***********************************//

    _IMG_best_deals .userInteractionEnabled = YES;
    
    UITapGestureRecognizer *best_deals_gesture = [[UITapGestureRecognizer alloc] initWithTarget:self  action:@selector(best_deals_action)];
    
    best_deals_gesture.numberOfTapsRequired = 1;
    
    [best_deals_gesture setDelegate:self];
    
    [_IMG_best_deals addGestureRecognizer:best_deals_gesture];


    //********************** setting the frame one by one  ***********************************//


    setupframe = _VW_second.frame;
    setupframe.origin.y = _VW_First.frame.origin.y + _VW_First.frame.size.height;
    setupframe.size.height = _collection_hot_deals.frame.origin.y + _collection_hot_deals.collectionViewLayout.collectionViewContentSize.height+10+_best_deals_more.frame.size.height;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_second.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_second];
    
    CGRect frameset = _best_deals_more.frame;
    frameset.origin.y = _collection_hot_deals.frame.origin.y + _collection_hot_deals.collectionViewLayout.collectionViewContentSize.height + 5;
    _best_deals_more.frame = frameset;

    
    [_collection_best_deals reloadData];
    
    
    setupframe = _VW_third.frame;
    setupframe.origin.y = _VW_second.frame.origin.y + _VW_second.frame.size.height +10;
    setupframe.size.height = _collection_best_deals.frame.origin.y + _collection_best_deals.collectionViewLayout.collectionViewContentSize.height+10+_hot_deals_more.frame.size.height;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_third.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_third];
    
     frameset = _hot_deals_more.frame;
    frameset.origin.y = _collection_best_deals.frame.origin.y + _collection_best_deals.collectionViewLayout.collectionViewContentSize.height + 5;
    _hot_deals_more.frame = frameset;
    
    
    
    [_collection_fashion_categirie reloadData];
    
    
    
    setupframe = _VW_Fourth.frame;
    setupframe.origin.y = _VW_third.frame.origin.y + _VW_third.frame.size.height +10;
    setupframe.size.height = _collection_fashion_categirie.frame.origin.y + _collection_fashion_categirie.collectionViewLayout.collectionViewContentSize.height+_BTN_TOP.frame.size.height + 15;
    setupframe.size.width = _Scroll_contents.frame.size.width;
    _VW_Fourth.frame = setupframe;
    [self.Scroll_contents addSubview:_VW_Fourth];
    
    
     frameset = _BTN_TOP.frame;
    frameset.origin.y = self.collection_fashion_categirie.frame.origin.y + self.collection_fashion_categirie.frame.size.height  + 5;
    _BTN_TOP.frame = frameset;
    
    _BTN_TOP.titleLabel.numberOfLines = 0;
   // NSLog(@"THe deals keya are %@",[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"] allKeys]);
    @try
    {
    if([hot_deals_ARR count] < 1)
    {
        _VW_second.hidden = YES;
        if([deals_ARR count] < 1)
        {
            _VW_third.hidden = YES;
            if(brands_arr.count < 1)
            {
                if([fashion_categirie_arr count] < 1)
                {
                    _VW_Fourth.hidden = NO;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_First.frame.origin.y + _VW_First.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                }
                
                
            }
            else
            {
                _VW_Fourth.hidden = NO;
                if([fashion_categirie_arr count]< 1)
                {
                    _collection_fashion_categirie.hidden = YES;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_First.frame.origin.y + _VW_First.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
                }
            }
            
        }
        else
        {
            setupframe = _VW_third.frame;
            setupframe.origin.y  = _VW_First.frame.origin.y + _VW_First.frame.size.height;
            _VW_third.frame = setupframe;
            if(brands_arr.count < 1)
            {
                if([fashion_categirie_arr count] < 1)
                {
                    _VW_Fourth.hidden = NO;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
                }
                
                
            }
            else
            {
                _VW_Fourth.hidden = NO;
                if([fashion_categirie_arr count]< 1)
                {
                    _collection_fashion_categirie.hidden = YES;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
                }
            }
            
        }
        
        
    }
    else
    {
        _VW_second.hidden = NO;
        
        if([deals_ARR count] < 1)
        {
            _VW_third.hidden = YES;
            if(brands_arr.count < 1)
            {
                if([fashion_categirie_arr count] < 1)
                {
                    _VW_Fourth.hidden = NO;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_second.frame.origin.y + _VW_second.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
                }
                
                
            }
            else
            {
                _VW_Fourth.hidden = NO;
                if([fashion_categirie_arr count] < 1)
                {
                    _collection_fashion_categirie.hidden = YES;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_second.frame.origin.y + _VW_second.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
                }
            }
            
        }
        else
        {
            _VW_third.hidden = NO;
            setupframe = _VW_third.frame;
            setupframe.origin.y  = _VW_second.frame.origin.y + _VW_second.frame.size.height;
            _VW_third.frame = setupframe;
            if(brands_arr.count < 1)
            {
                if([fashion_categirie_arr count] < 1)
                {
                    _VW_Fourth.hidden = YES;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
                }
                
            }
            else
            {
                _VW_Fourth.hidden = NO;
                if([fashion_categirie_arr count] < 1)
                {
                    _collection_fashion_categirie.hidden = YES;
                }
                else
                {
                    setupframe = _VW_Fourth.frame;
                    setupframe.origin.y  = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                    _VW_Fourth.frame = setupframe;
                    
                }
            }
            
            
            
        }
        
        
    }
    if(_VW_second.hidden == YES)
    {
        if(_VW_third.hidden == YES)
        {
            if(_VW_Fourth.hidden == YES)
            {
                scroll_ht = _VW_First.frame.origin.y + _VW_First.frame.size.height;
            }
            else
            {
                scroll_ht = _VW_Fourth.frame.origin.y + _VW_Fourth.frame.size.height;
                
            }
        }
        else
        {
            if(_VW_Fourth.hidden == YES)
            {
                scroll_ht = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                
            }
            else
            {
                scroll_ht = _VW_Fourth.frame.origin.y + _VW_Fourth.frame.size.height;
                
            }
            
            
        }
        
    }
    else
    {
        if(_VW_third.hidden == YES)
        {
            if(_VW_Fourth.hidden == YES)
            {
                scroll_ht = _VW_second.frame.origin.y + _VW_second.frame.size.height;
            }
            else
            {
                scroll_ht = _VW_Fourth.frame.origin.y + _VW_Fourth.frame.size.height;
                
            }
        }
        else
        {
            if(_VW_Fourth.hidden == YES)
            {
                scroll_ht = _VW_third.frame.origin.y + _VW_third.frame.size.height;
                
            }
            else
            {
                
                scroll_ht = _VW_Fourth.frame.origin.y + _VW_Fourth.frame.size.height;
                
            }
        }
        
    }
    
    }
    @catch(NSException *exception)
    {
        
    }
    self.page_controller_movies.numberOfPages =[[temp_dicts valueForKey:@"movie"] count];
    self.custom_story_page_controller.numberOfPages=[image_Top_ARR count];
    _BTN_left.layer.cornerRadius = _BTN_left.frame.size.width/2;
    _BTN_left.layer.masksToBounds = YES;
    _BTN_right.layer.cornerRadius = _BTN_right.frame.size.width/2;
    _BTN_right.layer.masksToBounds = YES;
    
    _BTN_Movie_left.layer.cornerRadius = _BTN_left.frame.size.width/2;
    _BTN_Movie_left.layer.masksToBounds = YES;
    _BTN_Movie_right.layer.cornerRadius = _BTN_right.frame.size.width/2;
    _BTN_Movie_right.layer.masksToBounds = YES;

    
    [_BTN_right addTarget:self action:@selector(BTN_right_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_left addTarget:self action:@selector(BTN_left_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_menu addTarget:self action:@selector(MENU_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Movie_right addTarget:self action:@selector(BTN_movies_right_action) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_Movie_left addTarget:self action:@selector(BTN_movies_left_action) forControlEvents:UIControlEventTouchUpInside];
    
    _BTN_fashion.tag = 1;
    [_BTN_fashion addTarget:self action:@selector(BTN_fashhion_cahnge) forControlEvents:UIControlEventTouchUpInside];
    [_BTN_QT_view addTarget:self action:@selector(movies_ACTIOn) forControlEvents:UIControlEventTouchUpInside];
    [_best_deals_more addTarget:self action:@selector(hot_deals_action) forControlEvents:UIControlEventTouchUpInside];
    [_hot_deals_more addTarget:self action:@selector(best_deals_action) forControlEvents:UIControlEventTouchUpInside];
    

    [self viewDidLayoutSubviews];
    
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_Scroll_contents layoutIfNeeded];
    
    _Scroll_contents.contentSize = CGSizeMake(_Scroll_contents.frame.size.width,scroll_ht);


}

#pragma mark - UIcollection view datasource/Deligate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(collectionView == _collection_showing_movies)
    {
        return [[temp_dicts valueForKey:@"movie"] count];
    }
    else if(collectionView == _collection_images)
    {
        // return temp_arr.count;
        NSInteger count = 0;
        @try
        {
            
            count = image_Top_ARR.count;
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        
        return count;
    }
    else if(collectionView == _collection_features)
    {
        //return temp_arr.count;
       // NSLog(@"Max count feautures %lu",[[json_Response_Dic valueForKey:@"bannerLarge"]count]);
        NSInteger count = 0;
        @try
        {
            
            count =  [[json_Response_Dic valueForKey:@"bannerLarge"]count];
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        
        return count;
        
    }
    else if(collectionView == _collection_hot_deals )
    {
        //return temp_hot_deals.count;
        NSInteger count = 0;
        @try
        {
            
            count =  [hot_deals_ARR count];;
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        
        return count;
        
    }
    else if( collectionView == _collection_best_deals)
    {
        //return temp_hot_deals.count; dealWidget-1
        NSInteger count = 0;
        @try
        {
            
            count =  [deals_ARR count];;
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        return count;
        
    }
    else if( collectionView == _collection_brands)
    {
        NSInteger count = 0;
        @try
        {
            
            count =  [brands_arr count];;
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        return count;
    }
    
    else if(collectionView == _collection_fashion_categirie)
    {
        NSInteger count = 0;
        @try
        {
            
            count =  [fashion_categirie_arr count];
        }
        @catch(NSException *exception)
        {
            count = 0;
        }
        
        return count;
    }
    else if(collectionView == _Collection_movies)
    {
        return Movies_arr.count;
    }
    
    return menu_arr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
   
    //collection images
    
    if(collectionView == _collection_images)
    {
        
        collection_img_cell *img_cell = (collection_img_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_image" forIndexPath:indexPath];
        @try
        {
            if(indexPath.row == image_Top_ARR.count-1)
            {
                img_cell.img.image = [UIImage imageNamed:[image_Top_ARR objectAtIndex:indexPath.row]];
            }
            else
            {
                  NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Images_path"];
                //NSLog(@"THE IMAGE PATH RESPONSE:%@",dict);
                NSString *url_Img_FULL = [NSString stringWithFormat:@"%@%@%@",[dict valueForKey:@"awsPath"],[dict valueForKey:@"banner"],[[image_Top_ARR objectAtIndex:indexPath.row] valueForKey:@"banner"]];
                url_Img_FULL  =[url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                [img_cell.img sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                placeholderImage:[UIImage imageNamed:@"logo.png"]
                                         options:SDWebImageRefreshCached];
            }
            
            
        }
        @catch(NSException *xception)
        {
            
        }
        
        
        return img_cell;
    }
    // collection now showing movies
    
       //collection features
    
    else if(collectionView == _collection_features)
    {
        cell_features *cell = (cell_features *)[collectionView dequeueReusableCellWithReuseIdentifier:@"features_cell" forIndexPath:indexPath];
        
        @try {
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Images_path"];
            
            NSString *url_Img_FULL = [NSString stringWithFormat:@"%@%@%@",[dict valueForKey:@"awsPath"],[dict valueForKey:@"bannerAds"],[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"mobile_banner"]];
            url_Img_FULL  =[url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            [cell.img sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                        placeholderImage:[UIImage imageNamed:@"logo.png"]];
            
        } @catch (NSException *exception) {
            NSLog(@"Exception from cell item indexpath %@",exception);
        }
        
        
        return cell;
        
        
    }
    
    //collection hot deals
    
    else if(collectionView == _collection_best_deals)
    {
        product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
        
        @try
        {
            
          NSString *url_Img_FULL = [NSString stringWithFormat:@"%@",[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_image"]];
            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            
            @try
            {
                
                NSString *str =[NSString stringWithFormat:@"%@",[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"stock_status"]];
                str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
                if([str isEqualToString:@"In stock"]|| [str isEqualToString:@""]|| [str isEqualToString:@"<null>"] )         {
                    pro_cell.LBL_stock.text =@"";
                    }
                else{
                    pro_cell.LBL_stock.text =[str uppercaseString];
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        pro_cell.LBL_stock.text = @"غير متوفّر";
                    }

                }
            }
            @catch(NSException *exception)
            {
                
            }
            
        
            
            pro_cell.LBL_item_name.titleLabel.numberOfLines = 2;
            [pro_cell.LBL_item_name setTitle:[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_title"]forState:UIControlStateNormal];
            pro_cell.LBL_item_name.titleLabel.textAlignment = NSTextAlignmentCenter;

            
            float rating = [[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"rating"] floatValue];
            rating =lroundf(rating);
            if(rating <= 1)
            {
                pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.92 green:0.39 blue:0.25 alpha:1.0];
            }
            else if(rating <= 2)
            {
                pro_cell.LBL_rating.backgroundColor =[UIColor colorWithRed:0.96 green:0.69 blue:0.24 alpha:1.0];
            }
            else if(rating <= 3)
            {
                pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.19 green:0.56 blue:0.78 alpha:1.0];
            }
            else
            {
                pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.25 green:0.80 blue:0.51 alpha:1.0];
            }
            
            pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%.f  ",rating];
            
            NSString *currency = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"currency"]];
            
            NSString *current_price = [NSString stringWithFormat:@"%@", [[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"special_price"]];
            
            NSString *prec_price = [NSString stringWithFormat:@"%@ %@",currency, [[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
            NSString *text ;
            if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                
        //********************** When The special Price is <null> or <nil> or <0>  ***********************************//

                if ([current_price isEqualToString:@"<null>"] || [current_price isEqualToString:@"<nil>"]||[current_price isEqualToString:@"0"]) {
                    
                    prec_price = [NSString stringWithFormat:@"%@ %@",currency, [[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
                    text = [NSString stringWithFormat:@"%@",prec_price];
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        prec_price = [NSString stringWithFormat:@"%@ %@",[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"],currency];
                        text = [NSString stringWithFormat:@"%@",prec_price];
                    }

                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:currency] ];
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:prec_price] ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    //NSParagraphStyleAttributeName
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    pro_cell.LBL_discount.text = @"";
                    
                    
                }
        //********************** When The special Price and Current price are Equal ***********************************//

                else if([prec_price isEqualToString:current_price] ||[current_price isEqualToString:@"0.00"])
                {
                   prec_price = [NSString stringWithFormat:@"%@ %@",currency, [[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
                    text = [NSString stringWithFormat:@"%@",prec_price];
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                                               prec_price = [NSString stringWithFormat:@"%@ %@",[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"],currency];
                        text = [NSString stringWithFormat:@"%@",prec_price];
                    }
                    
                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:currency] ];
                    
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:prec_price] ];
                    
                    
                    
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                    pro_cell.LBL_discount.text = @"";
                    
                }

                
                else{
                    
                    
                    NSString *str_discount = [NSString stringWithFormat:@"%@", [[deals_ARR objectAtIndex:indexPath.row]valueForKey:@"discount"]];
                    
                    NSString *str = @"% off";
                    pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@%@",str_discount,str];
                    
                    
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        
                        str = @"%خصم";
                        pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@ %@",str,str_discount];
                    }
                    else{
                        
                        str = @"% off";
                        pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@%@",str_discount,str];
                        
                    }
                    

                
                    
                   
                    
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        prec_price = [NSString stringWithFormat:@"%@ %@",[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"],currency];
                        current_price = [NSString stringWithFormat:@"%@ %@",current_price,currency];
                        
                        text = [NSString stringWithFormat:@"%@ %@",prec_price,current_price];
                    }
                    
                    else{
                        prec_price = [NSString stringWithFormat:@"%@ %@",currency, [[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
                         current_price = [NSString stringWithFormat:@"%@ %@",currency,current_price];
                        text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
                    }
                    
                   
                    
                    int sizeval = 14;
                    int desired_VAL = 10;
                    CGSize result = [[UIScreen mainScreen] bounds].size;
                    if(result.height <= 480)
                    {
                        desired_VAL = 8;
                    }
                    else if(result.height <= 568)
                    {
                        desired_VAL = 8;
                    }
                    
                    else
                    {
                        desired_VAL = 10;
                    }

                    
                    if (current_price.length >= desired_VAL)
                    {
                        sizeval = 14;
                        
//             if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"]isEqualToString:@"Arabic"])
                     //   {
//                          
//                            
//                            text = [NSString stringWithFormat:@"%@\n%@",prec_price,current_price];
//                        }
//                        else{
                            text = [NSString stringWithFormat:@"%@\n%@",current_price,prec_price];
 
                       // }
                        
                    }
                    else{
                        sizeval = 14;
                    }

                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:sizeval],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0],}range:[text rangeOfString:currency] ];
                    
                    NSRange ename = [text rangeOfString:current_price];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:sizeval],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:ename];
                    
                    
                    NSRange cmp = [text rangeOfString:prec_price];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:sizeval],NSForegroundColorAttributeName:[UIColor grayColor],}range:cmp ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                      
                        if (current_price.length >= desired_VAL)
                        {
                            [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                                   value:@2
                                                   range:NSMakeRange([current_price length]+1, [prec_price length])];
                        }
                        else{
                        [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                               value:@2
                                               range:NSMakeRange(0 ,[prec_price length])];
                        }
                    }
                    
                    else{
                        [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                               value:@2
                                               range:NSMakeRange([current_price length]+1, [prec_price length])];
                    }
                   
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                }
            }
            else
            {
                pro_cell.LBL_current_price.text = text;
            }
            
             pro_cell.LBL_current_price.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
            
            [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
            
            
            if ([[[deals_ARR objectAtIndex:indexPath.row] valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                [pro_cell.BTN_fav setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else{
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                
                [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            [pro_cell.BTN_fav addTarget:self action:@selector(best_dels_wishlist:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        
        NSLog(@"The cell frame is :%@",NSStringFromCGRect(pro_cell.frame));
        NSLog(@"The hot_deals frame is :%@",NSStringFromCGRect(_collection_hot_deals.frame));
        
        
        return pro_cell;
    }
    
    //collection Best deals
    
    else if(collectionView == _collection_hot_deals)
    {
        product_cell *pro_cell = (product_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"collection_product" forIndexPath:indexPath];
        
        @try
        {
            
            NSString *url_Img_FULL =[NSString stringWithFormat:@"%@", [[hot_deals_ARR objectAtIndex:indexPath.row ] valueForKey:@"product_image"]];
            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            
            
            pro_cell.LBL_item_name.titleLabel.numberOfLines = 2;
            [pro_cell.LBL_item_name setTitle:[[hot_deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_title"] forState:UIControlStateNormal];
            pro_cell.LBL_item_name.titleLabel.textAlignment = NSTextAlignmentCenter;


            
            
            float rating = [[[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"rating"] floatValue];
            rating =lroundf(rating);
            if(rating <= 1)
            {
                pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.92 green:0.39 blue:0.25 alpha:1.0];
            }
            else if(rating <= 2)
            {
                pro_cell.LBL_rating.backgroundColor =[UIColor colorWithRed:0.96 green:0.69 blue:0.24 alpha:1.0];
            }
            else if(rating <= 3)
            {
                pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.19 green:0.56 blue:0.78 alpha:1.0];
            }
            else
            {
                pro_cell.LBL_rating.backgroundColor = [UIColor colorWithRed:0.25 green:0.80 blue:0.51 alpha:1.0];
            }
            
            pro_cell.LBL_rating.text = [NSString stringWithFormat:@"%.f  ",rating];
            
            NSString *currency = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"currency"]];
            
            
            NSString *current_price = [NSString stringWithFormat:@"%@", [[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"special_price"]];
            
            NSString *prec_price = [NSString stringWithFormat:@"%@", [[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"product_price"]];
            NSString *text ;
            
            if ([pro_cell.LBL_current_price respondsToSelector:@selector(setAttributedText:)]) {
                
                NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
                [paragraphStyle setAlignment:NSTextAlignmentCenter];
                
                
        //********************** When The special Price is <null> or <nil> or <0>  ***********************************//
               

                if ([current_price isEqualToString:@"<null>"] || [current_price isEqualToString:@"<nil>"]||[current_price isEqualToString:@"0"]) {
                    
                    prec_price = [NSString stringWithFormat:@"%@ %@",currency, [[hot_deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
                    text = [NSString stringWithFormat:@"%@",prec_price];
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        prec_price = [NSString stringWithFormat:@"%@ %@",[[hot_deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"],currency];
                        text = [NSString stringWithFormat:@"%@",prec_price];
                    }

                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:currency] ];
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:prec_price] ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    //NSParagraphStyleAttributeName
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    pro_cell.LBL_discount.text = @"";
                    
                    
                    
                }
        //********************** When The special Price and Current price are Equal ***********************************//
                else if([prec_price isEqualToString:current_price] ||[current_price isEqualToString:@"0.00"])
                {
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        prec_price = [NSString stringWithFormat:@"%@ %@",[[hot_deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"],currency];
                        text = [NSString stringWithFormat:@"%@",prec_price];
                    }
                    
                    else{
                        prec_price = [NSString stringWithFormat:@"%@ %@",currency, [[hot_deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
                        text = [NSString stringWithFormat:@"%@",prec_price];
 
                    }
                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:currency] ];
                    
                    
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:14.0],NSForegroundColorAttributeName:[UIColor grayColor],}range:[text rangeOfString:prec_price] ];
                    
                    
                    
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                    pro_cell.LBL_discount.text = @"";
                    
                }
                
                
                else{
                    
                    
                    NSString *str_discount = [NSString stringWithFormat:@"%@", [[hot_deals_ARR objectAtIndex:indexPath.row]valueForKey:@"discount"]];
                    
                    NSString *str = @"% off";
                    pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@%@",str_discount,str];
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        
                        str = @"%خصم";
                        pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@ %@",str,str_discount];
                    }
                    else{
                        
                        str = @"% off";
                        pro_cell.LBL_discount.text = [NSString stringWithFormat:@"%@%@",str_discount,str];
                        
                    }
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        prec_price = [NSString stringWithFormat:@"%@ %@",[[hot_deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"],currency];
                        current_price = [NSString stringWithFormat:@"%@ %@",current_price,currency];
                        text = [NSString stringWithFormat:@"%@ %@",prec_price,current_price];
                    }
                    else{
                        prec_price = [NSString stringWithFormat:@"%@ %@",currency, [[hot_deals_ARR objectAtIndex:indexPath.row] valueForKey:@"product_price"]];
                         current_price = [NSString stringWithFormat:@"%@ %@",currency,current_price];
                        text = [NSString stringWithFormat:@"%@ %@",current_price,prec_price];
                    }

                    
                    int sizeval = 14;
                    int desired_VAL = 10;
                    CGSize result = [[UIScreen mainScreen] bounds].size;
                    if(result.height <= 480)
                    {
                        desired_VAL = 8;
                    }
                    else if(result.height <= 568)
                    {
                        desired_VAL = 8;
                    }
                    
                    else
                    {
                        desired_VAL = 10;
                    }
                    

                    if (current_price.length >= desired_VAL)
                    {
                        sizeval = 14;
                        
                        
//                        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//                        {
//
//                            text = [NSString stringWithFormat:@"%@\n %@",current_price,prec_price];
//                        }
//                        else{
                             text = [NSString stringWithFormat:@"%@\n%@",current_price,prec_price];
                       // }
                        
                        
                    }
                    else{
                        sizeval = 14;
                    }
                    
                    
                    
                    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:text attributes:nil];
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:sizeval],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0],}range:[text rangeOfString:currency] ];
                    
                    NSRange ename = [text rangeOfString:current_price];
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:sizeval],NSForegroundColorAttributeName:[UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0]}
                                                range:ename];
                
                    
                    NSRange cmp = [text rangeOfString:prec_price];
                  
                    
                    [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Light" size:sizeval],NSForegroundColorAttributeName:[UIColor grayColor],}range:cmp ];
                    
                    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [text length])];
                    
                    
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        if (current_price.length >= desired_VAL)
                        {
                            [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                                   value:@2
                                                   range:NSMakeRange([current_price length]+1, [prec_price length])];
                        }else{
                    [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                               value:@2
                                               range:NSMakeRange(0 ,[prec_price length])];
                        }
                    }
                    
                    else{
                        [attributedText addAttribute:NSStrikethroughStyleAttributeName
                                               value:@2
                                               range:NSMakeRange([current_price length]+1, [prec_price length])];
                    }
                    
                   
                    pro_cell.LBL_current_price.attributedText = attributedText;
                    
                }
            }
            else
            {
                pro_cell.LBL_current_price.text = text;
            }
            
            pro_cell.LBL_current_price.textContainer.lineBreakMode = NSLineBreakByWordWrapping;
            [pro_cell.BTN_fav setTag:indexPath.row];//wishListStatus
            
            
            if ([ [[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"wishListStatus"] isEqualToString:@"Yes"]) {
                
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                [pro_cell.BTN_fav setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
            }
            else{
                [pro_cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                
                [pro_cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            }
            
            [pro_cell.BTN_fav addTarget:self action:@selector(hot_dels_wishlist:) forControlEvents:UIControlEventTouchUpInside];
            
            
            
        }
        @catch(NSException *exception)
        {
            
            
        }
        
        NSLog(@"The cell frame is :%@",NSStringFromCGRect(pro_cell.frame));
        NSLog(@"The hot_deals frame is :%@",NSStringFromCGRect(_collection_hot_deals.frame));
        return pro_cell;
        
        
    }     else if(collectionView == _collection_brands)
    {
        cell_brands *cell = (cell_brands *)[collectionView dequeueReusableCellWithReuseIdentifier:@"brands_cell" forIndexPath:indexPath];
        
        @try
        {
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Images_path"];

            NSString *img_URL = [NSString stringWithFormat:@"%@%@%@",[dict valueForKey:@"awsPath"],[dict valueForKey:@"brand"],[[brands_arr objectAtIndex:indexPath.row]  valueForKey:@"logo"]];
            img_URL = [img_URL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            [cell.img sd_setImageWithURL:[NSURL URLWithString:img_URL]
                        placeholderImage:[UIImage imageNamed:@"logo.png"]
                                 options:SDWebImageRefreshCached];
            
            cell.contentView.layer.cornerRadius = 2.0f;
            cell.contentView.layer.masksToBounds = YES;
            cell.img.layer.cornerRadius = 2.0f;
            cell.img.layer.masksToBounds = YES;
            
        }
        @catch (NSException *exception) {
            NSLog(@"Exception from cell item indexpath %@",exception);
        }
        
        return cell;
        
        
        
    }
    //Collection Fashion categories
    
    else if(collectionView == _collection_fashion_categirie)
    {
        Fashion_categorie_cell *pro_cell = (Fashion_categorie_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"fashion_categorie" forIndexPath:indexPath];
        
        @try
        {
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"Images_path"];
            

            NSString *url_Img_FULL =[NSString stringWithFormat:@"%@%@%@",[dict valueForKey:@"awsPath"],[dict valueForKey:@"bannerAds"],[[fashion_categirie_arr objectAtIndex:indexPath.row] valueForKey:@"mobile_banner"]];
            url_Img_FULL = [url_Img_FULL stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
            
            
            
            [pro_cell.IMG_item sd_setImageWithURL:[NSURL URLWithString:url_Img_FULL]
                                 placeholderImage:[UIImage imageNamed:@"logo.png"]
                                          options:SDWebImageRefreshCached];
            
        }
        @catch(NSException *exception)
        {
            
        }
        
        return pro_cell;
        
    }
    // collection QTickets
    
  /*  else if(collectionView == _Collection_QT_menu)
    {
        collection_MENU *pro_cell = (collection_MENU *)[collectionView dequeueReusableCellWithReuseIdentifier:@"menu_cell" forIndexPath:indexPath];
        @try
        {
            NSArray *arr = [NSArray arrayWithObjects:@"Movies",@"Events",@"Sports",@"Leisure", nil];
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                arr = [NSArray arrayWithObjects:@"Leisure",@"Sports",@"Events",@"Movies", nil];
            }
            
            
            pro_cell.IMG_menu.image = [UIImage imageNamed:[menu_arr objectAtIndex:indexPath.row]];
            pro_cell.LBL_menu.text = [arr objectAtIndex:indexPath.row];
            if(indexPath.row == 0)
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.68 green:0.81 blue:0.60 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.37 green:0.70 blue:0.14 alpha:1.0];
                }
                else{
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.50 green:0.69 blue:0.80 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.20 green:0.56 blue:0.76 alpha:1.0];
                }
                
            }
            if(indexPath.row == 1)
            {
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.78 green:0.62 blue:0.78 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.57 green:0.17 blue:0.56 alpha:1.0];
                }
                else{
                    
                    
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.77 green:0.52 blue:0.64 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.93 green:0.10 blue:0.51 alpha:1.0];
                }
            }
            if(indexPath.row == 2)
            {
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.77 green:0.52 blue:0.64 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.93 green:0.10 blue:0.51 alpha:1.0];
                }
                
                else{
                    
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.78 green:0.62 blue:0.78 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.57 green:0.17 blue:0.56 alpha:1.0];
                }
            }
            if(indexPath.row == 3)
            {
                
                if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                {
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.50 green:0.69 blue:0.80 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.20 green:0.56 blue:0.76 alpha:1.0];
                }
                else{
                    
                    pro_cell.VW_back_ground.backgroundColor = [UIColor colorWithRed:0.68 green:0.81 blue:0.60 alpha:1.0];
                    pro_cell.VW_select.backgroundColor = [UIColor colorWithRed:0.37 green:0.70 blue:0.14 alpha:1.0];
                }
            }
            
            
        }
        @catch(NSException *exception)
        {
            
        }
        
        return pro_cell;
        
        
    }*/
    
    
    return 0;
    
    
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(collectionView == _collection_images)
    {
        
        return CGSizeMake(_collection_images.frame.size.width ,_collection_images.frame.size.height);
    }
      else if(collectionView == _collection_showing_movies)
    {
        
        return CGSizeMake(_collection_showing_movies.frame.size.width ,_collection_showing_movies.frame.size.height);
    }

    else if( collectionView == _collection_features)
    {
        return CGSizeMake(_collection_features.bounds.size.width ,_collection_features.frame.size.height);
        
    }
    else if(collectionView == _collection_best_deals)
    {
        return CGSizeMake(_collection_best_deals.frame.size.width/2.011, 315);
        
    }
    else if(collectionView == _Collection_QT_menu)
    {
        return CGSizeMake(_Collection_QT_menu.frame.size.width/4.1, 80);
    }
    else if(collectionView == _collection_hot_deals)
    {
        NSLog(@"the size is width %f: THE height%d",(_collection_hot_deals.bounds.size.width/2),285);

        return CGSizeMake(_collection_hot_deals.frame.size.width/2.011, 315);
        
    }
    else if( collectionView == _collection_brands)
    {
        return CGSizeMake(_collection_features.frame.size.width/3.28 ,50);
        
    }
    else if(collectionView == _collection_fashion_categirie)
    {
        
    //********************** set the height for first image in fashion accessories ***********************************//
        
        if(indexPath.row == 0)
        {
           return CGSizeMake(self.collection_fashion_categirie.bounds.size.width, 270);
        }
        else
        {
            return CGSizeMake(self.collection_fashion_categirie.bounds.size.width, 200);
        }
        
    }
    else
        return CGSizeMake(0,0);
    
    
    
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    
    int ht = 0;
    if(collectionView == _collection_hot_deals)
    {
        ht = 0;
    }
    
    if(collectionView == _collection_best_deals)
    {
        ht = 0;
    }
   
       
    return ht;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    int ht = 0;
    if(collectionView == _collection_hot_deals)
    {
        ht = 2;
    }
    
    if(collectionView == _collection_best_deals)
    {
        ht = 2;
    }
    if(collectionView == _collection_fashion_categirie)
    {
        ht = 2;
    }
       return ht;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    TIMER_countdown = [[NSTimer alloc]init];
    best_deals_Timer = [[NSTimer alloc]init];
    
    //********************** On select action for collection view best deals ***********************************//

    if(collectionView == _collection_best_deals)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[deals_ARR objectAtIndex:indexPath.row]valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
        
        NSString *merchant_id = [NSString stringWithFormat:@"%@",[[deals_ARR objectAtIndex:indexPath.row]valueForKey:@"merchant_id"]];
         [[NSUserDefaults standardUserDefaults] setValue:merchant_id forKey:@"Mercahnt_ID"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        

        [self performSegueWithIdentifier:@"QT_home_product_detail" sender:self];
    }
    
    //********************** On select action for collection view Hot deals ***********************************//

    else if(collectionView == _collection_hot_deals)
    {
        [[NSUserDefaults standardUserDefaults] setObject:[[hot_deals_ARR objectAtIndex:indexPath.row]valueForKey:@"url_key"] forKey:@"product_list_key_sub"];
        NSString *merchant_id = [NSString stringWithFormat:@"%@",[[hot_deals_ARR objectAtIndex:indexPath.row]valueForKey:@"merchant_id"]];
        [[NSUserDefaults standardUserDefaults] setValue:merchant_id forKey:@"Mercahnt_ID"];

        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"QT_home_product_detail" sender:self];

    }
    //********************** On select action for collection view Brands ***********************************//

      else if(collectionView == _collection_brands)
    {
        
        @try
        {
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        
            NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
            NSString *user_id;
            @try
            {
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
                
            }
        
        NSString *url_key = [NSString stringWithFormat:@"%@",[[brands_arr objectAtIndex:indexPath.row] valueForKey:@"url_key"]];
         NSString *list_TYPE = @"brandsList";
        NSString *urlkeyval = [NSString stringWithFormat:@"%@/%@/0",list_TYPE,url_key];
       
        [[NSUserDefaults standardUserDefaults] setValue:urlkeyval forKey:@"product_list_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/%@/Customer/1.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [[NSUserDefaults standardUserDefaults] setValue:[[[[brands_arr objectAtIndex:indexPath.row] valueForKey:@"_matchingData"]valueForKey:@"BrandDescriptions"] valueForKey:@"name"] forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
        }
        @catch(NSException *exception)
        {
            
        }
    
    }
    
    //********************** On select action for collection view Brands ***********************************//

    else if(collectionView == _collection_features)
    {
        @try
        {
        NSString *hot_deals_url = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"url"]];
        hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
        hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
        NSString *url_key;
        if([hot_deals_url containsString:@"/"])
        {
            url_key = [NSString stringWithFormat:@"%@",hot_deals_url];
 
        }
        else
        {
            url_key =[NSString stringWithFormat:@"%@/0",hot_deals_url];
        }
        [[NSUserDefaults standardUserDefaults] setValue:[[[json_Response_Dic valueForKey:@"bannerLarge"] objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
            NSString *list_TYPE = @"productList";
            NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
            if([user_id isEqualToString:@"(null)"])
            {
                user_id = @"0";
            }
            url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
        
       
            

        
        [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
        }
        @catch(NSException *Exception)
        {
            
        }

        
    }
    
    //********************** On select action for collection view automatic slide ***********************************//

    else if(collectionView == _collection_images)
    {
        @try
        {
//        if(indexPath.row == image_Top_ARR.count - 1)
//        {
//            [self movies_ACTIOn];
//        }
//        else
//        {
        NSString *hot_deals_url = [NSString stringWithFormat:@"%@",[[image_Top_ARR objectAtIndex:indexPath.row] valueForKey:@"url"]];
        hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
        hot_deals_url = [hot_deals_url stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
        NSString *url_key;
        if([hot_deals_url containsString:@"/"])
        {
            url_key = [NSString stringWithFormat:@"%@",hot_deals_url];
            
        }
        else
        {
            url_key =[NSString stringWithFormat:@"%@/0",hot_deals_url];
        }
        [[NSUserDefaults standardUserDefaults] setValue:[[image_Top_ARR objectAtIndex:indexPath.row] valueForKey:@"title"]  forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
            NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
            if([user_id isEqualToString:@"(null)"])
            {
                user_id = @"0";
            }
        
        NSString *list_TYPE = @"productList";
            NSString *url_key_val =[[image_Top_ARR objectAtIndex:indexPath.row] valueForKey:@"url"];
            url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
            url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
            [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
            [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
       // }
        }
        @catch(NSException *exception)
        {
            
        }

    }
    
    //********************** On select action  for collection view fashion categorie ***********************************//

    else if(collectionView == _collection_fashion_categirie)
    {
        NSString *fashion_deals_url = [NSString stringWithFormat:@"%@",[[fashion_categirie_arr objectAtIndex:indexPath.row] valueForKey:@"url"]];
        fashion_deals_url = [fashion_deals_url stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
        fashion_deals_url = [fashion_deals_url stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
        NSString *url_key;
        if([fashion_deals_url containsString:@"/"])
        {
            url_key = [NSString stringWithFormat:@"%@",fashion_deals_url];
            
        }
        else
        {
            url_key =[NSString stringWithFormat:@"%@/0",fashion_deals_url];
        }
        [[NSUserDefaults standardUserDefaults] setValue:[[fashion_categirie_arr objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"item_name"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *user_id = [NSString stringWithFormat:@"%@", [[[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"] valueForKey:@"id"]];
        if([user_id isEqualToString:@"(null)"])
        {
            user_id = @"0";
        }
        
        
        NSString *list_TYPE = @"productList";
        url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
        
        
        NSString *url_key_val =[[fashion_categirie_arr objectAtIndex:indexPath.row] valueForKey:@"url"];
        url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"catalog/" withString:@""];
         url_key_val = [url_key_val stringByReplacingOccurrencesOfString:@"discount/" withString:@""];
        [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
        [[NSUserDefaults standardUserDefaults] synchronize];

        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
        
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];

    }
    //********************** On select action for collection view now showing movies ***********************************//

//    else if(collectionView == _collection_showing_movies)
//    {
//        [[NSUserDefaults standardUserDefaults]  setValue:[[[temp_dicts valueForKey:@"movie"] objectAtIndex:indexPath.row] valueForKey:@"_id"]  forKey:@"id"];
//        [[NSUserDefaults standardUserDefaults]  synchronize];
//        
//        [self performSegueWithIdentifier:@"Movies_Booking" sender:self];
//    }
//    
//    //********************** On select action for collection view QTickets ***********************************//
//
//
//    else if(collectionView == _Collection_QT_menu)
//    {
//        NSUserDefaults *user_defafults = [NSUserDefaults standardUserDefaults];
//        
//        if(indexPath.row == 0)
//        {
//            
//            
//            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//            {
//                 [user_defafults setValue:@"LEISURE" forKey:@"header_name"];
//            }else{
//                 [user_defafults setValue:@"MOVIES" forKey:@"header_name"];
//            }
//            
//            
//        }
//        if(indexPath.row == 1)
//        {
//            
//            
//            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//            {
//                [user_defafults setValue:@"SPORTS" forKey:@"header_name"];
//            }else{
//                [user_defafults setValue:@"EVENTS" forKey:@"header_name"];
//            }
//            
//        }
//
//        if(indexPath.row == 2)
//        {
//            
//            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//            {
//               [user_defafults setValue:@"EVENTS" forKey:@"header_name"];
//            }else{
//                [user_defafults setValue:@"SPORTS" forKey:@"header_name"];
//
//            }
//            
//            
//            
//        }
//
//        if(indexPath.row == 3)
//        {
//            
//            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
//            {
//                [user_defafults setValue:@"MOVIES" forKey:@"header_name"];
//            }else{
//                [user_defafults setValue:@"LEISURE" forKey:@"header_name"];
//                
//            }
//            
//        }
//        [user_defafults synchronize];
//        
//        [self performSegueWithIdentifier:@"QTickets_identifier" sender:self];
//        
//
//    
//    }
//
    
}

#pragma mark - Uitableview Data Delgate Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if(tableView == _TBL_menu)
    {
        return 4;
    }
      return 0;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger ceel_count = 0;
    if(tableView == _TBL_menu)
    {
    if(section == 0)
    {
        ceel_count = ARR_category.count;
    }
    if(section == 1)
    {
        ceel_count = 3;
    }
    if(section == 2)
    {
        ceel_count = 1;
    }
    if(section == 3)
    {
        ceel_count = 4;
    }
         return ceel_count;
    }
    
    return ceel_count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

   
    NSInteger index;
    categorie_cell *cell = (categorie_cell *)[tableView dequeueReusableCellWithIdentifier:@"cate_cell"];
    
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        index = 0;
    }
    else{
        index =1;
    }
    
    // Menu table
    CGRect frameset =  cell.VW_line1.frame;
    frameset.size.height = 0.5;
    cell.VW_line1.frame = frameset;
    if(tableView == _TBL_menu)
    {

        if (cell == nil)
        {
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"categorie_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
        }
        CGRect frameset = cell.frame;
        frameset.size.width = _TBL_menu.frame.size.width;
        cell.frame = frameset;
        
        //********************** Set the Data for menu categories  ***********************************//

        
        if(indexPath.section == 0)
        {
            cell.LBL_arrow.hidden = NO;
            
            
            NSString *Title= [ARR_category objectAtIndex:indexPath.row] ;
            
            cell.LBL_name.text = [Title uppercaseString];
            [cell.LBL_arrow addTarget:self action:@selector(sub_category_action:) forControlEvents:UIControlEventTouchUpInside];
            cell.LBL_arrow.tag = indexPath.row;
            
        }
        
        //********************** Set the Data for Account categories  ***********************************//

        if(indexPath.section == 1)
        {

              cell.LBL_arrow.hidden = YES;
            NSArray *ARR_info;
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
               ARR_info = [NSArray arrayWithObjects:@"ملفي",@"عنواني",@"تغيير كلمة المرور", nil];

            }
            else
            {
                ARR_info = [NSArray arrayWithObjects:@"MY PROFILE",@"MY ADDRESS",@"CHANGE PASSWORD", nil];

            }

            cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
        }
        //********************** Set the Data for Language drop down  ***********************************//

        if(indexPath.section == 2)
        {
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                index = 3;
            }
            else{
                index =2;
            }
            
            
            language_cellTableViewCell *cell = (language_cellTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"language_cellTableViewCell"];
            CGRect frameset =  cell.VW_line1.frame;
            frameset.size.height = 0.5;
            cell.VW_line1.frame = frameset;
            
            NSArray *nib;
            nib = [[NSBundle mainBundle] loadNibNamed:@"categorie_cell" owner:self options:nil];
            cell = [nib objectAtIndex:index];
            cell.TXT_lang.text = language_str;
            cell.TXT_lang.delegate= self;
            
            cell.VW_line1.hidden = NO;
            
            _lang_pickers = [[UIPickerView alloc] init];
            _lang_pickers.delegate = self;
            _lang_pickers.dataSource = self;
            UIToolbar* conutry_close = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
            conutry_close.barStyle = UIBarStyleBlackTranslucent;
            [conutry_close sizeToFit];
            
           
            
            UIBarButtonItem *doneBtn = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done_action)];
             [doneBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
            
           UIBarButtonItem *flexibleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
            UIBarButtonItem *cancelBtn = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStylePlain target:self action:@selector(close_action)];
            [cancelBtn setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]} forState:UIControlStateNormal];
        
            
            NSMutableArray *barItems = [NSMutableArray arrayWithObjects:cancelBtn,flexibleItem,doneBtn, nil];
            [conutry_close setItems:barItems animated:YES];

            
            
            
//            UIButton *close=[[UIButton alloc]init];
//            close.frame=CGRectMake(conutry_close.frame.origin.x -20, 0, 100, conutry_close.frame.size.height);
//            [close setTitle:@"Close" forState:UIControlStateNormal];
//            [close addTarget:self action:@selector(close_action) forControlEvents:UIControlEventTouchUpInside];
//            [conutry_close addSubview:close];
            
            UITapGestureRecognizer *tapToSelect = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                  action:@selector(tappedToSelectRow:)];
                tapToSelect.delegate = self;
            tapToSelect.numberOfTapsRequired = 1;
            [_lang_pickers addGestureRecognizer:tapToSelect];

            
//            UIButton *done=[[UIButton alloc]init];
//            done.frame=CGRectMake(conutry_close.frame.size.width - 100, 0, 100, conutry_close.frame.size.height);
//            [done setTitle:@"Done" forState:UIControlStateNormal];
//            [done addTarget:self action:@selector(done_action) forControlEvents:UIControlEventTouchUpInside];
//            [conutry_close addSubview:done];
//
//            done.tag = indexPath.row;
            
            cell.TXT_lang.inputAccessoryView=conutry_close;
            cell.TXT_lang.inputView = _lang_pickers;
            cell.TXT_lang.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"language-name"];
            cell.TXT_lang.tintColor=[UIColor clearColor];
            
            return cell;
            
            
        }
        //********************** Set the Data for cotact us of Dohasooq  ***********************************//

        if(indexPath.section == 3)
        {
            NSArray *ARR_info;
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                NSString *about_us = @"معلومات عنا";
                  NSString *contact_us = @"اتصل بنا";
                NSString *terms =@"الأحكام والشروط";
                NSString *privacy =@"سياسة الخصوصية";
               // NSString *help =@"مكتب الخدمات";
                
                
            ARR_info = [NSArray arrayWithObjects:about_us,contact_us,terms,privacy, nil];

            }
            else{
                ARR_info = [NSArray arrayWithObjects:@"ABOUT US",@"CONTACT US",@"TERMS AND CONDITIONS",@"PRIVACY POLICY",/*@"HELPDESK"*/ nil];

            }

          
            cell.LBL_name.text = [ARR_info objectAtIndex:indexPath.row];
            cell.LBL_arrow.hidden = YES;
            
        }
        return cell;
        
    }
    
    // Evets list Table
    
     return cell;
    
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    TIMER_countdown = [[NSTimer alloc]init];
    best_deals_Timer = [[NSTimer alloc]init];
    
    if(tableView == _TBL_menu)
    {
    
    switch (indexPath.section)
    {

        case 0:
        {
            //********************** Category to Product list  ***********************************//

             [self swipe_left];
            NSString *list_TYPE = @"productList";
            NSDictionary *dict_all = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pho"] mutableCopy];
            NSString *str_id ;
            
            for(int  i=0;i<[[dict_all allValues] count];i++)
            {
                if([[ARR_category objectAtIndex:indexPath.row] isEqualToString:[[dict_all allValues] objectAtIndex:i]])
                {
                    str_id = [NSString stringWithFormat:@"%@",[[dict_all allKeys] objectAtIndex:i]];
                    
                }
            }

            NSString *list_key =[NSString stringWithFormat:@"%@/%@/0",list_TYPE,str_id];
            [[NSUserDefaults standardUserDefaults] setValue:list_key forKey:@"product_list_key"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
            NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
            NSString *user_id;
            @try
            {
                NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
                if(dict.count == 0)
                {
                    user_id = @"0";
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
                user_id = @"0";
                
            }
            
            NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,list_key,country,languge,user_id];
            
            
            [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self didelct_sub_categoies];
            

                  break;
        }
        case 1:
            //********************** Home to My addres  ***********************************//

            if(indexPath.row == 1)
            {
                 [self swipe_left];
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
                    
                }

                NSString *str_status_text;
                if([user_id isEqualToString:@"(null)"])
                {
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        str_status_text = @"يرجى تسجيل الدخول للوصول إلى هذا";
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"تسجيل الدخول" otherButtonTitles:@"إلغاء", nil];
                        alert.tag = 1;
                        [alert show];

                    }
                    else
                    {
                        str_status_text = @"Please login to access this";
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Login" otherButtonTitles:@"Cancel", nil];
                        alert.tag = 1;
                        [alert show];

                    }
                    

                    
                }
                else
                {
                  
                [self performSegueWithIdentifier:@"home_address" sender:self];
                }


                self.Scroll_contents.hidden = NO;
                
            }
            if(indexPath.row == 2)
            {
                //********************** Home to Change Password  ***********************************//

                 [self swipe_left];
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
                    
                }
                NSString *str_status_text;
                if([user_id isEqualToString:@"(null)"])
                {
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        str_status_text = @"يرجى تسجيل الدخول للوصول إلى هذا";
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"تسجيل الدخول" otherButtonTitles:@"إلغاء", nil];
                        alert.tag = 1;
                        [alert show];
                        
                    }
                    else
                    {
                        str_status_text = @"Please login to access this";
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Login" otherButtonTitles:@"Cancel", nil];
                        alert.tag = 1;
                        [alert show];
                        
                    }
                    
                    
                    
                }
                else
                {
                    
                [self performSegueWithIdentifier:@"login_forgot_pwd" sender:self];
               
                }
  
            }

            if(indexPath.row == 0)
            {
                //********************** Home to My Profile  ***********************************//

                 [self swipe_left];
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
                    
                }
                NSString *str_status_text;
                if([user_id isEqualToString:@"(null)"])
                {
                    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
                    {
                        str_status_text = @"يرجى تسجيل الدخول للوصول إلى هذا";
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"تسجيل الدخول" otherButtonTitles:@"إلغاء", nil];
                        alert.tag = 1;
                        [alert show];
                        
                    }
                    else
                    {
                        str_status_text = @"Please login to access this";
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Login" otherButtonTitles:@"Cancel", nil];
                        alert.tag = 1;
                        [alert show];
                        
                    }
                    
                    
                    
                }
                else
                {
                    
                    [Helper_activity animating_images:self];
                    [self performSelector:@selector(load_Profile_VC) withObject:nil afterDelay:0.01];
              
                }
            }
            else{
                NSLog(@"ACCount selected");
            }
            break;
             case 2:
            if(indexPath.row == 0)
            {
                
                
            }
            break;
            
        case 3:
            [self swipe_left];
            
            if(indexPath.row == 0)
            {
                //********************** Home to About us page ***********************************//

                [self performSegueWithIdentifier:@"Home_about_us" sender:self];

            }
            if(indexPath.row == 1)
            {
                //********************** Home to Contact us page ***********************************//

                @try
                {
                [self performSegueWithIdentifier:@"contact_us_segue" sender:self];
                }
                @catch(NSException *exception)
                {
                    NSLog(@"THe Exception from Cotact US segue :%@",exception);
                }
            }
            if(indexPath.row == 2)
            {
                //********************** Home to Terms and conditions page ***********************************//

                [self performSegueWithIdentifier:@"Home_terms" sender:self];
            }
            if(indexPath.row == 3)
            {
                //********************** Home to Privacy and policy page ***********************************//

                [self performSegueWithIdentifier:@"Home_privacy" sender:self];
            }
            break;
        default:
            break;
    }
    }
    
   
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing == NO || !indexPath)
    return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([ARR_category count]))
    return UITableViewCellEditingStyleInsert;
    
    else
    if (self.editing && indexPath.row == ([ARR_category count]))
    return UITableViewCellEditingStyleDelete;
    
    
    return UITableViewCellEditingStyleNone;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle) editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleInsert)
    {
        
    }
    else if(editingStyle == UITableViewCellEditingStyleDelete)
    {
        
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    return tableView.rowHeight;
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(15,0,320,1)];
    
   tempView.backgroundColor = [UIColor whiteColor];
    UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-10,305,0.5)];
    
    
    CGSize result = [[UIScreen mainScreen] bounds].size;
    
    if(result.height <= 480)
    {
        tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,_VW_swipe.frame.size.width - 5,0.3)];
    }
    else if(result.height <= 568)
    {
        tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,_VW_swipe.frame.size.width - 5,0.3)];
    }
    else
    {
        tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,_VW_swipe.frame.size.width - 5,0.3)];
    }
    
    
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        tempLabel.textAlignment = NSTextAlignmentRight;
    }
    tempLabel.backgroundColor = [UIColor lightGrayColor];
    
    
    [tempView addSubview:tempLabel];

    
    return tempView;

}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 1;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    
   return 20;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *tempView=[[UIView alloc]initWithFrame:CGRectMake(0,0,320,0)];
    UILabel *tempLabel;
    
    NSString *str;
    if(tableView == _TBL_menu)
    {
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height <= 480)
        {
             tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,220,30)];
        }
        else if(result.height <= 568)
        {
             tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,220,30)];
        }
        else
        {
            tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,0,275,30)];
        }
        

        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            tempLabel.textAlignment = NSTextAlignmentRight;
        }
        
        
        tempLabel.textColor = [UIColor lightGrayColor]; //here you can change the text color of header.
        tempLabel.font = [UIFont fontWithName:@"Poppins-Regular" size:12];
        
       
        
        if(section == 0)
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                
                str =@"جميع الفئات";
            }
            else{

            str =@"ALL CATEGORIES";
            }
        }
        if(section == 1)
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
            str = @"معلومات الحساب";
            }
            else{
                str = @"ACCOUNT INFO";
            }
            
        }
        
        if(section == 2)
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
            str = @"اللغة";
            }
            else{
                 str = @"LANGUAGE";
            }
        }
        if(section == 3)
        {
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
            str = @"روابط سريعة";
            }
            else{
                str = @"QUICK LINKS";
            }
        }
        tempLabel.text =str;
        tempLabel.backgroundColor = [UIColor whiteColor];
        [tempView addSubview:tempLabel];
        return tempView; 
    }
    else
    {
        UILabel *tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-10,305,40)];
        
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height <= 480)
        {
            tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,220,30)];
        }
        else if(result.height <= 568)
        {
            tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,220,30)];
        }
        else
        {
            tempLabel=[[UILabel alloc]initWithFrame:CGRectMake(15,-7,275,30)];
        }
        
        
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            tempLabel.textAlignment = NSTextAlignmentRight;
        }
        
        tempLabel.textColor = [UIColor grayColor]; //here you can change the text color of header.
        tempLabel.font = [UIFont fontWithName:@"Poppins-Regular" size:15];
        [tempView addSubview:tempLabel];
        return tempView;
        
    }
}

#pragma load the profile view contoller

-(void) load_Profile_VC
{
    [self performSegueWithIdentifier:@"edot_profile_VC" sender:self];
    [Helper_activity stop_activity_animation:self];
}

#pragma mark - custm methods

-(void)sub_category_action:(UIButton *)sender
{
    NSDictionary *dict_all = [[[NSUserDefaults standardUserDefaults] valueForKey:@"pho"] mutableCopy];
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *name = [ARR_category objectAtIndex:sender.tag];
    NSString *str_id ;//= [NSString stringWithFormat:@"%@",[[ARR_category objectAtIndex:sender.tag] valueForKey:@"name"]];

    for(int  i=0;i<[[dict_all allValues] count];i++)
    {
       if([name isEqualToString:[[dict_all allValues] objectAtIndex:i]])
       {
           str_id = [NSString stringWithFormat:@"%@",[[dict_all allKeys] objectAtIndex:i]];

       }
    }
    
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/getChildCat/%@/%@/%@/Customer.json",SERVER_URL,str_id,country,languge];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_sub_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self swipe_left];
    [self performSegueWithIdentifier:@"qt_home_sub_brands" sender:self];
    
    
    
}
- (IBAction)tappedToSelectRow:(UITapGestureRecognizer *)tapRecognizer
{
  if (tapRecognizer.state == UIGestureRecognizerStateEnded)
  {
   CGFloat rowHeight = [_lang_pickers rowSizeForComponent:0].height;
   CGRect selectedRowFrame = CGRectInset(_lang_pickers.bounds, 0.0, (CGRectGetHeight(_lang_pickers.frame) - rowHeight) / 2.0 );
  BOOL userTappedOnSelectedRow = (CGRectContainsPoint(selectedRowFrame, [tapRecognizer locationInView:_lang_pickers]));
  if (userTappedOnSelectedRow) {
  NSInteger selectedRow = [_lang_pickers selectedRowInComponent:0];
  [self pickerView:_lang_pickers didSelectRow:selectedRow inComponent:0];

   }
    
 }
     [self done_action];
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
     return true;
}


#pragma mark menu category to product list

-(void)didelct_sub_categoies
{
     [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];
    
    
}


#pragma mark - Uiscroll detect for movies and featured offers

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    @try {
        
        
        NSString *cellIdentifier;
        for (UICollectionViewCell *cell in [scrollView subviews])
        {
            cellIdentifier = [cell reuseIdentifier];
        }
        if ([cellIdentifier isEqualToString:@"collection_image"]) {
            float pageWidth = _collection_images.frame.size.width; // width + space
            
            float currentOffset = _collection_images.contentOffset.x;
            float targetOffset = targetContentOffset->x;
            float newTargetOffset = 1;
            
            if (targetOffset > currentOffset)
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
            else
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
            
            if (newTargetOffset < 0)
                newTargetOffset = 0;
            else if (newTargetOffset > _collection_images.contentSize.width)
                newTargetOffset = _collection_images.contentSize.width;
            
            targetContentOffset->x = currentOffset;
            [_collection_images setContentOffset:CGPointMake(newTargetOffset  , _collection_images.contentOffset.y) animated:YES];
            CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_images.contentOffset.y);
            NSIndexPath *visibleIndexPath = [self.collection_images indexPathForItemAtPoint:visiblePoint];
            
            
            
            self.custom_story_page_controller.currentPage = visibleIndexPath.row;
            mn = (int)self.custom_story_page_controller.currentPage;
            
        }
        else if([cellIdentifier isEqualToString:@"showing_movies_cell"])
        {
            float pageWidth = _collection_showing_movies.frame.size.width; // width + space
            
            float currentOffset = _collection_showing_movies.contentOffset.x;
            float targetOffset = targetContentOffset->x;
            float newTargetOffset = 1;
            
            if (targetOffset > currentOffset)
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
            else
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
            
            if (newTargetOffset < 0)
                newTargetOffset = 0;
            else if (newTargetOffset > _collection_showing_movies.contentSize.width)
                newTargetOffset = _collection_showing_movies.contentSize.width;
            
            targetContentOffset->x = currentOffset;
            [_collection_showing_movies setContentOffset:CGPointMake(newTargetOffset  , _collection_showing_movies.contentOffset.y) animated:YES];
            
            CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_showing_movies.contentOffset.y);
            NSIndexPath *visibleIndexPath = [_collection_showing_movies indexPathForItemAtPoint:visiblePoint];
            
            INDX_selected = visibleIndexPath;
            self.page_controller_movies.currentPage = visibleIndexPath.row;
            
        }

        else if([cellIdentifier isEqualToString:@"features_cell"])
        {
            float pageWidth = _collection_features.frame.size.width; // width + space
            
            float currentOffset = _collection_features.contentOffset.x;
            float targetOffset = targetContentOffset->x;
            float newTargetOffset = 1;
            
            if (targetOffset > currentOffset)
                newTargetOffset = ceilf(currentOffset / pageWidth) * pageWidth;
            else
                newTargetOffset = floorf(currentOffset / pageWidth) * pageWidth;
            
            if (newTargetOffset < 0)
                newTargetOffset = 0;
            else if (newTargetOffset > _collection_features.contentSize.width)
                newTargetOffset = _collection_features.contentSize.width;
            
            targetContentOffset->x = currentOffset;
            [_collection_features setContentOffset:CGPointMake(newTargetOffset  , _collection_features.contentOffset.y) animated:YES];
            
            CGPoint visiblePoint = CGPointMake(newTargetOffset, _collection_features.contentOffset.y);
            NSIndexPath *visibleIndexPath = [_collection_features indexPathForItemAtPoint:visiblePoint];
            
            INDX_selected = visibleIndexPath;
            //self.custom_story_page_controller.currentPage = visibleIndexPath.row;
            
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception);
        
    }
}
#pragma Buton Wish list Action

-(void)_BTN_wishlist_action
{
    [self swipe_left];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id;
    @try
    {
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
        
    }
    NSString *str_status_text;
    if([user_id isEqualToString:@"(null)"])
    {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str_status_text = @"يرجى تسجيل الدخول للوصول إلى هذا";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"تسجيل الدخول" otherButtonTitles:@"إلغاء", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            str_status_text = @"Please login to access this";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Login" otherButtonTitles:@"Cancel", nil];
            alert.tag = 1;
            [alert show];
            
        }
        
        
        
    }
   else
    {

        [self performSegueWithIdentifier:@"HomeQ_to_wishList" sender:self];

        
    }
    }

#pragma Wish list to cart page

- (IBAction)QTickets_Home_to_CartPage:(id)sender {
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id;
    @try
    {
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
        
    }
    NSString *str_status_text;
    if([user_id isEqualToString:@"(null)"])
    {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str_status_text = @"يرجى تسجيل الدخول للوصول إلى هذا";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"تسجيل الدخول" otherButtonTitles:@"إلغاء", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            str_status_text = @"Please login to access this";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Login" otherButtonTitles:@"Cancel", nil];
            alert.tag = 1;
            [alert show];
            
        }
        
        
        
    }
    else
    {
        
        [self performSegueWithIdentifier:@"homeQtkt_to_cart" sender:self];
        
        
    }
}

#pragma Movies Right scroll button action

-(void)BTN_movies_right_action
{
    @try
    {
    NSIndexPath *newIndexPath;
    if (!INDX_selected)
    {
        newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        INDX_selected = newIndexPath;
    }
    else if ([[temp_dicts valueForKey:@"movie"] count]  > INDX_selected.row)
    {
        if ([[temp_dicts valueForKey:@"movie"] count] == INDX_selected.row + 1) {
            newIndexPath = [NSIndexPath indexPathForRow:[[temp_dicts valueForKey:@"movie"] count] - 1 inSection:0];
            INDX_selected = newIndexPath;
        }
        else
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row + 1 inSection:0];
            INDX_selected = newIndexPath;
        }
    }
    
    
    if (!newIndexPath) {
        newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        INDX_selected = newIndexPath;
    }
    
    
    [_collection_showing_movies scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    _page_controller_movies.currentPage = INDX_selected.row;
    }
    @catch(NSException *exception)
    {
        
    }

}
#pragma Movies Left scroll button action


-(void)BTN_movies_left_action
{
    @try
    {
        NSIndexPath *newIndexPath;
        if (INDX_selected)
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row -1 inSection:0];
            INDX_selected = newIndexPath;
        }
        
        else if ([[temp_dicts valueForKey:@"movie"] count]  < INDX_selected.row)
        {
            if ([[temp_dicts valueForKey:@"movie"] count] == INDX_selected.row - 1)
            {
                newIndexPath = [NSIndexPath indexPathForRow:[[temp_dicts valueForKey:@"movie"] count] + 1 inSection:0];
                INDX_selected = newIndexPath;
            }
            else
            {
                newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row - 1 inSection:0];
                INDX_selected = newIndexPath;
            }
        }
        if (newIndexPath.row == 1)
        {
            newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            INDX_selected = newIndexPath;
        }
        if(newIndexPath.row < 1)
        {
            newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            INDX_selected = newIndexPath;
        }
        
        [_collection_showing_movies scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        _page_controller_movies.currentPage = INDX_selected.row;
    }
    
    
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception);
    }
    
}

#pragma Featured Offers Right scroll button action


-(void)BTN_right_action
{
  @try
    {
    NSIndexPath *newIndexPath;
    if (!INDX_selected)
    {
        newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        INDX_selected = newIndexPath;
    }
    
    else if ([[json_Response_Dic valueForKey:@"bannerLarge"]count]  > INDX_selected.row)
    {
        if ([[json_Response_Dic valueForKey:@"bannerLarge"]count] == INDX_selected.row + 1) {
            newIndexPath = [NSIndexPath indexPathForRow:[[json_Response_Dic valueForKey:@"bannerLarge"]count] - 1 inSection:0];
            INDX_selected = newIndexPath;
        }
        else
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row + 1 inSection:0];
            INDX_selected = newIndexPath;
        }
    }
    
    
    if (!newIndexPath) {
        newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        INDX_selected = newIndexPath;
    }
    
    
    [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    @catch(NSException *exception)
    {
        
    }
}
#pragma Featured offers left scroll button action


-(void)BTN_left_action
{
    @try
    {
        NSIndexPath *newIndexPath;
        if (INDX_selected)
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row -1 inSection:0];
            INDX_selected = newIndexPath;
        }
        
        else if ([[json_Response_Dic valueForKey:@"bannerLarge"]count]  < INDX_selected.row)
        {
            if ([[json_Response_Dic valueForKey:@"bannerLarge"]count] == INDX_selected.row - 1)
            {
                newIndexPath = [NSIndexPath indexPathForRow:[[json_Response_Dic valueForKey:@"bannerLarge"]count] + 1 inSection:0];
                INDX_selected = newIndexPath;
            }
            else
            {
                newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row - 1 inSection:0];
                INDX_selected = newIndexPath;
            }
        }
        if (newIndexPath.row == 1)
        {
            newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
            INDX_selected = newIndexPath;
        }
        if(newIndexPath.row < 1)
        {
            newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            INDX_selected = newIndexPath;
        }
        [_collection_features scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    
    
    @catch (NSException *exception)
    {
        NSLog(@"exception:%@",exception);
    }
    
}


#pragma Go To QTickets

-(void)movies_ACTIOn
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"header_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self performSegueWithIdentifier:@"QTickets_identifier" sender:self];
    
}
#pragma Menu Button Action

-(void)MENU_action
{
    
    _overlayView.hidden = NO;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDuration:-5];
    
    CGFloat new_X = 0;
    if (_VW_swipe.frame.origin.x == self.view.frame.origin.x)
    {
        new_X = _VW_swipe.frame.origin.x;
    }
    else
    {
        new_X = _VW_swipe.frame.origin.x - _menuDraw_width;
        
    }
    
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        _VW_swipe.frame = CGRectMake(self.view.frame.size.width-_VW_swipe.frame.size.width, _overlayView.frame.origin.y-20, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        
        
    }
    else{
        _VW_swipe.frame = CGRectMake(0, _overlayView.frame.origin.y - 20, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
    }
    
    
    [UIView commitAnimations];
    
    
    
}
#pragma Swipe left Action

- (void) SwipeLeft:(UISwipeGestureRecognizer *)sender
{
    
    [self swipe_left];
    
}
-(void)swipe_left
{
    
    if ( UISwipeGestureRecognizerDirectionLeft )
    {
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:-5];
        
        // int statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
        statusbar_HEIGHT = [UIApplication sharedApplication].statusBarFrame.size.height;
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            _VW_swipe.frame = CGRectMake(self.view.frame.size.width-_VW_swipe.frame.size.width, _overlayView.frame.origin.y-20, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        }
        else{
            _VW_swipe.frame = CGRectMake(0, _overlayView.frame.origin.y-20, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        }
        
        
        [UIView commitAnimations];
        
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:-5];
        _overlayView.hidden = YES;
        [UIView commitAnimations];
        
    }
    
}
#pragma Swipe Right Action


-(void)SwipeRight:(UISwipeGestureRecognizer *)sender
{
    if ( sender.direction | UISwipeGestureRecognizerDirectionRight )
    {
        _overlayView.hidden = NO;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDelegate:self];
        [UIView setAnimationDuration:-5];
        
        CGFloat new_X = 0;
        if (_VW_swipe.frame.origin.x == self.view.frame.origin.x)
        {
            new_X = _VW_swipe.frame.origin.x;
        }
        else
        {
            new_X = _VW_swipe.frame.origin.x - _menuDraw_width;
            
        }
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            _VW_swipe.frame = CGRectMake(self.view.frame.size.width-_VW_swipe.frame.size.width,_overlayView.frame.origin.y, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        }else{
            
            _VW_swipe.frame = CGRectMake(0, _overlayView.frame.origin.y - 20, _menuDraw_width, self.navigationController.view.frame.size.height-statusbar_HEIGHT);
        }
        
        
        
        
        [UIView commitAnimations];
        
    }
    
}

#pragma Movie call
-(void)movie_API_CALL
{
    @try
    {
        
      
        
        
        NSURL *URL = [[NSURL alloc] initWithString:@"https://api.q-tickets.com/V2.0/GetMoviesbyLangAndTheatreid"];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        //NSLog(@"Response dictionary: %@", xmlDoc);
        
        temp_dicts = [xmlDoc valueForKey:@"Movies"];
        NSMutableArray *tmp_arr = [temp_dicts valueForKey:@"movie"];
        
        
        
        //NSLog(@"Response dictionary: %@", tmp_arr);
        NSArray *old_arr = tmp_arr;//[json_RESULT mutableCopy];
        
        
        
        NSMutableArray *new_arr = [[NSMutableArray alloc]init];
        
        int count = (int)[old_arr count];
        int index = 0;
        
        int tags = 0;
        
        for (int i = 0; i < count; )
        {
            i= i+1;
            if ((i % 5) == 0 && i != 0)
            {
                NSDictionary *tmp_dictin = [NSDictionary dictionaryWithObjectsAndKeys:@"Qtickets",@"Movies", nil];
                [new_arr addObject:tmp_dictin];
                count = count + 1;
                tags = tags + 1;
            }
            else
            {
                index = i - tags - 1;
                [new_arr addObject:[old_arr objectAtIndex:index]];
            }
        }
        [Helper_activity stop_activity_animation:self];
        
        [Movies_arr removeAllObjects];
        Movies_arr = [new_arr mutableCopy];
        [_Collection_movies reloadData];
        [_collection_showing_movies reloadData];
        
        NSLog(@"Mouvie arr count %lu",(unsigned long)Movies_arr.count);
    }
    @catch(NSException *exception)
    {
        NSLog(@"Exception%@",exception);
    }
    
   
}

#pragma calling the QTickets movie API Call

-(void)API_movie
{
    
   // [self performSelector:@selector(movie_API_CALL) withObject:nil afterDelay:0.01];
    
}
#pragma ShopHome_api_integration Method Calling
-(void)API_CALL_FETCH
{
    
    TIMER_countdown = [[NSTimer alloc]init];
     best_deals_Timer = [[NSTimer alloc]init];

    @try
    {
    fashion_categirie_arr = [[NSMutableArray alloc]init];
    json_Response_Dic = [[NSMutableDictionary alloc]init];
    json_Response_Dic = [[NSUserDefaults standardUserDefaults] valueForKey:@"Home_data"];
    image_Top_ARR = [[NSMutableArray alloc]init];
    deals_ARR = [[NSMutableArray alloc]init];
    hot_deals_ARR = [[NSMutableArray alloc]init];
    brands_arr = [[NSMutableArray alloc]init];
    
    @try
    {
        
        [self movie_API_CALL];
    }
    @catch(NSException *exception)
    {
    }
    
        NSString *str = @"Women's";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str = @"للنساء "; 
            
        }
        NSString *str_deals =[NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"two"]  valueForKey:@"widgetTitle"]];
        _LBL_best_selling.text = str_deals;
        
        
        _Hot_deals_banner.text = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"]  valueForKey:@"widgetTitle"]];
        _Hot_deals.text = [NSString stringWithFormat:@"%@ %@",str,[json_Response_Dic valueForKey:@"fashion_name"]];// Banner Fashion Title Setting
    
        
    NSLog(@"API Call Fetch%@",json_Response_Dic);
        [[NSUserDefaults standardUserDefaults] setValue:[json_Response_Dic valueForKey:@"default_time_zone"] forKey:@"time_zone"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    for(int  i= 0; i<[[json_Response_Dic valueForKey:@"banners"]count];i++)
    {
        [image_Top_ARR addObject:[[json_Response_Dic valueForKey:@"banners"]objectAtIndex:i]];
    }
    
   // [image_Top_ARR addObject:@"banner_main.png"];
    [fashion_categirie_arr addObjectsFromArray:[json_Response_Dic valueForKey:@"bannerFashion"]];
        
     if([[json_Response_Dic valueForKey:@"dealSection"] count] < 1)
     {
         NSString *currency = [json_Response_Dic valueForKey:@"currency"];
         currency = [currency stringByReplacingOccurrencesOfString:@"(null)" withString:@"QAR"];
         currency = [currency stringByReplacingOccurrencesOfString:@"<null>" withString:@"QAR"];
         currency = [currency stringByReplacingOccurrencesOfString:@"" withString:@"QAR"];

         brands_arr = [json_Response_Dic valueForKey:@"brands_female"];
         [[NSUserDefaults standardUserDefaults] setValue:currency forKey:@"currency"];
         [[NSUserDefaults standardUserDefaults] synchronize];
         [_collection_images reloadData];
         [self set_timer_to_collection_images];
         [_collection_features reloadData];
         
         [_collection_brands reloadData];
         [self menu_set_UP];
         // [self cart_count]
         self.Scroll_contents.hidden = NO;
         
         
         [self set_up_VIEW];
           [_collection_fashion_categirie reloadData];
         [Helper_activity stop_activity_animation:self];

     }
    else
    {
        
        
        
        @try {
            
       
    for(int i=0 ; i < [[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"two"] allKeys] count];i++)
    {
        NSLog(@"The keys are %@",[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"two"] allKeys]);
            NSString *str_key = [NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"two"] allKeys] objectAtIndex:i]];
        if([[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"two"] valueForKey:str_key]  isKindOfClass:[NSDictionary class]])
        {
            
                  [deals_ARR addObject:[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"two"] valueForKey:str_key]];
        }
        
        
         } // for loop Close
        } @catch (NSException *exception) {
            NSLog(@"Exception in TWO Deal %@",exception);
        }
        
    // ********** Deal One *************
        
        @try {
            
      
        
    for(int i=0 ; i < [[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"] allKeys] count];i++)
    {
          NSString *str_key = [NSString stringWithFormat:@"%@",[[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"] allKeys] objectAtIndex:i]];
        
        if([[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"]valueForKey:str_key]  isKindOfClass:[NSDictionary class]])
        {
          

            [hot_deals_ARR addObject:[[[json_Response_Dic valueForKey:@"dealSection"] valueForKey:@"one"] valueForKey:str_key]];
        }

        
        
          }
        } @catch (NSException *exception) {
            NSLog(@"Exception in ONE Deal %@",exception);
        }
    // ********** Brands *************//
        
    brands_arr = [json_Response_Dic valueForKey:@"brands_female"];
    
       
    @try
        {
    for(int i = 0;i<hot_deals_ARR.count;i++)
    {
        
        NSString *time_diff = [NSString stringWithFormat:@"%@",[[hot_deals_ARR objectAtIndex:i] valueForKey:@"timeDiff"]];
        if([time_diff isEqualToString:@"No"] ||[time_diff isEqualToString:@"(null)"] ||[time_diff isEqualToString:@"<null>"]||!time_diff)
        {
            
        }
        else{
            NSDictionary *dict =@{@"tag":[NSString stringWithFormat:@"%d",i]}; //                            [dict setObject:[[hot_deals_ARR objectAtIndex:i] valueForKey:@"end_date"] forKey:@"timer"];
            TIMER_countdown = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(runUpdateDisplayLoop:)userInfo:dict repeats:YES];
        }
    
        

        }
        }
        @catch(NSException *exception)
        {
            
        }
        @try
        {
        for(int i = 0;i<deals_ARR.count;i++)
        {
            
            NSString *time_diff = [NSString stringWithFormat:@"%@",[[deals_ARR objectAtIndex:i] valueForKey:@"timeDiff"]];
            if([time_diff isEqualToString:@"No"] ||[time_diff isEqualToString:@"(null)"] ||[time_diff isEqualToString:@"<null>"]||!time_diff)
            {
                
            }
            else{
                NSDictionary *dict =@{@"tag":[NSString stringWithFormat:@"%d",i]}; //                            [dict setObject:[[hot_deals_ARR objectAtIndex:i] valueForKey:@"end_date"] forKey:@"timer"];
                TIMER_countdown = [NSTimer scheduledTimerWithTimeInterval:0.5 target:self selector:@selector(runUpdateDisplayLoop_best:)userInfo:dict repeats:YES];
            }
            
            
            
        }
        }
        @catch(NSException *exception)
        {
            
        }

    NSString *currency = [json_Response_Dic valueForKey:@"currency"];
    currency = [currency stringByReplacingOccurrencesOfString:@"(null)" withString:@"QAR"];
    currency = [currency stringByReplacingOccurrencesOfString:@"<null>" withString:@"QAR"];
    currency = [currency stringByReplacingOccurrencesOfString:@"" withString:@"QAR"];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:currency forKey:@"currency"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [_collection_images reloadData];
    [self set_timer_to_collection_images];
    [_collection_features reloadData];
    [_collection_hot_deals reloadData];
    [_collection_best_deals reloadData];
    [_collection_fashion_categirie reloadData];
    [_collection_brands reloadData];
    [self menu_set_UP];
   // [self cart_count]
    self.Scroll_contents.hidden = NO;
  

    [self set_up_VIEW];
    [Helper_activity stop_activity_animation:self];
    }
    }
    @catch(NSException *exception)
    {
        [Helper_activity stop_activity_animation:self];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];

        
    }

}
#pragma Total Home API call

-(void)API_call_total
{
    
    @try
    {
          [Helper_activity animating_images:self];
        
        /**********   After passing Language Id and Country ID ************/
        NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
        
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
            
        }
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/home/%ld/%ld/%@/Customer.json",SERVER_URL,(long)[user_defaults   integerForKey:@"country_id"],(long)[user_defaults integerForKey:@"language_id"],user_id];
       // NSLog(@"country id %ld ,language id %ld",[user_defaults integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]);
        
        
        
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                    
                }
                if (data) {
                    
                   
                    [Helper_activity stop_activity_animation:self];
                    @try
                    {
                    [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Home_data"];
                    [[NSUserDefaults standardUserDefaults] synchronize];
                        
                        if([language isEqualToString:@"Arabic"])
                        {
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Arabic" bundle:nil];
                            
                            Home_page_Qtickets *controller = [storyboard instantiateViewControllerWithIdentifier:@"Home_page_Qtickets"];
                            
                            
                            UINavigationController *navigationController =
                            [[UINavigationController alloc] initWithRootViewController:controller];
                            navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
                            navigationController.navigationBar.barTintColor = [UIColor whiteColor];
                            [self  presentViewController:navigationController animated:NO completion:nil];
                          
                            [_TBL_menu reloadData];
                            
                        }
                        else{
                            
                            
                            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
                            
                            Home_page_Qtickets *controller = [storyboard instantiateViewControllerWithIdentifier:@"QT_controller"];
                            UINavigationController *navigationController =
                            [[UINavigationController alloc] initWithRootViewController:controller];
                            navigationController.navigationBar.backgroundColor = [UIColor whiteColor];
                            navigationController.navigationBar.barTintColor = [UIColor whiteColor];
                            [self  presentViewController:navigationController animated:NO completion:nil];
                            [_TBL_menu reloadData];
                            
                            
                            
                            
                        }
     
                        [self language_switch_API];
                        
                        
                    [self view_appear];
                    }
                    @catch(NSException *exception)
                    {
                        
                    }
                    
                    
                }
                else
                {
                     [Helper_activity stop_activity_animation:self];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                    [alert show];
                    
                    
                    
                    
                }
                
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
        [Helper_activity stop_activity_animation:self];
        
    }
    
    
    
}
#pragma Log out Action

-(void)BTN_log_outs
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userdata"];
    [[NSUserDefaults standardUserDefaults] synchronize];
     if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
     {
         if([_BTN_log_out.titleLabel.text isEqualToString:@"تسجيل الدخول"])
         {
             [self swipe_left];
             ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
             [self presentViewController:login animated:NO completion:nil];
             
             
         }
         else
         {
             [self swipe_left];
             [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userdata"];
             [[NSUserDefaults standardUserDefaults] synchronize];
             NSString *str_status_text;
             
             str_status_text = @"شكراً، نراكم قريباً";
             
             UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"حسنا" otherButtonTitles:nil, nil];
             
             [alert show];
           
             
             [self cart_count];
             
             
             json_Response_Dic = [[NSMutableDictionary alloc]init];
            [self performSelector:@selector(API_call_total) withObject:nil afterDelay:0.01];
             
         }

     }
     else
     {
    
      if([_BTN_log_out.titleLabel.text isEqualToString:@"LOGIN"])
    {
        [self swipe_left];
        ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
        [self presentViewController:login animated:NO completion:nil];

        
    }
    else
    {
         [self swipe_left];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userdata"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        NSString *str_status_text;
        UIAlertView *alert;
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
             str_status_text = @"شكراً، نراكم قريباً";
             alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"حسنا" otherButtonTitles:nil, nil];
        }
        else
        {
            str_status_text = @"Thank you! See you soon!";
             alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        }
        
       
        
        [alert show];
        
        [self cart_count];

        json_Response_Dic = [[NSMutableDictionary alloc]init];
         [self performSelector:@selector(API_call_total) withObject:nil afterDelay:0.01];

    }
     }
}
#pragma mark - UIPickerViewDataSource Delegate Methods


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    if(pickerView == _lang_pickers)
    {
        return 1;
    }


    return 0;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
   
        NSLog(@"The language is:%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]);
        return [[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]count];
    

    return 0;
}

#pragma mark - UIPickerViewDelegate

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
       if(pickerView == _lang_pickers)
    {
      

        return [[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:row ] valueForKey:@"language_name_localized"];
    }


    
    return nil;
}


-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    
    
          isPickerViewScrolled = YES;
    
        language = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:row] valueForKey:@"language_name"];
    
        language_str = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:row] valueForKey:@"language_name_localized"];
   
    id_language = [NSString stringWithFormat:@"%@",[[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:row] valueForKey:@"id"]];
    
    language_code = [NSString stringWithFormat:@"%@",[[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:row] valueForKey:@"language_code"]];
    

}
#pragma mark PickerViewAccessory Done Button ACtion
-(void)done_action
{
    
    if (!isPickerViewScrolled) {
        
        
        @try {
            
             language_code = [NSString stringWithFormat:@"%@",[[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:0] valueForKey:@"language_code"]];
            
            language = [[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:0] valueForKey:@"language_name"];
            [[NSUserDefaults standardUserDefaults]setValue:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:0] valueForKey:@"id"] forKey:@"language_id"];
             [[NSUserDefaults standardUserDefaults]setValue:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:0] valueForKey:@"language_code"] forKey:@"code_language"];
            
            
//             [[NSUserDefaults standardUserDefaults] setObject:[[lang_arr objectAtIndex:j] valueForKey:@"language_code"] forKey:@"code_language"];
            
            
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
        } @catch (NSException *exception) {
            NSLog(@"Language Selection Exception ::%@",exception);
        }
        
    }
    else{
        //                [[NSUserDefaults standardUserDefaults]setValue:[[[[NSUserDefaults standardUserDefaults] valueForKey:@"language_arr"]objectAtIndex:row] valueForKey:@"id"] forKey:@"language_id"];
        //                [[NSUserDefaults standardUserDefaults]synchronize];
        [[NSUserDefaults  standardUserDefaults] setValue:id_language forKey:@"language_id"];
        [[NSUserDefaults standardUserDefaults]setValue:language_code forKey:@"code_language"];
    }
    
    
    
    
    [_TBL_menu reloadData];
    
    
    if ([language isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"]])
    {
        
    }
    else{
        
        // For Arabic
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"story_board_language"];
        [[NSUserDefaults  standardUserDefaults] setValue:language forKey:@"story_board_language"];
        
        
        // Displaying text in TableView Language TextField....
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"language-name"];
        [[NSUserDefaults  standardUserDefaults] setValue:language forKey:@"language-name"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        [self API_call_total];
        
        [self menu_set_UP];
    }
    
}

#pragma mark PickerViewAccessory close Button ACtion

-(void)close_action
{
    [_TBL_menu reloadData];
    [self.view endEditing:YES];
    BOOL animationsEnabled = [UIView areAnimationsEnabled];
    [UIView setAnimationsEnabled:NO];
    [UIView setAnimationsEnabled:animationsEnabled];
}

#pragma Button Bookings action

-(void)btn_address_action
{
    [self swipe_left];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id;
    @try
    {
        if(dict.count == 0)
        {
            user_id = @"(null)";
        }
        else
        {
            NSString *str_id = @"user_id";
           
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
        
    }
    NSString *str_status_text;
    if([user_id isEqualToString:@"(null)"])
    {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str_status_text = @"يرجى تسجيل الدخول للوصول إلى هذا";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"تسجيل الدخول" otherButtonTitles:@"إلغاء", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            str_status_text = @"Please login to access this";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Login" otherButtonTitles:@"Cancel", nil];
            alert.tag = 1;
            [alert show];
            
        }
        
        
        
    }
  else
    {
        [Helper_activity animating_images:self];
        [self performSelector:@selector(load_Profile_VC) withObject:nil afterDelay:0.01];

       // home_bookings
        //[self performSegueWithIdentifier:@"home_bookings" sender:self];

    }
}
#pragma Button Orders action


-(void)btn_orders_action
{
    [self swipe_left];
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id;
    @try
    {
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
        
    }
    NSString *str_status_text;
    if([user_id isEqualToString:@"(null)"])
    {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str_status_text = @"يرجى تسجيل الدخول للوصول إلى هذا";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"تسجيل الدخول" otherButtonTitles:@"إلغاء", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            str_status_text = @"Please login to access this";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Login" otherButtonTitles:@"Cancel", nil];
            alert.tag = 1;
            [alert show];
            
        }
        
        
        
    }
   else
    {

    [self performSegueWithIdentifier:@"my_orders" sender:self];
    }
}

#pragma mark Add_to_wishList_API Calling

-(void)hot_dels_wishlist:(UIButton *)sender
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id;
    @try
    {
       if(dict.count == 0)
    {
        user_id = @"(null)";
    }
    else
    {
        NSString *str_id = @"user_id";
       
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
    
}
NSString *str_status_text;
    if([user_id isEqualToString:@"(null)"])
    {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str_status_text = @"يرجى تسجيل الدخول للوصول إلى هذا";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"تسجيل الدخول" otherButtonTitles:@"إلغاء", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            str_status_text = @"Please login to access this";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Login" otherButtonTitles:@"Cancel", nil];
            alert.tag = 1;
            [alert show];
            
        }
        
        
        
    }
    else
    {
      
    NSString *urlGetuser;
    @try
    {
        
        
        urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[hot_deals_ARR objectAtIndex:sender.tag] valueForKey:@"product_id"],user_id];
    }
    @catch(NSException *exception)
    {
        
    }
   
    @try
    {
       
        [Helper_activity animating_images:self];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    
                    [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
                }
                if (data) {
                   NSDictionary  *json_Response = data;
                    if(json_Response)
                    {
                        
                        [Helper_activity stop_activity_animation:self];
                        
                        
                        NSLog(@"The Wishlist %@",json_Response);
                        NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                        product_cell *cell = (product_cell *)[self.collection_hot_deals cellForItemAtIndexPath:index];
                        
                        
                        @try {
                           
                            if ([[NSString stringWithFormat:@"%@",[json_Response valueForKey:@"msg"]] isEqualToString:@"Added to your Wishlist"]) {
                                
                                
//                            if ([[json_Response valueForKey:@"status"] isEqualToString:@"Added to your Wishlist"])
//                            {
                                
                                
                                [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                                [cell.BTN_fav setTitleColor: [UIColor redColor] forState:UIControlStateNormal];
                                [HttpClient createaAlertWithMsg:[json_Response valueForKey:@"multi_msg"] andTitle:@""];
                                
                                
                            }
                            else
                            {
                                if ([[json_Response valueForKey:@"msg"] isEqualToString:@"Customer wishlist already saved"] || [[json_Response valueForKey:@"msg"] isEqualToString:@"تم حفظ قائمة رغبات العميل"])
                                
                                {
                                    NSString *str_id = [NSString stringWithFormat:@"%@",[[hot_deals_ARR objectAtIndex:sender.tag] valueForKey:@"product_id"]];
                                    
                                    [self hot_delete_from_wishLis:str_id];
                                    [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                                    [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                                    
                                }

                                
                            }
                        }
                            @catch(NSException *exception)
                            {
                                [Helper_activity stop_activity_animation:self];
                                

                            }
                        

                        
                        
                    }
                    else
                    {
                        [Helper_activity stop_activity_animation:self];
   
                    }
                    
                    
                }
                
            });
        }];
    }
    @catch(NSException *exception)
    {
        
        [Helper_activity stop_activity_animation:self];
        
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
      

   
    }
    }
   
}
#pragma Delete Item from Wishlist

-(void)hot_delete_from_wishLis:(NSString *)pd_id
{
    
    /* Del WishList
     
     http://192.168.0.171/dohasooq/apis/delFromWishList/1/24.json
     
     example
     Product_id =1
     User_Id = 24
     
     */
    
    [Helper_activity animating_images:self];
    
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_ID = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
    
    NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/delFromWishList/%@/%@.json",SERVER_URL,pd_id,user_ID];
    
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    @try {
        [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (error) {
                    [Helper_activity stop_activity_animation:self];
                    NSLog(@"Api error %@",[error localizedDescription]);
                }
                if (data) {
                    NSLog(@"delFromWishList data %@",data);
                    
                    [Helper_activity stop_activity_animation:self];
                    NSDictionary *temp_dict = data;
                    
                        @try {
                            
                            [HttpClient createaAlertWithMsg:[temp_dict valueForKey:@"multi_msg"] andTitle:@""];
                            
                        } @catch (NSException *exception) {
                            NSLog(@"sdfsd sdf sdf %@",exception);
                            
                        }
                    
                }
                
            });
            
        }];
    } @catch (NSException *exception) {
        [Helper_activity stop_activity_animation:self];
        
        NSLog(@" sdfs sdf asfdrew we %@",exception);
        
    }
}
#pragma Add best deals Item to wish list

-(void)best_dels_wishlist:(UIButton *)sender
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id;
    @try
    {
        if(dict.count == 0)
        {
            user_id = @"(null)";
        }
        else
        {
            NSString *str_id = @"user_id";
           
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
        
    }
    NSString *str_status_text;
    if([user_id isEqualToString:@"(null)"])
    {
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str_status_text = @"يرجى تسجيل الدخول للوصول إلى هذا";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"تسجيل الدخول" otherButtonTitles:@"إلغاء", nil];
            alert.tag = 1;
            [alert show];
            
        }
        else
        {
            str_status_text = @"Please login to access this";
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:str_status_text delegate:self cancelButtonTitle:@"Login" otherButtonTitles:@"Cancel", nil];
            alert.tag = 1;
            [alert show];
            
        }
        
        
        
    }
   else
    {
        

    NSString *urlGetuser;
    @try
    {
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];
        
        NSLog(@"Sender ...........%ld",(long)[sender tag]);
        
        
        [Helper_activity animating_images:self];
        
     urlGetuser =[NSString stringWithFormat:@"%@apis/addToWishList/%@/%@.json",SERVER_URL,[[deals_ARR objectAtIndex:sender.tag] valueForKey:@"product_id"],user_id];
        
         NSLog(@"URL ...........%@",urlGetuser);
        
            NSError *error;
            
            NSHTTPURLResponse *response = nil;
        
            NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
            NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
            [request setURL:urlProducts];
            [request setHTTPMethod:@"POST"];
            [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
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
            NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
            if(aData)
            {
                
                
                NSMutableDictionary *json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSJSONReadingAllowFragments error:&error];
                
                NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
                product_cell *cell = (product_cell *)[self.collection_best_deals cellForItemAtIndexPath:index];
                
                
                @try {
                    
                    if ([[NSString stringWithFormat:@"%@",[json_DATA valueForKey:@"msg"]] isEqualToString:@"Added to your Wishlist"]) {
//                    if ([[json_DATA valueForKey:@"status"] isEqualToString:@"Added to your Wishlist"]) {
                        
                        [Helper_activity stop_activity_animation:self];
                        [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                        
                        [cell.BTN_fav setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
                        //[HttpClient createaAlertWithMsg:@"Added to your wishlist" andTitle:@""];
                        [HttpClient createaAlertWithMsg:[json_DATA valueForKey:@"multi_msg"] andTitle:@
                         ""];
                        
                        
                    }
                    else{
                        
                        if ([[json_DATA valueForKey:@"msg"] isEqualToString:@"Customer wishlist already saved"] || [[json_DATA valueForKey:@"msg"] isEqualToString:@"تم حفظ قائمة رغبات العميل"])
                        {
                            NSString *str_id = [NSString stringWithFormat:@"%@",[[deals_ARR objectAtIndex:sender.tag] valueForKey:@"product_id"]];
                             [Helper_activity stop_activity_animation:self];
                            [self hot_delete_from_wishLis:str_id];
                               [cell.BTN_fav setTitle:@"" forState:UIControlStateNormal];
                            [cell.BTN_fav setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];

                            
                        }

                        
                    }
                }
                @catch(NSException *exception)
                {
                }
                
                  [Helper_activity stop_activity_animation:self];
                
                NSLog(@"Best Deals Wishlist %@",json_DATA);
                
            }
        }
        @catch(NSException *exception)
        {
            NSLog(@"asdfghgf gf %@",exception);
            [Helper_activity stop_activity_animation:self];
        }

    @catch(NSException*exception)
    {
       
    }
    
    }
    
}

#pragma mark Deals Image action homepage to Product List
-(void)hot_deals_action
{
     TIMER_countdown = [[NSTimer alloc]init];
//    [[NSUserDefaults standardUserDefaults] setValue:[[[json_Response_Dic valueForKey:@"dealSection" ] valueForKey:@"one"]  valueForKey:@"widgetEnglishTitle"] forKey:@"item_name"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
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
        
    }
    
    
    NSString *url_key = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"dealSection" ] valueForKey:@"one"]  valueForKey:@"widgetEnglishTitle"]];
    NSString *list_TYPE = @"dealsList";
    url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
  
     [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];


}
#pragma Deals Image action homepage to Product List

-(void)best_deals_action
{
     TIMER_countdown = [[NSTimer alloc]init];
//    [[NSUserDefaults standardUserDefaults] setValue:[[[json_Response_Dic valueForKey:@"dealSection" ] valueForKey:@"two"]  valueForKey:@"widgetTitle"] forKey:@"item_name"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
   // http://192.168.0.171/dohasooq/apis/dealsList/Best%20Selling%20Products/(null)/(null)/27/Customer.json
    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
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
        
    }
    
    
    NSString *url_key = [NSString stringWithFormat:@"%@",[[[json_Response_Dic valueForKey:@"dealSection" ] valueForKey:@"two"]  valueForKey:@"widgetEnglishTitle"]];
    NSString *list_TYPE = @"dealsList";
    url_key = [NSString stringWithFormat:@"%@/%@",list_TYPE,url_key];
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
    
     [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
   
    [self performSegueWithIdentifier:@"qt_home_product_list" sender:self];

}
#pragma Brands API calling

-(void)brands_API_call
{
    
    @try
    {
       
        
        NSError *error;
        brands_arr = [[NSMutableArray alloc]init];
        NSHTTPURLResponse *response = nil;
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *urlGetuser;
        if(_BTN_fashion.tag == 0)
        {
           urlGetuser =[NSString stringWithFormat:@"%@apis/getFashionBrands/male/%@/%@.json",SERVER_URL,country,languge];
        }
        else
        {
            urlGetuser =[NSString stringWithFormat:@"%@apis/getFashionBrands/female/%@/%@.json",SERVER_URL,country,languge];

            
        }
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        
        // set Cookie and awllb....
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
        
        //[request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        
        
        if(aData)
        {
            [Helper_activity stop_activity_animation:self];
            
         NSDictionary   *brands_dict= (NSDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            [[NSUserDefaults standardUserDefaults] setObject:[brands_dict valueForKey:@"brand_result"] forKey:@"brands_LIST"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            brands_arr = [brands_dict valueForKey:@"brand_result"];
            fashion_categirie_arr =  [[NSMutableArray alloc]init];
            fashion_categirie_arr = [brands_dict valueForKey:@"banners"];
            [self.collection_fashion_categirie reloadData];
            [self set_up_VIEW];

            
            [self.collection_brands reloadData];
            NSLog(@"The response Api form Brands%@",brands_dict);
            
            
        }
        else
        {
            [Helper_activity stop_activity_animation:self];
            
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Some thing went to wrong please try again later" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
    }
    
    @catch(NSException *exception)
    {
        NSLog(@"The error is:%@",exception);
        
        [Helper_activity stop_activity_animation:self];
    }
    
}
#pragma Fashion accessories Men and Women Icon change


-(void)BTN_fashhion_cahnge
{
    //men_icon.png
    NSData *imgData1 = UIImagePNGRepresentation(_BTN_fashion.currentBackgroundImage);
    NSData *imgData2 = UIImagePNGRepresentation([UIImage imageNamed:@"women_logo"]);
    BOOL isCompare =  [imgData1 isEqualToData:imgData2];
    if (isCompare)
    {
        
        _IMG_Person_banner.image = [UIImage imageNamed:@"upload-4"];
        _IMG_Things_banner.image = [UIImage imageNamed:@"bag"];
        [_BTN_fashion setBackgroundImage:[UIImage imageNamed:@"men_icon"] forState:UIControlStateNormal];


        [_BTN_fashion setTag:1];
        [Helper_activity animating_images:self];
        [self performSelector:@selector(brands_API_call) withObject:nil afterDelay:0.1];
        NSString *str = @"Women's";
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            str = @"للنساء ";
            
        }

        _Hot_deals.text = [NSString stringWithFormat:@"%@ %@",str,[json_Response_Dic valueForKey:@"fashion_name"]];
        [_collection_brands reloadData];


  }
  else
  {
      
      
      _IMG_Person_banner.image = [UIImage imageNamed:@"men"];
      _IMG_Things_banner.image = [UIImage imageNamed:@"shoes_prod"];
      
      [_BTN_fashion setBackgroundImage:[UIImage imageNamed:@"women_logo"] forState:UIControlStateNormal];


      [_BTN_fashion setTag:0];
      [Helper_activity animating_images:self];
      [self performSelector:@selector(brands_API_call) withObject:nil afterDelay:0.1];
      NSString *str = @"Men's";
      if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
      {
          str = @"للرجال ";
          
      }
      _Hot_deals.text = [NSString stringWithFormat:@"%@ %@",str,[json_Response_Dic valueForKey:@"fashion_name"]];//@"MEN'S FASHION ACCESORIES";
      [_collection_brands reloadData];
      

     
  }
    
}
#pragma Alert View Delegate Implementation

- (void)alertView:(UIAlertView *)alertView
clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(alertView.tag == 2)
    {
    if (buttonIndex == [alertView cancelButtonIndex])
    {
        [[NSUserDefaults standardUserDefaults]  removeObjectForKey:@"country_id"];
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"language_id"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        VC_intial *intial = [self.storyboard instantiateViewControllerWithIdentifier:@"intial_VC"];
        [self presentViewController:intial animated:NO completion:nil];

   
    }

    else{
       
        NSLog(@"cancel:");

    }
    }
    else if(alertView.tag == 1)
    {
        if (buttonIndex == [alertView cancelButtonIndex])
        {
            ViewController *login = [self.storyboard instantiateViewControllerWithIdentifier:@"login_VC"];
            [self presentViewController:login animated:NO completion:nil];

            
            
        }
        else
        {
            NSLog(@"cancel:");

        }
        
        
    }
    

    
}

#pragma mark TextField Delegate

-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    if(textField == _TXT_search)
    {
     [self performSegueWithIdentifier:@"home_dohasooq_search" sender:self];
    }
    if (textField.tag == 5) {
        isPickerViewScrolled  = NO;
    }
}
#pragma cart count api calling

-(void)cart_count
{
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
    NSString *user_id;
    @try
    {
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
        
    }
    if([user_id isEqualToString:@"(null)"])
    {
        _badgeView.hidden = YES;
    }
    
    else
    {
        NSString *str_count = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"cart_count"]];
        if([str_count intValue ] > 0)
        {
            _badgeView.hidden = NO;
            _badgeView.badgeValue = [str_count integerValue];
        }
        else{
            _badgeView.hidden = YES;
        }
    }
   }

#pragma mark TimerMethod for automatic scrolling images
-(void)set_timer_to_collection_images{
    
    
    [NSTimer scheduledTimerWithTimeInterval:10
                                     target:self
                                   selector:@selector(scrolling_image:)
                                   userInfo:nil
                                    repeats:YES];
    mn=0;
    
}

-(void)scrolling_image:(NSTimeInterval *)timer{
    
    
    @try {
        mn ++;
        if (mn==image_Top_ARR.count) {
            mn=0;
        }
        NSIndexPath *newIndexPath=[NSIndexPath indexPathForRow:mn inSection:0];
        
        
        [self.custom_story_page_controller setCurrentPage:mn];
        [_collection_images scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
    } @catch (NSException *exception) {
        NSLog(@"dskfjsd fsaihdfwf %@",exception);
    }
    
    
    
    
    
}
#pragma Delegate method for wipe Gesture

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
     if ([touch.view isDescendantOfView:_VW_swipe]) {
       return NO;
     }
    return YES;
}
#pragma close The menu action

- (IBAction)Close_ACTION:(id)sender
{
      [self swipe_left];
}
#pragma go to Top action

-(void)TOP_action
{
    [self.Scroll_contents setContentOffset:CGPointZero animated:YES];
}
-(void)seacrh_ACTION
{
    [self performSegueWithIdentifier:@"home_dohasooq_search" sender:self];

}

#pragma Hot deals Timer Display method

-(NSString *)runUpdateDisplayLoop : (NSTimer *) timer //:(NSString *)str_date
{
   
    NSDate *date;NSString *text;
    NSDateFormatter *dateStringParser = [[NSDateFormatter alloc] init];
    
    NSString *str_time_zone = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"default_time_zone"]];
    if([str_time_zone isEqualToString:@""]||[str_time_zone isEqualToString:@"<null>"])
    {
        str_time_zone = [[NSTimeZone localTimeZone] abbreviation];
    }
    
    [dateStringParser setTimeZone:[NSTimeZone timeZoneWithName:str_time_zone]];
    [dateStringParser setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    int tag1 =  [[timer.userInfo valueForKey:@"tag"] intValue];
    NSString *STR_bidDate;
    @try
    {
    
   STR_bidDate =  [[hot_deals_ARR objectAtIndex:tag1]valueForKey:@"end_date"];
    }
    @catch(NSException *exception)
    {
        
    }//[TIMER_new.userInfo valueForKey:@"timer"];
    if([STR_bidDate isKindOfClass:[NSNull class]]||[STR_bidDate isEqualToString:@"<null>"]||[STR_bidDate isEqualToString:@"(null)"]||!STR_bidDate)
    {
        
    }
   
    else
    {
   date = [dateStringParser dateFromString:STR_bidDate];
    
  //  NSDateFormatter *labelFormatter = [[NSDateFormatter alloc] init];
   // [labelFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    NSDate* currentDate = [NSDate date];
    
    NSTimeInterval timeInterval = [date timeIntervalSinceDate:currentDate];
    
    NSCalendar *sysCalendar = [NSCalendar currentCalendar];
    NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date];
    NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitSecond;
    
    NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date  toDate:date2  options:0];
    
    NSString *STR_timeRe;
    
    if ([breakdownInfo day] <= 0 ) {
        
        STR_timeRe = [NSString stringWithFormat:@"Ends in %02d: %02d: %02d",(int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            // STR_timeRe = [NSString stringWithFormat:@"%02d: %02d: %02d ينتهي بـ",(int)[breakdownInfo second], (int)[breakdownInfo minute], (int)[breakdownInfo hour]];
            
             STR_timeRe = [NSString stringWithFormat:@"ينتهي بـ%02d: %02d: %02d",(int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
        }
        
        
    }
    else if ([breakdownInfo day] <= 0 && [breakdownInfo hour] <= 0)
    {
        
        STR_timeRe = [NSString stringWithFormat:@"Ends in %02d: %02d",(int)[breakdownInfo minute], (int)[breakdownInfo second]];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
          //  STR_timeRe = [NSString stringWithFormat:@"%02d: %02d ينتهي بـ",(int)[breakdownInfo second], (int)[breakdownInfo minute]];
            
               STR_timeRe = [NSString stringWithFormat:@"ينتهي بـ %02d: %02d",(int)[breakdownInfo minute], (int)[breakdownInfo second]];
        }

        
    }
    else if ([breakdownInfo day] <= 0 && [breakdownInfo hour] <= 0 && [breakdownInfo minute] <= 0)
    {
        
        STR_timeRe = [NSString stringWithFormat:@"Ends in %02d", (int)[breakdownInfo second]];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            //STR_timeRe = [NSString stringWithFormat:@"%02d ينتهي بـ",(int)[breakdownInfo second]];
            STR_timeRe = [NSString stringWithFormat:@"ينتهي بـ %02d", (int)[breakdownInfo second]];

        }

        
        
    }
    else
    {
        
        STR_timeRe = [NSString stringWithFormat:@"Ends in %02d Days: %02d: %02d: %02d", (int)[breakdownInfo day], (int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
        
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
         //  STR_timeRe = [NSString stringWithFormat:@"%02d: %02d: %02d:الأيام %2d ينتهي بـ",(int)[breakdownInfo second], (int)[breakdownInfo minute], (int)[breakdownInfo hour], (int)[breakdownInfo day]];
            
              STR_timeRe = [NSString stringWithFormat:@"  ينتهي في:%2d الأيام: %02d: %02d: %02d", (int)[breakdownInfo day], (int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
        }

    }
    
    
    text = [NSString stringWithFormat:@"%@",STR_timeRe];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[timer.userInfo valueForKey:@"tag"] intValue] inSection:0];
    product_cell *cell = (product_cell *)[_collection_hot_deals cellForItemAtIndexPath:indexPath];
    
    NSString *str =[NSString stringWithFormat:@"%@",[[hot_deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"stock_status"]];
    str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
      CGSize result = [[UIScreen mainScreen] bounds].size;
    int sizeval = 12.0;
    if(result.height <= 480)
    {
        sizeval = 8.0;
    }
    else if(result.height <= 568)
    {
        sizeval = 9.0;
    }
    else
    {
        sizeval = 9.0;
    }
  if([str isEqualToString:@"In stock"]|| [str isEqualToString:@""]|| [str isEqualToString:@"<null>"] )
  {
        
        cell.LBL_stock.font = [UIFont fontWithName:@"Poppins-Regular" size:sizeval];
        cell.LBL_stock.textColor = [UIColor darkGrayColor];
        cell.LBL_stock.text = text;
    }
    else
    {
        cell.LBL_stock.font = [UIFont fontWithName:@"Poppins-Regular" size:14.0];

        cell.LBL_stock.textColor = [UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0];
        cell.LBL_stock.text = [str uppercaseString];
        cell.LBL_stock.text = [str uppercaseString];
        if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
        {
            cell.LBL_stock.text = @"";
        }

    }

    
    }
    
    //    product_cell *cell =
    return text;
}

#pragma Best deals Timer Display method

-(NSString *)runUpdateDisplayLoop_best : (NSTimer *) timer //:(NSString *)str_date
{
    
    NSDate *date;NSString *text;
    NSDateFormatter *dateStringParser = [[NSDateFormatter alloc] init];
    
    NSString *str_time_zone = [NSString stringWithFormat:@"%@",[json_Response_Dic valueForKey:@"default_time_zone"]];
    if([str_time_zone isEqualToString:@""]||[str_time_zone isEqualToString:@"<null>"])
    {
        str_time_zone = [[NSTimeZone localTimeZone] abbreviation];
    }
    
    [dateStringParser setTimeZone:[NSTimeZone timeZoneWithName:str_time_zone]];
    [dateStringParser setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    
    int tag1 =  [[timer.userInfo valueForKey:@"tag"] intValue];
    NSString *STR_bidDate;
    @try
    {
        
        STR_bidDate =  [[deals_ARR objectAtIndex:tag1]valueForKey:@"end_date"];
    }
    @catch(NSException *exception)
    {
        
    }    if([STR_bidDate isKindOfClass:[NSNull class]]||[STR_bidDate isEqualToString:@"<null>"]||[STR_bidDate isEqualToString:@"(null)"]||!STR_bidDate)
    {
        
    }
    
    else
    {
        date = [dateStringParser dateFromString:STR_bidDate];
        
        
        
        NSDateFormatter *dateFormatter=[[NSDateFormatter alloc] init];
        
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        
        
        NSDate* currentDate = [NSDate date];
        
        NSTimeInterval timeInterval = [date timeIntervalSinceDate:currentDate];
        
        NSCalendar *sysCalendar = [NSCalendar currentCalendar];
        NSDate *date2 = [[NSDate alloc] initWithTimeInterval:timeInterval sinceDate:date];
        NSCalendarUnit unitFlags = NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitDay | NSCalendarUnitSecond;
        
        NSDateComponents *breakdownInfo = [sysCalendar components:unitFlags fromDate:date  toDate:date2  options:0];
        
        NSString *STR_timeRe;
        
        if ([breakdownInfo day] <= 0 ) {
            
            STR_timeRe = [NSString stringWithFormat:@"Ends in %02d: %02d: %02d",(int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                STR_timeRe = [NSString stringWithFormat:@"%02d: %02d: %02d ينتهي بـ",(int)[breakdownInfo second], (int)[breakdownInfo minute], (int)[breakdownInfo hour]];
            }
            
            
        }
        else if ([breakdownInfo day] <= 0 && [breakdownInfo hour] <= 0)
        {
            
            STR_timeRe = [NSString stringWithFormat:@"Ends in %02d: %02d",(int)[breakdownInfo minute], (int)[breakdownInfo second]];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                STR_timeRe = [NSString stringWithFormat:@"%02d: %02d ينتهي بـ",(int)[breakdownInfo second], (int)[breakdownInfo minute]];
            }
            
            
        }
        else if ([breakdownInfo day] <= 0 && [breakdownInfo hour] <= 0 && [breakdownInfo minute] <= 0)
        {
            
            STR_timeRe = [NSString stringWithFormat:@"Ends in %02d", (int)[breakdownInfo second]];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
              //  STR_timeRe = [NSString stringWithFormat:@"%02d ينتهي بـ",(int)[breakdownInfo second]];
                STR_timeRe = [NSString stringWithFormat:@"ينتهي بـ %02d", (int)[breakdownInfo second]];

            }
            
            
            
        }
        else
        {
            
            STR_timeRe = [NSString stringWithFormat:@"Ends in %02d Days: %02d: %02d: %02d", (int)[breakdownInfo day], (int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
            
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
               // STR_timeRe = [NSString stringWithFormat:@"%02d: %02d: %02d:الأيام %2d ينتهي بـ",(int)[breakdownInfo second], (int)[breakdownInfo minute], (int)[breakdownInfo hour], (int)[breakdownInfo day]];
                  STR_timeRe = [NSString stringWithFormat:@"  ينتهي في:%2d الأيام: %02d: %02d: %02d", (int)[breakdownInfo day], (int)[breakdownInfo hour], (int)[breakdownInfo minute], (int)[breakdownInfo second]];
            }
            
        }
        
        
        text = [NSString stringWithFormat:@"%@",STR_timeRe];
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForItem:[[timer.userInfo valueForKey:@"tag"] intValue] inSection:0];
        product_cell *cell = (product_cell *)[_collection_best_deals cellForItemAtIndexPath:indexPath];
        
        NSString *str =[NSString stringWithFormat:@"%@",[[deals_ARR objectAtIndex:indexPath.row ]  valueForKey:@"stock_status"]];
        str = [str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
        CGSize result = [[UIScreen mainScreen] bounds].size;
        int sizeval = 12.0;
        if(result.height <= 480)
        {
            sizeval = 8.0;
        }
        else if(result.height <= 568)
        {
            sizeval = 9.0;
        }
        else
        {
            sizeval = 9.0;
        }
        if([str isEqualToString:@"In stock"]|| [str isEqualToString:@""]|| [str isEqualToString:@"<null>"] )
        {
            
            cell.LBL_stock.font = [UIFont fontWithName:@"Poppins-Regular" size:sizeval];
            cell.LBL_stock.textColor = [UIColor darkGrayColor];
            cell.LBL_stock.text = text;
        }
        else
        {
            cell.LBL_stock.font = [UIFont fontWithName:@"Poppins-Regular" size:14.0];
            
            cell.LBL_stock.textColor = [UIColor colorWithRed:0.90 green:0.22 blue:0.00 alpha:1.0];
            cell.LBL_stock.text = [str uppercaseString];
            cell.LBL_stock.text = [str uppercaseString];
            if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
            {
                cell.LBL_stock.text = @"غير متوفّر";
            }
            
        }
        
        
    }
    
    return text;
}

#pragma cart Count API call
-(void)cart_count_intail{
    
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
        
    }
    [HttpClient cart_count:user_id completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""
             ];
            
        }
        if (data) {
            NSLog(@"cart count sadas %@",data);
            NSDictionary *dict = data;
            @try {
                
                NSString *badge_value = [NSString stringWithFormat:@"%@",[dict valueForKey:@"cartcount"]];
                [[NSUserDefaults standardUserDefaults] setValue:badge_value forKey:@"cart_count"];
                [[NSUserDefaults standardUserDefaults]synchronize];
                
                
                
            } @catch (NSException *exception) {
                
                
                NSLog(@"asjdas dasjbd asdas iccxv %@",exception);
            }
            
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated
{
    TIMER_countdown = [[NSTimer alloc]init];
}
#pragma Brand_action Right
-(void)brand_right_action
{
    
    @try
    {
    NSIndexPath *newIndexPath;
    if (!INDX_selected)
    {
        newIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        INDX_selected = newIndexPath;
    }
    
    else if ([brands_arr count]  > INDX_selected.row)
    {
        if ([brands_arr count] == INDX_selected.row + 3) {
            newIndexPath = [NSIndexPath indexPathForRow:[brands_arr count] - 3 inSection:0];
            INDX_selected = newIndexPath;
        }
        else
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row + 3 inSection:0];
            INDX_selected = newIndexPath;
        }
    }
    
    
    if (!newIndexPath) {
        newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        INDX_selected = newIndexPath;
    }
    
    
    [_collection_brands scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    @catch(NSException *exception)
    {
        
    }
    
}

#pragma Brand_action Left

-(void)BTN_left_brand_action
{
    @try
    {
    NSIndexPath *newIndexPath;
    if (INDX_selected)
    {
        newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row - 3 inSection:0];
        INDX_selected = newIndexPath;
    }
    
    else if ([brands_arr count]  > INDX_selected.row)
    {
        if ([brands_arr count] == INDX_selected.row - 3) {
            newIndexPath = [NSIndexPath indexPathForRow:[brands_arr count] - 3 inSection:0];
            INDX_selected = newIndexPath;
        }
        else
        {
            newIndexPath = [NSIndexPath indexPathForRow:INDX_selected.row - 3 inSection:0];
            INDX_selected = newIndexPath;
        }
    }
    
    
    if (!newIndexPath) {
        newIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
        INDX_selected = newIndexPath;
    }
    if (newIndexPath.row == 1)
    {
        newIndexPath = [NSIndexPath indexPathForRow:1 inSection:0];
        INDX_selected = newIndexPath;
    }
    if(newIndexPath.row < 1)
    {
        newIndexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        INDX_selected = newIndexPath;
    }

    
    [_collection_brands scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:INDX_selected.row inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
    }
    @catch(NSException *exception)
    {
        
    }

}
#pragma mark First Time Total API call
-(void)API_call
{
    
            @try
            {
                [Helper_activity animating_images:self];
    
                /**********   After passing Language Id and Country ID ************/
                NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
    
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
    
                NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/home/%ld/%ld/%@/Customer.json",SERVER_URL,(long)[user_defaults integerForKey:@"country_id"],(long)[user_defaults integerForKey:@"language_id"],user_id];
                
    
    
                urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
                [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (error) {
                            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
    
                            [Helper_activity stop_activity_animation:self];
                        }
                        if (data) {
    
                            @try {
                                 [Helper_activity stop_activity_animation:self];
                                [[NSUserDefaults standardUserDefaults] setObject:data forKey:@"Home_data"];
                                [[NSUserDefaults standardUserDefaults] synchronize];
                                
                                [self MENU_api_call];
                                
                                
                            } @catch (NSException *exception)
                            {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                                [alert show];
    
    
                            }
    
    
    
                        }
                        else
                        {
                           [Helper_activity stop_activity_animation:self];
                            //                        VW_overlay.hidden = YES;
                            //                        [activityIndicatorView stopAnimating];
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
                            [alert show];
                            // [self viewWillAppear:NO];
    
    
    
                        }
    
                      //  [Helper_activity stop_activity_animation:self];
    
                    });
                }];
            }
            @catch(NSException *exception)
            {
                NSLog(@"The error is:%@",exception);
                [HttpClient createaAlertWithMsg:[NSString stringWithFormat:@"%@",exception] andTitle:@"Exception"];
                //        VW_overlay.hidden = YES;
                //        [activityIndicatorView stopAnimating];
                // [self viewWillAppear:NO];
               [Helper_activity stop_activity_animation:self];
                
            }
    
}
#pragma Menu api call
-(void)MENU_api_call
{
    
    @try
    {
        [Helper_activity animating_images:self];
        
        
        NSError *error;
        
        NSHTTPURLResponse *response = nil;
        NSUserDefaults *user_defaults = [NSUserDefaults standardUserDefaults];
        //    NSString *urlGetuser =[NSString stringWithFormat:@"%@menuList/%ld/%ld.json",SERVER_URL,(long)[user_defaults   integerForKey:@"country_id"],[user_defaults integerForKey:@"language_id"]];
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *lang = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/getCategoryList/%@/%@.json",SERVER_URL,country,lang];
        
        NSLog(@"%ld,%ld",(long)[user_defaults integerForKey:@"country_id"],(long)[user_defaults integerForKey:@"language_id"]);
        
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        // set Cookie and awllb..
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
        //[request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if (response) {
            [HttpClient filteringCookieValue:response];
        }
        
        if (error) {
            [HttpClient createaAlertWithMsg:[error localizedDescription] andTitle:@""];
            [Helper_activity stop_activity_animation:self];
            
        }
        
        
        if(aData)
        {
            
            
            NSDictionary *json_DATA = (NSDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            
            [Helper_activity stop_activity_animation:self];
            
            if (![json_DATA count]) {
                
                [HttpClient createaAlertWithMsg:@"Something went to wrong ." andTitle:@""];
                
            }
            else{
                
                
                NSLog(@"the api_collection_product%@",json_DATA);
                [[NSUserDefaults standardUserDefaults] setObject:json_DATA  forKey:@"pho"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                _Scroll_contents.delegate =self;
                
                // TIMER_new = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(runUpdateDisplayLoop:)userInfo:nil repeats:YES];
                //  [self popUpZoomIn:_BTN_fashion];
                [self.collection_images registerNib:[UINib nibWithNibName:@"cell_image" bundle:nil]  forCellWithReuseIdentifier:@"collection_image"];
                [self.collection_features registerNib:[UINib nibWithNibName:@"cell_features" bundle:nil]  forCellWithReuseIdentifier:@"features_cell"];
                [self.collection_showing_movies registerNib:[UINib nibWithNibName:@"cell_features" bundle:nil]  forCellWithReuseIdentifier:@"showing_movies_cell"];
                [self.collection_hot_deals registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
                [self.collection_best_deals registerNib:[UINib nibWithNibName:@"product_cell" bundle:nil]  forCellWithReuseIdentifier:@"collection_product"];
                [self.collection_fashion_categirie registerNib:[UINib nibWithNibName:@"Fashion_categorie_cell" bundle:nil]  forCellWithReuseIdentifier:@"fashion_categorie"];
                
                
                [self.Collection_movies registerNib:[UINib nibWithNibName:@"Movies_cell" bundle:nil]  forCellWithReuseIdentifier:@"movie_cell"];
                
                [self.Collection_movies registerNib:[UINib nibWithNibName:@"Image_qtickets" bundle:nil]  forCellWithReuseIdentifier:@"Image_qtickets"];
                [self.Collection_movies registerNib:[UINib nibWithNibName:@"upcoming_cell" bundle:nil]  forCellWithReuseIdentifier:@"upcoming_cell"];
                
                
                tag =0;
                leng_text = @"LANGUAGES";
                halls_text =@"THEATERS";
                
                collection_tag = 0;
                _BTN_leisure_venues.text = _BTN_venues.text;
                _BTN_sports_venues.text = _BTN_venues.text;
                brands_arr = [[NSMutableArray alloc]init];
                _TXT_search.delegate =self;
                
                
                _TXT_search.layer.borderColor = [UIColor lightGrayColor].CGColor;
                _TXT_search.layer.borderWidth = 0.2f;
                
                
                _hot_deals_more.layer.cornerRadius = 2.0f;
                _hot_deals_more.layer.masksToBounds = YES;
                
                _best_deals_more.layer.cornerRadius = 2.0f;
                _best_deals_more.layer.masksToBounds = YES;
                
                [_BTN_brand_right addTarget:self action:@selector(brand_right_action) forControlEvents:UIControlEventTouchUpInside];
                [_BTN_brand_left addTarget:self action:@selector(BTN_left_brand_action) forControlEvents:UIControlEventTouchUpInside];
                
                [_BTN_TOP addTarget:self action:@selector(TOP_action) forControlEvents:UIControlEventTouchUpInside];
                [_BTN_search addTarget:self action:@selector(seacrh_ACTION) forControlEvents:UIControlEventTouchUpInside];
                [_logo addTarget:self action:@selector(logo_api_call) forControlEvents:UIControlEventTouchUpInside];
                [self view_appear];
                
            }
            
        }
        
    }
    @catch(NSException *exception)
    {
        [Helper_activity stop_activity_animation:self];
        
        NSLog(@"%@",exception);
      
        
        
    }
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark language_switch_API
-(void)language_switch_API{
    @try
    {
        
        [Helper_activity animating_images:self];
        
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge_str = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
   
         language_code = [[NSUserDefaults standardUserDefaults] valueForKey:@"code_language"];
        
        
        NSString *urlGetuser =[NSString stringWithFormat:@"%@users/switch-language/%@/%@/%@/Mobile",SERVER_URL,country,languge_str,language_code];
        
       
        
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


@end
