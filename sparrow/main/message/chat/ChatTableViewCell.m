//
//  ChatTableViewCell.m
//  sparrow
//
//  Created by hwy on 2021/11/29.
//

#import <UIImageView+WebCache.h>
#import "ChatTableViewCell.h"
#import "View+MASAdditions.h"
#import "NSString+Size.h"
#import "ImageDisplayTool.h"
#import "MessageModel.h"
#import "UserModel.h"
#import "BaseData.h"
#import "EnumList.h"


@interface ChatTableViewCell ()

@property (nonatomic, strong) UILabel        *messageLabel;             //文字消息
@property (nonatomic, strong) UIImageView    *messageImageView;         //图片消息
@property (nonatomic, strong) UIView         *messageBGView;            //消息背景框
@property (nonatomic, strong) MessageModel   *messageModel;
@property (nonatomic, strong) UserModel      *userModel;
@property (nonatomic, strong) UserModel      *friendModel;

@end

@implementation ChatTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
	}
	return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                 messageModel:(MessageModel *)messageModel
                  friendModel:(UserModel *)friendModel {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		_userModel = [BaseData sharedData].userModel;
		_messageModel = messageModel;
		_friendModel = friendModel;
		[self initStyle];
	}
	return self;
}

- (void)initStyle {
	CellDirection cellDirection = [self.userModel.userId isEqualToString:self.messageModel.sendId] ? right : left;
//    NSLog(@"%@",self.messageModel.sendId);


	[self setSelectionStyle:UITableViewCellSelectionStyleNone];
	self.backgroundColor = UIColor.clearColor;
	[self initHeadPortrait:cellDirection];

	switch ([self.messageModel.type intValue]) {
		case messageText:
			[self initMessageLabel:cellDirection];
			break;
		case messageImage:
			[self initMessageImage:cellDirection];
			break;
		case messageVideo:
			break;
		default:
			break;
	}
}

- (void)initHeadPortrait:(CellDirection)direction {
	_headPortraitImageView = [[UIImageView alloc] init];
	NSString *url = direction == left ? self.friendModel.headPortrait : self.userModel.headPortrait;
	[_headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:url] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];
	_headPortraitImageView.layer.cornerRadius = 15;
    _headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
	_headPortraitImageView.layer.masksToBounds = YES;
	[self.contentView addSubview:_headPortraitImageView];
	[_headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(MESSAGE_CHAT_HEAD_PORTRAIT_SIZE);
		make.top.mas_equalTo(APP_PRIMARY_MARGIN);
		direction == left ? make.left.mas_equalTo(APP_PRIMARY_MARGIN)
			: make.right.mas_equalTo(-APP_PRIMARY_MARGIN);
	}];
}

- (void)initMessageLabel:(CellDirection)direction {
	NSString *message = self.messageModel.content;
	CGSize messageSize = [message calculateSizeOfString:MESSAGE_CHAT_TEXT_MAX_WIDTH fontSize:APP_FONT_SIZE];
	_messageBGView = [[UIView alloc] init];
	_messageBGView.backgroundColor = UIColor.whiteColor;
	_messageBGView.layer.masksToBounds = YES;
	_messageBGView.layer.cornerRadius = 10;
	[self.contentView addSubview:_messageBGView];
	[_messageBGView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(messageSize.width + MESSAGE_CHAT_LABEL_BORDER_SIZE);
		make.height.mas_equalTo(messageSize.height + MESSAGE_CHAT_LABEL_BORDER_SIZE);
		direction == left ? make.left.equalTo(self.headPortraitImageView.mas_right).offset(APP_PRIMARY_MARGIN)
			: make.right.equalTo(self.headPortraitImageView.mas_left).inset(APP_PRIMARY_MARGIN);
		make.top.mas_equalTo(APP_PRIMARY_MARGIN);
	}];

	_messageLabel = [[UILabel alloc] init];
	_messageLabel.text = message;
	[_messageLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
	_messageLabel.numberOfLines = 0;
	[self.messageBGView addSubview:_messageLabel];
	[_messageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(messageSize.width);
		make.height.mas_equalTo(messageSize.height);
		make.center.equalTo(self.messageBGView);
	}];
}

- (void)initMessageImage:(CellDirection)direction {
	_messageImageView = [[UIImageView alloc] init];
	_messageImageView.layer.masksToBounds = YES;
	_messageImageView.layer.cornerRadius = 10;
	_messageImageView.userInteractionEnabled = YES;
	_messageImageView.contentMode = UIViewContentModeScaleAspectFill;
	[_messageImageView setClipsToBounds:YES];
	[self.contentView addSubview:_messageImageView];
	if (self.messageModel.image != nil) {
		_messageImageView.image = self.messageModel.image;
	} else {
//		[_messageImageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.messageModel.content]];
        
//        NSURL *url = [NSURL fileURLWithPath:self.messageModel.content];
//        self.userModel.userId == self.messageModel.sendId
        if(  self.userModel.userId == self.messageModel.sendId){
//            [_messageImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"noImage"]];
            [_messageImageView sd_setImageWithURL:[NSURL fileURLWithPath:self.messageModel.content] placeholderImage:[UIImage imageNamed:@"noImage"]];
        }else{
            [_messageImageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.messageModel.content] placeholderImage:[UIImage imageNamed:@"noImage"]];
        }
//        [_messageImageView sd_setImageWithURL:[NSURL fileURLWithPath:self.messageModel.content] placeholderImage:[UIImage imageNamed:@"noImage"]];
	}

	[_messageImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(MESSAGE_CHAT_IMAGE_WIDTH);
		make.height.mas_equalTo(MESSAGE_CHAT_IMAGE_HEIGHT);
		direction == left ? make.left.equalTo(self.headPortraitImageView.mas_right).offset(APP_PRIMARY_MARGIN)
			: make.right.equalTo(self.headPortraitImageView.mas_left).inset(APP_PRIMARY_MARGIN);
		make.top.mas_equalTo(APP_PRIMARY_MARGIN);
	}];
	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage)];
	[self.messageImageView addGestureRecognizer:tapGestureRecognizer];
}

- (void)openImage {
	[ImageDisplayTool scanBigImageWithImageView:self.messageImageView alpha:1];
}

@end
