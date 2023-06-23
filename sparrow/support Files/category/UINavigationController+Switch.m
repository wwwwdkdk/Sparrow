////
////  UINavigationController+Switch.m
////  sparrow
////
////  Created by hwy on 2021/12/8.
////
//#import <objc/runtime.h>
//#import "UINavigationController+Switch.h"
//
//@implementation UINavigationController (Switch)
//+ (void)initialize {
//    if (self == (Class) [UINavigationController self]) {
//        // 交换方法
//        SEL originalSelector = NSSelectorFromString(@"_updateInteractiveTransition:");
//        SEL swizzledSelector = NSSelectorFromString(@"et__updateInteractiveTransition:");
//        Method originalMethod = class_getInstanceMethod([self class], originalSelector);
//        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
//        method_exchangeImplementations(originalMethod, swizzledMethod);
//    }
//}
//
//// 交换的方法，监控滑动手势
//- (void)et__updateInteractiveTransition:(CGFloat)percentComplete {
//    [self et__updateInteractiveTransition:(percentComplete)];
//    NSLog(@"滑动距离:%f",percentComplete);
//    NSLog(@"%@",[self.navigationBar subviews]);
//    NSLog(@"%lf", self.endAlpha.doubleValue);
//    if(self.startAlpha==nil||self.endAlpha==nil){
//        return;
//    } else if((self.endAlpha.doubleValue  <=  1 - percentComplete)&&self.startAlpha > self.endAlpha ){
//        self.navigationBar.subviews.firstObject.alpha = 1 - percentComplete;
//    }else if((self.startAlpha.doubleValue  <=  1 - percentComplete)&&self.startAlpha < self.endAlpha ){
//        self.navigationBar.subviews.firstObject.alpha = percentComplete;
//    }
//}
//
//- (void)setStartAlpha:(NSNumber *)startAlpha{
//    objc_setAssociatedObject(self, "START_ALPHA", startAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC );
//}
//
//-(NSNumber *)startAlpha {
//    return objc_getAssociatedObject(self, "START_ALPHA");
//}
//
//- (void)setEndAlpha:(NSNumber *)startAlpha{
//    objc_setAssociatedObject(self, "END_ALPHA", startAlpha, OBJC_ASSOCIATION_COPY_NONATOMIC );
//}
//
//-(NSNumber *)endAlpha {
//    return objc_getAssociatedObject(self, "END_ALPHA");
//}
//
//
//-(void)switch:(CGFloat)start
//           to:(CGFloat)end{
//    [self setStartAlpha:@(start)];
//    [self setEndAlpha:@(end)];
//
//}
//
//@end
