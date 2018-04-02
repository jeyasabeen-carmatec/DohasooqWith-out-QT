//
//  VC_filter_product_list.m
//  Dohasooq_mobile
//
//  Created by Test User on 30/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_filter_product_list.h"
#import "filter_cell.h"

@interface VC_filter_product_list ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    NSString *lower,*upper,*discount;
    NSArray *product_arr;
    
    NSMutableArray *Brands_arr_post;
    BOOL filter_val;
    
}

@end

@implementation VC_filter_product_list

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    discount = @"";
    //sortedArray = [anArray sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];

    NSArray  *Temp_arr =[[[NSUserDefaults standardUserDefaults] valueForKey:@"brands_LISTs"] allObjects];
    product_arr = [Temp_arr sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    NSLog(@"THE userdefaults%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"brands_LIST"]);
    
      CGRect framset = _VW_contents.frame;
    framset.size.height = _BTN_submit.frame.origin.y + _BTN_submit.frame.size.height;
    framset.size.width = _scroll_contents.frame.size.width;
    _VW_contents.frame = framset;
    [self.scroll_contents addSubview:_VW_contents];
    Brands_arr_post  = [[NSMutableArray alloc]init];
    
    
    
    
    @try
    {
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"max_min"];
        NSString *min = [NSString stringWithFormat:@"%@",[dict valueForKey:@"min"]];
        NSString *max =[NSString stringWithFormat:@"%@",[dict valueForKey:@"max"]];
        
//        if ([max isEqualToString:min]) {
//            
//            
//            min = @"0";
//        }
        
        
        
        
        max = [max stringByReplacingOccurrencesOfString:@"<nil>" withString:@"10"];
        max = [max stringByReplacingOccurrencesOfString:@"<null>" withString:@"10"];
        
//        if ([max isEqualToString:@"1"]) {
//            
//            max = @"10";
//        }
        // max = [max stringByReplacingOccurrencesOfString:@"0" withString:@"10"];
        
        _LBL_slider.trackColor =[UIColor colorWithRed:1.00 green:0.98 blue:0.80 alpha:1.0];
        
//        _LBL_slider.stepSize = 1;
        // Set color for highlighted section of the slider track
        _LBL_slider.trackHighlightColor =[UIColor colorWithRed:0.92 green:0.66 blue:0.27 alpha:1.0];
        // Set height of slider track
        _LBL_slider.trackHeight = 8.0;
        _LBL_slider.stepSize = 0.1;
        
        
        @try
        {
            
            
            min = [min stringByReplacingOccurrencesOfString:@"<nil>" withString:@"0"];
            min = [min stringByReplacingOccurrencesOfString:@"<null>" withString:@"0"];
            
            self.LBL_slider.minValue = [min floatValue];
            self.LBL_slider.maxValue = [max floatValue];
            
            self.LBL_slider.lowerValue = [min floatValue];
            self.LBL_slider.upperValue = [max floatValue];
            
            
            lower = [NSString stringWithFormat:@"%d",(int)self.LBL_slider.lowerValue];
            upper = [NSString stringWithFormat:@"%d",(int)self.LBL_slider.upperValue];
        }
        @catch(NSException *exceprtion)
        {
            
        }
        
        
        //self.LBL_slider.minimumRange = 1;
        
        
        
        @try {
            
            self.LBL_max.text = [NSString stringWithFormat:@"Max %@ %d",[[NSUserDefaults standardUserDefaults] valueForKey:@"currency"], (int)self.LBL_slider.maxValue];
            self.LBL_min.text = [NSString stringWithFormat:@"Min %@ %d", [[NSUserDefaults standardUserDefaults] valueForKey:@"currency"],(int)self.LBL_slider.minValue];
            NSLog(@"%@ /n %@",lower,upper);
        } @catch (NSException *exception) {
            NSLog(@"%@",exception);
        }
        
        
    }
    @catch(NSException *exception)
    {
        
    }
    [_BTN_submit addTarget:self action:@selector(submit_ACTION) forControlEvents:UIControlEventTouchUpInside];
        
    
    _BTN_ten.tag = 1;
    _BTN_twenty.tag = 1;
    _BTN_thirty.tag = 1;
    _BTN_forty.tag = 1;
    _BTN_fifty.tag = 1;
    _BTN_check.tag = 1;
    
    [_collection_produtcs reloadData];
    
    framset = _collection_produtcs.frame;
    framset.size.height =  _collection_produtcs.collectionViewLayout.collectionViewContentSize.height;
    framset.size.width = _Vw_line1.frame.size.width;
    _collection_produtcs.frame = framset;
    
    framset = _Vw_line1.frame;
    framset.origin.y = _collection_produtcs.frame.origin.y + _collection_produtcs.frame.size.height + 5;
    _Vw_line1.frame = framset;
    
    framset = _VW_radio.frame;
    framset.origin.y = _Vw_line1.frame.origin.y + _Vw_line1.frame.size.height + 5;
    _VW_radio.frame = framset;
    framset = _BTN_submit.frame;
    framset.origin.y = _VW_radio.frame.origin.y + _VW_radio.frame.size.height;
    _BTN_submit.frame = framset;
    
    framset = _VW_contents.frame;
    framset.size.width = _VW_contents.frame.size.width;
    framset.size.height = _BTN_submit.frame.origin.y + _BTN_submit.frame.size.height;
    _VW_contents.frame = framset;
    
    framset = _IMG_back_ground.frame;
    framset.size.width = _VW_contents.frame.size.width;
    framset.size.height = _scroll_contents.frame.origin.y + _scroll_contents.frame.size.height;
    _IMG_back_ground.frame = framset;
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
}

-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [_scroll_contents layoutIfNeeded];
    _scroll_contents.contentSize = CGSizeMake(_scroll_contents.frame.size.width,_VW_contents.frame.origin.y + _VW_contents.frame.size.height);
    
}

- (IBAction)labelSliderChanged:(CCRangeSlider*)sender
{
    lower = [NSString stringWithFormat:@"%d",(int)self.LBL_slider.lowerValue];
    upper = [NSString stringWithFormat:@"%d",(int)self.LBL_slider.upperValue];
    self.LBL_max.text = [NSString stringWithFormat:@"Max QAR %d", (int)self.LBL_slider.upperValue];
    self.LBL_min.text = [NSString stringWithFormat:@"Min QAR %d", (int)self.LBL_slider.lowerValue];
    
    
}
-(IBAction)back_action:(id)sender {
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)submit_ACTION
{
    NSUserDefaults *user_dflts = [NSUserDefaults standardUserDefaults];

    NSString *country = [user_dflts valueForKey:@"country_id"];
    NSString *languge = [user_dflts valueForKey:@"language_id"];
    NSDictionary *dict = [user_dflts valueForKey:@"userdata"];
    NSString *min = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"min"]];
    NSString *max = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"max"]];
    NSString *range = [NSString stringWithFormat:@"%@,%@",min,max];
    [[NSUserDefaults standardUserDefaults] setValue:range  forKey:@"Range_val"];
    [[NSUserDefaults standardUserDefaults] synchronize];

    NSString *brands = [Brands_arr_post componentsJoinedByString:@","];

    NSString *user_id = [NSString stringWithFormat:@"%@",[dict valueForKey:@"customer_id"]];

    
    NSString *url_str = [NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json?discountValue=%@ &range=%@,%@&brand=%@&sortKeyword=",SERVER_URL,[[NSUserDefaults standardUserDefaults]valueForKey:@"product_list_key"],country,languge,user_id,discount,min,max,brands];
    url_str = [url_str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    url_str = [url_str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    
    [[NSUserDefaults standardUserDefaults] setValue:brands forKey:@"brnds"];
    [[NSUserDefaults standardUserDefaults] setValue:discount forKey:@"discount_val"];
    [[NSUserDefaults standardUserDefaults] setValue:url_str forKey:@"product_list_url_filter"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self.delegate filetr_URL:url_str];

    [self.navigationController popViewControllerAnimated:NO];

  
    
    
    
    NSLog(@"the filter_ticked");
}

- (IBAction)tenabove:(id)sender
{
    if(_BTN_ten.tag == 1)
    {
        [_BTN_ten setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_twenty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_thirty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_forty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_fifty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_ten.tag = 0;
        discount = @"10";

    }
    else
    {
        [_BTN_ten setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_ten.tag = 1;
        _BTN_twenty.tag = 1;
        _BTN_thirty.tag = 1;
        _BTN_forty.tag = 1;
        _BTN_fifty.tag = 1;
        
    }
}
- (IBAction)twentyabove:(id)sender {
    
    if(_BTN_twenty.tag == 1)
    {
        [_BTN_twenty setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_ten setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_thirty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_forty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_fifty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_twenty.tag = 0;
        discount = @"20";
        
    }
    else
    {
        [_BTN_twenty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_twenty.tag = 1;
        _BTN_ten.tag = 1;
        _BTN_thirty.tag = 1;
        _BTN_forty.tag = 1;
        _BTN_fifty.tag = 1;
        
    }

}
- (IBAction)thirtyabove:(id)sender {
    
    if(_BTN_thirty.tag == 1)
    {
        [_BTN_thirty setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_ten setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_twenty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_forty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_fifty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_thirty.tag = 0;
        discount = @"30";
        
    }
    else
    {
        [_BTN_thirty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_thirty.tag = 1;
        _BTN_twenty.tag = 1;
        _BTN_ten.tag = 1;
        _BTN_forty.tag = 1;
        _BTN_fifty.tag = 1;

        
        
    }

}
- (IBAction)fortyabove:(id)sender {
    if(_BTN_forty.tag == 1)
    {
        [_BTN_forty setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_ten setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_twenty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_thirty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        [_BTN_fifty setImage:[UIImage imageNamed:@"radio"] forState:UIControlStateNormal];
        _BTN_forty.tag = 0;
        discount = @"40";
        
    }
    else
    {
        [_BTN_forty setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_forty.tag = 1;
        _BTN_thirty.tag = 1;
        _BTN_twenty.tag = 1;
        _BTN_ten.tag = 1;
        _BTN_fifty.tag = 1;
        
    }

}
- (IBAction)fiftyabove:(id)sender {
    
    if(_BTN_fifty.tag == 1)
    {
        [_BTN_fifty setImage:[UIImage imageNamed:@"radiobtn-2"] forState:UIControlStateNormal];
        [_BTN_ten setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_twenty setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_thirty setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        [_BTN_forty setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_fifty.tag = 0;
        discount = @"50";
        
    }
    else
    {
        [_BTN_fifty setImage:[UIImage imageNamed:@"radio_unSlt"] forState:UIControlStateNormal];
        _BTN_fifty.tag = 1;
        _BTN_forty.tag = 1;
        _BTN_thirty.tag = 1;
        _BTN_twenty.tag = 1;
        _BTN_ten.tag = 1;
        
    }

}

#pragma collection arguments

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return product_arr.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    filter_cell *cell = (filter_cell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.LBL_name.text = [product_arr objectAtIndex:indexPath.row];
    cell.BTN_check.tag = indexPath.row;
    [cell.BTN_check addTarget:self action:@selector(check_action:) forControlEvents:UIControlEventTouchUpInside];

    
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.collection_produtcs.bounds.size.width/2.2, 50);
}
-(void)check_action:(UIButton *)sender
{
    NSIndexPath *index = [NSIndexPath indexPathForRow:sender.tag inSection:0];
    filter_cell *cell = (filter_cell *)[self.collection_produtcs cellForItemAtIndexPath:index];
    
    NSData *data1 = UIImagePNGRepresentation(cell.IMG_check.image);
    NSData *data2 = UIImagePNGRepresentation([UIImage imageNamed:@"uncheked_order"]);
    NSDictionary *dict = [[NSUserDefaults standardUserDefaults] valueForKey:@"brands_LISTs"];
     NSString *temp_str;
    for(int i = 0;i<dict.count;i++)
    {
        if([[product_arr objectAtIndex:sender.tag] isEqualToString:[[dict allValues] objectAtIndex:i]])
        {
            temp_str = [NSString stringWithFormat:@"%@",[[dict allKeys] objectAtIndex:i]];
        }
    }
   //= [[product_arr allKeys] objectAtIndex:sender.tag];

    if([data1 isEqual:data2])
    {
        cell.IMG_check.image = [UIImage imageNamed:@"checkbox_select.png"];
        
        [Brands_arr_post addObject:temp_str];
        
      
    }
    else
    {
        cell.IMG_check.image = [UIImage imageNamed:@"uncheked_order"];

        for(int i = 0; i < Brands_arr_post.count;i++)
        {
            if([temp_str intValue] == [[Brands_arr_post objectAtIndex:i] intValue])
            {
                [Brands_arr_post removeObjectAtIndex:i];
            }
        }

    }
    
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
