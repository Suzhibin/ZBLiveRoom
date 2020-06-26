//
//  UITextView+ZBPlaceHolder.m
//  ZBLiveRoom
//
//  Created by Suzhibin on 2020/4/15.
//  Copyright © 2020 Suzhibin. All rights reserved.
//

#import "UITextView+ZBPlaceHolder.h"
#import <objc/runtime.h>

static const void *BJX_placeHolderKey;

@interface UITextView ()
@property (nonatomic, readonly) UILabel *BJX_placeHolderLabel;
@end
@implementation UITextView (ZBPlaceHolder)
+(void)load{
    [super load];
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"layoutSubviews")),
                                   class_getInstanceMethod(self.class, @selector(BJXPlaceHolder_swizzling_layoutSubviews)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"dealloc")),
                                   class_getInstanceMethod(self.class, @selector(BJXPlaceHolder_swizzled_dealloc)));
    method_exchangeImplementations(class_getInstanceMethod(self.class, NSSelectorFromString(@"setText:")),
                                   class_getInstanceMethod(self.class, @selector(BJXPlaceHolder_swizzled_setText:)));
}
#pragma mark - swizzled
- (void)BJXPlaceHolder_swizzled_dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [self BJXPlaceHolder_swizzled_dealloc];
}
- (void)BJXPlaceHolder_swizzling_layoutSubviews {
    if (self.BJX_placeHolder) {
        UIEdgeInsets textContainerInset = self.textContainerInset;
        CGFloat lineFragmentPadding = self.textContainer.lineFragmentPadding;
        CGFloat x = lineFragmentPadding + textContainerInset.left + self.layer.borderWidth;
        CGFloat y = textContainerInset.top + self.layer.borderWidth;
        CGFloat width = CGRectGetWidth(self.bounds) - x - textContainerInset.right - 2*self.layer.borderWidth;
        CGFloat height = [self.BJX_placeHolderLabel sizeThatFits:CGSizeMake(width, 0)].height;
        self.BJX_placeHolderLabel.frame = CGRectMake(x, y, width, height);
    }
    [self BJXPlaceHolder_swizzling_layoutSubviews];
}
- (void)BJXPlaceHolder_swizzled_setText:(NSString *)text{
    [self BJXPlaceHolder_swizzled_setText:text];
    if (self.BJX_placeHolder) {
        [self updatePlaceHolder];
    }
}
#pragma mark - associated
-(NSString *)BJX_placeHolder{
    return objc_getAssociatedObject(self, &BJX_placeHolderKey);
}
-(void)setBJX_placeHolder:(NSString *)BJX_placeHolder{
    objc_setAssociatedObject(self, &BJX_placeHolderKey, BJX_placeHolder, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self updatePlaceHolder];
}
-(UIColor *)BJX_placeHolderColor{
    return self.BJX_placeHolderLabel.textColor;
}
-(void)setBJX_placeHolderColor:(UIColor *)BJX_placeHolderColor{
    self.BJX_placeHolderLabel.textColor = BJX_placeHolderColor;
}
- (CGFloat)placeHolderFontSize {
    return self.placeHolderFontSize;
}

- (void)setPlaceHolderFontSize:(CGFloat)placeHolderFontSize {
    self.BJX_placeHolderLabel.font = [UIFont systemFontOfSize:placeHolderFontSize];
}

-(NSString *)placeholder{
    return self.BJX_placeHolder;
}
-(void)setPlaceholder:(NSString *)placeholder{
    self.BJX_placeHolder = placeholder;
}
#pragma mark - update
- (void)updatePlaceHolder{
    if (self.text.length) {
        [self.BJX_placeHolderLabel removeFromSuperview];
        return;
    }
    self.BJX_placeHolderLabel.textAlignment = self.textAlignment;
    self.BJX_placeHolderLabel.text = self.BJX_placeHolder;
    [self insertSubview:self.BJX_placeHolderLabel atIndex:0];
}
#pragma mark - lazzing
-(UILabel *)BJX_placeHolderLabel{
    UILabel *placeHolderLab = objc_getAssociatedObject(self, @selector(BJX_placeHolderLabel));
    if (!placeHolderLab) {
        placeHolderLab = [[UILabel alloc] init];
        placeHolderLab.numberOfLines = 0;
        placeHolderLab.textColor = [UIColor lightGrayColor];
        objc_setAssociatedObject(self, @selector(BJX_placeHolderLabel), placeHolderLab, OBJC_ASSOCIATION_RETAIN);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePlaceHolder) name:UITextViewTextDidChangeNotification object:self];
    }
    return placeHolderLab;
}
- (UIFont *)cacutDefaultFont{
    static UIFont *font = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        UITextView *textview = [[UITextView alloc] init];
        textview.text = @" ";
        font = textview.font;
    });
    return font;
}
@end
