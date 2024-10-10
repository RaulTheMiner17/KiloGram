#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface SCIManager : NSObject

+ (BOOL)MusicStickers;
+ (BOOL)DevOptions;
+ (BOOL)ShareLoc;
+ (BOOL)ShareComment;
+ (BOOL)FLEX;

+ (void)showSaveVC:(id)item;
+ (void)cleanCache;
+ (NSString *)getDownloadingPersent:(float)per;

@end
