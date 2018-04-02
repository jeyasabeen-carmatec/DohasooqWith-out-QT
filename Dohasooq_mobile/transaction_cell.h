//
//  transaction_cell.h
//  Dohasooq_mobile
//
//  Created by Carmatec on 08/01/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface transaction_cell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *LBL_amount;
@property(nonatomic,weak) IBOutlet UILabel *LBL_paymen_method;
@property(nonatomic,weak) IBOutlet UILabel *LBL_transaction_Id;
@property(nonatomic,weak) IBOutlet UILabel *LBL_payment_response;
@property(nonatomic,weak) IBOutlet UIView *VW_layer;


@end
