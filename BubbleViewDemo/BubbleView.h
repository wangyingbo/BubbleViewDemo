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

/**Convenience method to make a WBRectCornerRadius*/
NS_INLINE WBRectCornerRadius WBRectCornerRadiusMake(CGFloat topLeft,CGFloat topRight,CGFloat bottomLeft,CGFloat bottomRight){
    WBRectCornerRadius cornerRadius;
    cornerRadius.topLeft = topLeft;
    cornerRadius.topRight = topRight;
    cornerRadius.bottomLeft = bottomLeft;
    cornerRadius.bottomRight = bottomRight;
    return cornerRadius;
}

@interface BubbleView : UIControl
/**effective area. use it to add subviews */
@property (nonatomic, strong, readonly) UIView *contentView;
/**path line width. default is 1.f*/
@property (nonatomic, assign) CGFloat lineWidth;
/**path line color*/
@property (nonatomic, strong) UIColor *lineColor;
/**layer path fill color*/
@property (nonatomic, strong) UIColor *fillColor;
/**effective content corner radius*/
@property (nonatomic, assign) WBRectCornerRadius cornerRadius;
/**effective area size. update the contentView size if need. */
@property (nonatomic, assign) CGSize contentSize;
/**
 rely which corner to display angle
 eg:
 UIRectCornerTopLeft    (-30, 30) or (30, -30)
 UIRectCornerTopRight   (-30, -30) or (30, 30)
 UIRectCornerBottomRight    (30, -30) or (-30, 30)
 UIRectCornerBottomLeft (30, 30) or (-30, -30)
 */
@property (nonatomic, assign) UIRectCorner corner;
/**
 the off point to corner.
 
   /\
 1---->2
 |     |
 |     |
 4<----3
 
 the display order is 1--->2--->3--->4
 */
@property (nonatomic, assign) CGPoint offPoint;
/**the angle width. default is 15.f*/
@property (nonatomic, assign) CGFloat angleWidth;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// 用origin初始化，size会根据属性算出
/// @param origin origin description
- (instancetype)initWithOrigin:(CGPoint)origin;

/// should recall the method if the above properties is changed.
- (void)draw;

@end

NS_ASSUME_NONNULL_END
