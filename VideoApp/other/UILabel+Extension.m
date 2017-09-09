//
//  UILabel+Extension.m
//  smartHR
//
//  Created by 叶健东 on 16/11/15.
//  Copyright © 2016年 www.huirenshi.com. All rights reserved.
//

#import "UILabel+Extension.h"

@implementation UILabel (Extension)

+ (UILabel *)labelWithFont:(UIFont *)font
                 textColor:(UIColor *)textColor
             numberOfLines:(NSInteger)lines
             textAlignment:(NSTextAlignment)textAlignment {
    UILabel *label = [[UILabel alloc] init];
    label.font = font;
    label.textColor = textColor;
    label.numberOfLines = lines;
    label.textAlignment = textAlignment;
    return label;
}


+ (void)showStats:(NSString *)stats atView:(UIView *)view {
    
    UILabel *message = [[UILabel alloc] init];
    message.layer.cornerRadius = 10;
    message.clipsToBounds = YES;
    message.backgroundColor = RGBA(0, 0, 0, 0.8);
    message.numberOfLines = 0;
    message.font = [UIFont systemFontOfSize:13];
    message.textColor =[UIColor whiteColor] ;
    message.textAlignment = NSTextAlignmentCenter;
    message.alpha = 0;
    
    message.text = stats;
    CGSize size = [stats boundingRectWithSize:CGSizeMake(MAXFLOAT, 50)
                                      options:NSStringDrawingUsesLineFragmentOrigin
                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:14]}
                                      context:nil].size;
    message.frame = CGRectMake(KScreenWidth/2-size.width/2-35, 10, size.width + 45, size.height + 5);

    [view addSubview:message];
    
    [UIView animateWithDuration:.5 animations:^{
        message.alpha = 1;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.5 animations:^{
            message.alpha = 0;
        } completion:^(BOOL finished) {
            [message removeFromSuperview];
            
        }];
    }];
}

//+ (void)showStat:(NSString *)stats atView:(UIView *)view {
//    
//    UILabel *message = [[UILabel alloc] init];
//    message.layer.cornerRadius = 10;
//    message.clipsToBounds = YES;
//    message.backgroundColor = RGBA(0, 0, 0, 0.8);
//    message.numberOfLines = 0;
//    message.font = [UIFont systemFontOfSize:15];
//    message.textColor =[UIColor whiteColor] ;
//    message.textAlignment = NSTextAlignmentCenter;
//    message.alpha = 0;
//    
//    message.text = stats;
//    CGSize size = [stats boundingRectWithSize:CGSizeMake(MAXFLOAT, 50)
//                                      options:NSStringDrawingUsesLineFragmentOrigin
//                                   attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:15]}
//                                      context:nil].size;
//    message.frame = CGRectMake(KScreenWidth/2-size.width/2-35, 10, size.width + 70, size.height + 10);
//    
//    [view addSubview:message];
//    
//    [UIView animateWithDuration:.5 animations:^{
//        message.alpha = 1;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:.5 animations:^{
//            message.alpha = 0;
//        } completion:^(BOOL finished) {
//            [message removeFromSuperview];
//            
//        }];
//    }];
//}



- (void)setAttributeTextWithString:(NSString *)string range:(NSRange)range {
    NSMutableAttributedString *attrsString = [[NSMutableAttributedString alloc] initWithString:string];
    [attrsString addAttribute:NSForegroundColorAttributeName value:[UIColor blackColor] range:range];
    self.attributedText = attrsString;
}

+(NSData*)resetSizeOfImageData:(UIImage *)source_image{
    
    // 分辨率
    CGSize newSize=CGSizeMake(source_image.size.width, source_image.size.height);
//    CGFloat tempHeight= newSize.height/1024;
//    CGFloat tempWidth=newSize.width/1024;
//    
//    if (tempWidth>tempHeight) {
//        newSize=CGSizeMake(800, 480);
//    }else if (tempWidth==tempHeight){
//        newSize=CGSizeMake(480, 480);
//    }else{
        newSize=CGSizeMake(150, 150);
//    }
    
    UIGraphicsBeginImageContext(newSize);
    
    [source_image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    
    UIImage *newImage=UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 调整大小
    NSData *imageData=UIImageJPEGRepresentation(newImage, 0.5);
    
    return imageData;
    
}



+ (UIImage *)handleImage:(UIImage *)originalImage withSize:(CGSize)size
{
    CGSize originalsize = [originalImage size];
    NSLog(@"改变前图片的宽度为%f,图片的高度为%f",originalsize.width,originalsize.height);
    
    //原图长宽均小于标准长宽的，不作处理返回原图
    if (originalsize.width<size.width && originalsize.height<size.height)
    {
        return originalImage;
    }
    
    //原图长宽均大于标准长宽的，按比例缩小至最大适应值
    else if(originalsize.width>size.width && originalsize.height>size.height)
    {
        CGFloat rate = 1.0;
        CGFloat widthRate = originalsize.width/size.width;
        CGFloat heightRate = originalsize.height/size.height;
        
        rate = widthRate>heightRate?heightRate:widthRate;
        
        CGImageRef imageRef = nil;
        
        if (heightRate>widthRate)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height*rate/2, originalsize.width, size.height*rate));//获取图片整体部分
        }
        else
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width*rate/2, 0, size.width*rate, originalsize.height));//获取图片整体部分
        }
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图长宽有一项大于标准长宽的，对大于标准的那一项进行裁剪，另一项保持不变
    else if(originalsize.height>size.height || originalsize.width>size.width)
    {
        CGImageRef imageRef = nil;
        
        if(originalsize.height>size.height)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(0, originalsize.height/2-size.height/2, originalsize.width, size.height));//获取图片整体部分
        }
        else if (originalsize.width>size.width)
        {
            imageRef = CGImageCreateWithImageInRect([originalImage CGImage], CGRectMake(originalsize.width/2-size.width/2, 0, size.width, originalsize.height));//获取图片整体部分
        }
        
        UIGraphicsBeginImageContext(size);//指定要绘画图片的大小
        CGContextRef con = UIGraphicsGetCurrentContext();
        
        CGContextTranslateCTM(con, 0.0, size.height);
        CGContextScaleCTM(con, 1.0, -1.0);
        
        CGContextDrawImage(con, CGRectMake(0, 0, size.width, size.height), imageRef);
        
        UIImage *standardImage = UIGraphicsGetImageFromCurrentImageContext();
        NSLog(@"改变后图片的宽度为%f,图片的高度为%f",[standardImage size].width,[standardImage size].height);
        
        UIGraphicsEndImageContext();
        CGImageRelease(imageRef);
        
        return standardImage;
    }
    
    //原图为标准长宽的，不做处理
    else
    {
        return originalImage;
    }
}

+(UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

@end
