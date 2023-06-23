//
//  MineTableViewCell.m
//  sparrow
//
//  Created by hwy on 2021/11/25.
//

#import <SDWebImage/UIImageView+WebCache.h>
#import <Masonry/MASConstraintMaker.h>
#import <Masonry/View+MASAdditions.h>
#import "MineTableViewCell.h"
#import "View+MASAdditions.h"
#import "UIImageView+WebCache.h"
#import "NSString+Size.h"
#import "ImageDisplayTool.h"
#import "HttpRequestUtil.h"
#import "DynamicHttpRequest.h"
#import "BaseModel.h"
#import "PictureModel.h"
#import "UserModel.h"

@interface MineTableViewCell ()

@property (nonatomic, strong) DynamicModel *dynamicModel;               //动态数据
@property (nonatomic, strong) UIImageView *headPortraitImageView;       //用户头像
@property (nonatomic, strong) UILabel     *nickNameLabel;               //昵称标签
@property (nonatomic, strong) UILabel     *timeLabel;                   //时间标签
@property (nonatomic, strong) UILabel     *contentLabel;                //内容标签
@property (nonatomic, strong) UILabel     *agreeLabel;
@property (nonatomic, strong) UILabel     *collectionLabel;
@property (nonatomic, strong) UIButton    *agreeBtn;                    //点赞按钮
@property (nonatomic, strong) UIButton    *collectionBtn;               //收藏按钮
@property (nonatomic, strong) UIButton    *deleteBtn;                   //删除按钮
@property (nonatomic, strong) UITextField *replyField;                  //评论文本框

@end

@implementation MineTableViewCell

- (void)awakeFromNib {
	[super awakeFromNib];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	[super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.selectionStyle = UITableViewCellSelectionStyleNone;
	}
	return self;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(DynamicModel *)model {
	if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
		self.dynamicModel = model;
		[self initStyle];
	}
	return self;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)initStyle {
	[self initHeadPortraitImageView];
	[self initNicknameLabel];
	[self initTimeLabel];
	[self initContent];
	[self initButtons];
}

- (void)initHeadPortraitImageView {
	_headPortraitImageView = [[UIImageView alloc] init];
	_headPortraitImageView.layer.cornerRadius = 10;
	_headPortraitImageView.layer.masksToBounds = YES;
    _headPortraitImageView.backgroundColor = PRIMARY_BG_COLOR;
	[_headPortraitImageView sd_setImageWithURL:[[NSURL alloc] initWithString:self.dynamicModel.userModel.headPortrait] placeholderImage:[UIImage imageNamed:@"noHeadPortrait"]];
	[self.contentView addSubview:_headPortraitImageView];
	[_headPortraitImageView mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.height.mas_equalTo(MINE_CELL_HEAD_PORTRAIT_SIZE);
		make.left.top.mas_equalTo(APP_PRIMARY_MARGIN);
	}];
}

- (void)initNicknameLabel {
	_nickNameLabel = [[UILabel alloc] init];
	[self.contentView addSubview:_nickNameLabel];
	_nickNameLabel.text = self.dynamicModel.userModel.nickname;
	[_nickNameLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
	[_nickNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.mas_equalTo(MINE_CELL_NICKNAME_WIDTH);
		make.top.mas_equalTo(self.headPortraitImageView);
		make.height.mas_equalTo(MINE_CELL_LABEL_HEIGHT);
		make.left.equalTo(self.headPortraitImageView.mas_right).offset(APP_PRIMARY_MARGIN);
	}];
}

- (void)initTimeLabel {
	_timeLabel = [[UILabel alloc] init];
	[self.contentView addSubview:_timeLabel];
	_timeLabel.text = self.dynamicModel.time;
	[_timeLabel setTextColor:UIColor.grayColor];
	[_timeLabel setFont:[UIFont systemFontOfSize:APP_SMALL_FONT_SIZE]];
	[_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.width.left.equalTo(self.nickNameLabel);
		make.top.equalTo(self.nickNameLabel.mas_bottom);
		make.height.mas_equalTo(self.nickNameLabel);
	}];
}

- (void)initContent {
	//文字内容
	_contentLabel = [[UILabel alloc] init];
	[self.contentView addSubview:_contentLabel];
	_contentLabel.numberOfLines = 0;
	[_contentLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
	_contentLabel.text = self.dynamicModel.content;
	[_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.left.equalTo(self.headPortraitImageView);
		make.width.mas_equalTo(MINE_CELL_CONTENT_WIDTH);
		make.height.mas_equalTo([_contentLabel.text calculateSizeOfString:MINE_CELL_CONTENT_WIDTH fontSize:APP_FONT_SIZE].height);
		make.top.equalTo(self.headPortraitImageView.mas_bottom).offset(APP_PRIMARY_MARGIN);
	}];
	//图片内容
	NSArray<PictureModel *> *picArray = self.dynamicModel.picture;
	if (picArray.count == 1) { //一张图片
		UIImageView *imageView = [[UIImageView alloc] init];
		imageView.userInteractionEnabled = YES;
		imageView.contentMode = UIViewContentModeScaleAspectFill;
		[imageView setClipsToBounds:YES];
//		[imageView sd_setImageWithURL:[[NSURL alloc] initWithString:picArray[0].picture]];
        [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:picArray[0].picture] placeholderImage:[UIImage imageNamed:@"noImage"]];
		imageView.layer.cornerRadius = 10;
		imageView.layer.masksToBounds = YES;
		[self.contentView addSubview:imageView];
		[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.mas_equalTo(MINE_CELL_ONE_IMAGE_WIDTH);
			if (picArray[0].width != nil && picArray[0].height != nil) {
				CGFloat proportion = [picArray[0].height floatValue] / [picArray[0].width floatValue];
				make.height.mas_equalTo(MINE_CELL_ONE_IMAGE_WIDTH * (proportion <= 2 ? proportion : 2));
			} else {
				make.height.mas_equalTo(MINE_CELL_ONE_IMAGE_HEIGHT);
			}
			make.top.equalTo(self.contentLabel.mas_bottom).offset(APP_PRIMARY_MARGIN);
			make.left.equalTo(self.contentLabel);
		}];
		UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage:)];
		[imageView addGestureRecognizer:tapGestureRecognizer];
	} else if (picArray.count == 2) { //两张图片
		for (NSUInteger i = 0; i < 2; i++) {
			UIImageView *imageView = [[UIImageView alloc] init];
			imageView.contentMode = UIViewContentModeScaleAspectFill;
			[imageView setClipsToBounds:YES];
			imageView.userInteractionEnabled = YES;
            [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:picArray[i].picture] placeholderImage:[UIImage imageNamed:@"noImage"]];
			imageView.layer.cornerRadius = 10;
			imageView.layer.masksToBounds = YES;
			[self.contentView addSubview:imageView];
			[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.width.mas_equalTo(MINE_CELL_TWO_IMAGE_WIDTH);
				make.height.mas_equalTo(MINE_CELL_TWO_IMAGE_HEIGHT);
				make.top.equalTo(self.contentLabel.mas_bottom).offset(APP_PRIMARY_MARGIN);
				make.left.equalTo(self.contentLabel).offset((MINE_CELL_TWO_IMAGE_WIDTH + MINE_CELL_IMAGE_MARGIN) * i);
			}];
			UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage:)];
			[imageView addGestureRecognizer:tapGestureRecognizer];
		}
	} else if (picArray.count >= 3) { //三张图片及以上
		for (NSUInteger i = 0; i < picArray.count; i++) {
			UIImageView *imageView = [[UIImageView alloc] init];
			imageView.contentMode = UIViewContentModeScaleAspectFill;
			[imageView setClipsToBounds:YES];
			imageView.userInteractionEnabled = YES;
//			[imageView sd_setImageWithURL:[[NSURL alloc] initWithString:picArray[i].picture]];
            [imageView sd_setImageWithURL:[[NSURL alloc] initWithString:picArray[i].picture] placeholderImage:[UIImage imageNamed:@"noImage"]];
			imageView.layer.cornerRadius = 10;
			imageView.layer.masksToBounds = YES;
			[self.contentView addSubview:imageView];
			[imageView mas_makeConstraints:^(MASConstraintMaker *make) {
				make.width.height.mas_equalTo(MINE_CELL_THREE_OR_MORE_IMAGE_SIZE);
				make.top.equalTo(self.contentLabel.mas_bottom).offset((MINE_CELL_THREE_OR_MORE_IMAGE_SIZE + MINE_CELL_IMAGE_MARGIN) * ((int) i / 3) + APP_PRIMARY_MARGIN);
				make.left.equalTo(self.contentLabel).offset((MINE_CELL_THREE_OR_MORE_IMAGE_SIZE + MINE_CELL_IMAGE_MARGIN) * (i % 3));
			}];
			UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(openImage:)];
			[imageView addGestureRecognizer:tapGestureRecognizer];
		}
	}
}

- (void)initButtons {
	_agreeBtn = [[UIButton alloc] init];
	[self.contentView addSubview:_agreeBtn];
	if (self.dynamicModel.agree) {
		[_agreeBtn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
	} else {
		[_agreeBtn setImage:[UIImage imageNamed:@"noAgree"] forState:UIControlStateNormal];
	}

	[_agreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.width.mas_equalTo(MINE_CELL_BUTTON_SIZE);
		make.left.equalTo(self.headPortraitImageView).offset(MINE_CELL_BUTTON_SIZE / 2);
		make.bottom.mas_equalTo(-APP_PRIMARY_MARGIN);
	}];

	[_agreeBtn addTarget:self action:@selector(agreeDynamic:) forControlEvents:UIControlEventTouchUpInside];

	_agreeLabel = [[UILabel alloc] init];
	_agreeLabel.text = self.dynamicModel.agreeCount;
	_agreeLabel.textColor = UIColor.grayColor;
	[_agreeLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
	[self.contentView addSubview:_agreeLabel];
	[_agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.height.equalTo(self.agreeBtn);
		make.width.mas_equalTo([_agreeLabel.text calculateSizeOfString:APP_VIEW_WITH_MARGIN_WIDTH fontSize:APP_FONT_SIZE].width);
		make.left.equalTo(self.agreeBtn.mas_right).offset(APP_PRIMARY_MARGIN / 2);
	}];

	_collectionBtn = [[UIButton alloc] init];
	[self.contentView addSubview:_collectionBtn];
	if (self.dynamicModel.collection) {
		[_collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
	} else {
		[_collectionBtn setImage:[UIImage imageNamed:@"noCollection"] forState:UIControlStateNormal];
	}
	[_collectionBtn mas_makeConstraints:^(MASConstraintMaker *make) {
		make.height.width.bottom.equalTo(self.agreeBtn);
		make.left.equalTo(self.agreeLabel.mas_right).offset(APP_PRIMARY_MARGIN);
	}];
	[_collectionBtn addTarget:self action:@selector(collectionDynamic:) forControlEvents:UIControlEventTouchUpInside];
    
	_collectionLabel = [[UILabel alloc] init];
	_collectionLabel.text = self.dynamicModel.collectionCount;
	_collectionLabel.textColor = UIColor.grayColor;
	[_collectionLabel setFont:[UIFont systemFontOfSize:APP_FONT_SIZE]];
	[self.contentView addSubview:_collectionLabel];
	[_collectionLabel mas_makeConstraints:^(MASConstraintMaker *make) {
		make.bottom.height.equalTo(self.agreeLabel);
		make.width.mas_equalTo([@"999+" calculateSizeOfString:APP_VIEW_WITH_MARGIN_WIDTH fontSize:APP_FONT_SIZE].width);
		make.left.equalTo(self.collectionBtn.mas_right).offset(APP_PRIMARY_MARGIN / 2);
    }];
}

- (void)openImage:(UIGestureRecognizer *)sender {
	[ImageDisplayTool scanBigImageWithImageView:(UIImageView *) sender.view alpha:1];
}

- (void)agreeDynamic:(UIButton *)sender {
	[DynamicHttpRequest agreeDynamic:self.dynamicModel.dynamicId successBlock:^(NSDictionary *_Nonnull data) {
		self.dynamicModel.agree = !self.dynamicModel.agree;
		if (self.dynamicModel.agree) {
			[self.agreeBtn setImage:[UIImage imageNamed:@"agree"] forState:UIControlStateNormal];
		} else {
			[self.agreeBtn setImage:[UIImage imageNamed:@"noAgree"] forState:UIControlStateNormal];
		}
		self.agreeLabel.text = self.dynamicModel.agreeCount = data[@"agreeCount"];
		[self.agreeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
			make.bottom.height.equalTo(self.agreeBtn);
			make.width.mas_equalTo([self.agreeLabel.text calculateSizeOfString:APP_VIEW_WITH_MARGIN_WIDTH fontSize:APP_FONT_SIZE].width);
			make.left.equalTo(self.agreeBtn.mas_right).offset(APP_PRIMARY_MARGIN / 2);
		}];
	}failBlock:nil];
}

- (void)collectionDynamic:(UIButton *)sender {
	[DynamicHttpRequest collectionDynamic:self.dynamicModel.dynamicId successBlock:^(NSDictionary *_Nonnull data) {
		self.dynamicModel.collection = !self.dynamicModel.collection;
		if (self.dynamicModel.collection) {
			[self.collectionBtn setImage:[UIImage imageNamed:@"collection"] forState:UIControlStateNormal];
		} else {
			[self.collectionBtn setImage:[UIImage imageNamed:@"noCollection"] forState:UIControlStateNormal];
		}
		self.collectionLabel.text = self.dynamicModel.collectionCount = data[@"collectionCount"];
	}                           failBlock:nil];
}

@end
