//
//  TXT_Blck_VS_field.m
//  
//
//  Created by Carmatec on 06/01/18.
//
//

#import "TXT_Blck_VS_field.h"

@implementation TXT_Blck_VS_field


- (CGRect)editingRectForBounds:(CGRect)bounds {
    if([[[NSUserDefaults standardUserDefaults] valueForKey:@"story_board_language"] isEqualToString:@"Arabic"])
    {
        return CGRectMake(bounds.size.width - 10  ,bounds.origin.y ,bounds.origin.y- bounds.size.width -5, bounds.size.height);
        //return CGRectMake(10, bounds.origin.y, bounds.size.width-5, bounds.size.height);
        
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
         return CGRectMake(bounds.size.width - 10  ,bounds.origin.y ,bounds.origin.y- bounds.size.width -5, bounds.size.height);
        //return CGRectMake(10, bounds.origin.y, bounds.size.width-5, bounds.size.height);
        
        
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
