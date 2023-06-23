//
//  PostViewController.h
//  sparrow
//
//  Created by hwy on 2021/12/1.
//

#import <UIKit/UIKit.h>
#import <QBImagePickerController/QBImagePickerController.h>

NS_ASSUME_NONNULL_BEGIN

@interface PostViewController : BaseViewController
	<UIImagePickerControllerDelegate,
	UINavigationControllerDelegate,
	UITextViewDelegate,
    QBImagePickerControllerDelegate>
@end

NS_ASSUME_NONNULL_END
