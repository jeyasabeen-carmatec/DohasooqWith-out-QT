//
//  VC_product_search.m
//  Dohasooq_mobile
//
//  Created by Test User on 14/12/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_product_search.h"
#import "HttpClient.h"
#import "Helper_activity.h"
#import "search_Cell_products.h"

@interface VC_product_search ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
{
    NSArray *search_ARR;;
    NSArray *search_arr;
    NSString *lower,*upper,*discount;
    NSMutableArray *search_total_PRODUCT_ARR;
    
    
}
@end

@implementation VC_product_search

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.screenName = @"Global search page";
    
    /*************************** Frame setting for Navigation bar ***************************/


    CGRect frame_nav = _VW_navMenu.frame;
    frame_nav.origin.x = 0.0f;
    frame_nav.size.width = self.navigationController.navigationBar.frame.size.width - _BTN_search.frame.size.width;
    _VW_navMenu.frame = frame_nav;
    
    frame_nav = _TXT_search.frame;
    frame_nav.size.width = _VW_navMenu.frame.size.width - _BTN_search.frame.size.width- _BTN_close.frame.size.width;
    _TXT_search.frame = frame_nav;
    
    frame_nav = _BTN_search.frame;
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
         frame_nav.origin.x = _TXT_search.frame.origin.x- _BTN_search.frame.size.width-2;
    }
    else
    {
         frame_nav.origin.x = _TXT_search.frame.size.width - _BTN_search.frame.size.width-2;
    }
   // frame_nav.origin.x = _TXT_search.frame.size.width - _BTN_search.frame.size.width-2;
    _BTN_search.frame =  frame_nav;
   //  _TBL_search_results.hidden = YES;
    
    _TXT_search.delegate = self;
    [_BTN_close addTarget:self action:@selector(Close_Action) forControlEvents:UIControlEventTouchUpInside];
    [_TXT_search addTarget:self action:@selector(search_API) forControlEvents:UIControlEventEditingChanged];
    [_BTN_search addTarget:self action:@selector(search_API_ALL) forControlEvents:UIControlEventTouchUpInside];
    _BTN_search.tag = 1;
    
    /*************************** Frame setting for Empty view ***************************/

    CGRect frameset = _VW_empty.frame;
    frameset.size.width = 200;
    frameset.size.height = 200;
    _VW_empty.frame = frameset;
    _VW_empty.center = self.view.center;
    [self.view addSubview:_VW_empty];
    _VW_empty.hidden = YES;
    
    _BTN_empty.layer.cornerRadius = self.BTN_empty.frame.size.width / 2;
    _BTN_empty.layer.masksToBounds = YES;
    
    [Helper_activity animating_images:self];
    [self performSelector:@selector(search_DATA) withObject:nil afterDelay:0.01];




}
-(void)viewWillAppear:(BOOL)animated
{
    
    self.navigationController.navigationBar.hidden = NO;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                  forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    
    
}
-(void)Close_Action
{
    [self.navigationController popViewControllerAnimated:NO];
}
#pragma Textfield delegates

-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
#pragma Table view delegate methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
        return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [search_ARR  count];
  
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    search_Cell_products *cell = (search_Cell_products *)[tableView dequeueReusableCellWithIdentifier:@"search_cell"];
    
    if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"search_Cell_products" owner:self options:nil];
        cell = [nib objectAtIndex:0];
      
    }
    
         cell.LBL_item_name.text = [NSString stringWithFormat:@"%@",
                               [[search_ARR objectAtIndex:indexPath.row] valueForKey:@"name"]];
    
    
    
    NSString *str = cell.LBL_item_name.text;
      str  =[str stringByReplacingOccurrencesOfString:@"<null>" withString:@""];
    str  =[str stringByReplacingOccurrencesOfString:@"(null)" withString:@""];
    
    cell.LBL_item_name.text = str;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        cell.LBL_item_name.textAlignment= NSTextAlignmentRight;
    }
    

    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
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
    /*************************** Preparing the url ***************************/

    NSString *url_key= [NSString stringWithFormat:@"%@",[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"name"]];
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    NSString *list_TYPE = @"productList";
    
    NSString *str_key = [NSString stringWithFormat:@"%@/txt_%@/0",list_TYPE,[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"name"]];
    [[NSUserDefaults standardUserDefaults] setValue:str_key forKey:@"product_list_key"];
    

    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/txt_%@/0/%@/%@/%@/Customer/1.json",SERVER_URL,list_TYPE,url_key,country,languge,user_id];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setValue:[[search_ARR objectAtIndex:indexPath.row] valueForKey:@"title"] forKey:@"item_name"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    

    [self performSegueWithIdentifier:@"search_product_list" sender:self];
      
    
}
#pragma calling the api while loading the page

-(void)search_DATA
{
    search_total_PRODUCT_ARR = [[NSMutableArray alloc]init];;
    @try
    {
    NSError *error;
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
       NSString *list_TYPE = @"productNamesList";
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@.json",SERVER_URL,list_TYPE,country,languge];
    
    NSHTTPURLResponse *response = nil;
    //   Languages/getLangByCountry/"+countryid+".json
    NSURL *urlProducts=[NSURL URLWithString:urlGetuser];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:urlProducts];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    // [request setHTTPBody:postData];
    //[request setAllHTTPHeaderFields:headers];
    [request setHTTPShouldHandleCookies:NO];
    NSData *aData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    if(aData)
    {
        [Helper_activity stop_activity_animation:self];
        search_total_PRODUCT_ARR  = (NSMutableArray *)[NSJSONSerialization JSONObjectWithData:aData options:NSASCIIStringEncoding error:&error];
       // search_ARR = [dictin valueForKey:@"products"];
        
        
    }
    else
    {
           [Helper_activity stop_activity_animation:self];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
        [alert show];
    }
        
}

@catch(NSException *exception)
{
       [Helper_activity stop_activity_animation:self];
    NSLog(@"The error is:%@",exception);
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Connection Error" delegate:self cancelButtonTitle:nil otherButtonTitles:@"Ok", nil];
    [alert show];
    
   
    
}


}
#pragma search the string from textfield when press the search button

-(void)search_API_ALL

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
    
    if(_TXT_search.text.length > 1)
    {
        _BTN_search.tag = 0;
        NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
        NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
        NSString *list_TYPE = @"productList";
        NSString *str_key = [NSString stringWithFormat:@"%@/txt_%@/0",list_TYPE,_TXT_search.text];
        [[NSUserDefaults standardUserDefaults] setValue:str_key forKey:@"product_list_key"];
        
        NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/txt_%@/0/%@/%@/%@/Customer/1.json",SERVER_URL,list_TYPE,_TXT_search.text,country,languge,user_id];
        urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
        
        [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        // [[NSUserDefaults standardUserDefaults] synchronize];
        
        
        [self performSegueWithIdentifier:@"search_product_list" sender:self];
    }
    else
    {
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"Please enter a keyword to search for products" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
        [alert show];
        
        
        
    }
    
    
    
    
    
}
#pragma Search The data while Typing the Letters in the page

-(void)search_API
{
    
    
    NSString *substring = [NSString stringWithString:_TXT_search.text];
    
    NSArray *arr = [search_total_PRODUCT_ARR mutableCopy];
    
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF['name'] BEGINSWITH[c] %@",substring];
    
    search_ARR = [arr filteredArrayUsingPredicate:predicate];//BEGINSWITH//CONTAINS
    if(search_ARR.count < 1)
    {
        _TBL_search_results.hidden = YES;
    }
    else{
        _TBL_search_results.hidden =NO;
        NSSortDescriptor *sortByName = [NSSortDescriptor sortDescriptorWithKey:@"name"
                                                                     ascending:YES];
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortByName];
        NSArray *sortedArray = [search_ARR sortedArrayUsingDescriptors:sortDescriptors];
        
        search_ARR = sortedArray;
        
        [_TBL_search_results reloadData];
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
