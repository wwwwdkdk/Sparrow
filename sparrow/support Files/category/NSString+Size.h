//
//  NSString+Size.h
//  sparrow
//
//  Created by hwy on 2021/12/3.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface NSString (Size)
- (CGSize)calculateSizeOfString:(CGFloat)width fontSize:(CGFloat)fontSize;
@end

NS_ASSUME_NONNULL_END
