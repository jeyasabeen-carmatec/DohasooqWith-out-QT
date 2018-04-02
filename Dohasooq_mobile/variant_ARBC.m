//
//  variant_ARBC.m
//  Dohasooq_mobile
//
//  Created by jeya sabeen on 16/03/18.
//  Copyright © 2018 Test User. All rights reserved.
//

#import "variant_ARBC.h"

@implementation variant_ARBC

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        //return CGRectMake(bounds.size.width - 10  ,bounds.origin.y ,bounds.origin.y- bounds.size.width -5, bounds.size.height);
        return CGRectMake(bounds.size.width-30, bounds.origin.y, bounds.size.width-10, bounds.size.height);
        
    }
    else
    {
        return CGRectMake(10, bounds.origin.y, bounds.size.width-5, bounds.size.height);
        
    }
    
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        // return CGRectMake(bounds.size.width - 10  ,bounds.origin.y ,bounds.origin.y- bounds.size.width -5, bounds.size.height);
        return CGRectMake(bounds.size.width-30, bounds.origin.y, bounds.size.width, bounds.size.height);
        
        
    }
    else
    {
        return CGRectMake(10, bounds.origin.y, bounds.size.width-5, bounds.size.height);
        
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
