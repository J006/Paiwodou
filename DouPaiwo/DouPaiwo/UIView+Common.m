

#import "UIView+Common.h"
#define kTagBadgeView  1000
#define kTagLineView 1007
#import <objc/runtime.h>
@implementation UIView (Common)

- (void)setY:(CGFloat)y{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}
- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}
- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}
- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}
- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}
- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size.width = size.width;
    frame.size.height = size.height;
    self.frame = frame;
}

+ (UIView *)lineViewWithPointYY:(CGFloat)pointY{
  return [self lineViewWithPointYY:pointY andColor:[UIColor colorWithHexString:@"0xc8c7cc"]];
}

+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color{
  return [self lineViewWithPointYY:pointY andColor:color andLeftSpace:0];
}

+ (UIView *)lineViewWithPointYY:(CGFloat)pointY andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
  UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(leftSpace, pointY, kScreen_Width - leftSpace, 0.5)];
  lineView.backgroundColor = color;
  return lineView;
}

- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown{
  [self addLineUp:hasUp andDown:hasDown andColor:[UIColor colorWithHexString:@"0xc8c7cc"]];
}

- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color{
  [self removeViewWithTag:kTagLineView];
  if (hasUp) {
    UIView *upView = [UIView lineViewWithPointYY:0 andColor:color];
    upView.tag = kTagLineView;
    [self addSubview:upView];
  }
  if (hasDown) {
    UIView *downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds)-0.5 andColor:color];
    downView.tag = kTagLineView;
    [self addSubview:downView];
  }
  return [self addLineUp:hasUp andDown:hasDown andColor:color andLeftSpace:0];
}
- (void)addLineUp:(BOOL)hasUp andDown:(BOOL)hasDown andColor:(UIColor *)color andLeftSpace:(CGFloat)leftSpace{
  [self removeViewWithTag:kTagLineView];
  if (hasUp) {
    UIView *upView = [UIView lineViewWithPointYY:0 andColor:color andLeftSpace:leftSpace];
    upView.tag = kTagLineView;
    [self addSubview:upView];
  }
  if (hasDown) {
    UIView *downView = [UIView lineViewWithPointYY:CGRectGetMaxY(self.bounds)-0.5 andColor:color andLeftSpace:leftSpace];
    downView.tag = kTagLineView;
    [self addSubview:downView];
  }
}
- (void)removeViewWithTag:(NSInteger)tag{
  for (UIView *aView in [self subviews]) {
    if (aView.tag == tag) {
      [aView removeFromSuperview];
    }
  }
}

- (CGFloat)maxXOfFrame{
    return CGRectGetMaxX(self.frame);
}

- (CGSize)sizeToFitWidth  :(CGSize)size newWidth:(CGFloat)newWidth
{
  CGFloat newHeight   = size.height*newWidth/size.width;
  size  = CGSizeMake(newWidth, newHeight);
  return size;
}

- (CGFloat)heightToFitWidth  :(CGSize)size newWidth:(CGFloat)newWidth
{
  CGFloat newHeight   = size.height*newWidth/size.width;
  return  newHeight;
}

@end










