//
//  UIView+Frame.h
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

- (id) initWithParent:(UIView *)parent;
+ (id) viewWithParent:(UIView *)parent;
- (void)removeAllSubViews;
- (void)removeAllSubViewsRecursively;
- (void)setBackgroundImage:(UIImage*)image;
- (UIImage*)toImage;


/**
 *  设置部分圆角(绝对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii;
/**
 *  设置部分圆角(相对布局)
 *
 *  @param corners 需要设置为圆角的角 UIRectCornerTopLeft | UIRectCornerTopRight | UIRectCornerBottomLeft | UIRectCornerBottomRight | UIRectCornerAllCorners
 *  @param radii   需要设置的圆角大小 例如 CGSizeMake(20.0f, 20.0f)
 *  @param rect    需要设置的圆角view的rect
 */
- (void)addRoundedCorners:(UIRectCorner)corners
                withRadii:(CGSize)radii
                 viewRect:(CGRect)rect;


// Position of the top-left corner in superview's coordinates
@property CGPoint position;
@property CGFloat x;
@property CGFloat y;
@property CGFloat top;
@property CGFloat bottom;
@property CGFloat left;
@property CGFloat right;


// makes hiding more logical
@property BOOL	visible;


// Setting size keeps the position (top-left corner) constant
@property CGSize size;
@property CGFloat width;
@property CGFloat height;

@end

