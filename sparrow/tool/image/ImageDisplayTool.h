//
//  ImageDisplayTool.h
//  sparrow
//
//  Created by hwy on 2021/12/8.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ImageDisplayTool : NSObject

//  浏览大图
+ (void)scanBigImageWithImageView:(UIImageView *)currentImageview alpha:(CGFloat)alpha;

@end

NS_ASSUME_NONNULL_END
