//
//  MineTableViewCell.h
//  sparrow
//
//  Created by hwy on 2021/11/25.
//

#import <UIKit/UIKit.h>
#import "DynamicModel.h"

NS_ASSUME_NONNULL_BEGIN

//头像尺寸
#define MINE_CELL_HEAD_PORTRAIT_SIZE        APP_SCREEN_WIDTH * 0.12
//昵称标签的宽度
#define MINE_CELL_NICKNAME_WIDTH            (APP_VIEW_WITH_MARGIN_WIDTH - APP_PRIMARY_MARGIN * 3 - MINE_CELL_HEAD_PORTRAIT_SIZE)
//内容标签的宽度
#define MINE_CELL_CONTENT_WIDTH             (APP_VIEW_WITH_MARGIN_WIDTH - 2 * APP_PRIMARY_MARGIN)
//标签高度
#define MINE_CELL_LABEL_HEIGHT              MINE_CELL_HEAD_PORTRAIT_SIZE / 2
//照片间距
#define MINE_CELL_IMAGE_MARGIN              APP_PRIMARY_MARGIN * 0.5
//动态只有一张图片时图片的宽度
#define MINE_CELL_ONE_IMAGE_WIDTH           MINE_CELL_CONTENT_WIDTH *0.8
//动态只有一张图片时图片的高度
#define MINE_CELL_ONE_IMAGE_HEIGHT          MINE_CELL_CONTENT_WIDTH * 0.6
//动态只有两张图片时图片的高度
#define MINE_CELL_TWO_IMAGE_WIDTH           (MINE_CELL_CONTENT_WIDTH -  MINE_CELL_IMAGE_MARGIN) / 2
//动态只有两张图片时图片的高度
#define MINE_CELL_TWO_IMAGE_HEIGHT          MINE_CELL_TWO_IMAGE_WIDTH * 0.75
//动态只有三张图片时图片的尺寸
#define MINE_CELL_THREE_OR_MORE_IMAGE_SIZE  (MINE_CELL_CONTENT_WIDTH - 2 * MINE_CELL_IMAGE_MARGIN) / 3
//按钮尺寸
#define MINE_CELL_BUTTON_SIZE               MINE_CELL_HEAD_PORTRAIT_SIZE * 0.4

@interface MineTableViewCell : UITableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
                        model:(DynamicModel *)model;

@end

NS_ASSUME_NONNULL_END
