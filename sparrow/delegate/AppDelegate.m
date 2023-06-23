//
//  AppDelegate.m
//  sparrow
//
//  Created by hwy on 2021/11/3.
//

#import <CocoaAsyncSocket/GCDAsyncSocket.h>
#import "AppDelegate.h"
#import "MineViewController.h"
#import "MessageListViewController.h"
#import "LoginViewController.h"
#import "BaseUITabBarController.h"
#import "HttpRequestUtil.h"
#import "TcpRequest.h"
#import "BaseData.h"
#import "MessageCache.h"
#import "HttpAddressModel.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    BaseData *baseData = [[BaseData alloc] init];
    [baseData getNewUserInfo];

    TcpRequest *tcpRequest = [[TcpRequest alloc] init];
    [tcpRequest connectToHost:APP_TCP_BASE_ADDRESS onPort:APP_TCP_BASE_PORT];
    [self initCache];
    [self initWindow];
    [self checkLogin];
    return YES;
}

//初始化根页面
- (void)initWindow {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
}

//缓存初始化
- (void)initCache {
    MessageCache *messageCache = [[MessageCache alloc] init];
    [messageCache createTable];
}

//检查是否存在token
- (void)checkLogin {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *token = [defaults objectForKey:@"token"];
    NSString *userId = [defaults objectForKey:@"userId"];
    if (token && userId) {
        BaseUITabBarController *tabBarController = [[BaseUITabBarController alloc] init];
        self.window.rootViewController = tabBarController;
    } else {
        self.window.rootViewController = [[LoginViewController alloc] init];
    }
}


#pragma mark - Core Data stack

@synthesize persistentContainer = _persistentContainer;

- (NSPersistentContainer *)persistentContainer {
    @synchronized (self) {
        if (_persistentContainer == nil) {
            _persistentContainer = [[NSPersistentContainer alloc] initWithName:@"sparrow"];
            [_persistentContainer loadPersistentStoresWithCompletionHandler:^(NSPersistentStoreDescription *storeDescription, NSError *error) {
                if (error != nil) {
                    NSLog(@"Unresolved error %@, %@", error, error.userInfo);
                    abort();
                }
            }];
        }
    }

    return _persistentContainer;
}

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(nullable UIWindow *)window {
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *context = self.persistentContainer.viewContext;
    NSError *error = nil;
    if ([context hasChanges] && ![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, error.userInfo);
        abort();
    }
}

@end

