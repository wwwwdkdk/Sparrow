//
//  MessageListViewController.h
//  sparrow
//
//  Created by hwy on 2021/11/15.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MessageListViewController : BaseViewController
	<UITableViewDataSource,
	UITableViewDelegate,
	UIScrollViewDelegate
	>
- (void)getMessageList;
@end

NS_ASSUME_NONNULL_END
