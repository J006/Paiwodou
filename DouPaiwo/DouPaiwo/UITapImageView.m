

#import "UITapImageView.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "UIImage+Common.h"
//#import <UIImageView+UIActivityIndicatorForSDWebImage.h>
@interface  UITapImageView ()

@property (nonatomic, copy) void(^tapAction)(id);

@end

@implementation UITapImageView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (instancetype)init
{
    return [self initWithFrame:CGRectZero];
}

- (void)tap{
    if (self.tapAction) {
        self.tapAction(self);
    }
}
- (void)addTapBlock:(void(^)(id obj))tapAction{
    self.tapAction = tapAction;
    if (![self gestureRecognizers]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap)];
        [self addGestureRecognizer:tap];
    }
}

-(void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction
{
    __weak typeof(self) weakSelf = self;
    [self  sd_setImageWithURL:imgUrl placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
      if(weakSelf.alpha==0.0 || cacheType ==SDImageCacheTypeDisk || cacheType ==SDImageCacheTypeMemory)
      {
        [weakSelf   addTapBlock:tapAction];
        return;
      }
      weakSelf.alpha = 0.0;
      [UIView animateWithDuration:1.0
                            delay:0.0
                          options:UIViewAnimationOptionTransitionCrossDissolve
                       animations:^{
                         weakSelf.alpha = 1.0;
                       }completion:^(BOOL finished){
                         [weakSelf addTapBlock:tapAction];
                       }];
    }];
    //[self setImageWithURL:imgUrl  usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

}

-(void)setImageWithUrlWaitForLoad:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction
{
  __weak typeof(self) weakSelf = self;
  [self sd_setImageWithURL:imgUrl placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    if(image)
    {
      if(weakSelf.alpha==0.0)
      {
        [weakSelf   addTapBlock:tapAction];
        return;
      }
      weakSelf.alpha = 0.0;
      [UIView animateWithDuration:1.0
                            delay:0.0
                          options:UIViewAnimationOptionTransitionCrossDissolve
                       animations:^{
                         weakSelf.alpha = 1.0;
                       }completion:^(BOOL finished){
                               [weakSelf addTapBlock:tapAction];
                       }];

    }
  }];
  /*
  [self  setImageWithURL:imgUrl placeholderImage:placeholderImage  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
   { 
      if(image)
      {
        [UIView animateWithDuration:0.5
                              delay:0.0
                            options:UIViewAnimationOptionTransitionCrossDissolve
                         animations:^{
                           weakSelf.alpha = 1.0;
                         }completion:^(BOOL finished){
                         }];
        [weakSelf addTapBlock:tapAction];
      }
   }usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   */
}

-(void)setImageWithUrlWaitForLoadForAvatarCircle:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction
{
  __weak typeof(self) weakSelf = self;
  [self sd_setImageWithURL:imgUrl placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    if(image)
    {
      [weakSelf   doCircleFrame];
      if(weakSelf.alpha==0.0)
      {
         [weakSelf   addTapBlock:tapAction];
        return;
      }
        weakSelf.alpha = 0.0;
      [UIView animateWithDuration:1.0
                            delay:0.0
                          options:UIViewAnimationOptionTransitionCrossDissolve
                       animations:^{
                         weakSelf.alpha = 1.0;
                       }completion:^(BOOL finished){
                         [weakSelf   addTapBlock:tapAction];
 
                       }];
    }
  }];
  /*
  [self  setImageWithURL:imgUrl placeholderImage:placeholderImage  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
   {
     if(image)
     {
       [weakSelf addTapBlock:tapAction];
       [weakSelf  doCircleFrame];
     }
   }usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
   */
}


-(void)setImageAndChangeSizeWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction  newHeight:(CGFloat)newHeight newWidth:(CGFloat)newWidth
{
    __weak typeof(self) weakSelf = self;
  [self sd_setImageWithURL:imgUrl placeholderImage:placeholderImage completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
    if(error==nil  && image!=nil)
    {
      CGSize imageSize = image.size;
      if(newHeight!=0)
      {
        CGFloat  theNewWidth = [weakSelf  widthToFitHeight:imageSize newHeight:newHeight];
        imageSize  = CGSizeMake(theNewWidth, newHeight);
      }
      else if(newWidth!=0)
      {
        CGFloat  theNewHeight= [weakSelf  heightToFitWidth:imageSize newWidth:newWidth];
        imageSize  = CGSizeMake(newWidth, theNewHeight);
      }
      if(weakSelf.alpha==0.0 || cacheType ==SDImageCacheTypeDisk || cacheType ==SDImageCacheTypeMemory)
      {
        [weakSelf            setSize:imageSize];
        [weakSelf            addTapBlock:tapAction];
        [weakSelf.superview  setNeedsLayout];
        return;
      }
      [weakSelf            setSize:imageSize];
      weakSelf.alpha = 0.0;
      [UIView animateWithDuration:1.0
                            delay:0.0
                          options:UIViewAnimationOptionTransitionCrossDissolve
                       animations:^{
                         weakSelf.alpha = 1.0;
                       }completion:^(BOOL finished){
                         [weakSelf            addTapBlock:tapAction];
                         [weakSelf.superview  setNeedsLayout];
                         
                       }];

    }
  }];
  
  /*
  [self  setImageWithURL:imgUrl placeholderImage:placeholderImage  completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL)
   {
     if(error==nil  && image!=nil)
     {
       CGSize imageSize = image.size;
       if(newHeight!=0)
       {
         CGFloat  theNewWidth = [weakSelf  widthToFitHeight:imageSize newHeight:newHeight];
         imageSize  = CGSizeMake(theNewWidth, newHeight);
       }
       else if(newWidth!=0)
       {
         CGFloat  theNewHeight= [weakSelf  heightToFitWidth:imageSize newWidth:newWidth];
         imageSize  = CGSizeMake(newWidth, theNewHeight);
       }
       [weakSelf            setSize:imageSize];
       [weakSelf            addTapBlock:tapAction];
       [weakSelf.superview  setNeedsLayout];
     }
     
   }usingActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
   */
}

- (CGFloat)heightToFitWidth  :(CGSize)size newWidth:(CGFloat)newWidth
{
  CGFloat newHeight   = size.height*newWidth/size.width;
  return  newHeight;
}

- (CGFloat)widthToFitHeight  :(CGSize)size newHeight:(CGFloat)newHeight
{
  CGFloat newWidth  = size.width*newHeight/size.height;
  return  newWidth;
}

@end
