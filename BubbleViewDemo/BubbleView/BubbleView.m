//
//  BubbleView.m
//  BubbleViewDemo
//
//  Created by 王迎博 on 2021/7/20.
//  Copyright © 2021 王颖博. All rights reserved.
//

#import "BubbleView.h"

typedef NS_OPTIONS(NSUInteger, CurveControlDirection) {
    CurveControlDirectionX     = 1 << 0,
    CurveControlDirectionY     = 1 << 1,
    CurveControlDirectionX_Y   = 0xff,
    CurveControlDirectionAll   = ~0UL
};

@interface BubbleView ()
@property (nonatomic, strong) CAShapeLayer *bubbleLayer;
@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGPoint angleMiddlePoint;
@property (nonatomic, assign) CGPoint anchorPoint;
@end


@implementation BubbleView

#pragma mark - override
- (instancetype)initWithAnchorPoint:(CGPoint)anchorPoint
{
    if (self = [self initWithOrigin:CGPointZero]) {
        self.anchorPoint = anchorPoint;
    }
    return self;
}

- (instancetype)initWithOrigin:(CGPoint)origin
{
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, 0, 0)]) {
        [self initUI];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

#pragma mark - init UI
- (void)initUI
{
    [self addSubview:self.contentView];
    [self.layer insertSublayer:self.bubbleLayer atIndex:0];
}

#pragma mark - lazy
- (CAShapeLayer *)bubbleLayer
{
    if (!_bubbleLayer) {
        _bubbleLayer = [[CAShapeLayer alloc] init];
    }
    return _bubbleLayer;
}

- (UIView *)contentView
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
    }
    return _contentView;
}

- (CGFloat)angleWidth
{
    if (!_angleWidth) {
        _angleWidth = 15.f;
    }
    return _angleWidth;
}

- (CGFloat)lineWidth
{
    if (!_lineWidth) {
        _lineWidth = 1.f;
    }
    return _lineWidth;
}

#pragma mark - setter

NS_INLINE void _checkValid(UIRectCorner corner,CGPoint offPoint){
    NSCAssert1(!((corner & UIRectCornerTopLeft) && offPoint.x<0 && offPoint.y<0), @"UIRectCornerTopLeft and its offPoint:%@ is invalid", NSStringFromCGPoint(offPoint));
    NSCAssert1(!((corner & UIRectCornerTopRight) && offPoint.x>0 && offPoint.y<0), @"UIRectCornerTopRight and its offPoint:%@ is invalid", NSStringFromCGPoint(offPoint));
    NSCAssert1(!((corner & UIRectCornerBottomRight) && offPoint.x>0 && offPoint.y>0), @"UIRectCornerBottomRight and its offPoint:%@ is invalid", NSStringFromCGPoint(offPoint));
    NSCAssert1(!((corner & UIRectCornerBottomLeft) && offPoint.x<0 && offPoint.y>0), @"UIRectCornerBottomLeft and its offPoint:%@ is invalid", NSStringFromCGPoint(offPoint));
}

- (void)setCorner:(UIRectCorner)corner
{
    _corner = corner;
}

- (void)setOffPoint:(CGPoint)offPoint
{
    _offPoint = offPoint;
}

- (void)setFillColor:(UIColor *)fillColor
{
    _fillColor = fillColor;
}

- (void)setEdge:(UIRectEdge)edge
{
    _edge = edge;
    if (_edge & UIRectEdgeTop) {
        self.corner |= UIRectCornerTopLeft;
    }
    if (_edge & UIRectEdgeRight) {
        self.corner |= UIRectCornerTopRight;
    }
    if (_edge & UIRectEdgeBottom) {
        self.corner |= UIRectCornerBottomLeft;
    }
    if (_edge & UIRectEdgeLeft) {
        self.corner |= UIRectCornerTopLeft;
    }
}

#pragma mark - private
/// all bullbleView size
- (CGSize)_layoutSize
{
    CGSize size = CGSizeZero;
    size.width += self.contentSize.width;
    size.height += self.contentSize.height;
    if (self.corner & UIRectCornerTopLeft || self.corner & UIRectCornerBottomLeft) {
        if (self.offPoint.x<0) {
            size.width += ABS(self.offPoint.x);
        }
    }else if (self.corner & UIRectCornerTopRight || self.corner & UIRectCornerBottomRight) {
        if (self.offPoint.x>0) {
            size.width += ABS(self.offPoint.x);
        }
    }
    
    if (self.corner & UIRectCornerTopLeft || self.corner & UIRectCornerTopRight) {
        if (self.offPoint.y<0) {
            size.height += ABS(self.offPoint.y);
        }
    }else if (self.corner & UIRectCornerBottomLeft || self.corner & UIRectCornerBottomRight) {
        if (self.offPoint.y>0) {
            size.height += ABS(self.offPoint.y);
        }
    }
    
    return size;
}

- (CGRect)_layoutContentViewFrame
{
    CGPoint origin = [self _originPoint];
    return CGRectMake(origin.x, origin.y, self.contentSize.width, self.contentSize.height);
}

- (CGPoint)_originPoint
{
    CGFloat originX = 0;
    CGFloat originY = 0;
    if (self.corner & UIRectCornerTopLeft || self.corner & UIRectCornerBottomLeft) {
        if (self.offPoint.x<0) {
            originX += ABS(self.offPoint.x);
        }
    }
    if (self.corner & UIRectCornerTopLeft || self.corner & UIRectCornerTopRight) {
        if (self.offPoint.y<0) {
            originY += ABS(self.offPoint.y);
        }
    }
    return CGPointMake(originX, originY);
}

- (void)_drawPath
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    path.lineWidth=self.lineWidth;
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    CGRect contentFrame = [self _layoutContentViewFrame];
    CGFloat maxX = CGRectGetMaxX(contentFrame);
    CGFloat maxY = CGRectGetMaxY(contentFrame);
    CGFloat contentX = CGRectGetMinX(contentFrame);
    CGFloat contentY = CGRectGetMinY(contentFrame);

    //draw edge, leave the corner space
    WBRectCornerRadius radius = self.cornerRadius;
    UIRectCorner corner = self.corner;
    CGFloat curveCotrol = ABS(self.curveCotrol);
    BOOL angleCurve = self.angleCurve;
    
    //draw corner radius
    //https://blog.csdn.net/zhanglizhi111/article/details/106875201/
    
    
    /*****top edge*****/
    
    [path moveToPoint:CGPointMake(self.cornerRadius.topLeft+contentX,contentY)];
    BOOL topLineLeft = (corner & UIRectCornerTopLeft) && self.offPoint.x>0;
    BOOL topLineRight = (corner & UIRectCornerTopRight) && self.offPoint.x<0;
    if (topLineLeft || topLineRight) {
        CGFloat startPointX = 0;
        if (topLineLeft) {
            startPointX = contentX;
            startPointX = startPointX + self.offPoint.x - self.angleWidth/2;
            CGPoint angleStartPoint = CGPointMake(startPointX, contentY);
            CGPoint angleMidPoint = CGPointMake(startPointX+self.angleWidth/2, contentY+self.offPoint.y);
            CGPoint angleEndPoint = CGPointMake(startPointX+self.angleWidth, contentY);
            [path addLineToPoint:angleStartPoint];
            if (angleCurve) {
                angleMidPoint.x = angleStartPoint.x;
                [path addQuadCurveToPoint:angleMidPoint controlPoint:_controlPoint(angleStartPoint, angleMidPoint, CurveControlDirectionX, curveCotrol)];
                [path addQuadCurveToPoint:angleEndPoint controlPoint:_controlPoint(angleMidPoint, angleEndPoint, CurveControlDirectionX, curveCotrol)];
            }else {
                [path addLineToPoint:angleMidPoint];
                [path addLineToPoint:angleEndPoint];
            }
            self.angleMiddlePoint = angleMidPoint;
            corner ^= UIRectCornerTopLeft;
        }else if (topLineRight) {
            startPointX = maxX;
            startPointX = startPointX + self.offPoint.x - self.angleWidth/2;
            CGPoint angleStartPoint = CGPointMake(startPointX, contentY);
            CGPoint angleMidPoint = CGPointMake(startPointX+self.angleWidth/2, contentY+self.offPoint.y);
            CGPoint angleEndPoint = CGPointMake(startPointX+self.angleWidth, contentY);
            [path addLineToPoint:angleStartPoint];
            if (angleCurve) {
                angleMidPoint.x = angleEndPoint.x;
                [path addQuadCurveToPoint:angleMidPoint controlPoint:_controlPoint(angleStartPoint, angleMidPoint, CurveControlDirectionX, -curveCotrol)];
                [path addQuadCurveToPoint:angleEndPoint controlPoint:_controlPoint(angleMidPoint, angleEndPoint, CurveControlDirectionX, -curveCotrol)];
            }else {
                [path addLineToPoint:angleMidPoint];
                [path addLineToPoint:angleEndPoint];
            }
            self.angleMiddlePoint = angleMidPoint;
            corner ^= UIRectCornerTopRight;
        }
    }
    [path addLineToPoint:CGPointMake(maxX-radius.topRight,contentY)];// top edge
    //topRight
    //[path moveToPoint:CGPointMake(maxX-radius.topRight,contentY)];
    [path addArcWithCenter:CGPointMake(maxX - radius.topRight, radius.topRight+contentY) radius:radius.topRight startAngle:1.5 * M_PI endAngle:0 * M_PI clockwise:YES];
    
    /*****right edge*****/
    
    //[path moveToPoint:CGPointMake(maxX, radius.topRight+contentY)];
    BOOL rightLineTop = (corner & UIRectCornerTopRight) && self.offPoint.y>0;
    BOOL rightLineBottom = (corner & UIRectCornerBottomRight) && self.offPoint.y<0;
    if (rightLineTop || rightLineBottom) {
        CGFloat startPointY = 0;
        if (rightLineTop) {
            startPointY = contentY;
            startPointY = startPointY + self.offPoint.y - self.angleWidth/2;
            CGPoint angleStartPoint = CGPointMake(maxX, startPointY);
            CGPoint angleMidPoint = CGPointMake(maxX+self.offPoint.x, startPointY+self.angleWidth/2);
            CGPoint angleEndPoint = CGPointMake(maxX, startPointY+self.angleWidth);
            [path addLineToPoint:angleStartPoint];
            if (angleCurve) {
                angleMidPoint.y = angleStartPoint.y;
                [path addQuadCurveToPoint:angleMidPoint controlPoint:_controlPoint(angleStartPoint, angleMidPoint, CurveControlDirectionY, curveCotrol)];
                [path addQuadCurveToPoint:angleEndPoint controlPoint:_controlPoint(angleMidPoint, angleEndPoint, CurveControlDirectionY, curveCotrol)];
            }else {
                [path addLineToPoint:angleMidPoint];
                [path addLineToPoint:angleEndPoint];
            }
            self.angleMiddlePoint = angleMidPoint;
            corner ^= UIRectCornerTopRight;
        }else if (rightLineBottom) {
            startPointY = maxY;
            startPointY = startPointY + self.offPoint.y - self.angleWidth/2;
            CGPoint angleStartPoint = CGPointMake(maxX, startPointY);
            CGPoint angleMidPoint = CGPointMake(maxX+self.offPoint.x, startPointY+self.angleWidth/2);
            CGPoint angleEndPoint = CGPointMake(maxX, startPointY+self.angleWidth);
            [path addLineToPoint:angleStartPoint];
            if (angleCurve) {
                angleMidPoint.y = angleEndPoint.y;
                [path addQuadCurveToPoint:angleMidPoint controlPoint:_controlPoint(angleStartPoint, angleMidPoint, CurveControlDirectionY, -curveCotrol)];
                [path addQuadCurveToPoint:angleEndPoint controlPoint:_controlPoint(angleMidPoint, angleEndPoint, CurveControlDirectionY, -curveCotrol)];
            }else {
                [path addLineToPoint:angleMidPoint];
                [path addLineToPoint:angleEndPoint];
            }
            self.angleMiddlePoint = angleMidPoint;
            corner ^= UIRectCornerBottomRight;
        }
    }
    [path addLineToPoint:CGPointMake(maxX, maxY-radius.bottomRight)];//right edge
    //bottomRight
    //[path moveToPoint:CGPointMake(maxX, maxY-radius.bottomRight)];
    [path addArcWithCenter:CGPointMake(maxX-radius.bottomRight, maxY-radius.bottomRight)radius:radius.bottomRight startAngle:0 * M_PI endAngle:0.5 * M_PI clockwise:YES];
    
    /*****bottom edge*****/
    
    //[path moveToPoint:CGPointMake(maxX-radius.bottomRight, maxY)];
    BOOL bottomLineLeft = (corner & UIRectCornerBottomLeft) && self.offPoint.x>0;
    BOOL bottomLineRight = (corner & UIRectCornerBottomRight) && self.offPoint.x<0;
    if (bottomLineLeft || bottomLineRight) {
        CGFloat startPointX = 0;
        if (bottomLineLeft) {
            startPointX = contentX;
            startPointX = startPointX + self.offPoint.x + self.angleWidth;
            CGPoint angleStartPoint = CGPointMake(startPointX, maxY);
            CGPoint angleMidPoint = CGPointMake(startPointX - self.angleWidth/2, maxY+self.offPoint.y);
            CGPoint angleEndPoint = CGPointMake(startPointX - self.angleWidth, maxY);
            [path addLineToPoint:angleStartPoint];
            if (angleCurve) {
                angleMidPoint.x = angleEndPoint.x;
                [path addQuadCurveToPoint:angleMidPoint controlPoint:_controlPoint(angleStartPoint, angleMidPoint, CurveControlDirectionX, curveCotrol)];
                [path addQuadCurveToPoint:angleEndPoint controlPoint:_controlPoint(angleMidPoint, angleEndPoint, CurveControlDirectionX, curveCotrol)];
            }else {
                [path addLineToPoint:angleMidPoint];
                [path addLineToPoint:angleEndPoint];
            }
            self.angleMiddlePoint = angleMidPoint;
            corner ^= UIRectCornerBottomLeft;
        }else if (bottomLineRight) {
            startPointX = maxX;
            startPointX = startPointX + self.offPoint.x;
            CGPoint angleStartPoint = CGPointMake(startPointX, maxY);
            CGPoint angleMidPoint = CGPointMake(startPointX - self.angleWidth/2, maxY+self.offPoint.y);
            CGPoint angleEndPoint = CGPointMake(startPointX - self.angleWidth, maxY);
            [path addLineToPoint:angleStartPoint];
            if (angleCurve) {
                angleMidPoint.x = angleStartPoint.x;
                [path addQuadCurveToPoint:angleMidPoint controlPoint:_controlPoint(angleStartPoint, angleMidPoint, CurveControlDirectionX, -curveCotrol)];
                [path addQuadCurveToPoint:angleEndPoint controlPoint:_controlPoint(angleMidPoint, angleEndPoint, CurveControlDirectionX, -curveCotrol)];
            }else {
                [path addLineToPoint:angleMidPoint];
                [path addLineToPoint:angleEndPoint];
            }
            self.angleMiddlePoint = angleMidPoint;
            corner ^= UIRectCornerBottomRight;
        }
    }
    [path addLineToPoint:CGPointMake(radius.bottomLeft+contentX, maxY)];//bottom edge
    //bottomLeft
    //[path moveToPoint:CGPointMake(radius.bottomLeft+contentX, maxY)];
    [path addArcWithCenter:CGPointMake(radius.bottomLeft+contentX, maxY-radius.bottomLeft) radius:radius.bottomLeft startAngle:0.5 * M_PI endAngle:1 * M_PI clockwise:YES];
    
    /*****left edge*****/
    
    //[path moveToPoint:CGPointMake(contentX, maxY-radius.bottomLeft)];
    BOOL leftLineTop = (corner & UIRectCornerTopLeft) && self.offPoint.y>0;
    BOOL leftLineBottom = (corner & UIRectCornerBottomLeft) && self.offPoint.y<0;
    if (leftLineTop || leftLineBottom) {
        CGFloat startPointY = 0;
        if (leftLineTop) {
            startPointY = contentY;
            startPointY = startPointY + self.offPoint.y + self.angleWidth;
            CGPoint angleStartPoint = CGPointMake(contentX, startPointY);
            CGPoint angleMidPoint = CGPointMake(contentX+self.offPoint.x, startPointY - self.angleWidth/2);
            CGPoint angleEndPoint = CGPointMake(contentX, startPointY - self.angleWidth);
            [path addLineToPoint:angleStartPoint];
            if (angleCurve) {
                angleMidPoint.y = angleEndPoint.y;
                [path addQuadCurveToPoint:angleMidPoint controlPoint:_controlPoint(angleStartPoint, angleMidPoint, CurveControlDirectionY, curveCotrol)];
                [path addQuadCurveToPoint:angleEndPoint controlPoint:_controlPoint(angleMidPoint, angleEndPoint, CurveControlDirectionY, curveCotrol)];
            }else {
                [path addLineToPoint:angleMidPoint];
                [path addLineToPoint:angleEndPoint];
            }
            self.angleMiddlePoint = angleMidPoint;
            corner ^= UIRectCornerTopLeft;
        }else if (leftLineBottom) {
            startPointY = maxY;
            startPointY = startPointY + self.offPoint.y;
            CGPoint angleStartPoint = CGPointMake(contentX, startPointY);
            CGPoint angleMidPoint = CGPointMake(contentX + self.offPoint.x, startPointY - self.angleWidth/2);
            CGPoint angleEndPoint = CGPointMake(contentX, startPointY - self.angleWidth);
            [path addLineToPoint:angleStartPoint];
            if (angleCurve) {
                angleMidPoint.y = angleStartPoint.y;
                [path addQuadCurveToPoint:angleMidPoint controlPoint:_controlPoint(angleStartPoint, angleMidPoint, CurveControlDirectionY, -curveCotrol)];
                [path addQuadCurveToPoint:angleEndPoint controlPoint:_controlPoint(angleMidPoint, angleEndPoint, CurveControlDirectionY, -curveCotrol)];
            }else {
                [path addLineToPoint:angleMidPoint];
                [path addLineToPoint:angleEndPoint];
            }
            self.angleMiddlePoint = angleMidPoint;
            corner ^= UIRectCornerBottomLeft;
        }
    }
    [path addLineToPoint:CGPointMake(contentX, radius.topLeft+contentY)];//left edge
    //topLeft
    //[path moveToPoint:CGPointMake(contentX, radius.topLeft+contentY)];
    [path addArcWithCenter:CGPointMake(radius.topLeft+contentX, radius.topLeft+contentY) radius:radius.topLeft startAngle:1 * M_PI endAngle:1.5 * M_PI clockwise:YES];
    
    
    //set color
    [self.lineColor set];
    [path stroke];
    [self.fillColor set];
    [path fill];
    CAShapeLayer *shape = self.bubbleLayer;
    shape.strokeColor = self.lineColor.CGColor;
    shape.fillColor = (self.fillColor ? : self.backgroundColor).CGColor;
    shape.lineWidth = self.lineWidth;
    shape.path= path.CGPath;
}

NS_INLINE CGPoint _controlPoint(CGPoint startPoint, CGPoint endPoint, CurveControlDirection direction, CGFloat curveControl) {
    return CGPointMake((startPoint.x + endPoint.x)/2 + ((direction & CurveControlDirectionX) ? curveControl : 0), (startPoint.y + endPoint.y)/2 + ((direction & CurveControlDirectionY) ? curveControl : 0));
};

- (void)_angleAnchorToPoint:(CGPoint)anchorPoint
{
    if (!self.superview) { return; }
    CGRect tempRect = self.frame;
    CGPoint relativePoint = [self convertPoint:self.angleMiddlePoint toView:self.superview];
    CGFloat offX = anchorPoint.x - relativePoint.x;
    CGFloat offY = anchorPoint.y - relativePoint.y;
    tempRect.origin.x += offX;
    tempRect.origin.y += offY;
    self.frame = tempRect;
}

#pragma mark - public

- (void)draw {
    //check the corner and offPoint is valid.
    _checkValid(self.corner, self.offPoint);
    
    //set contentView frame and corner
    self.contentView.frame = [self _layoutContentViewFrame];
    [self.contentView setRectCornerRadius:self.cornerRadius];
    
    //set bubbleLayer frame
    CGSize size = [self _layoutSize];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    self.bubbleLayer.frame = rect;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    
    //draw again
    [self _drawPath];
    
    //set the angle point
    [self _angleAnchorToPoint:self.anchorPoint];
}

- (void)angleAnchorToPoint:(CGPoint)anchorPoint
{
    self.anchorPoint = anchorPoint;
    [self _angleAnchorToPoint:anchorPoint];
}

@end


@implementation UIView (Corner)

- (void)setRectCornerRadius:(WBRectCornerRadius)cornerRadius
{
    UIBezierPath *path = [UIBezierPath bezierPath];
    WBRectCornerRadius inset = cornerRadius;
    CGFloat width = CGRectGetWidth(self.frame);
    CGFloat height = CGRectGetHeight(self.frame);
    [path addArcWithCenter:CGPointMake(inset.topLeft, inset.topLeft) radius:inset.topLeft startAngle:1 * M_PI endAngle:1.5 * M_PI clockwise:YES];
    [path addArcWithCenter:CGPointMake(width - inset.topRight, inset.topRight) radius:inset.topRight startAngle:1.5 * M_PI endAngle:0 * M_PI clockwise:YES];
    [path addArcWithCenter:CGPointMake(width-inset.bottomRight, height-inset.bottomRight)radius:inset.bottomRight startAngle:0 * M_PI endAngle:0.5 * M_PI clockwise:YES];
    [path addArcWithCenter:CGPointMake(inset.bottomLeft, height-inset.bottomLeft) radius:inset.bottomLeft startAngle:0.5 * M_PI endAngle:1 * M_PI clockwise:YES];
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    self.layer.mask = shapeLayer;
}

@end
