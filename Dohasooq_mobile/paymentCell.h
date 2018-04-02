//
//  TableViewCell.h
//  Dohasooq_mobile
//
//  Created by Carmatec on 08/01/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface paymentCell : UITableViewCell
@property(nonatomic,weak) IBOutlet UILabel *LBL_order_status;
@property(nonatomic,weak) IBOutlet UILabel *LBL_paymen_status;
@property(nonatomic,weak) IBOutlet UILabel *LBL_notes;
@property(nonatomic,weak) IBOutlet UIView *VW_layer;


@end
