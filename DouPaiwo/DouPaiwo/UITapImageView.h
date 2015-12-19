
/**
 *  @author J006, 15-06-15 12:06:06
 *
 *  可点击图片的类,增加跳转block
 *
 *  @return <#return value description#>
 */
#import <UIKit/UIKit.h>

@interface UITapImageView : UIImageView
- (void)addTapBlock:(void(^)(id obj))tapAction;

-(void)setImageWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction;

-(void)setImageWithUrlWaitForLoad:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction;

-(void)setImageWithUrlWaitForLoadForAvatarCircle:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction;

-(void)setImageAndChangeSizeWithUrl:(NSURL *)imgUrl placeholderImage:(UIImage *)placeholderImage tapBlock:(void(^)(id obj))tapAction  newHeight:(CGFloat)newHeight newWidth:(CGFloat)newWidth;

@end
