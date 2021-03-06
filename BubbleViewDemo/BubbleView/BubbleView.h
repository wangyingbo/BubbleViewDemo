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

@interface UIView (Corner)
/**set view corner radius for each corner*/
- (void)setRectCornerRadius:(WBRectCornerRadius)cornerRadius;
@end

@interface BubbleView : UIControl
/**you can set bubble layer shadowColor etc. */
@property (nonatomic, strong, readonly) CAShapeLayer *bubbleLayer;
/**effective area. use it to add subviews if you want to. */
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
/**the angle width. default is 15.f*/
@property (nonatomic, assign) CGFloat angleWidth;
/**curve angle enable*/
@property (nonatomic, assign) BOOL angleCurve;
/**curve control point offset*/
@property (nonatomic, assign) CGFloat curveCotrol;
/**
 rely on which corner to display angle. the corner and edge are mutually exclusive.
 
 1----→2
 ↑     |
 |     ↓
 4←----3
 
 the path display order is 1--->2--->3--->4
 
 eg:
 ----------------------------------------------------
        corner                      offPoint
 ----------------------------------------------------
 UIRectCornerTopLeft        (-30, 30) or (30, -30)
 ----------------------------------------------------
 UIRectCornerTopRight       (-30, -30) or (30, 30)
 ----------------------------------------------------
 UIRectCornerBottomRight    (30, -30) or (-30, 30)
 ----------------------------------------------------
 UIRectCornerBottomLeft     (30, 30) or (-30, -30)
 ----------------------------------------------------
 */
@property (nonatomic, assign) UIRectCorner corner;
/**
 rely on which edge to display angle. the edge and corner are mutually exclusive.
 
 1----→2
 |     |
 ↓     ↓
 4----→3
 
 the path display order is 1--->2；1--->4；2--->3；4--->3.
 
 eg:
 ----------------------------------------------------
        edge                            offPoint
 ----------------------------------------------------
 UIRectEdgeTop (origin:topLeft)         (30, -30)
 ----------------------------------------------------
 UIRectEdgeRight (origin:topRight)      (30, 30)
 ----------------------------------------------------
 UIRectEdgeBottom (origin:bottomLeft)   (30, 30)
 ----------------------------------------------------
 UIRectEdgeLeft (origin:topLeft)        (-30, 30)
 ----------------------------------------------------
 */
@property (nonatomic, assign) UIRectEdge edge;
/**
 the off point to corner.it considers the corner you choosed as the origin point to display.
 */
@property (nonatomic, assign) CGPoint offPoint;

- (instancetype)init NS_UNAVAILABLE;
+ (instancetype)new NS_UNAVAILABLE;

/// init with the anchor point of the angle.
/// @param anchorPoint anchorPoint description
- (instancetype)initWithAnchorPoint:(CGPoint)anchorPoint;

/// should recall the method if one of the above properties is changed. 
/// the draw method will layout subviews, you could get the correct bubble's frame after call the draw method.
- (void)draw;

/**set the angle point to the anchor point which is in the same superView.*/
- (void)angleAnchorToPoint:(CGPoint)anchorPoint;

@end

NS_ASSUME_NONNULL_END
