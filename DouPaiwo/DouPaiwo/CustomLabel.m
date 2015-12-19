//
//  CustomLabel.m
//  TestPaiwo
//
//  Created by J006 on 15/5/5.
//  Copyright (c) 2015年 Light Chasers. All rights reserved.
//

#import "CustomLabel.h"
#import "NSString+Common.h"

@implementation CustomLabel

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
@synthesize verticalAlignment;

-(id)initWithFrame:(CGRect)frame

{
  self = [super initWithFrame:frame];
  if (!self) return nil;
  
  // set inital value via IVAR so the setter isn't called
  verticalAlignment = VerticalAlignmentTop;
  
  return self;
}

-(VerticalAlignment) verticalAlignment
{
  return verticalAlignment;
}

-(void) setVerticalAlignment:(VerticalAlignment)value
{
  verticalAlignment = value;
  [self setNeedsDisplay];
}

// align text block according to vertical alignment settings
-(CGRect)textRectForBounds:(CGRect)bounds
    limitedToNumberOfLines:(NSInteger)numberOfLines
{
  CGRect rect = [super textRectForBounds:bounds
                  limitedToNumberOfLines:numberOfLines];
  CGRect result;
  switch (verticalAlignment)
  {
    case VerticalAlignmentTop:
      result = CGRectMake(bounds.origin.x, bounds.origin.y,
                          rect.size.width, rect.size.height);
      break;
      
    case VerticalAlignmentMiddle:
      result = CGRectMake(bounds.origin.x,
                          bounds.origin.y + (bounds.size.height - rect.size.height) / 2,
                          rect.size.width, rect.size.height);
      break;
      
    case VerticalAlignmentBottom:
      result = CGRectMake(bounds.origin.x,
                          bounds.origin.y + (bounds.size.height - rect.size.height),
                          rect.size.width, rect.size.height);
      break;
      
    default:
      result = bounds;
      break;
  }
  return result;
}

- (void)setLineSpacing  :(CGFloat)lineSpacing
{
  if(!self.text || [self.text isEmpty])
    return;
  NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
  NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
  paragraphStyle.lineSpacing = lineSpacing;
  [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, self.text.length-1)];
  self.attributedText = attributedString;
}


-(void)drawTextInRect:(CGRect)rect
{
  CGRect r = [self textRectForBounds:rect
              limitedToNumberOfLines:self.numberOfLines];
  [super drawTextInRect:r];
}
@end
