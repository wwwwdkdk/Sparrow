//
//  DynamicViewController.h
//  sparrow
//
//  Created by hwy on 2021/12/2.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

//页面类型
typedef enum {
    all = 0,        //好友动态
    agree = 1,      //点赞动态
    collection = 2, //收藏动态
    mine = 3        //某个用户的动态
}DynamicType;

@interface DynamicViewController : BaseViewController<
UIScrollViewDelegate,
UITableViewDataSource,
UITableViewDelegate>

@property(nonatomic,copy)NSString *naviTitle;

-(instancetype)initWithType:(DynamicType)dynamicType;
- (instancetype)initWithType:(DynamicType)dynamicType
                      userId:(NSString*)userId;

@end

NS_ASSUME_NONNULL_END
