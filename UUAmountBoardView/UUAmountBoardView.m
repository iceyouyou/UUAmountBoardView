//
//  UUAmountBoardView.m
//  UUAmountBoardViewDemo
//
//  Created by youyou on 2017/10/9.
//  Copyright © 2017年 iceyouyou. All rights reserved.
//

#import "UUAmountBoardView.h"
#import <pop/POP.h>

@interface UUAmountBoardView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) NSString *amountPattern;
@property (nonatomic, copy) NSString *amount;
@property (nonatomic, copy) NSString *amountString;

@property (nonatomic, assign) CGSize unitSize;
@property (nonatomic, assign) CGFloat unitSpacing;

@property (nonatomic, strong) UIFont *textFont;
@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, assign) CGPoint textOffset;

@property (nonatomic, strong) UIImage *unitBgImage;
@property (nonatomic, copy) void (^unitBgViewMaker)(UIView *unitBgView);

@property (nonatomic, strong) NSMutableArray<UUAmountBoardTableView*> *units;
@property (nonatomic, strong) NSMutableArray<UIView*> *unitBgViews;

@end

@implementation UUAmountBoardView

static int ROUNDS_IN_COUNTING = 1;   // 滚动到指定位置时跨过的完整圈数(0~9为一圈)

- (instancetype)initWithFrame:(CGRect)frame
                amountPattern:(NSString*)amountPattern
                     unitSize:(CGSize)unitSize
                  unitSpacing:(CGFloat)unitSpacing
                     textFont:(UIFont*)textFont
                    textColor:(UIColor*)textColor
                   textOffset:(CGPoint)textOffset
                  unitBgImage:(UIImage*)unitBgImage {
    if (self = [super initWithFrame:frame]) {
        _amountPattern = amountPattern;
        _unitSize = unitSize;
        _unitSpacing = unitSpacing;
        _textFont = textFont;
        _textColor = textColor;
        _textOffset = textOffset;
        _unitBgImage = unitBgImage;
        [self createUnitBgs];
        [self createUnits];
    }
    return self;
}

- (instancetype)initWithAmountPattern:(NSString*)amountPattern
                             unitSize:(CGSize)unitSize
                          unitSpacing:(CGFloat)unitSpacing
                             textFont:(UIFont*)textFont
                            textColor:(UIColor*)textColor
                           textOffset:(CGPoint)textOffset
                          unitBgImage:(UIImage*)unitBgImage {
    if (self = [super init]) {
        _amountPattern = amountPattern;
        _unitSize = unitSize;
        _unitSpacing = unitSpacing;
        _textFont = textFont;
        _textColor = textColor;
        _textOffset = textOffset;
        _unitBgImage = unitBgImage;
        [self createUnitBgs];
        [self createUnits];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
                amountPattern:(NSString*)amountPattern
                     unitSize:(CGSize)unitSize
                  unitSpacing:(CGFloat)unitSpacing
                     textFont:(UIFont*)textFont
                    textColor:(UIColor*)textColor
                   textOffset:(CGPoint)textOffset
              unitBgViewMaker:(void (^)(UIView *unitBgView))unitBgViewMaker {
    if (self = [super initWithFrame:frame]) {
        _amountPattern = amountPattern;
        _unitSize = unitSize;
        _unitSpacing = unitSpacing;
        _textFont = textFont;
        _textColor = textColor;
        _textOffset = textOffset;
        _unitBgViewMaker = unitBgViewMaker;
        [self createUnitBgs];
        [self createUnits];
    }
    return self;
}

- (instancetype)initWithAmountPattern:(NSString*)amountPattern
                             unitSize:(CGSize)unitSize
                          unitSpacing:(CGFloat)unitSpacing
                             textFont:(UIFont*)textFont
                            textColor:(UIColor*)textColor
                           textOffset:(CGPoint)textOffset
                      unitBgViewMaker:(void (^)(UIView *unitBgView))unitBgViewMaker {
    if (self = [super init]) {
        _amountPattern = amountPattern;
        _unitSize = unitSize;
        _unitSpacing = unitSpacing;
        _textFont = textFont;
        _textColor = textColor;
        _textOffset = textOffset;
        _unitBgViewMaker = unitBgViewMaker;
        [self createUnitBgs];
        [self createUnits];
    }
    return self;
}

- (void)createUnitBgs {
    if (!_unitBgViews) {
        self.unitBgViews = [NSMutableArray array];
    } else {
        [_unitBgViews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_unitBgViews removeAllObjects];
    }

    if (_unitBgImage) {
        for (int i = 0; i < _amountPattern.length; i++) {
            UIImageView *unitBgView = [[UIImageView alloc] initWithImage:_unitBgImage];
            [unitBgView setFrame:CGRectMake((_unitSize.width + _unitSpacing) * i,
                                            0.0f,
                                            _unitSize.width,
                                            _unitSize.height)];
            [self addSubview:unitBgView];
            [_unitBgViews addObject:unitBgView];
        }
    } else if (_unitBgViewMaker) {
        for (int i = 0; i < _amountPattern.length; i++) {
            UIView *unitBgView = [[UIView alloc] init];
            [unitBgView setFrame:CGRectMake((_unitSize.width + _unitSpacing) * i,
                                            0.0f,
                                            _unitSize.width,
                                            _unitSize.height)];
            _unitBgViewMaker(unitBgView);
            [self addSubview:unitBgView];
            [_unitBgViews addObject:unitBgView];
        }
    } else {
        for (int i = 0; i < _amountPattern.length; i++) {
            UIView *unitBgView = [[UIView alloc] init];
            [unitBgView setFrame:CGRectMake((_unitSize.width + _unitSpacing) * i,
                                            0.0f,
                                            _unitSize.width,
                                            _unitSize.height)];
            [self addSubview:unitBgView];
            [_unitBgViews addObject:unitBgView];
        }
    }
}

- (void)fixUnitBgs {
    if (!_unitBgViews) {
        self.unitBgViews = [NSMutableArray array];
    }

    if (_unitBgImage) {
        NSMutableArray *unitBgNeedsRemove = [NSMutableArray array];
        for (int i = 0; i < MAX(_amountPattern.length, _unitBgViews.count); i++) {
            if (i < MIN(_amountPattern.length, _unitBgViews.count)) {
                // 已创建，无需重置内容
            } else if (i >= _amountPattern.length && i < _units.count) {
                // 已创建，多余需删除
                [_unitBgViews[i] removeFromSuperview];
                [unitBgNeedsRemove addObject:_unitBgViews[i]];
            } else {
                // 初次创建
                UIImageView *unitBgView = [[UIImageView alloc] initWithImage:_unitBgImage];
                [unitBgView setFrame:CGRectMake((_unitSize.width + _unitSpacing) * i,
                                                0.0f,
                                                _unitSize.width,
                                                _unitSize.height)];
                [self addSubview:unitBgView];
                [_unitBgViews addObject:unitBgView];
            }
        }
        // 删除多余UnitBg
        [_unitBgViews removeObjectsInArray:unitBgNeedsRemove];
    } else if (_unitBgViewMaker) {
        NSMutableArray *unitBgNeedsRemove = [NSMutableArray array];
        for (int i = 0; i < MAX(_amountPattern.length, _unitBgViews.count); i++) {
            if (i < MIN(_amountPattern.length, _unitBgViews.count)) {
                // 已创建，仅需重置内容
                [_unitBgViews[i].subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                _unitBgViewMaker(_unitBgViews[i]);
            } else if (i >= _amountPattern.length && i < _units.count) {
                // 已创建，多余需删除
                [_unitBgViews[i] removeFromSuperview];
                [unitBgNeedsRemove addObject:_unitBgViews[i]];
            } else {
                // 初次创建
                UIView *unitBgView = [[UIView alloc] init];
                [unitBgView setFrame:CGRectMake((_unitSize.width + _unitSpacing) * i,
                                                0.0f,
                                                _unitSize.width,
                                                _unitSize.height)];
                _unitBgViewMaker(unitBgView);
                [self addSubview:unitBgView];
                [_unitBgViews addObject:unitBgView];
            }
        }
        // 删除多余UnitBg
        [_unitBgViews removeObjectsInArray:unitBgNeedsRemove];
    } else {
        NSMutableArray *unitBgNeedsRemove = [NSMutableArray array];
        for (int i = 0; i < MAX(_amountPattern.length, _unitBgViews.count); i++) {
            if (i < MIN(_amountPattern.length, _unitBgViews.count)) {
                // 已创建，无需重置内容
            } else if (i >= _amountPattern.length && i < _units.count) {
                // 已创建，多余需删除
                [_unitBgViews[i] removeFromSuperview];
                [unitBgNeedsRemove addObject:_unitBgViews[i]];
            } else {
                // 初次创建
                UIView *unitBgView = [[UIView alloc] init];
                [unitBgView setFrame:CGRectMake((_unitSize.width + _unitSpacing) * i,
                                                0.0f,
                                                _unitSize.width,
                                                _unitSize.height)];
                [self addSubview:unitBgView];
                [_unitBgViews addObject:unitBgView];
            }
        }
        // 删除多余UnitBg
        [_unitBgViews removeObjectsInArray:unitBgNeedsRemove];
    }
}

- (void)createUnits {
    if (!_units) {
        self.units = [NSMutableArray array];
    } else {
        [_units makeObjectsPerformSelector:@selector(removeFromSuperview)];
        [_units removeAllObjects];
    }

    for (int i = 0; i < _amountPattern.length; i++) {
        NSString *unitStr = [_amountPattern substringWithRange:NSMakeRange(i, 1)];

        UUAmountBoardTableView *unit = [[UUAmountBoardTableView alloc] initWithFrame:CGRectMake((_unitSize.width + _unitSpacing) * i, 0.0f, _unitSize.width, _unitSize.height) style:UITableViewStyleGrouped];
        if (@available(iOS 11.0, *)) {
            unit.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
        unit.tag = i;
        if ([self isPureInt:unitStr]) {
            [unit setScrollEnabled:YES];    // 数字，可滚动
        } else {
            [unit setScrollEnabled:NO];     // 非数字，不可滚动
            unit.placeholder = unitStr;
        }
        unit.backgroundColor = [UIColor clearColor];
        unit.estimatedRowHeight = _unitSize.height;
        unit.delegate = self;
        unit.dataSource = self;
        unit.showsVerticalScrollIndicator = NO;
        unit.showsHorizontalScrollIndicator = NO;
        unit.separatorStyle = UITableViewCellSeparatorStyleNone;
        unit.userInteractionEnabled = NO;
        [self addSubview:unit];

        [_units addObject:unit];
    }
}

- (void)fixUnits {
    if (!_units) {
        self.units = [NSMutableArray array];
    }

    NSMutableArray *unitNeedsRemove = [NSMutableArray array];
    for (int i = 0; i < MAX(_amountPattern.length, _units.count); i++) {
        if (i < MIN(_amountPattern.length, _units.count)) {
            // 已创建，仅需重置内容
            NSString *unitStr = [_amountPattern substringWithRange:NSMakeRange(i, 1)];
            UUAmountBoardTableView *unit = _units[i];
            unit.placeholder = unitStr;
            if ([self isPureInt:unitStr]) {
                [unit setScrollEnabled:YES];    // 数字，可滚动
            } else {
                [unit setScrollEnabled:NO];     // 非数字，不可滚动
            }
        } else if (i >= _amountPattern.length && i < _units.count) {
            // 已创建，多余需删除
            [_units[i] removeFromSuperview];
            [unitNeedsRemove addObject:_units[i]];
        } else {
            // 初次创建
            NSString *unitStr = [_amountPattern substringWithRange:NSMakeRange(i, 1)];

            UUAmountBoardTableView *unit = [[UUAmountBoardTableView alloc] initWithFrame:CGRectMake((_unitSize.width + _unitSpacing) * i, 0.0f, _unitSize.width, _unitSize.height) style:UITableViewStyleGrouped];
            if (@available(iOS 11.0, *)) {
                unit.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
            }
            unit.tag = i;
            unit.placeholder = unitStr;
            if ([self isPureInt:unitStr]) {
                [unit setScrollEnabled:YES];    // 数字，可滚动
            } else {
                [unit setScrollEnabled:NO];     // 非数字，不可滚动
            }
            unit.backgroundColor = [UIColor clearColor];
            unit.estimatedRowHeight = _unitSize.height;
            unit.delegate = self;
            unit.dataSource = self;
            unit.showsVerticalScrollIndicator = NO;
            unit.showsHorizontalScrollIndicator = NO;
            unit.separatorStyle = UITableViewCellSeparatorStyleNone;
            unit.userInteractionEnabled = NO;
            [self addSubview:unit];

            [_units addObject:unit];
        }
    }

    // 删除多余Unit
    [_units removeObjectsInArray:unitNeedsRemove];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self setFrame:CGRectMake(CGRectGetMinX(self.frame),
                              CGRectGetMinY(self.frame),
                              _amountPattern.length * _unitSize.width + (_amountPattern.length - 1) * _unitSpacing,
                              _unitSize.height)];

    for (int i = 0; i < _unitBgViews.count; i++) {
        [_unitBgViews[i] setFrame:CGRectMake((_unitSize.width + _unitSpacing) * i, 0.0f, _unitSize.width, _unitSize.height)];
    }

    for (int i = 0; i < _units.count; i++) {
        [_units[i] setFrame:CGRectMake((_unitSize.width + _unitSpacing) * i, 0.0f, _unitSize.width, _unitSize.height)];
    }
}

- (void)setAmount:(NSString*)amount {
    if (!amount || [amount isEqualToString:@""]) {
        return;
    }

    _amountString = nil;
    if (![_amount isEqualToString:amount]) {
        BOOL isContentSizeChanged = (amount.length != _units.count);

        _amount = amount;
        _amountPattern = amount;
        [self fixUnitBgs];
        [self fixUnits];

        if (isContentSizeChanged) {
            [self invalidateIntrinsicContentSize];
        }
    }

    for (int i = 0; i < _units.count; i++) {
        if (_units[i].isScrollEnabled) {
            NSString *unitStr = [amount substringWithRange:NSMakeRange(i, 1)];
            if (@available(iOS 11.0, *)) {
                [_units[i] setContentOffset:CGPointMake(0.0f, [unitStr intValue] * _unitSize.height)];
            } else {
                [_units[i] scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:[unitStr intValue] inSection:0] atScrollPosition:UITableViewScrollPositionNone animated:NO];
            }
        }
    }
}

- (void)countingToAmount {
    if (!_amount || [_amount isEqualToString:@""]) {
        return;
    }

    _amountString = nil;
    for (int i = 0; i < _units.count; i++) {
        if (_units[i].isScrollEnabled) {
            NSString *unitStr = [_amount substringWithRange:NSMakeRange(i, 1)];
            POPBasicAnimation *unitCountingAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPTableViewContentOffset];
            unitCountingAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
            unitCountingAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, (_unitSize.height * ROUNDS_IN_COUNTING * 10) + (_unitSize.height * [unitStr intValue]))];
            unitCountingAnimation.beginTime = CACurrentMediaTime();
            unitCountingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            unitCountingAnimation.duration = 2.0 + (i * 0.3);
            [_units[i] pop_addAnimation:unitCountingAnimation forKey:@"unitCountingAnimation"];
        }
    }
}

- (void)countingToAmount:(NSString*)amount {
    if (!amount || [amount isEqualToString:@""]) {
        return;
    }

    _amountString = nil;
    if (![_amount isEqualToString:amount]) {
        BOOL isContentSizeChanged = (amount.length != _units.count);

        _amount = amount;
        _amountPattern = amount;
        [self fixUnitBgs];
        [self fixUnits];

        if (isContentSizeChanged) {
            [self invalidateIntrinsicContentSize];
        }
    }

    for (int i = 0; i < _units.count; i++) {
        if (_units[i].isScrollEnabled) {
            NSString *unitStr = [_amount substringWithRange:NSMakeRange(i, 1)];
            POPBasicAnimation *unitCountingAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPTableViewContentOffset];
            unitCountingAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
            unitCountingAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, (_unitSize.height * ROUNDS_IN_COUNTING * 10) + (_unitSize.height * [unitStr intValue]))];
            unitCountingAnimation.beginTime = CACurrentMediaTime();
            unitCountingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            unitCountingAnimation.duration = 2.0 + (i * 0.3);
            [_units[i] pop_addAnimation:unitCountingAnimation forKey:@"unitCountingAnimation"];
        }
    }
}

- (void)countingToAmountString:(NSString*)amountString {
    if (!amountString || [amountString isEqualToString:@""]) {
        return;
    }

    _amountString = amountString;
    NSMutableString *fakeAmount = [NSMutableString string];
    for (int i = 0; i < _amountString.length; i++) {
        [fakeAmount appendString:@"0"];
    }

    if (![_amount isEqualToString:fakeAmount]) {
        BOOL isContentSizeChanged = (fakeAmount.length != _units.count);

        _amount = fakeAmount;
        _amountPattern = fakeAmount;
        [self fixUnitBgs];
        [self fixUnits];

        if (isContentSizeChanged) {
            [self invalidateIntrinsicContentSize];
        }
    }

    for (int i = 0; i < _units.count; i++) {
        if (_units[i].isScrollEnabled) {
            NSString *unitStr = [_amount substringWithRange:NSMakeRange(i, 1)];
            POPBasicAnimation *unitCountingAnimation = [POPBasicAnimation animationWithPropertyNamed:kPOPTableViewContentOffset];
            unitCountingAnimation.fromValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, 0.0f)];
            unitCountingAnimation.toValue = [NSValue valueWithCGPoint:CGPointMake(0.0f, (_unitSize.height * ROUNDS_IN_COUNTING * 10) + (_unitSize.height * [unitStr intValue]))];
            unitCountingAnimation.beginTime = CACurrentMediaTime();
            unitCountingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
            unitCountingAnimation.duration = 2.0 + (i * 0.3);
            [_units[i] pop_addAnimation:unitCountingAnimation forKey:@"unitCountingAnimation"];
        }
    }
}

#pragma mark - AutoLayout
- (CGFloat)viewWidth {
    return _unitBgViews.count * _unitSize.width + (_unitBgViews.count - 1) * _unitSpacing;
}

- (CGFloat)viewHeight {
    return _unitSize.height;
}

- (CGSize)intrinsicContentSize {
    return CGSizeMake([self viewWidth], [self viewHeight]);
}

#pragma mark - Utils
- (BOOL)isPureInt:(NSString *)string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return _unitSize.height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.1f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.1f;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"AmountBoardTableViewCellReuseId";
    UUAmountBoardTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (nil == cell) {
        cell = [[UUAmountBoardTableViewCell alloc] initWithTextFont:_textFont textColor:_textColor textOffset:_textOffset reuseIdentifier:reuseId];
    }

    if (tableView.isScrollEnabled) {
        if (!_amountString) {
            [cell setContent:[NSString stringWithFormat:@"%ld", (indexPath.row % 10)]];
        } else {
            // only used for @selector(countingToAmountString:)
            if (indexPath.row == ROUNDS_IN_COUNTING * 10) {
                [cell setContent:[_amountString substringWithRange:NSMakeRange(tableView.tag, 1)]];
            } else {
                [cell setContent:[NSString stringWithFormat:@"%ld", (indexPath.row % 10)]];
            }
        }
    } else {
        [cell setContent:((UUAmountBoardTableView*)tableView).placeholder];
    }

    return cell;
}

@end

#pragma mark - UUAmountBoardTableView(Private)
@implementation UUAmountBoardTableView

@end

#pragma mark - UUAmountBoardTableViewCell(Private)
@interface UUAmountBoardTableViewCell ()

@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation UUAmountBoardTableViewCell

- (instancetype)initWithTextFont:(UIFont*)textFont textColor:(UIColor*)textColor textOffset:(CGPoint)textOffset reuseIdentifier:(nullable NSString *)reuseIdentifier {
    if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setBackgroundColor:[UIColor clearColor]];
        [self.contentView setBackgroundColor:[UIColor clearColor]];

        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = textFont;
        _contentLabel.textColor = textColor;
        [_contentLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_contentLabel];

        NSLayoutConstraint *centerXConstraint = [NSLayoutConstraint constraintWithItem:_contentLabel
                                                                             attribute:NSLayoutAttributeCenterX
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeCenterX
                                                                            multiplier:1.0f
                                                                              constant:textOffset.x];
        NSLayoutConstraint *centerYConstraint = [NSLayoutConstraint constraintWithItem:_contentLabel
                                                                             attribute:NSLayoutAttributeCenterY
                                                                             relatedBy:NSLayoutRelationEqual
                                                                                toItem:self.contentView
                                                                             attribute:NSLayoutAttributeCenterY
                                                                            multiplier:1.0f
                                                                              constant:textOffset.y];
        [self.contentView addConstraints:@[centerXConstraint, centerYConstraint]];
    }
    return self;
}

- (void)prepareForReuse {
    [super prepareForReuse];
    _contentLabel.text = @"";
}

- (void)setContent:(NSString*)content {
    _contentLabel.text = content;
}

@end
