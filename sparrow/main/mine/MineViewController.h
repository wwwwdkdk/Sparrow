//
//  MineViewController.h
//  sparrow
//
//  Created by hwy on 2021/11/8.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MineViewController : BaseViewController
        <UIImagePickerControllerDelegate,
        UIScrollViewDelegate,
        UITableViewDataSource,
        UITableViewDelegate,
        HideNavigationBarProtocol>

+ (UIImage *)imageWithColor:(UIColor *)color;

@end

NS_ASSUME_NONNULL_END
