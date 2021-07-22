//
//  BubbleView.m
//  BubbleViewDemo
//
//  Created by 王迎博 on 2021/7/20.
//  Copyright © 2021 王颖博. All rights reserved.
//

#import "BubbleView.h"

@interface BubbleView ()
@property (nonatomic, strong) CAShapeLayer *bubbleLayer;
@property (nonatomic, strong) UIView *contentView;
@end


@implementation BubbleView

#pragma mark - override
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
    [self.layer addSublayer:self.bubbleLayer];
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

NS_INLINE void checkValid(UIRectCorner corner,CGPoint offPoint){
    NSString *suffix = [NSString stringWithFormat:@" and its offPoint:%@ is invalid",NSStringFromCGPoint(offPoint)];
    NSString *topLeftError = [@"UIRectCornerTopLeft" stringByAppendingString:suffix];
    NSCAssert(!((corner&UIRectCornerTopLeft) && offPoint.x<0 && offPoint.y<0), topLeftError);
    NSString *topRightError = [@"UIRectCornerTopRight" stringByAppendingString:suffix];
    NSCAssert(!((corner&UIRectCornerTopRight) && offPoint.x>0 && offPoint.y<0), topRightError);
    NSString *bottomRightError = [@"UIRectCornerBottomRight" stringByAppendingString:suffix];
    NSCAssert(!((corner&UIRectCornerBottomRight) && offPoint.x>0 && offPoint.y>0), bottomRightError);
    NSString *bottomLeftError = [@"UIRectCornerBottomLeft" stringByAppendingString:suffix];
    NSCAssert(!((corner&UIRectCornerBottomLeft) && offPoint.x<0 && offPoint.y>0), bottomLeftError);
}

- (void)setCorner:(UIRectCorner)corner
{
    _corner = corner;
}

- (void)setOffPoint:(CGPoint)offPoint
{
    _offPoint = offPoint;
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
    path.lineWidth=self.lineWidth;//线宽
    path.lineCapStyle = kCGLineCapRound;
    path.lineJoinStyle = kCGLineJoinRound;
    
    CGRect contentFrame = [self _layoutContentViewFrame];
    CGFloat maxX = CGRectGetMaxX(contentFrame);
    CGFloat maxY = CGRectGetMaxY(contentFrame);
    CGFloat contentX = CGRectGetMinX(contentFrame);
    CGFloat contentY = CGRectGetMinY(contentFrame);

    //draw edge, leave the corner space
    WBRectCornerRadius inset = self.cornerRadius;
    UIRectCorner corner = self.corner;
    //topLeft
    [path moveToPoint:CGPointMake(self.cornerRadius.topLeft+contentX,contentY)];
    BOOL topLineLeft = (corner&UIRectCornerTopLeft) && self.offPoint.x>0;
    BOOL topLineRight = (corner&UIRectCornerTopRight) && self.offPoint.x<0;
    if (topLineLeft || topLineRight) {
        CGFloat startPointX = 0;
        if (topLineLeft) {
            startPointX = contentX;
            startPointX = startPointX + self.offPoint.x - self.angleWidth/2;
            [path addLineToPoint:CGPointMake(startPointX, contentY)];
            [path addLineToPoint:CGPointMake(startPointX+self.angleWidth/2, contentY+self.offPoint.y)];
            [path addLineToPoint:CGPointMake(startPointX+self.angleWidth, contentY)];
            corner ^= UIRectCornerTopLeft;
        }else if (topLineRight) {
            startPointX = maxX;
            startPointX = startPointX + self.offPoint.x - self.angleWidth/2;
            [path addLineToPoint:CGPointMake(startPointX, contentY)];
            [path addLineToPoint:CGPointMake(startPointX+self.angleWidth/2, contentY+self.offPoint.y)];
            [path addLineToPoint:CGPointMake(startPointX+self.angleWidth, contentY)];
            corner ^= UIRectCornerTopRight;
        }
    }
    [path addLineToPoint:CGPointMake(maxX-inset.topRight,contentY)];// top edge
    //topRight
    [path moveToPoint:CGPointMake(maxX, inset.topRight+contentY)];
    BOOL rightLineTop = (corner&UIRectCornerTopRight) && self.offPoint.y>0;
    BOOL rightLineBottom = (corner&UIRectCornerBottomRight) && self.offPoint.y<0;
    if (rightLineTop || rightLineBottom) {
        CGFloat startPointY = 0;
        if (rightLineTop) {
            startPointY = contentY;
            startPointY = startPointY + self.offPoint.y - self.angleWidth/2;
            [path addLineToPoint:CGPointMake(maxX, startPointY)];
            [path addLineToPoint:CGPointMake(maxX+self.offPoint.x, startPointY+self.angleWidth/2)];
            [path addLineToPoint:CGPointMake(maxX, startPointY+self.angleWidth)];
            corner ^= UIRectCornerTopRight;
        }else if (rightLineBottom) {
            startPointY = maxY;
            startPointY = startPointY + self.offPoint.y - self.angleWidth/2;
            [path addLineToPoint:CGPointMake(maxX, startPointY)];
            [path addLineToPoint:CGPointMake(maxX+self.offPoint.x, startPointY+self.angleWidth/2)];
            [path addLineToPoint:CGPointMake(maxX, startPointY+self.angleWidth)];
            corner ^= UIRectCornerBottomRight;
        }
    }
    [path addLineToPoint:CGPointMake(maxX, maxY-inset.bottomRight)];//right edge
    //bottomRight
    [path moveToPoint:CGPointMake(maxX-inset.bottomRight, maxY)];
    BOOL bottomLineLeft = (corner&UIRectCornerBottomLeft) && self.offPoint.x>0;
    BOOL bottomLineRight = (corner&UIRectCornerBottomRight) && self.offPoint.x<0;
    if (bottomLineLeft || bottomLineRight) {
        CGFloat startPointX = 0;
        if (bottomLineLeft) {
            startPointX = contentX + inset.bottomLeft+contentX;
            startPointX = startPointX + self.offPoint.x + self.angleWidth;
            [path addLineToPoint:CGPointMake(startPointX, maxY)];
            [path addLineToPoint:CGPointMake(startPointX - self.angleWidth/2, maxY+self.offPoint.y)];
            [path addLineToPoint:CGPointMake(startPointX - self.angleWidth, maxY)];
            corner ^= UIRectCornerBottomLeft;
        }else if (bottomLineRight) {
            startPointX = maxX;
            startPointX = startPointX + self.offPoint.x;
            [path addLineToPoint:CGPointMake(startPointX, maxY)];
            [path addLineToPoint:CGPointMake(startPointX - self.angleWidth/2, maxY+self.offPoint.y)];
            [path addLineToPoint:CGPointMake(startPointX - self.angleWidth, maxY)];
            corner ^= UIRectCornerBottomRight;
        }
    }
    [path addLineToPoint:CGPointMake(inset.bottomLeft+contentX, maxY)];//bottom edge
    //bottomLeft
    BOOL leftLineTop = (corner&UIRectCornerTopLeft) && self.offPoint.y>0;
    BOOL leftLineBottom = (corner&UIRectCornerBottomLeft) && self.offPoint.y<0;
    [path moveToPoint:CGPointMake(contentX, maxY-inset.bottomLeft)];
    if (leftLineTop || leftLineBottom) {
        CGFloat startPointY = 0;
        if (leftLineTop) {
            startPointY = inset.topLeft+contentY;
            startPointY = startPointY + self.offPoint.y + self.angleWidth;
            [path addLineToPoint:CGPointMake(contentX, startPointY)];
            [path addLineToPoint:CGPointMake(contentX+self.offPoint.x, startPointY - self.angleWidth/2)];
            [path addLineToPoint:CGPointMake(contentX, startPointY - self.angleWidth)];
            corner ^= UIRectCornerTopLeft;
        }else if (leftLineBottom) {
            startPointY = maxY;
            startPointY = startPointY + self.offPoint.y;
            [path addLineToPoint:CGPointMake(contentX, startPointY)];
            [path addLineToPoint:CGPointMake(contentX + self.offPoint.x, startPointY - self.angleWidth/2)];
            [path addLineToPoint:CGPointMake(contentX, startPointY - self.angleWidth)];
            corner ^= UIRectCornerBottomLeft;
        }
    }
    [path addLineToPoint:CGPointMake(contentX, inset.topLeft+contentY)];//left edge
    
    //draw corner radius
    //https://blog.csdn.net/zhanglizhi111/article/details/106875201/
    //topLeft
    [path moveToPoint:CGPointMake(contentX, inset.topLeft+contentY)];
    [path addArcWithCenter:CGPointMake(inset.topLeft+contentX, inset.topLeft+contentY) radius:inset.topLeft startAngle:1 * M_PI endAngle:1.5 * M_PI clockwise:YES];
    //topRight
    [path moveToPoint:CGPointMake(maxX-inset.topRight,contentY)];
    [path addArcWithCenter:CGPointMake(maxX - inset.topRight, inset.topRight+contentY) radius:inset.topRight startAngle:1.5 * M_PI endAngle:0 * M_PI clockwise:YES];
    //bottomRight
    [path moveToPoint:CGPointMake(maxX, maxY-inset.bottomRight)];
    [path addArcWithCenter:CGPointMake(maxX-inset.bottomRight, maxY-inset.bottomRight)radius:inset.bottomRight startAngle:0 * M_PI endAngle:0.5 * M_PI clockwise:YES];
    //bottomLeft
    [path moveToPoint:CGPointMake(inset.bottomLeft+contentX, maxY)];
    [path addArcWithCenter:CGPointMake(inset.bottomLeft+contentX, maxY-inset.bottomLeft) radius:inset.bottomLeft startAngle:0.5 * M_PI endAngle:1 * M_PI clockwise:YES];
    
    //set color
    [self.lineColor set];
    [path stroke];
    [self.fillColor set];
    [path fill];
    CAShapeLayer *shape = self.bubbleLayer;
    shape.strokeColor = self.lineColor.CGColor;
    shape.fillColor = (self.fillColor ?: self.backgroundColor).CGColor;
    shape.lineWidth = self.lineWidth;
    shape.path= path.CGPath;
}

#pragma mark - public

- (void)draw {
    //check the corner and offPoint is valid.
    checkValid(self.corner, self.offPoint);
    
    //set contentView frame and corner
    self.contentView.frame = [self _layoutContentViewFrame];
    [self.contentView rectCornerRadius:self.cornerRadius];
    
    //set bubbleLayer frame
    CGSize size = [self _layoutSize];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    self.bubbleLayer.frame = rect;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height);
    
    //draw again
    [self _drawPath];
}


/**
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/


@end

@implementation UIView (Corner)

- (void)rectCornerRadius:(WBRectCornerRadius)cornerRadius
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
