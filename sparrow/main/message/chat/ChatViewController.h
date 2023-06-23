//
//  ChatViewController.h
//  sparrow
//
//  Created by hwy on 2021/11/16.
//

#import <UIKit/UIKit.h>
#import <QBImagePickerController/QBImagePickerController.h>
#import "BaseViewController.h"
@class UserModel;

NS_ASSUME_NONNULL_BEGIN

@interface ChatViewController : BaseViewController
        <UITableViewDelegate,
        UITableViewDataSource,
        UIImagePickerControllerDelegate,
        QBImagePickerControllerDelegate,
        UITextViewDelegate,
        UIScrollViewDelegate
        >
//@property (nonatomic, copy)NSString *friendId;
//@property (nonatomic, copy)NSString *friendNIckName;
-(instancetype)initWithFriendInfo:(UserModel *)friendModel;

@end

NS_ASSUME_NONNULL_END
