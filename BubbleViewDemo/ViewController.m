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
    bubble.corner = UIRectCornerTopRight;
    bubble.offPoint = CGPointMake(30, 30);
    bubble.fillColor = [UIColor whiteColor];
    bubble.lineColor = [UIColor purpleColor];
    bubble.lineWidth = 5.f;
    bubble.cornerRadius = WBRectCornerRadiusMake(15, 15, 15, 15);
    [self.view addSubview:bubble];
    
    bubble.contentView.backgroundColor = [UIColor whiteColor];
    
    [bubble draw];
}


@end
