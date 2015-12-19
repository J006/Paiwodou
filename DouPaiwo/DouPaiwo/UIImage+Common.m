
/**
 *  @author J006, 15-05-21 11:05:15
 *
 *  
 *
 *  @param Common
 *
 *  @return
 */
#import "UIImage+Common.h"
#import <GPUImage.h>

@implementation UIImage (Common)
+(UIImage *)imageWithColor:(UIColor *)aColor{
    return [UIImage imageWithColor:aColor withFrame:CGRectMake(0, 0, 1, 1)];
}

+(UIImage *)imageWithColor:(UIColor *)aColor withFrame:(CGRect)aFrame{
    UIGraphicsBeginImageContext(aFrame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [aColor CGColor]);
    CGContextFillRect(context, aFrame);
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}

- (UIImage *)takeSnapshotOfView:(UIView *)view
{
  UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
  [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  
  return image;
}

- (UIImage*)takeSnapshotFrameOfView:(UIView *)view WithFrame:(CGRect)frame
{
  UIGraphicsBeginImageContext(CGSizeMake(view.frame.size.width, view.frame.size.height));
  [view drawViewHierarchyInRect:CGRectMake(0, 0, view.frame.size.width, view.frame.size.height) afterScreenUpdates:YES];
  UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  CGImageRef ref = CGImageCreateWithImageInRect(image.CGImage, frame);
  UIImage *newImage = [UIImage imageWithCGImage:ref];
  CGImageRelease(ref);
  return newImage;
}

- (UIImage *)addTwoImageToOne:(UIImage *)oneImg twoImage:(UIImage *)twoImg topleft:(CGPoint)tlPos
{
  UIGraphicsBeginImageContext(oneImg.size);
  [oneImg drawInRect:CGRectMake(0, 0, oneImg.size.width, oneImg.size.height)];
  [twoImg drawInRect:CGRectMake(0,0,oneImg.size.width,oneImg.size.height) blendMode:kCGBlendModeNormal alpha:0.8];
  UIImage *resultImg = UIGraphicsGetImageFromCurrentImageContext();
  UIGraphicsEndImageContext();
  return resultImg;
}

- (UIImage*)randomSetPreLoadImageWithSize :(CGSize)size
{
  CGRect  rect    = CGRectMake(0, 0, size.width, size.height);
  NSArray *colorArray = @[@"e7afc7",@"747b85",@"776d80",@"a0a09d",@"bbceef",@"a9a6a4",@"997a86",@"d8d6d0"];
  NSInteger randomIndex = arc4random() % (7+1);
  UIImage *image  = [UIImage  imageWithColor:[UIColor colorWithHexString:[colorArray objectAtIndex:randomIndex]] withFrame:rect];
  return image;
}

- (UIImage*)addBlackFillterToImageWithOrigImage
{
  UIImage *sourceImage = self;
  UIImage *blackImage  = [UIImage imageWithColor:[UIColor colorWithRed:0 green:0 blue:0 alpha:0.3] withFrame:CGRectMake(0, 0, sourceImage.size.width, sourceImage.size.height)];
  UIImage *tempImage  = [sourceImage addTwoImageToOne:sourceImage twoImage:blackImage topleft:CGPointMake(0, 0)];
  return tempImage;
}

- (UIImage *)imageWithGaussianBlur:(UIImage *)image
{
  //GPUImagePicture *stillImageSource = [[GPUImagePicture alloc] initWithImage:image];
  GPUImageGaussianBlurFilter *blurFilter = [[GPUImageGaussianBlurFilter alloc]init];
  blurFilter.blurRadiusInPixels = 2;
  blurFilter.blurPasses = 1;
  UIImage *quickFilteredImage = [blurFilter imageByFilteringImage:image];
  return quickFilteredImage;
}

//截取部分图像
-(UIImage*)getSubImage:(CGRect)rect
{
  CGImageRef subImageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
  CGRect smallBounds = CGRectMake(0, 0, CGImageGetWidth(subImageRef), CGImageGetHeight(subImageRef));
  UIGraphicsBeginImageContext(smallBounds.size);
  CGContextRef context = UIGraphicsGetCurrentContext();
  CGContextDrawImage(context, smallBounds, subImageRef);
  UIImage* smallImage = [UIImage imageWithCGImage:subImageRef];
  UIGraphicsEndImageContext();
  
  return smallImage;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat) alpha
{
  UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
  
  CGContextRef ctx = UIGraphicsGetCurrentContext();
  CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
  
  CGContextScaleCTM(ctx, 1, -1);
  CGContextTranslateCTM(ctx, 0, -area.size.height);
  
  CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
  
  CGContextSetAlpha(ctx, alpha);
  
  CGContextDrawImage(ctx, area, self.CGImage);
  
  UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
  
  UIGraphicsEndImageContext();
  
  return newImage;
}


//对图片尺寸进行压缩--
-(UIImage*)scaledToSize:(CGSize)targetSize
{
    UIImage *sourceImage = self;
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat scaleFactor = 0.0;
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetSize.width / imageSize.width;
        CGFloat heightFactor = targetSize.height / imageSize.height;
        if (widthFactor < heightFactor)
            scaleFactor = heightFactor; // scale to fit height
        else
            scaleFactor = widthFactor; // scale to fit width
    }
    scaleFactor = MIN(scaleFactor, 1.0);
    CGFloat targetWidth = imageSize.width* scaleFactor;
    CGFloat targetHeight = imageSize.height* scaleFactor;

    targetSize = CGSizeMake(floorf(targetWidth), floorf(targetHeight));
    UIGraphicsBeginImageContext(targetSize); // this will crop
    [sourceImage drawInRect:CGRectMake(0, 0, ceilf(targetWidth), ceilf(targetHeight))];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        DebugLog(@"could not scale image");
        newImage = sourceImage;
    }
    UIGraphicsEndImageContext();
    return newImage;
}
-(UIImage*)scaledToSize:(CGSize)targetSize highQuality:(BOOL)highQuality{
    if (highQuality) {
        targetSize = CGSizeMake(2*targetSize.width, 2*targetSize.height);
    }
    return [self scaledToSize:targetSize];
}

-(UIImage *)scaledToMaxSize:(CGSize)size{
    
    CGFloat width = size.width;
    CGFloat height = size.height;
    
    CGFloat oldWidth = self.size.width;
    CGFloat oldHeight = self.size.height;
    
    CGFloat scaleFactor = (oldWidth > oldHeight) ? width / oldWidth : height / oldHeight;
    
    // 如果不需要缩放
    if (scaleFactor > 1.0) {
        return self;
    }
    
    CGFloat newHeight = oldHeight * scaleFactor;
    CGFloat newWidth = oldWidth * scaleFactor;
    CGSize newSize = CGSizeMake(newWidth, newHeight);
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0);
    [self drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

-(UIImage*)cutSizeFitFor:(CGSize)size
{
  CGFloat originalWidth = self.size.width;
  CGFloat originalHeight = self.size.height;
  CGFloat targetWidth = size.width;
  CGFloat targetHeight = size.height;
  
  if(originalWidth/originalHeight>targetWidth/targetHeight)
  {
    CGFloat fitWidth  = targetHeight*originalWidth/originalHeight;
    UIImageView *imgview = [[UIImageView alloc] init];
    imgview.frame = CGRectMake(0, 0, fitWidth, targetHeight);
    CGRect rect =  CGRectMake((fitWidth-targetWidth)/2, 0, targetWidth, targetHeight);//要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
    CGImageRef cgimg = CGImageCreateWithImageInRect([[self scaledToSize:CGSizeMake(fitWidth, targetHeight)] CGImage], rect);
    return [UIImage imageWithCGImage:cgimg];
  }
  else
  {
    CGFloat fitHeight  = originalHeight*targetWidth/originalWidth;
    UIImageView *imgview = [[UIImageView alloc] init];
    imgview.frame = CGRectMake(0, 0, targetWidth, fitHeight);
    CGRect rect =  CGRectMake(0, (fitHeight-targetHeight)/2, targetWidth, targetHeight);//要裁剪的图片区域，按照原图的像素大小来，超过原图大小的边自动适配
    CGImageRef cgimg = CGImageCreateWithImageInRect([[self scaledToSize:CGSizeMake(targetWidth, fitHeight)] CGImage], rect);
    return [UIImage imageWithCGImage:cgimg];
  }
  return self;
}

+ (UIImage *)fullResolutionImageFromALAsset:(ALAsset *)asset{
    ALAssetRepresentation *assetRep = [asset defaultRepresentation];
    CGImageRef imgRef = [assetRep fullResolutionImage];
    UIImage *img = [UIImage imageWithCGImage:imgRef scale:assetRep.scale orientation:(UIImageOrientation)assetRep.orientation];
//    UIImage *img = [UIImage imageWithCGImage:imgRef];
    return img;
}

- (UIImage*)createGaussianBlurImageWithImage  :(UIImage*)theImage withValue:(NSNumber*)value
{
  CIContext *context = [CIContext contextWithOptions:nil];
  CIImage *inputImage = [CIImage imageWithCGImage:theImage.CGImage];
  CIFilter *filter = [CIFilter filterWithName:@"CIGaussianBlur"];
  [filter setValue:inputImage forKey:kCIInputImageKey];
  [filter setValue:value forKey:@"inputRadius"];
  CIImage *result = [filter valueForKey:kCIOutputImageKey];
  CGImageRef cgImage = [context createCGImage:result fromRect:[inputImage extent]];
  UIImage *returnImage = [UIImage imageWithCGImage:cgImage];
  return returnImage;
}

@end
