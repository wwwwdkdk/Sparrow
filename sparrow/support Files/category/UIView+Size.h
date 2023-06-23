//
//  UIView+Size.h
//  sparrow
//
//  Created by hwy on 2021/12/30.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN
@interface UIView (Size)

@property(nonatomic, assign) CGSize size;
@property(nonatomic, assign) CGFloat width;
@property(nonatomic, assign) CGFloat height;
@property(nonatomic, assign) CGFloat top;
@property(nonatomic, assign) CGFloat bottom;
@property(nonatomic, assign) CGFloat left;
@property(nonatomic, assign) CGFloat right;
@property(nonatomic, assign) CGFloat centerX;
@property(nonatomic, assign) CGFloat centerY;

@end
NS_ASSUME_NONNULL_END

