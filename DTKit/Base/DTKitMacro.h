//
//  DTKitMacro.h
//  DTKitDemo
//
//  Created by zhaojh on 16/9/14.
//  Copyright © 2016年 zhaojh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DTTools.h"
#import "DTSingleton.h"

/*横竖屏相关*/
#define dtIsPortrait             isPortrait()
#define dtIsLandscape            isLandscape()

/*系统版本*/
#define dtSystemVersion          [UIDevice currentDevice].systemVersion // String类型
#define dtIOSVersion             dtSystemVersion.doubleValue
#define dtIOS8UP                 (dtIOSVersion >= 8.0)
#define dtIOS9UP                 (dtIOSVersion >= 9.0)
#define dtIOS10UP                (dtIOSVersion >= 10.0)

/*手机物理宽高 Portrait*/
#define dtScreenWidth            (dtIsLandscape ? screenHeight() : screenWidth())
#define dtScreenHeight           (dtIsLandscape ? screenWidth()  : screenHeight())
#define dtScreenScale            screenScale()  //这个是手机的像素 取值1，2，3
#define dtScreenHeightRate       (dtScreenHeight / (dtIsLandscape ? 320.0 : 480.0))
#define dtScreenWidthRate        (dtScreenWidth / (dtIsLandscape ? 480.0 : 320.0))

//以320的宽度为基准，计算等比例值dtScreenWidth
#define dtEqualRate(f)           (dtScreenWidthRate * f)

/*navbar默认高度和tabbar默认高度*/
#define dtNavBarHeight           (dtIsLandscape ? 52 : 64)
#define dtTabBarHeight           49

/*键盘固定高度*/
#define dtKeyboardHeight         (dtIsDevicePad ? 264 : 216)

/*角度幅度转换*/
#define dtDegreesToRadians(x)    degreesToRadians(x)
#define dtRadiansToDegrees(x)    radiansToDegrees(x)

/*设备相关信息*/
#define dtIsPhone35              (isScreenSize(CGSizeMake(320, 480)) || \
                                  isScreenSize(CGSizeMake(640, 960)))// 4/4S
#define dtIsPhone4               isScreenSize(CGSizeMake(640, 1136)) //5,5C,5S
#define dtIsPhone47              isScreenSize(CGSizeMake(750, 1334)) //6
#define dtIsPhone55              isScreenSize(CGSizeMake(1242, 2208))//6Plus @3x

#define dtIsDevicePhone          (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define dtIsDevicePad            (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)

/*判断对象是否属于某个类或者是某个类的成员*/
#define dtIsKindOf(obj, Class)   [obj isKindOfClass:[Class class]]
#define dtIsMemberOf(obj, Class) [obj isMemberOfClass:[Class class]]

/*id对象与NSData之间转换-->coding协议本地存储*/
#define dtObjectToData(object)    [NSKeyedArchiver archivedDataWithRootObject:object]
#define dtDataToObject(data)      [NSKeyedUnarchiver unarchiveObjectWithData:data]

/*读取xib文件的类*/
#define dtViewByNib(Class, owner) [[[NSBundle mainBundle] loadNibNamed:Class owner:owner options:nil] lastObject]

/*读取故事板*/
#define dtStoryboard             [UIStoryboard storyboardWithName:@"Main" bundle:nil]
#define dtViewController(identy) [dtStoryboard instantiateViewControllerWithIdentifier:identy]

/*文件路径*/
#define dtPathHome                NSHomeDirectory()
#define dtPathTemp                NSTemporaryDirectory()
#define dtPathBundle(name, ext)   [[NSBundle mainBundle] pathForResource:name ofType:ext]
#define dtPathDocument            [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define dtPathDocumentAppend(f)   [dtPathDocument stringByAppendingPathComponent:f]

/*加载图片*/
#define dtImageByName(name)       [UIImage imageNamed:name]
#define dtImageByPath(path)       [UIImage imageWithContentsOfFile:path]
#define dtImageByRPath(name, ext) [UIImage imageWithContentsOfFile:dtPathBundle(name, ext)]

/*常用方法简写*/
#define dtAppDelegate             (AppDelegate *)[[UIApplication sharedApplication] delegate]
#define dtWindow                  [[[UIApplication sharedApplication] windows] lastObject]
#define dtKeyWindow               [[UIApplication sharedApplication] keyWindow]
#define dtUserDefaults            [NSUserDefaults standardUserDefaults]
#define dtNotificationCenter      [NSNotificationCenter defaultCenter]
#define dtIconBadgeNumber         [UIApplication sharedApplication].applicationIconBadgeNumber

#define dtInitObject(obj, Class)  Class *obj = [[Class alloc] init]

/*本地化方法简写*/
#define dtLStr(key)               NSLocalizedString(key, nil)
#define dtLStrTable(key, tbl)     NSLocalizedStringFromTable(key, tbl, nil)
#define dtEmptyString             @""

//当前设置的语言
#define dtCurrentLanguage          [[NSLocale preferredLanguages] objectAtIndex:0]
//当前APP的版本, 发布
#define dtAPPVersion               [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
//测试版本号
#define dtAPPTestVersion           [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"]
//当前APP的名称
#define dtAPPName                  [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"]
//属性
#define dtAPPIdentifier            [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleIdentifier"]
//以系统版本来判断是否是第一次启动，包括升级后是否为第一次启动。
#define dtFirstLaunch              dtAPPVersion
//判断是否为第一次运行，升级后启动不算是第一次运行
#define dtFirstRun                 @"FirstRun"

// block self
#define dtWeakSelf                 typeof(self) __weak weakSelf = self;
#define dtStrongSelf               typeof(weakSelf) __strong strongSelf = weakSelf;

/*调试相关*/

//ARC
#if __has_feature(objc_arc)
//compiling with ARC
#else
#define dtSafeRelease(object) { if(object) { [object release]; object = nil; } }
#endif

/*调试模式下输入NSLog，发布后不再输入*/
#ifndef __OPTIMIZE__
#define NSLog(FORMAT, ...) \
fprintf(stderr,"%s\n",[[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);

#define NSLogPoint(p) NSLog(@"%.2f, %.2f", p.x, p.y)
#define NSLogSize(p)  NSLog(@"%.2f, %.2f", p.width, p.height)
#define NSLogRect(p)  NSLog(@"%.2f, %.2f, %.2f, %.2f", p.origin.x, p.origin.y, p.size.width, p.size.height)

#else
#define NSLog(...) {}

#define NSLogPoint(p)
#define NSLogSize(p)
#define NSLogRect(p)

#endif

/*区分模拟机和真机*/
#if TARGET_OS_IPHONE
//iPhone Device
#endif

#if TARGET_IPHONE_SIMULATOR
//iPhone Simulator
#endif

/******断言******/
#define dtAssert2(condition, desc, returnValue) \
if ((condition) == NO) { \
NSString *file = [NSString stringWithUTF8String:__FILE__]; \
NSLog(@"\n警告文件：%@\n警告行数：第%d行\n警告方法：%s\n警告描述：%@", file, __LINE__,  __FUNCTION__, desc); \
return returnValue; \
}

#define dtAssert(condition, desc) dtAssert2(condition, desc, )

#define dtAssertParamNotNil2(param, returnValue) \
dtAssert2(param, [[NSString stringWithFormat:@#param] stringByAppendingString:@"参数不能为nil"], returnValue)

#define dtAssertParamNotNil(param) dtAssertParamNotNil2(param, )


/********************************/


// 命名声明, 用于当前类的唯一名称, 通知的时候用此来命名
#define AS_Static_Property( __name ) \
- (NSString *)__name; \
+ (NSString *)__name;

// 命名实现
#define DEF_Static_Property( __name ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
return [NSString stringWithFormat:@"%s", #__name]; \
}

#define DEF_Static_Property2( __name, __prefix ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
return [NSString stringWithFormat:@"%@.%s", __prefix, #__name]; \
}

#define DEF_Static_Property3( __name, __prefix, __prefix2 ) \
- (NSString *)__name \
{ \
return (NSString *)[[self class] __name]; \
} \
+ (NSString *)__name \
{ \
return [NSString stringWithFormat:@"%@.%@.%s", __prefix, __prefix2, #__name]; \
}


