//
//  UIView+Size.m
//  sparrow
//
//  Created by hwy on 2021/12/30.
//

#import "UIView+Size.h"

@implementation UIView (Size)

- (void)setSize:(CGSize)size {
	CGRect frame = self.frame;
	frame.size = size;
	self.frame = frame;
}

- (CGSize)size {
	return self.frame.size;
}

- (void)setWidth:(CGFloat)width {
	CGRect frame = self.frame;
	frame.size.width = width;
	self.frame = frame;
}

- (void)setHeight:(CGFloat)height {
	CGRect frame = self.frame;
	frame.size.height = height;
	self.frame = frame;
}

- (void)setLeft:(CGFloat)left {
	CGRect frame = self.frame;
	frame.origin.x = left;
	self.frame = frame;
}

- (void)setTop:(CGFloat)top {
	CGRect frame = self.frame;
	frame.origin.y = top;
	self.frame = frame;
}

- (void)setBottom:(CGFloat)bottom {
	CGRect frame = self.frame;
	frame.origin.y = self.superview.height - self.height - bottom;
	self.frame = frame;
}

- (void)setRight:(CGFloat)right {
	CGRect frame = self.frame;
	frame.origin.x = self.superview.frame.size.width - self.width - right;
	self.frame = frame;
}

- (void)setCenterX:(CGFloat)centerX {
	CGPoint center = self.center;
	center.x = centerX;
	self.center = center;
}

- (void)setCenterY:(CGFloat)centerY {
	CGPoint center = self.center;
	center.y = centerY;
	self.center = center;
}

- (CGFloat)centerY {
	return self.center.y;
}

- (CGFloat)centerX {
	return self.center.x;
}

- (CGFloat)width {
	return self.frame.size.width;
}


- (CGFloat)height {
	return self.frame.size.height;
}

- (CGFloat)left {
	return self.frame.origin.x;
}

- (CGFloat)top {
	return self.frame.origin.y;
}

- (CGFloat)right {
	return self.frame.origin.x + self.width;
}

- (CGFloat)bottom {
	return self.frame.origin.y + self.height;
}


@end
