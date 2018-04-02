//
//  HoshiTextField.m
//  CCTextFieldEffects
//
//  Created by Kelvin on 6/25/16.
//  Copyright © 2016 Cokile. All rights reserved.
//

#import "NonArabicHoshiTextField.h"
//#import "STR_ICON.h"

@interface NonArabicHoshiTextField ()

@property (strong, nonatomic) CALayer *inactiveBorderLayer;
@property (strong, nonatomic) CALayer *activeBorderLayer;
@property (nonatomic) CGPoint activePlaceholderPoint;

@end

@implementation NonArabicHoshiTextField

#pragma mark - Constants
static CGFloat const activeBorderThickness = 0.5;
static CGFloat const inactiveBorderThickness = 0.5;
static CGPoint const textFieldInsets = {0, 12};
static CGPoint const placeholderInsets = {0, 6};

#pragma mark - Custom accessorys
- (void)setBorderInactiveColor:(UIColor *)borderInactiveColor {
    _borderInactiveColor = borderInactiveColor;
    
    [self updateBorder];
    
    
}

- (void)setBorderActiveColor:(UIColor *)borderActiveColor {
    _borderActiveColor = borderActiveColor;
    
    [self updateBorder];
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    [self updatePlaceholder];
}

- (void)setPlaceholderFontScale:(CGFloat)placeholderFontScale {
    _placeholderFontScale = placeholderFontScale;
    
    [self updatePlaceholder];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    [self updatePlaceholder];
}

- (void)setBounds:(CGRect)bounds {
    [super setBounds:bounds];
    
    [self updateBorder];
    [self updatePlaceholder];
}

#pragma mark - Lifecycle
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self commonInit];
    }
    
    return self;
}

- (CGRect) leftViewRectForBounds:(CGRect)bounds {
    
    CGRect textRect = [super leftViewRectForBounds:bounds];
    textRect.origin.x -= 10;
    return textRect;
}

- (instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        [self commonInit];
        self.clipsToBounds = YES;
        
    }
    return self;
}

- (void) commonInit {
    
    self.inactiveBorderLayer = [[CALayer alloc] init];
    self.activeBorderLayer = [[CALayer alloc] init];
    self.placeholderLabel = [[UILabel alloc] init];
    
    self.borderInactiveColor = [UIColor lightGrayColor];
    self.borderActiveColor = [UIColor lightGrayColor];
    self.placeholderColor = [UIColor grayColor];
    self.cursorColor = [UIColor colorWithRed:0.349 green:0.3725 blue:0.4314 alpha:1.0];
    self.textColor = [UIColor grayColor];
    [self setFont:[UIFont fontWithName:@"Poppins-Light" size:17]];
    
    self.placeholderFontScale = 0.65;
    self.activePlaceholderPoint = CGPointZero;
    
}

#pragma mark - Overridden methods

- (void)drawRect:(CGRect)rect {
    
    CGRect frame;
    frame = CGRectMake(20, rect.size.height, rect.size.width, rect.size.height);
    
    
    self.placeholderLabel.frame = CGRectInset(frame, placeholderInsets.x, placeholderInsets.y);
    self.placeholderLabel.font = [self placeholderFontFromFont:self.font];
    
    
    [self updateBorder];
    [self updatePlaceholder];
    
    [self.layer addSublayer:self.inactiveBorderLayer];
    [self.layer addSublayer:self.activeBorderLayer];
    [self addSubview:self.placeholderLabel];
}

- (CGRect)editingRectForBounds:(CGRect)bounds {
    
            return CGRectMake(30, bounds.origin.y + 5, bounds.size.width, bounds.size.height);
        
    
    
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectMake(30, bounds.origin.y + 5, bounds.size.width, bounds.size.height);
        
   
}

- (void)animateViewsForTextEntry {
    if (self.text.length == 0) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
                           self.placeholderLabel.frame = CGRectMake(20, self.placeholderLabel.frame.origin.y, CGRectGetWidth(self.placeholderLabel.frame), CGRectGetHeight(self.placeholderLabel.frame));
         
            self.placeholderLabel.textColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
        } completion:^(BOOL finished) {
            if (self.didBeginEditingHandler != nil) {
                self.didBeginEditingHandler();
            }
        }];
    }
    
    [self layoutPlaceholderInTextRect];
    self.placeholderLabel.frame = CGRectMake(self.activePlaceholderPoint.x, self.activePlaceholderPoint.y, CGRectGetWidth(self.placeholderLabel.frame), CGRectGetHeight(self.placeholderLabel.frame));
    
    [UIView animateWithDuration:0.2 animations:^{
        self.placeholderLabel.alpha = 1.0;
    }];
    
    self.activeBorderLayer.frame = [self rectForBorderThickness:activeBorderThickness isFilled:YES];
}

- (void)animateViewsForTextDisplay {
    if (self.text.length == 0) {
        [UIView animateWithDuration:0.35 delay:0 usingSpringWithDamping:0.8 initialSpringVelocity:2.0 options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [self layoutPlaceholderInTextRect];
            self.placeholderLabel.textColor = [UIColor grayColor];
            
        } completion:^(BOOL finished) {
            if (self.didEndEditingHandler != nil) {
                self.didEndEditingHandler();
            }
        }];
        
        self.activeBorderLayer.frame = [self rectForBorderThickness:activeBorderThickness isFilled:NO];
        
    }
}

#pragma mark - Private methods
- (void)updateBorder{
    self.inactiveBorderLayer.frame = [self rectForBorderThickness:inactiveBorderThickness isFilled:YES];
    self.inactiveBorderLayer.backgroundColor = self.borderInactiveColor.CGColor;
    
    self.activeBorderLayer.frame = [self rectForBorderThickness:activeBorderThickness isFilled:NO];
    self.activeBorderLayer.backgroundColor = self.borderActiveColor.CGColor;
}

- (void)updatePlaceholder {
    self.placeholderLabel.text = self.placeholder;
    self.placeholderLabel.textColor = [UIColor grayColor];
    [self.placeholderLabel sizeToFit];
    [self layoutPlaceholderInTextRect];
    
    if ([self isFirstResponder] || self.text.length!=0) {
        self.placeholderLabel.textColor = [UIColor colorWithRed:0.99 green:0.68 blue:0.16 alpha:1.0];
        
        [self animateViewsForTextEntry];
    }
}

- (UIFont *)placeholderFontFromFont:(UIFont *)font {
    
    UIFont *smallerFont = [UIFont fontWithName:@"Poppins-Regular" size:font.pointSize*self.placeholderFontScale+2];
    
    return smallerFont;
}

- (CGRect)rectForBorderThickness:(CGFloat)thickness isFilled:(BOOL)isFilled {
    if (isFilled) {
        return CGRectMake(0, CGRectGetHeight(self.frame)-thickness, CGRectGetWidth(self.frame), thickness);
    } else {
        return CGRectMake(0, CGRectGetHeight(self.frame)-thickness, 0, thickness);
    }
}

- (void)layoutPlaceholderInTextRect {
    CGRect textRect = [self textRectForBounds:self.bounds];
    CGFloat originX = 30;
    
        
        self.placeholderLabel.frame = CGRectMake(originX, textRect.size.height/2.5, CGRectGetWidth(self.placeholderLabel.bounds), CGRectGetHeight(self.placeholderLabel.bounds));
        self.activePlaceholderPoint = CGPointMake(30, self.placeholderLabel.frame.origin.y-self.placeholderLabel.frame.size.height);
    
    
}
@end
