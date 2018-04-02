//
//  VC_my_bookings.m
//  Dohasooq_mobile
//
//  Created by Test User on 21/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_my_bookings.h"
#import "HMSegmentedControl.h"
#import "bookings_cell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "XMLDictionary.h"
#import "HttpClient.h"
#import "Helper_activity.h"
@interface VC_my_bookings ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *Total_QT_arr;
//    UIView *VW_overlay;
//    UIActivityIndicatorView *activityIndicatorView;
    NSMutableDictionary *json_DATA;
    UIImageView *not_found_image;//No_items_Found
}
@property (nonatomic, strong) HMSegmentedControl *segmentedControl4;

@end

@implementation VC_my_bookings

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"MyBookings screen";

    [self addSEgmentedControl];
    
    
    
    CGRect frameset = _VW_empty.frame;
    frameset.size.width = 200;
    frameset.size.height = 200;
    _VW_empty.frame = frameset;
    _VW_empty.center = self.view.center;
    [self.view addSubview:_VW_empty];
    _VW_empty.hidden = YES;
    
    _BTN_empty.layer.cornerRadius = self.BTN_empty.frame.size.width / 2;
    _BTN_empty.layer.masksToBounds = YES;

  
}
-(void)viewWillAppear:(BOOL)animated
{
    
    
    self.navigationItem.hidesBackButton = YES;

    self.TBL_bookings.hidden = YES;
    [Helper_activity animating_images:self];
    
    [self performSelector:@selector(booking_API) withObject:nil afterDelay:0.01];
  
    
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if([Total_QT_arr isKindOfClass:[NSArray class]])
    {
        return Total_QT_arr.count;
    }
   else
   {
      return 1;
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath

{
    
    NSInteger index;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        
        
        index = 0;
        
    }
    else{
        index = 0;
    }
    
    
    bookings_cell *book_cell = (bookings_cell *)[tableView dequeueReusableCellWithIdentifier:@"book_cell"];
    
    if (book_cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"bookings_cell" owner:self options:nil];
        book_cell = [nib objectAtIndex:index];
    }

    @try
    {
    if(_segmentedControl4.selectedSegmentIndex== 0)
    {
         if([Total_QT_arr isKindOfClass:[NSArray class]])
         {    NSString *str_event_name = [[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_movie"];
             book_cell.LBL_event_name.text = str_event_name;
             NSString *str_code = [NSString stringWithFormat:@"%@",[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_confirmationCode"]];
             NSString *str_confirm_code = [NSString stringWithFormat:@"Confirmation code %@",str_code];
             
             if ([book_cell.LBL_confirmation_code respondsToSelector:@selector(setAttributedText:)]) {
                 
                 NSDictionary *attribs = @{
                                           NSForegroundColorAttributeName:book_cell.LBL_confirmation_code.textColor,
                                           NSFontAttributeName:book_cell.LBL_confirmation_code.font
                                           };
                 NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_confirm_code attributes:attribs];
                 
                 
                 
                 NSRange ename = [str_confirm_code rangeOfString:str_code];
                 [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                         range:ename];
                 
                 book_cell.LBL_confirmation_code.attributedText = attributedText;
             }
             else
             {
                 book_cell.LBL_confirmation_code.text = str_confirm_code;
             }
             
             
         
        @try
        {
            NSString *img_url = @"https://www.q-tickets.com/movie_images/OLDBOY_thumb.jpg";//[[Total_QT_arr objectAtIndex:indexPath.row]valueForKey:@"_movieImageURL"];
            //img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            [book_cell.IMG_item_name sd_setImageWithURL:[NSURL URLWithString:img_url]
                                       placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                                options:SDWebImageRefreshCached];
        }
        @catch(NSException *exception)
        {
            
        }
        
        NSString *str_theatre = [NSString stringWithFormat:@"Theatre: %@",[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_theater"]];
        book_cell.LBL_theatre.text = str_theatre;
        
        NSString *str_timings = [NSString stringWithFormat:@"Timing: %@",[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_showdate"]];
        book_cell.LBL_timings.text = str_timings;
        
        NSString *str_seats = [NSString stringWithFormat:@"Selected Seats:\n%@",[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_seats"]];
             
             CGSize result = [[UIScreen mainScreen] bounds].size;
             
             if(result.height <= 480)
             {
                 [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:7]];
                 
             }
             else if(result.height <= 568)
             {
                  [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:12]];
             }
             else
             {
                   [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:12]];
             }
             
             
        book_cell.LBL_seats.text = str_seats;
        NSString *str_amount = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_total_Cost"]];
          NSString *str_AMT = @"Total Amount:";
             
        
        NSString *total_amount = [NSString stringWithFormat:@"%@ %@",str_AMT,str_amount];
        
        if ([book_cell.LBL_total_amount respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:book_cell.LBL_total_amount.textColor,
                                      NSFontAttributeName:book_cell.LBL_total_amount.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:total_amount attributes:attribs];
            
            NSRange ename = [total_amount rangeOfString:str_AMT];
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:8.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
                
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
                
            }
            

            
            
            NSRange enames = [total_amount rangeOfString:str_amount];
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:8.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];

            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];

            }

            
            
            book_cell.LBL_total_amount.attributedText = attributedText;
        }
        else
        {
            book_cell.LBL_total_amount.text = total_amount;
        }
             
    }
    else
    {
        NSString *str_event_name = [Total_QT_arr valueForKey:@"_movie"];
        book_cell.LBL_event_name.text = str_event_name;
        NSString *str_code = [NSString stringWithFormat:@"%@",[Total_QT_arr valueForKey:@"_confirmationCode"]];
        NSString *str_confirm_code = [NSString stringWithFormat:@"Confirmation code %@",str_code];
        
        if ([book_cell.LBL_confirmation_code respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:book_cell.LBL_confirmation_code.textColor,
                                      NSFontAttributeName:book_cell.LBL_confirmation_code.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_confirm_code attributes:attribs];
            
            
            
            NSRange ename = [str_confirm_code rangeOfString:str_code];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:ename];
            
            book_cell.LBL_confirmation_code.attributedText = attributedText;
        }
        else
        {
            book_cell.LBL_confirmation_code.text = str_confirm_code;
        }
        
        @try
        {
            NSString *img_url = [Total_QT_arr valueForKey:@"_movieImageURL"];
            //img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
            [book_cell.IMG_item_name sd_setImageWithURL:[NSURL URLWithString:img_url]
                                       placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                                options:SDWebImageRefreshCached];
        }
        @catch(NSException *excpeiotn)
        {
            
        }
        
        NSString *str_theatre = [NSString stringWithFormat:@"Theatre: %@",[Total_QT_arr valueForKey:@"_theater"]];
        book_cell.LBL_theatre.text = str_theatre;
        
        NSString *str_timings = [NSString stringWithFormat:@"Timing: %@",[Total_QT_arr valueForKey:@"_showdate"]];
        book_cell.LBL_timings.text = str_timings;
        
        NSString *str_seats = [NSString stringWithFormat:@"Selected Seats:\n%@",[Total_QT_arr valueForKey:@"_seats"]];
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height <= 480)
        {
            [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:7]];
            
        }
        else if(result.height <= 568)
        {
            [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:12]];
        }
        else
        {
            [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:12]];
        }
        

        book_cell.LBL_seats.text = str_seats;
        NSString *str_amount = [NSString stringWithFormat:@"%@ %@",[Total_QT_arr valueForKey:@"_total_Cost"],[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        NSString *str_AMT = @"Total Amount:";
        
        
        NSString *total_amount = [NSString stringWithFormat:@"%@ %@",str_AMT,str_amount];

        
        
        if ([book_cell.LBL_total_amount respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:book_cell.LBL_total_amount.textColor,
                                      NSFontAttributeName:book_cell.LBL_total_amount.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:total_amount attributes:attribs];
            
            
            
            NSRange ename = [total_amount rangeOfString:str_AMT];
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:8.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
                
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
                
            }
            
            
            
            
            NSRange enames = [total_amount rangeOfString:str_amount];
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:8.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
                
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
                
            }
            
            
            book_cell.LBL_total_amount.attributedText = attributedText;
        }
        else
        {
            book_cell.LBL_total_amount.text = total_amount;
        }
        return book_cell;
    }
       
    }
  else if(_segmentedControl4.selectedSegmentIndex == 1)
    {
        if([Total_QT_arr isKindOfClass:[NSArray class]])
        {
            
            NSString *str_event_name = [[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_Event"];
            book_cell.LBL_event_name.text = str_event_name;
            NSString *str_code = [NSString stringWithFormat:@"%@",[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_confirmationCode"]];
            NSString *str_confirm_code = [NSString stringWithFormat:@"Confirmation code %@",str_code];
            
            if ([book_cell.LBL_confirmation_code respondsToSelector:@selector(setAttributedText:)]) {
                
                NSDictionary *attribs = @{
                                          NSForegroundColorAttributeName:book_cell.LBL_confirmation_code.textColor,
                                          NSFontAttributeName:book_cell.LBL_confirmation_code.font
                                          };
                NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_confirm_code attributes:attribs];
                
                
                
                NSRange ename = [str_confirm_code rangeOfString:str_code];
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
                
                book_cell.LBL_confirmation_code.attributedText = attributedText;
            }
            else
            {
                book_cell.LBL_confirmation_code.text = str_confirm_code;
            }
            
            
        }
        NSString *img_url = [[Total_QT_arr objectAtIndex:indexPath.row]valueForKey:@"_eventImageURL"];
        [book_cell.IMG_item_name sd_setImageWithURL:[NSURL URLWithString:img_url]
                                   placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                            options:SDWebImageRefreshCached];
        
        NSString *str_theatre = [NSString stringWithFormat:@"Ticketname: %@",[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_TicketName"]];
        book_cell.LBL_theatre.text = str_theatre;
        
        NSString *str_timings = [NSString stringWithFormat:@"Eventdate: %@",[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_eventDate"]];
        book_cell.LBL_timings.text = str_timings;
        
        NSString *str_seats = [NSString stringWithFormat:@"Total Seats: %@",[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_seatsCount"]];
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height <= 480)
        {
            [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:7]];
            
        }
        else if(result.height <= 568)
        {
            [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:12]];
        }
        else
        {
            [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:12]];
        }

        book_cell.LBL_seats.text = str_seats;
        NSString *str_amount = [NSString stringWithFormat:@"%@ %@",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],[[Total_QT_arr objectAtIndex:indexPath.row] valueForKey:@"_total_Cost"]];
        
        NSString *str_AMT = @"Total Amount:";
        
        NSString *total_amount = [NSString stringWithFormat:@"%@ %@",str_AMT,str_amount];

        
        if ([book_cell.LBL_total_amount respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:book_cell.LBL_total_amount.textColor,
                                      NSFontAttributeName:book_cell.LBL_total_amount.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:total_amount attributes:attribs];
            
            
            
            NSRange ename = [total_amount rangeOfString:str_AMT];
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:8.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
                
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
                
            }
            
            
            
            
            NSRange enames = [total_amount rangeOfString:str_amount];
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:8.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
                
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
                
            }
            book_cell.LBL_total_amount.attributedText = attributedText;
        }
        else
        {
            book_cell.LBL_total_amount.text = total_amount;
        }
    }
    else
    {
        NSString *str_event_name = [Total_QT_arr valueForKey:@"_Event"];
        book_cell.LBL_event_name.text = str_event_name;
        NSString *str_code = [NSString stringWithFormat:@"%@",[Total_QT_arr valueForKey:@"_confirmationCode"]];
        NSString *str_confirm_code = [NSString stringWithFormat:@"Confirmation code %@",str_code];
        
        if ([book_cell.LBL_confirmation_code respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:book_cell.LBL_confirmation_code.textColor,
                                      NSFontAttributeName:book_cell.LBL_confirmation_code.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:str_confirm_code attributes:attribs];
            
            
            
            NSRange ename = [str_confirm_code rangeOfString:str_code];
            [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                    range:ename];
            
            book_cell.LBL_confirmation_code.attributedText = attributedText;
        }
        else
        {
            book_cell.LBL_confirmation_code.text = str_confirm_code;
        }
        
        
        NSString *img_url = [Total_QT_arr valueForKey:@"_eventImageURL"];
       // img_url = [img_url stringByReplacingOccurrencesOfString:@"http" withString:@"https"];
        [book_cell.IMG_item_name sd_setImageWithURL:[NSURL URLWithString:img_url]
                                   placeholderImage:[UIImage imageNamed:@"upload-8.png"]
                                            options:SDWebImageRefreshCached];
        
        NSString *str_theatre = [NSString stringWithFormat:@"Ticketname: %@",[Total_QT_arr valueForKey:@"_TicketName"]];
        book_cell.LBL_theatre.text = str_theatre;
        
        NSString *str_timings = [NSString stringWithFormat:@"Eventdate: %@",[Total_QT_arr valueForKey:@"_eventDate"]];
        book_cell.LBL_timings.text = str_timings;
        
        NSString *str_seats = [NSString stringWithFormat:@"Total Seats::%@",[Total_QT_arr valueForKey:@"_seatsCount"]];
        CGSize result = [[UIScreen mainScreen] bounds].size;
        if(result.height <= 480)
        {
            [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:7]];
            
        }
        else if(result.height <= 568)
        {
            [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:12]];
        }
        else
        {
            [book_cell.LBL_seats setFont:[UIFont systemFontOfSize:12]];
        }
        

        book_cell.LBL_seats.text = str_seats;
        NSString *str_amount = [NSString stringWithFormat:@"%@ %@",[Total_QT_arr valueForKey:@"_total_Cost"],[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"]];
        
        NSString *str_AMT = @"Total Amount:";
        
        
        NSString *total_amount = [NSString stringWithFormat:@"%@ %@",str_amount,str_AMT];
        
        if ([book_cell.LBL_total_amount respondsToSelector:@selector(setAttributedText:)]) {
            
            NSDictionary *attribs = @{
                                      NSForegroundColorAttributeName:book_cell.LBL_total_amount.textColor,
                                      NSFontAttributeName:book_cell.LBL_total_amount.font
                                      };
            NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:total_amount attributes:attribs];
            
            
            
            NSRange ename = [total_amount rangeOfString:str_AMT];
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:8.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
                
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:ename];
                
            }
            
            
            
            
            NSRange enames = [total_amount rangeOfString:str_amount];
            if(result.height <= 480)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:8.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
            }
            else if(result.height <= 568)
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:12.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
                
            }
            else
            {
                [attributedText setAttributes:@{NSFontAttributeName:[UIFont fontWithName:@"Poppins-Medium" size:15.0],NSForegroundColorAttributeName:[UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0]}
                                        range:enames];
                
            }
            
            book_cell.LBL_total_amount.attributedText = attributedText;
        }
        else
        {
            book_cell.LBL_total_amount.text = total_amount;
        }

    }
    }
    @catch(NSException *exception)
    {
        
    }

    return book_cell;

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewAutomaticDimension;
}
-(CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 10;
}

-(void) addSEgmentedControl
{
    self.segmentedControl4 = [[HMSegmentedControl alloc] initWithFrame:_VW_segment.frame];
    CGRect frame = self.segmentedControl4.frame;
    frame.size.width = self.navigationController.navigationBar.frame.size.width;
    self.segmentedControl4.frame = frame;
    
    
    
    self.segmentedControl4.sectionTitles = @[@" Movies  ",@" Events "];
  
    
    self.segmentedControl4.backgroundColor = [UIColor clearColor];
    self.segmentedControl4.titleTextAttributes = @{NSForegroundColorAttributeName : [UIColor blackColor],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15]};
    self.segmentedControl4.selectedTitleTextAttributes = @{NSForegroundColorAttributeName : [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0],NSFontAttributeName:[UIFont fontWithName:@"Poppins-Regular" size:15]};
    self.segmentedControl4.selectionIndicatorColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
    //    self.segmentedControl4.selectionIndicatorColor
    self.segmentedControl4.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    self.segmentedControl4.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    self.segmentedControl4.selectionIndicatorHeight = 2.0f;
    
    
    [self.segmentedControl4 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    
    [self.view addSubview:self.segmentedControl4];
}
- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl4
{
    if(segmentedControl4.selectedSegmentIndex == 0)
    {
//        VW_overlay.hidden = NO;
//        [activityIndicatorView startAnimating];
        [Helper_activity animating_images:self];
        [self performSelector:@selector(movies_VIEW) withObject:nil afterDelay:0.01];
        
        _TBL_bookings.hidden = YES;
        [_TBL_bookings reloadData];
        not_found_image.hidden= YES;
    }
    else
    {
        not_found_image.hidden= YES;
        [Helper_activity animating_images:self];

        [self performSelector:@selector(event_VIEW) withObject:nil afterDelay:0.01];
        _TBL_bookings.hidden = YES;
        [_TBL_bookings reloadData];
        
    }
}
-(void)booking_API
{
    @try
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"userdata"];
        NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"id"]];

        NSString *id_user = user_id;
        NSDictionary *parameters = @{
                                     @"user_id": id_user
                                    };
        NSError *error;
        NSError *err;
        NSHTTPURLResponse *response = nil;
        
        NSData *postData = [NSJSONSerialization dataWithJSONObject:parameters options:NSASCIIStringEncoding error:&err];
        NSLog(@"the posted data is:%@",parameters);
        NSString *urlGetuser =[NSString stringWithFormat:@"%@apis/mybookings.json",SERVER_URL];
        // urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
        [request setURL:urlProducts];
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:postData];
        //[request setAllHTTPHeaderFields:headers];
        [request setHTTPShouldHandleCookies:NO];
        NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
        if(aData)
        {
//            [activityIndicatorView stopAnimating];
//            VW_overlay.hidden = YES;
           
           json_DATA = (NSMutableDictionary *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
            NSLog(@"The response Api post sighn up API %@",json_DATA);
            
           
            @try
            {
                if([[json_DATA valueForKey:@"mbookid"] isKindOfClass:[NSNull class]])
                {
                    
                    
                    [Helper_activity stop_activity_animation:self];
                    _VW_empty.hidden = NO;
                    _VW_segment.hidden = YES;
                    _TBL_bookings.hidden = YES;

                }
                
            else if([[json_DATA valueForKey:@"mbookid"] isEqualToString:@"<null>"] || [[json_DATA valueForKey:@"mbookid"] isEqualToString:@""])
            {
                _VW_empty.hidden = NO;
                _VW_segment.hidden = YES;
                _TBL_bookings.hidden = YES;
                
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No Bookings found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                [alert show];
                
                [Helper_activity stop_activity_animation:self];


            }
            else
            {
                [self movies_VIEW];
                _VW_empty.hidden = YES;
                _VW_segment.hidden = NO;
               // _TBL_bookings.hidden = NO;
                self.segmentedControl4.selectedSegmentIndex = 0;
                [self segmentedControlChangedValue:self.segmentedControl4];
                [Helper_activity stop_activity_animation:self];



                
            }
            }
            @catch(NSException *Exception)
            {
                
            }
            
        }
        else
        {
//            [activityIndicatorView stopAnimating];
//            VW_overlay.hidden = YES;
             [Helper_activity stop_activity_animation:self];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Failed" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
            [alert show];
        }
        
    }
    
    @catch(NSException *exception)
    {
        [Helper_activity stop_activity_animation:self];
        NSLog(@"The error is:%@",exception);
//        [activityIndicatorView stopAnimating];
//        VW_overlay.hidden = YES;
    }
    

}
-(void)movies_VIEW
{
    //https://api.q-tickets.com/V2.0/bookingconfirmaionmovie?booking_id=2129581,2129578,2129571,2129570,21...
//https://api.q-tickets.com/V2.0/bookingconfirmaionmovie?booking_id=A2540996,A2541003,2541061,2541119

    
    Total_QT_arr = [[NSMutableArray alloc]init];
        @try {
            
            NSString *unfilteredString =[json_DATA valueForKey:@"mbookid"];
            if([unfilteredString isKindOfClass:[NSNull class]])
            {
                 [Helper_activity stop_activity_animation:self];
                _TBL_bookings.hidden = YES;
                _VW_empty.hidden = NO;
                _VW_segment.hidden = YES;
                _TBL_bookings.hidden = YES;
            }
           
            else{
            NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@",1234567890"] invertedSet];
            NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
            
            NSLog (@"Result: %@", resultString);
            NSMutableString *data = [NSMutableString stringWithString:resultString];
            [data deleteCharactersInRange:NSMakeRange(0, 1)];

            NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/bookingconfirmaionmovie?booking_id=%@",data];
        
            
            
            NSURL *URL = [[NSURL alloc] initWithString:str_url];
            NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
                       NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
            if([[xmlDoc valueForKey:@"_status"] isEqualToString:@"true"])
            {
                [Helper_activity stop_activity_animation:self];

                Total_QT_arr =[xmlDoc valueForKey:@"bookinghistory"];
              // [Total_QT_arr addObject:[xmlDoc valueForKey:@"bookinghistory"]];
                _TBL_bookings.delegate = self;
                _TBL_bookings.dataSource = self;
                [_TBL_bookings reloadData];
                  _TBL_bookings.hidden = NO;
                NSString *str_err = [NSString stringWithFormat:@"%@",[[xmlDoc valueForKey:@"result"] valueForKey:@"_errorcode"]];
            
                
                if([[[xmlDoc valueForKey:@"result"] valueForKey:@"_errorcode"] isEqualToString:str_err] || [[[xmlDoc valueForKey:@"result"] valueForKey:@"_errorcode"] isEqualToString:@"<null>"])
                {
                   
                    _TBL_bookings.hidden = YES;
                    _VW_empty.hidden = NO;
                    _VW_segment.hidden = YES;
                    _TBL_bookings.hidden = YES;
                    

                }
                else
                {
                    _VW_empty.hidden = YES;
                    _VW_segment.hidden = NO;
                    _TBL_bookings.hidden = NO;

                }

                
            }
            else{
              [Helper_activity stop_activity_animation:self];
                _TBL_bookings.hidden = YES;
                _VW_empty.hidden = NO;
                _VW_segment.hidden = YES;
                _TBL_bookings.hidden = YES;

//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"No bookings Found" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
//                [alert show];

            }
            }
            
             }
        @catch(NSException *exception)
        {
            [Helper_activity stop_activity_animation:self];

            NSLog(@"exception");
            
        }
        
   
}
-(void)event_VIEW
{
    Total_QT_arr = [[NSMutableArray alloc]init];

   
       // https://api.q-tickets.com/V2.0/bookingconfirmaionevents?booking_id=897694,897693,897690,897689,897688
        
        NSString *unfilteredString =[json_DATA valueForKey:@"ebookid"];
        if([unfilteredString isKindOfClass:[NSNull class]])
        {
            [Helper_activity stop_activity_animation:self];
            _TBL_bookings.hidden = YES;
            _VW_empty.hidden = NO;
            _VW_segment.hidden = YES;
            _TBL_bookings.hidden = YES;
            
        }
        else{
            
         @try {
        NSCharacterSet *notAllowedChars = [[NSCharacterSet characterSetWithCharactersInString:@",1234567890"] invertedSet];
        NSString *resultString = [[unfilteredString componentsSeparatedByCharactersInSet:notAllowedChars] componentsJoinedByString:@""];
        
        NSLog (@"Result: %@", resultString);
        NSMutableString *data = [NSMutableString stringWithString:resultString];
        [data deleteCharactersInRange:NSMakeRange(0, 1)];

        NSString *str_url = [NSString stringWithFormat:@"https://api.q-tickets.com/V2.0/bookingconfirmaionevents?booking_id=%@",data];
        
        
        NSURL *URL = [[NSURL alloc] initWithString:str_url];
        NSString *xmlString = [[NSString alloc] initWithContentsOfURL:URL encoding:NSUTF8StringEncoding error:NULL];
        NSDictionary *xmlDoc = [NSDictionary dictionaryWithXMLString:xmlString];
        if(xmlDoc)
        {
           [Helper_activity stop_activity_animation:self];

           // Total_QT_arr = [xmlDoc valueForKey:@"bookinghistory"];
            Total_QT_arr =[[xmlDoc valueForKey:@"BookingHistories"] valueForKey:@"bookinghistory"];
            _TBL_bookings.delegate = self;
            _TBL_bookings.dataSource = self;
             [_TBL_bookings reloadData];
            _TBL_bookings.hidden = NO;
            NSString *str_err = [NSString stringWithFormat:@"%@",[[xmlDoc valueForKey:@"result"] valueForKey:@"_errorcode"]];

                if([[[xmlDoc valueForKey:@"result"] valueForKey:@"_errorcode"] isEqualToString:str_err] || [[[xmlDoc valueForKey:@"result"] valueForKey:@"_errorcode"] isEqualToString:@"<null>"])
            {
               
                _TBL_bookings.hidden = YES;
                _VW_empty.hidden = NO;
                _VW_segment.hidden = YES;
                _TBL_bookings.hidden = YES;


            
            }
            else
            {
                _TBL_bookings.hidden = NO;
                _VW_empty.hidden = YES;
                _VW_segment.hidden = NO;
                _TBL_bookings.hidden = NO;

            }

            
        }
        else{
            [Helper_activity stop_activity_animation:self];
            _TBL_bookings.hidden = YES;
            _VW_empty.hidden = NO;
            _VW_segment.hidden = YES;
            _TBL_bookings.hidden = YES;
            

           
            
        }
        
    }
    @catch(NSException *exception)
    {
        [Helper_activity stop_activity_animation:self];

        NSLog(@"exception");
        
    }
    
    }
    
}
- (IBAction)back_ACTION:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (IBAction)home_action:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
