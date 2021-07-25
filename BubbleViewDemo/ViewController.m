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
    self.view.backgroundColor = [UIColor blackColor];
    
    BubbleView *bubble = [[BubbleView alloc] initWithOrigin:CGPointMake(100.f, 200.f)];
    bubble.contentSize = CGSizeMake(150, 80.f);
    bubble.corner = UIRectCornerBottomLeft;
    //corner和edge是互斥的，corner要比edge灵活。如果设置了corner就不要设置edge。反之亦然。
    //bubble.edge = UIRectEdgeBottom;
    bubble.offPoint = CGPointMake(40, 20);
    bubble.fillColor = [UIColor whiteColor];
    bubble.lineColor = [UIColor purpleColor];
    bubble.lineWidth = 2.5f;
    bubble.cornerRadius = WBRectCornerRadiusMake(15, 15, 15, 15);
    bubble.angleCurve = YES;
    bubble.curveCotrol = 5.f;
    [self.view addSubview:bubble];
    
    bubble.backgroundColor = [UIColor greenColor];
    bubble.contentView.backgroundColor = [UIColor whiteColor];
    
    [bubble draw];
}


@end
