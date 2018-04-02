//
//  TXT_Blck_field.m
//  Dohasooq_mobile
//
//  Created by Test User on 23/10/17.
//  Copyright © 2017 Test User. All rights reserved.
//

#import "TXT_Blck_field.h"

@implementation TXT_Blck_field

- (CGRect)editingRectForBounds:(CGRect)bounds {
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        //return CGRectMake(bounds.size.width - 10  ,bounds.origin.y ,bounds.origin.y- bounds.size.width -5, bounds.size.height);
         return CGRectMake(10, bounds.origin.y, bounds.size.width-10, bounds.size.height);
        
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
        return CGRectMake(bounds.size.width, bounds.origin.y, bounds.size.width, bounds.size.height);

        
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
