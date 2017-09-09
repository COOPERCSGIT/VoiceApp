//
//  UILabel+Extension.h
//  smartHR
//
//  Created by 叶健东 on 16/11/15.
//  Copyright © 2016年 www.huirenshi.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (Extension)

+ (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
             numberOfLines:(NSInteger)lines
             textAlignment:(NSTextAlignment)textAlignment;

+(UIImage *)fixOrientation:(UIImage* )aImage;
/**
 *  自己粗略做的一个指示器=。=
 *
 *  @param stats 提示内容
 *  @param view  添加到view上
 */
+ (void)showStats:(NSString *)stats atView:(UIView *)view;
//+ (void)showStat:(NSString *)stats atView:(UIView *)view;
/**
 *  快速设置富文本
 *
 *  @param string 需要设置的字符串
 *  @param range  需要设置的范围（范围文字颜色显示为下厨房橘红色）
 */
- (void)setAttributeTextWithString:(NSString *)string range:(NSRange)range;


+(NSData*)resetSizeOfImageData:(UIImage *)source_image;

+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size;

@end
