
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  @author J006, 15-04-25 18:04:35
 *
 *  图片调整工具类
 */
@interface ImageSizeManager : NSObject
+ (instancetype)shareManager;

- (NSMutableDictionary *)read;
- (BOOL)save;

- (void)saveImage:(NSString *)imagePath size:(CGSize)size;
- (CGFloat)sizeOfImage:(NSString *)imagePath;
- (BOOL)hasSrc:(NSString *)src;

//Image Resize (used in tweet and message)
- (CGSize)sizeWithSrc:(NSString *)src originalWidth:(CGFloat)originalWidth maxHeight:(CGFloat)maxHeight;
- (CGSize)sizeWithImage:(UIImage *)image originalWidth:(CGFloat)originalWidth maxHeight:(CGFloat)maxHeight;
- (CGSize)sizeWithSrc:(NSString *)src originalWidth:(CGFloat)originalWidth maxHeight:(CGFloat)maxHeight minWidth:(CGFloat)minWidth;

- (CGSize)newSizeWithImage:(UIImage *)image :(CGFloat)maxWidth;

@end
