//
//  AppDelegate.h
//  sparrow
//
//  Created by hwy on 2021/11/3.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property(readonly, strong) NSPersistentContainer *persistentContainer;
@property(strong, nonatomic) UIWindow *window;

- (void)saveContext;


@end

