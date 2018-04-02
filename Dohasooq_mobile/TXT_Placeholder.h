#import "CCTextField.h"


@interface TXT_Placeholder : CCTextField

#pragma mark - Public methods
/**
 *  The color of the border when it has no content.
 *
 *  his property applies a color to the lower edge of the control. The default value for this property is a gray color.
 */
@property (strong, nonatomic) UIColor *borderInactiveColor;

/**
 *  The color of the border when it has content.
 *
 *  This property applies a color to the lower edge of the control. The default value for this property is a dark gray color.
 */
@property (strong, nonatomic) UIColor *borderActiveColor;

/**
 *  The color of the placeholder text.
 *
 *  This property applies a color to the complete placeholder string. The default value for this property is a gray color.
 */
@property (strong, nonatomic) UIColor *placeholderColor;

/**
 *  The scale of the placeholder font.
 *
 *  This property determines the size of the placeholder label relative to the font size of the text field.
 */
@property(nonatomic) CGFloat placeholderFontScale;
@property (nonatomic,strong) UILabel *lbl_icon;

//@property (nonatomic,weak) UILabel *lbl1;


@end
