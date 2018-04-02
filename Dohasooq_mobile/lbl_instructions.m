//
//  lbl_instructions.m
//  Dohasooq_mobile
//
//  Created by anumolu mac mini on 06/02/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import "lbl_instructions.h"

@implementation lbl_instructions

//-(CGRect)textRectForBounds:(CGRect)bounds {
//    return CGRectMake(bounds.origin.x + 10, bounds.origin.y , bounds.size.width - 20, bounds.size.height - 10);
//}

//-(CGRect)alignmentRectForFrame:(CGRect)frame
//{
//    return CGRectMake(frame.origin.x + 10, frame.origin.y + 10 , frame.size.width - 20, frame.size.height - 20);
//}

- (void)drawTextInRect:(CGRect)rect {
    UIEdgeInsets insets = {0, 0, 0, 0};
    
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
         [super drawTextInRect:UIEdgeInsetsInsetRect(CGRectMake(rect.size.width - 20, rect.origin.y + 10 , rect.size.width - 40, rect.size.height - 20), insets)];

    }
    else{
    [super drawTextInRect:UIEdgeInsetsInsetRect(CGRectMake(rect.origin.x + 20, rect.origin.y + 10 , rect.size.width - 40, rect.size.height - 20), insets)];
    }
}

@end
