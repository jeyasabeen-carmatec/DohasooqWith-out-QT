 //
//  VC_ub_table_view.m
//  Dohasooq_mobile
//
//  Created by Test User on 04/11/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "VC_ub_table_view.h"
#import "HttpClient.h"
#import "Helper_activity.h"
#import "categorie_cell.h"
#import "dynamic_categirie_cell.h"

@interface VC_ub_table_view ()<UITableViewDelegate,UITableViewDataSource>
{
    NSMutableArray *sub_arr;
    BOOL stat_tag;
    BOOL isTableExpanded;
}

@end

@implementation VC_ub_table_view

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    /*************************** Analitics screen name ***************************/
    self.screenName = @"Sub category screen";
    sub_arr = [[NSMutableArray alloc]init];
    isTableExpanded=NO;
    
#pragma Empty View Frame
    
    CGRect frameset = _VW_empty.frame;
    frameset.size.width = 200;
    frameset.size.height = 200;
    _VW_empty.frame = frameset;
    _VW_empty.center = self.view.center;
    [self.view addSubview:_VW_empty];
    _VW_empty.hidden = YES;
    _TBL_sub_brnds.hidden = YES;
    
    _BTN_empty.layer.cornerRadius = self.BTN_empty.frame.size.width / 2;
    _BTN_empty.layer.masksToBounds = YES;
    
  
    
    _TBL_sub_brnds.delegate = self;
    _TBL_sub_brnds.dataSource = self;
  
    [self load_DATA];
    
    /*************************** Set the data in alphabetical order ***************************/

  //  sub_arr = [[NSMutableArray alloc] init];
   /* NSMutableArray *sortedArray = [[NSMutableArray alloc]init];
    sortedArray = [[[NSUserDefaults standardUserDefaults] valueForKey:@"product_sub_list"] mutableCopy];
    NSMutableArray *arr = [NSMutableArray array];
    
    
    for (NSDictionary *item in [sortedArray valueForKey:@"child_categories"]) {
         [arr addObject:item];
        //[duplicatesRemoved addObject:item];
    }
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                 ascending:YES];
    sub_arr = [arr sortedArrayUsingDescriptors:@[sortDescriptor]];*/
   // [sub_arr  addObjectsFromArray:srt_arr];
    
}

#pragma Load the data in Table view 

-(void)load_DATA
{
    
    NSString *str_URL = [[NSUserDefaults standardUserDefaults] valueForKey:@"product_list_sub_url"];
    NSString *urlGetuser;
    urlGetuser =[NSString stringWithFormat:@"%@",str_URL];
    urlGetuser = [urlGetuser stringByReplacingOccurrencesOfString:@" " withString:@"%20"];
    [Helper_activity animating_images:self];
    
    [HttpClient postServiceCall:urlGetuser andParams:nil completionHandler:^(id  _Nullable data, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                [Helper_activity stop_activity_animation:self];
            }
              if (data)
              {
                  [Helper_activity stop_activity_animation:self];
                  sub_arr = [data mutableCopy];
                  if(sub_arr.count  < 1)
                  {
                      _VW_empty.hidden = NO;
                      _TBL_sub_brnds.hidden = YES;
                  }
                  else
                  {
                      _VW_empty.hidden = YES;
                      _TBL_sub_brnds.hidden= NO;
                  }

                  [_TBL_sub_brnds reloadData];
              }
            
            });
        }];
    

    
    
    
    [_BTN_title setTitle:[[[NSUserDefaults standardUserDefaults] valueForKey:@"item_name"] uppercaseString] forState:UIControlStateNormal];
 
}
-(void)viewWillAppear:(BOOL)animated{
    self.navigationItem.hidesBackButton = YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma Table view Delegate Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;
{
    return [sub_arr count];
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *Title;
    NSString *identifier;
    NSInteger index;
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        /*************************** For English cell ***************************/

        identifier = @"cete_cell";
        index = 1;
        
    }
    else{
        /*************************** For Arabic cell ***************************/

        identifier = @"QCate_cell";
        index = 0;
        
        
    }

    /*************************** Creation of category cell ***************************/

    dynamic_categirie_cell *cell = (dynamic_categirie_cell *)[tableView dequeueReusableCellWithIdentifier:identifier];
    
       if (cell == nil)
    {
        NSArray *nib;
        nib = [[NSBundle mainBundle] loadNibNamed:@"dynamic_categirie_cll" owner:self options:nil];
        cell = [nib objectAtIndex:index];
    }
    
    
    
    NSDictionary *d1 = [sub_arr objectAtIndex:indexPath.row] ;
    /*************************** Hiding the Button based on sub child data ***************************/

    if([[d1 valueForKey:@"sub_child"] count] > 0)
    {
        cell.LBL_arrow.alpha = 1.0;
        [cell.LBL_arrow setTitle:@"+" forState:UIControlStateNormal];
        cell.LBL_arrow.tag = indexPath.row;
        [cell.LBL_arrow addTarget:self action:@selector(showSubItems:) forControlEvents:UIControlEventTouchUpInside];
    }
    else
    {
        cell.LBL_arrow.alpha = 0.0;
    }
    
    NSDictionary *d = [[sub_arr objectAtIndex:indexPath.row] mutableCopy] ;
    NSArray *arr = [d valueForKey:@"sub_child"];
    
    for(NSDictionary *dInner in arr )
    {
        if([sub_arr indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
            [cell.LBL_arrow setTitle:@"-" forState:UIControlStateNormal];
            cell.LBL_arrow.tag = indexPath.row;
            [cell.LBL_arrow addTarget:self action:@selector(showSubItems:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    
    Title= [[sub_arr objectAtIndex:indexPath.row] valueForKey:@"name"];
    cell.LBL_name.text = Title;

    
    return cell;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)aTableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.editing == NO || !indexPath)
        return UITableViewCellEditingStyleNone;
    
    if (self.editing && indexPath.row == ([sub_arr count]))
        return UITableViewCellEditingStyleInsert;
    else
        if (self.editing && indexPath.row == ([sub_arr count]))
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
#pragma collapse the rows when press Minus Button

-(void)CollapseRows:(NSArray*)ar
{
    for(NSDictionary *dInner in ar )
    {
        NSUInteger indexToRemove=[sub_arr indexOfObjectIdenticalTo:dInner];
        NSArray *arInner=[dInner valueForKey:@"sub_child"];
        if(arInner && [arInner count]>0)
        {
            [self CollapseRows:arInner];
        }
        
        if([sub_arr indexOfObjectIdenticalTo:dInner]!=NSNotFound)
        {
            [sub_arr removeObjectIdenticalTo:dInner];
            [self.TBL_sub_brnds deleteRowsAtIndexPaths:[NSArray arrayWithObject:
                                                   [NSIndexPath indexPathForRow:indexToRemove inSection:0]
                                                   ]
                                 withRowAnimation:UITableViewRowAnimationLeft];
        }
    }
}

#pragma Show the sub Items while it have the subcategoiries

-(void)showSubItems :(UIButton *) sender
{

    UIButton *btn = (UIButton*)sender;
    CGRect buttonFrameInTableView = [btn convertRect:btn.bounds toView:self.TBL_sub_brnds];
    NSIndexPath *indexPath = [self.TBL_sub_brnds indexPathForRowAtPoint:buttonFrameInTableView.origin];
    
    dynamic_categirie_cell *cell = (dynamic_categirie_cell *)[self.TBL_sub_brnds cellForRowAtIndexPath:indexPath];
    
    
    if ([cell.LBL_arrow.titleLabel.text  isEqualToString:@"+"])
    {
        [cell.LBL_arrow setTitle:@"-" forState:UIControlStateNormal];
    }
    else
    {
        [cell.LBL_arrow setTitle:@"+" forState:UIControlStateNormal];
    }
    
    NSDictionary *d = [[sub_arr objectAtIndex:indexPath.row] mutableCopy] ;
    NSArray *arr = [d valueForKey:@"sub_child"];
    if(arr)
    {
        for(NSDictionary *subitems in arr )
        {
            NSInteger index = [sub_arr indexOfObjectIdenticalTo:subitems];
            isTableExpanded = (index>0 && index!=NSIntegerMax);
            if(isTableExpanded) break;
        }
        if(isTableExpanded)
        {
            [self CollapseRows:arr];
        }
        else
        {
            NSUInteger count = indexPath.row+1;
            NSMutableArray *arrCells=[NSMutableArray array];
            for(NSDictionary *dInner in arr )
            {
                [arrCells addObject:[NSIndexPath indexPathForRow:count inSection:0]];
                @try
                {
                [sub_arr insertObject:dInner atIndex:count++];
                    
                }
                @catch(NSException *exception)
                {
                    
                }
            }
            @try
            {
            [self.TBL_sub_brnds insertRowsAtIndexPaths:arrCells withRowAnimation:UITableViewRowAnimationLeft];
            }
            @catch(NSException *exception)
            {
                
            }
        }
    }
}

#pragma On select action for sub cateogory to move to product list

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
   // product_list_type
    
     [[NSUserDefaults standardUserDefaults] setValue:@"0" forKey:@"discount"];
     [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSString *name = [[sub_arr objectAtIndex:indexPath.row] valueForKey:@"name"];

    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"sub_name"];
    [[NSUserDefaults standardUserDefaults] setValue:name forKey:@"sub_name"];
     [[NSUserDefaults standardUserDefaults] synchronize];

    
    NSString *country = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"country_id"]];
    NSString *languge = [NSString stringWithFormat:@"%@",[[NSUserDefaults standardUserDefaults] valueForKey:@"language_id"]];
    /*************************** checking that user is logged in or NOT ***************************/

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
        
    /*************************** Preparing the url for product list  ***************************/

    
    NSString *list_TYPE = @"productList";
    NSString *url_key = [NSString stringWithFormat:@"%@/%@/0",list_TYPE,[[sub_arr objectAtIndex:indexPath.row] valueForKey:@"id"]];
    
    
    NSString * urlGetuser =[NSString stringWithFormat:@"%@apis/%@/%@/%@/%@/Customer/1.json",SERVER_URL,url_key,country,languge,user_id];
        
    [[NSUserDefaults standardUserDefaults] setValue:@"sublist" forKey:@"list_seg"];
    [[NSUserDefaults standardUserDefaults] setValue:url_key forKey:@"product_list_key"];
    [[NSUserDefaults standardUserDefaults] setValue:urlGetuser forKey:@"product_list_url"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    NSMutableDictionary *dic=[sub_arr objectAtIndex:indexPath.row];
    
    NSLog(@"Selected dict = %@",dic);
    
   
    
    [self performSegueWithIdentifier:@"sublist_product_list" sender:self];
    
}
#pragma Back Button action

- (IBAction)back_ACTIon:(id)sender
{
    [self.navigationController popViewControllerAnimated:NO];
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
