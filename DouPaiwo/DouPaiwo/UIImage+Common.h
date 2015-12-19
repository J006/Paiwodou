
/**
 *  @author J006, 15-05-21 11:05:03
 *
 *  
 *
 *  @param Common
 *
 *  @return
 */
#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>


@interface UIImage (Common)

+(UIImage *)imageWithColor:(UIColor *)aColor;
+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame;
-(UIImage*)scaledToSize:(CGSize)targetSize;
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality;
-(UIImage*)scaledToMaxSize:(CGSize )size;
-(UIImage*)cutSizeFitFor:(CGSize )size;
+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset;
- (UIImage*)createGaussianBlurImageWithImage  :(UIImage*)theImage withValue:(NSNumber*)value;
- (UIImage*)takeSnapshotOfView:(UIView *)view;
- (UIImage*)takeSnapshotFrameOfView:(UIView *)view WithFrame:(CGRect)frame;
- (UIImage*)addBlackFillterToImageWithOrigImage;
- (UIImage *)imageWithGaussianBlur:(UIImage *)image;
- (UIImage*)getSubImage:(CGRect)rect;
- (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg topleft:(CGPoint)tlPos;
/**
 *  @author J.006, 15-09-18 13:09:14
 *
 *  根据指定size生成预读取的图片
 *
 *  @param size
 *
 *  @return
 */
- (UIImage*)randomSetPreLoadImageWithSize :(CGSize)size;

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
@end
