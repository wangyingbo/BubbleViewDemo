//
//  ViewController.m
//  BubbleViewDemo
//
//  Created by 王迎博 on 2021/7/20.
//  Copyright © 2021 王颖博. All rights reserved.
//

#import "ViewController.h"
#import "BubbleView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    BubbleView *bubble = [[BubbleView alloc] initWithOrigin:CGPointMake(100.f, 200.f)];
    bubble.contentSize = CGSizeMake(150, 80.f);
    bubble.corner = UIRectCornerBottomLeft;
    //corner和edge是互斥的，corner要比edge灵活。如果设置了corner就不要设置edge。反之亦然。
    //bubble.edge = UIRectEdgeBottom;
    bubble.offPoint = CGPointMake(100, 20);
    bubble.fillColor = [UIColor whiteColor];
    bubble.lineColor = [UIColor purpleColor];
    bubble.lineWidth = 2.5f;
    bubble.cornerRadius = WBRectCornerRadiusMake(15, 15, 15, 15);
    bubble.angleCurve = YES;
    bubble.curveCotrol = 5.f;
    bubble.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bubble];
    //如果修改了bubble的属性，需要再次调用-draw方法，刷新绘制；
    [bubble draw];
    
    //可以给contentView添加子控件。动态更改contentView的size布局。
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.font = [UIFont systemFontOfSize:15.f];
    tipLabel.text = @"this is a bubble tip";
    [bubble.contentView addSubview:tipLabel];
    [tipLabel sizeToFit];
    tipLabel.center = bubble.contentView.center;
}


@end
