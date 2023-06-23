//
//  ChatTableViewCell.h
//  sparrow
//
//  Created by hwy on 2021/11/29.
//

#import <UIKit/UIKit.h>

@class UserModel;
@class MessageModel;

NS_ASSUME_NONNULL_BEGIN

//消息显示的方向
typedef enum {
	left = 0,
	right = 1
} CellDirection;

////消息类型
//typedef enum {
//	text = 0,
//	image = 1,
//	video = 2
//} MessageType;

//头像尺寸
#define MESSAGE_CHAT_HEAD_PORTRAIT_SIZE      APP_SCREEN_WIDTH * 0.14
//照片宽度
#define MESSAGE_CHAT_IMAGE_WIDTH             (APP_SCREEN_WIDTH - MESSAGE_CHAT_HEAD_PORTRAIT_SIZE * 2 - APP_PRIMARY_MARGIN * 4)
//照片高度
#define MESSAGE_CHAT_IMAGE_HEIGHT            MESSAGE_CHAT_IMAGE_WIDTH * 0.75
//文字消息最大宽度
#define MESSAGE_CHAT_TEXT_MAX_WIDTH          MESSAGE_CHAT_IMAGE_WIDTH - APP_PRIMARY_MARGIN
//文字消息框边距
#define MESSAGE_CHAT_LABEL_BORDER_SIZE       APP_SCREEN_WIDTH * 0.05

@interface ChatTableViewCell : UITableViewCell

//@property (nonatomic, strong) NSDictionary   *messageDictionary;           //消息数据
//@property (nonatomic, strong) NSDictionary   *friendInfo;                  //好友资料
//@property (nonatomic, strong) NSDictionary   *userInfo;                    //个人资料
@property (nonatomic, strong) UIImageView    *headPortraitImageView;         //头像

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                 messageModel:(MessageModel *)messageModel
                  friendModel:(UserModel *)friendModel;

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier;

// -(void) initStyle;

@end

NS_ASSUME_NONNULL_END
