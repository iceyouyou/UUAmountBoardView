//
//  UUAmountBoardView.h
//  UUAmountBoardViewDemo
//
//  Created by youyou on 2017/10/9.
//  Copyright © 2017年 iceyouyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UUAmountBoardView : UIView

- (instancetype)initWithFrame:(CGRect)frame
                amountPattern:(NSString*)amountPattern  // 初始占位符
                     unitSize:(CGSize)unitSize          // 一个数字单位的Size
                  unitSpacing:(CGFloat)unitSpacing      // 每个数字单位的间距
                     textFont:(UIFont*)textFont         // 显示内容的字体
                    textColor:(UIColor*)textColor       // 显示内容的字体颜色
                   textOffset:(CGPoint)textOffset       // 显示内容的偏移量
                  unitBgImage:(UIImage*)unitBgImage;    // 每个数字单位的背景图
- (instancetype)initWithAmountPattern:(NSString*)amountPattern
                             unitSize:(CGSize)unitSize
                          unitSpacing:(CGFloat)unitSpacing
                             textFont:(UIFont*)textFont
                            textColor:(UIColor*)textColor
                           textOffset:(CGPoint)textOffset
                          unitBgImage:(UIImage*)unitBgImage;
- (instancetype)initWithFrame:(CGRect)frame
                amountPattern:(NSString*)amountPattern  // 初始占位符
                     unitSize:(CGSize)unitSize          // 一个数字单位的Size
                  unitSpacing:(CGFloat)unitSpacing      // 每个数字单位的间距
                     textFont:(UIFont*)textFont         // 显示内容的字体
                    textColor:(UIColor*)textColor       // 显示内容的字体颜色
                   textOffset:(CGPoint)textOffset       // 显示内容的偏移量
              unitBgViewMaker:(void (^)(UIView *unitBgView))unitBgViewMaker;    // 构建每个数字单位背景View的回调
- (instancetype)initWithAmountPattern:(NSString*)amountPattern
                             unitSize:(CGSize)unitSize
                          unitSpacing:(CGFloat)unitSpacing
                             textFont:(UIFont*)textFont
                            textColor:(UIColor*)textColor
                           textOffset:(CGPoint)textOffset
                      unitBgViewMaker:(void (^)(UIView *unitBgView))unitBgViewMaker;

- (void)setAmount:(NSString*)amount;        // 设置目标金额
- (void)countingToAmount;                   // 滚动到已设置的目标金额
- (void)countingToAmount:(NSString*)amount; // 滚动到指定目标金额

@end

#pragma mark - UUAmountBoardTableView(Private)
@interface UUAmountBoardTableView : UITableView
@property (nonatomic, copy) NSString *placeholder;  // 若不可滚动时显示的占位字符
@end

#pragma mark - UUAmountBoardTableViewCell(Private)
@interface UUAmountBoardTableViewCell : UITableViewCell
- (void)setContent:(NSString*)content;
- (instancetype)initWithTextFont:(UIFont*)textFont textColor:(UIColor*)textColor textOffset:(CGPoint)textOffset reuseIdentifier:(nullable NSString *)reuseIdentifier;
@end
