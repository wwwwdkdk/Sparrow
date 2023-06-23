//
//  NewFriendTableViewCell.h
//  sparrow
//
//  Created by hwy on 2021/12/22.
//

#import <UIKit/UIKit.h>
#import "FriendRequestModel.h"

NS_ASSUME_NONNULL_BEGIN

//头像尺寸
#define CONTACT_NEW_FRIEND_HEAD_PORTRAIT_SIZE       APP_SCREEN_WIDTH * 0.12

@interface NewFriendTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                    sendModel:(FriendRequestModel *)sendModel;


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                receivedModel:(FriendRequestModel *)receivedModel;
@end

NS_ASSUME_NONNULL_END
