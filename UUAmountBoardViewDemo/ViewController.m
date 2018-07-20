//
//  ViewController.m
//  UUAmountBoardViewDemo
//
//  Created by Ye Yang on 2018/7/19.
//  Copyright © 2018年 iceyouyou. All rights reserved.
//

#import "ViewController.h"
#import "UUAmountBoardView.h"

@interface ViewController ()

@property (nonatomic, strong) UUAmountBoardView *firstAmountBoardView;
@property (nonatomic, strong) UUAmountBoardView *secondAmountBoardView;
@property (nonatomic, strong) UUAmountBoardView *thirdAmountBoardView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // the first AmountBoardView
    _firstAmountBoardView = [[UUAmountBoardView alloc] initWithFrame:(CGRectMake(20.0f, 105.0f, 0.0f, 0.0f))
                                                       amountPattern:@"000"
                                                            unitSize:CGSizeMake(20.0f, 25.0f)
                                                         unitSpacing:4.0f
                                                            textFont:[UIFont fontWithName:@"DINCondensed-Bold" size:24.0f]
                                                           textColor:[UIColor colorWithRed:(255.0f / 255.0f) green:(70.0f / 255.0f) blue:(71.0f / 255.0f) alpha:1.0f]
                                                          textOffset:CGPointMake(0.0f, 3.0f)
                                                         unitBgImage:[UIImage imageNamed:@"unitBgImage"]];
    [_firstAmountBoardView setAmount:@"7,654,321"];
    [self.view addSubview:_firstAmountBoardView];

    // the second AmountBoardView
    _secondAmountBoardView = [[UUAmountBoardView alloc] initWithFrame:(CGRectMake(20.0f, 175.0f, 0.0f, 0.0f))
                                                        amountPattern:@"000"
                                                             unitSize:CGSizeMake(20.0f, 25.0f)
                                                          unitSpacing:4.0f
                                                             textFont:[UIFont fontWithName:@"DINCondensed-Bold" size:24.0f]
                                                            textColor:[UIColor colorWithRed:(255.0f / 255.0f) green:(70.0f / 255.0f) blue:(71.0f / 255.0f) alpha:1.0f]
                                                           textOffset:CGPointMake(0.0f, 3.0f)
                                                        unitBgViewMaker:^(UIView *unitBgView) {
                                                            unitBgView.layer.borderWidth = 0.5f;
                                                            unitBgView.layer.borderColor = [UIColor colorWithRed:(255.0f / 255.0f) green:(70.0f / 255.0f) blue:(71.0f / 255.0f) alpha:1.0f].CGColor;
                                                            unitBgView.layer.cornerRadius = 4.0f;
                                                        }];
    [_secondAmountBoardView setAmount:@"3532407"];
    [self.view addSubview:_secondAmountBoardView];

    // the third AmountBoardView
    _thirdAmountBoardView = [[UUAmountBoardView alloc] initWithFrame:(CGRectMake(20.0f, 220.0f, 0.0f, 0.0f))
                                                        amountPattern:@"0,000,000"
                                                             unitSize:CGSizeMake(20.0f, 25.0f)
                                                         unitSpacing:4.0f
                                                            textFont:[UIFont systemFontOfSize:20.0f]
                                                           textColor:[UIColor colorWithRed:(10.0f / 255.0f) green:(126.0f / 255.0f) blue:(240.0f / 255.0f) alpha:1.0f]
                                                          textOffset:CGPointZero
                                                      unitBgViewMaker:^(UIView *unitBgView) {
                                                          unitBgView.layer.borderWidth = 0.5f;
                                                          unitBgView.layer.borderColor = [UIColor colorWithRed:(134.0f / 255.0f) green:(175.0f / 255.0f) blue:(241.0f / 255.0f) alpha:1.0f].CGColor;
                                                          unitBgView.layer.cornerRadius = 4.0f;

                                                          CAGradientLayer *gradientLayer = [CAGradientLayer layer];
                                                          gradientLayer.frame = unitBgView.bounds;
                                                          gradientLayer.cornerRadius = 4.0f;
                                                          [gradientLayer setColors:@[(id)[UIColor colorWithRed:(217.0f / 255.0f) green:(228.0f / 255.0f) blue:(254.0f / 255.0f) alpha:1.0f].CGColor,
                                                                                     (id)[UIColor colorWithRed:(245.0f / 255.0f) green:(245.0f / 255.0f) blue:(245.0f / 255.0f) alpha:1.0f].CGColor]];
                                                          [gradientLayer setStartPoint:CGPointMake(0.5f, 0.0f)];
                                                          [gradientLayer setEndPoint:CGPointMake(0.5f, 1.0f)];
                                                          [unitBgView.layer addSublayer:gradientLayer];

                                                          UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(3.0f, CGRectGetHeight(unitBgView.bounds) / 2.0f, CGRectGetWidth(unitBgView.bounds) - 6.0f, 0.5f)];
                                                          [lineView setBackgroundColor:[UIColor colorWithRed:(160.0f / 255.0f) green:(215.0f / 255.0f) blue:(232.0f / 255.0f) alpha:1.0f]];
                                                          [unitBgView addSubview:lineView];
                                                      }];
    [self.view addSubview:_thirdAmountBoardView];

    // layout
    [self nothingImportant];
}

- (void)nothingImportant {
    CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;

    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 40.0f, screenWidth - 40.0f, 20.0f)];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"UUAmountBoardView Demo";
    title.font = [UIFont systemFontOfSize:14.0f];
    [self.view addSubview:title];

    // AmountBoardView with UIImageView background
    UILabel *imageBgAmountBoardTitle = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 80.0f, screenWidth - 40.0f, 20.0f)];
    imageBgAmountBoardTitle.text = @"UIImageView background";
    imageBgAmountBoardTitle.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:imageBgAmountBoardTitle];

    // AmountBoardView with Custom UIView background
    UILabel *viewBgAmountBoardTitle = [[UILabel alloc] initWithFrame:CGRectMake(20.0f, 150.0f, screenWidth - 40.0f, 20.0f)];
    viewBgAmountBoardTitle.text = @"Custom UIView background";
    viewBgAmountBoardTitle.font = [UIFont systemFontOfSize:12.0f];
    [self.view addSubview:viewBgAmountBoardTitle];

    UIButton *startCountingBtn = [[UIButton alloc] initWithFrame:CGRectMake(20.0f, 285.0f, 50.0f, 20.0f)];
    startCountingBtn.titleLabel.font = [UIFont systemFontOfSize:10.0f];
    [startCountingBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [startCountingBtn setTitle:@"Start" forState:UIControlStateNormal];
    startCountingBtn.layer.cornerRadius = 4.0f;
    startCountingBtn.layer.borderWidth = 1.0f;
    [self.view addSubview:startCountingBtn];
    [startCountingBtn addTarget:self action:@selector(handleStartCountingAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)handleStartCountingAction:(id)sender {
    [_firstAmountBoardView countingToAmount];
    [_secondAmountBoardView countingToAmount];
    [_thirdAmountBoardView countingToAmount:@"8,392,058"];
}

@end
