//
//  BubbleView.h
//  BubbleViewDemo
//
//  Created by 王迎博 on 2021/7/20.
//  Copyright © 2021 王颖博. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct WBRectCornerRadius {
    CGFloat topLeft;
    CGFloat topRight;
    CGFloat bottomLeft;
    CGFloat bottomRight;
} WBRectCornerRadius;


NS_INLINE WBRectCornerRadius WBRectCornerRadiusMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight){
    WBRectCornerRadius cornerRadius;
    cornerRadius.topLeft = topLeft;
    cornerRadius.topRight = topRight;
    cornerRadius.bottomLeft = bottomLeft;
    cornerRadius.bottomRight = bottomRight;
    return cornerRadius;
}

@interface BubbleView : UIControl
@property (nonatomic, strong, readonly) UIView *contentView;
@property (nonatomic, assign) CGFloat lineWidth;
@property (nonatomic, strong) UIColor *lineColor;
@property (nonatomic, strong) UIColor *fillColor;
@property (nonatomic, assign) WBRectCornerRadius cornerRadius;
@property (nonatomic, assign) UIRectCorner corner;
@property (nonatomic, assign) CGSize contentSize;
@property (nonatomic, assign) CGPoint offPoint;
@property (nonatomic, assign) CGFloat angleWidth;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 用origin初始化，size会根据属性算出
/// @param origin origin description
- (instancetype)initWithOrigin:(CGPoint)origin;

- (void)draw;

@end

NS_ASSUME_NONNULL_END
