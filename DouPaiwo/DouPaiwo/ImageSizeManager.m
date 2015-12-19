#define kPath_ImageSizeDict @"ImageSizeDict"
#define kImageSizeManager_maxCount 1000
#define kImageSizeManager_resetCount (kImageSizeManager_maxCount/2)

#import "ImageSizeManager.h"

@interface ImageSizeManager ()
@property (strong, nonatomic) NSMutableDictionary *imageSizeDict;

@end

@implementation ImageSizeManager
+ (instancetype)shareManager
{
    static ImageSizeManager *shared_manager = nil;
    static dispatch_once_t pred;
    dispatch_once(&pred, ^{
        shared_manager = [[self alloc] init];
        [shared_manager read];
    });
    return shared_manager;
}
- (NSMutableDictionary *)read{
    if (!_imageSizeDict) {
        NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ImageSizeDict], kPath_ImageSizeDict];
        _imageSizeDict = [NSMutableDictionary dictionaryWithContentsOfFile:abslutePath];
        if (!_imageSizeDict) {
            _imageSizeDict = [NSMutableDictionary dictionary];
        }
    }
    return _imageSizeDict;
}

- (BOOL)save{
    if (_imageSizeDict) {
        if ([self createDirInCache:kPath_ImageSizeDict]) {
            NSString *abslutePath = [NSString stringWithFormat:@"%@/%@.plist", [self pathInCacheDirectory:kPath_ImageSizeDict], kPath_ImageSizeDict];
            return [_imageSizeDict writeToFile:abslutePath atomically:YES];
        }
    }
    return NO;
}

- (void)saveImage:(NSString *)imagePath size:(CGSize)size{
    if (imagePath && ![_imageSizeDict objectForKey:imagePath]) {
        [_imageSizeDict setObject:[NSNumber numberWithFloat:size.height/size.width] forKey:imagePath];
    }
}

- (CGFloat)sizeOfImage:(NSString *)imagePath{
    CGFloat imageSize = 1;
    NSNumber *sizeValue = [_imageSizeDict objectForKey:imagePath];
    if (sizeValue) {
        imageSize = sizeValue.floatValue;
    }
    return imageSize;
}

- (BOOL)hasSrc:(NSString *)src{
    NSNumber *sizeValue = [_imageSizeDict objectForKey:src];
    BOOL hasSrc = NO;
    if (sizeValue) {
        hasSrc = YES;
    }
    return hasSrc;
}

- (NSString* )pathInCacheDirectory:(NSString *)fileName
{
  NSArray *cachePaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
  NSString *cachePath = [cachePaths objectAtIndex:0];
  return [cachePath stringByAppendingPathComponent:fileName];
}

//创建缓存文件夹
- (BOOL) createDirInCache:(NSString *)dirName
{
  NSString *dirPath = [self pathInCacheDirectory:dirName];
  BOOL isDir = NO;
  NSFileManager *fileManager = [NSFileManager defaultManager];
  BOOL existed = [fileManager fileExistsAtPath:dirPath isDirectory:&isDir];
  BOOL isCreated = NO;
  if ( !(isDir == YES && existed == YES) )
  {
    isCreated = [fileManager createDirectoryAtPath:dirPath withIntermediateDirectories:YES attributes:nil error:nil];
  }
  if (existed) {
    isCreated = YES;
  }
  return isCreated;
}

- (CGSize)sizeWithImageH_W:(CGFloat)height_width originalWidth:(CGFloat)originalWidth{
    CGSize reSize = CGSizeZero;
    reSize.width = originalWidth;
    reSize.height = originalWidth *height_width;
    return reSize;
}

- (CGSize)sizeWithSrc:(NSString *)src originalWidth:(CGFloat)originalWidth maxHeight:(CGFloat)maxHeight{
    CGSize reSize = [self sizeWithImageH_W:[self sizeOfImage:src] originalWidth:originalWidth];
    if (reSize.height > maxHeight) {
        reSize.height = maxHeight;
    }
    return reSize;
}
- (CGSize)sizeWithImage:(UIImage *)image originalWidth:(CGFloat)originalWidth maxHeight:(CGFloat)maxHeight{
    CGSize reSize = [self sizeWithImageH_W:(image.size.height/image.size.width) originalWidth:originalWidth];
    if (reSize.height > maxHeight) {
        reSize.height = maxHeight;
    }
    return reSize;
}

/**
 *  @author J006, 15-05-12 18:05:28
 *
 *  根据给定的最大宽度,返回适配图片的size
 *
 *  @param image
 *  @param maxWidth
 *
 *  @return 适配图片的size
 */
- (CGSize)newSizeWithImage:(UIImage *)image :(CGFloat)maxWidth
{
  CGSize originaSize = image.size;
  CGFloat newHeight   = originaSize.height*maxWidth/originaSize.width;
  CGSize reSize = CGSizeMake(maxWidth, newHeight);
  return reSize;
}


- (CGSize)sizeWithSrc:(NSString *)src originalWidth:(CGFloat)originalWidth maxHeight:(CGFloat)maxHeight minWidth:(CGFloat)minWidth{
    CGSize reSize = [self sizeWithImageH_W:[self sizeOfImage:src] originalWidth:originalWidth];
    CGFloat scale = maxHeight/reSize.height;
    if (scale < 1) {
        reSize = CGSizeMake(reSize.width *scale, reSize.height*scale);
    }
    if (reSize.width < minWidth) {
        reSize.width = minWidth;
    }
    return reSize;
}
@end
