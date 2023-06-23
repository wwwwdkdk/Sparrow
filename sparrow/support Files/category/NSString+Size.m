//
//  NSString+Size.m
//  sparrow
//
//  Created by hwy on 2021/12/3.
//

#import "NSString+Size.h"

@implementation NSString (Size)

- (CGSize)calculateSizeOfString:(CGFloat)width fontSize:(CGFloat)fontSize {
	CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT) //显示的宽度和高度
	                                 options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
	                              attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:fontSize]}
	                                 context:nil].size;
	size.height += 1;
    size.width += 1;
	return size;
}


@end



