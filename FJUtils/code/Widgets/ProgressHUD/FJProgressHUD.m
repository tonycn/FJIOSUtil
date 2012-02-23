//
//  FJProgressHUD.m
//  FJUtils
//
//  Created by Jianjun Wu on 2/21/12.
//  Copyright (c) 2012 Fourj. All rights reserved.
//
//  MBRoundProgressView is written by Matej Bukovinski's in MBProgressHUD https://github.com/matej/MBProgressHUD
//  This code is distributed under the terms and conditions of the MIT license. 

#import <QuartzCore/QuartzCore.h>
#import "FJProgressHUD.h"


@interface MBRoundProgressView : UIView {
@private
  float _progress;
}

/**
 * Progress (0.0 to 1.0)
 */
@property (nonatomic, assign) float progress;

@end

@implementation MBRoundProgressView

#pragma mark -
#pragma mark Accessors

- (float)progress {
  return _progress;
}

- (void)setProgress:(float)progress {
  _progress = progress;
  [self setNeedsDisplay];
}

#pragma mark -
#pragma mark Lifecycle

- (id)init {
  return [self initWithFrame:CGRectMake(0.0f, 0.0f, 37.0f, 37.0f)];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
  }
  return self;
}

#pragma mark -
#pragma mark Drawing

- (void)drawRect:(CGRect)rect {
	
  CGRect allRect = self.bounds;
  CGRect circleRect = CGRectInset(allRect, 2.0f, 2.0f);
	
  CGContextRef context = UIGraphicsGetCurrentContext();
	
  // Draw background
  CGContextSetRGBStrokeColor(context, 1.0, 1.0, 1.0, 1.0); // white
  CGContextSetRGBFillColor(context, 1.0, 1.0, 1.0, 0.1); // translucent white
  CGContextSetLineWidth(context, 2.0f);
  CGContextFillEllipseInRect(context, circleRect);
  CGContextStrokeEllipseInRect(context, circleRect);
	
  // Draw progress
  CGPoint center = CGPointMake(allRect.size.width / 2, allRect.size.height / 2);
  CGFloat radius = (allRect.size.width - 4) / 2;
  CGFloat startAngle = - (M_PI / 2); // 90 degrees
  CGFloat endAngle = (self.progress * 2 * M_PI) + startAngle;
  CGContextSetRGBFillColor(context, 1.0f, 1.0f, 1.0f, 1.0f); // white
  CGContextMoveToPoint(context, center.x, center.y);
  CGContextAddArc(context, center.x, center.y, radius, startAngle, endAngle, 0);
  CGContextClosePath(context);
  CGContextFillPath(context);
}

/////////////////////////////////////////////////////////////////////////////////////////////

@end

static const CGFloat kIconEdge = 37.f;

@implementation FJProgressHUD

@synthesize iconType = _iconType;
@synthesize layoutType = _layoutType;

@synthesize iconSize = _iconSize;
@synthesize contentInsets = _contentInsets;
@synthesize messageText = _messageText;

- (void)dealloc {
  [_iconCustomView release];
  [_iconImageView release];
  [_iconActivity release];
  [_iconProgressView release];
  _currentIconViewRef = NULL;
  [_messageLabel release];
  [_maskView release];
  [_messageText release];
  
  [super dealloc];
}

- (id)initWithFrame:(CGRect)frame {
  self = [super initWithFrame:frame];
  if (self) {
    _iconSize = CGSizeZero;
    _contentInsets = UIEdgeInsetsMake(5.f, 5.f, 5.f, 5.f);
    _iconType = kFJProgressHUDIconNone;
    _layoutType = kFJProgressHUDLayoutHorizontal;
    _currentIconViewRef = NULL;
  }
  return self;
}

+ (FJProgressHUD *)ProgressHUDWithSize:(CGSize)size {
  
  CGRect frame = CGRectZero;
  frame.size = size;
  FJProgressHUD *progressHUD = [[[FJProgressHUD alloc] initWithFrame:frame] autorelease];
  return progressHUD;
}

- (void)releaseCurrentIconView {
  if (_currentIconViewRef != NULL) {
    [*_currentIconViewRef release];
    *_currentIconViewRef = nil;
    _currentIconViewRef = NULL;
  }
}

- (void)setCurrentIconView:(UIView **)v {
  if (v != NULL 
      & v != nil 
      && _currentIconViewRef != NULL 
      && *_currentIconViewRef != nil) {
    [self releaseCurrentIconView];
  }
  _currentIconViewRef = v;
  [self addSubview:*v];
}

- (void)setIconType:(FJProgressHUDIconType)iconType {
  
  _iconType = iconType;
  switch (_iconType) {
    case kFJProgressHUDIconNone:
      [self setCurrentIconView:nil];
      break;
      
    case kFJProgressHUDIconActivity:
      _iconActivity = [[UIActivityIndicatorView alloc] 
                       initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
      [_iconActivity startAnimating];
      [self setCurrentIconView:&_iconActivity];
      break;

    case kFJProgressHUDIconCustomImage:
      _iconImageView = [[UIImageView alloc] init];
      [self setCurrentIconView:&_iconImageView];
      break;
      
    case kFJProgressHUDIconCustomView:
      
      break;
      
    case kFJProgressHUDIconProgress:
      _iconProgressView = [[MBRoundProgressView alloc] init];
      [self setCurrentIconView:&_iconProgressView];
      break;
    default:
      break;
  }
}

- (void)setIconCustomView:(UIView *)view {
  
  [_iconCustomView autorelease];
  _iconCustomView = [view retain];
  _iconType = kFJProgressHUDIconCustomView;
  [self setCurrentIconView:&_iconCustomView];
}

- (void)setMessageText:(NSString *)messageText {
  
  [_messageText autorelease];
  _messageText = [messageText copy];
  
  if (_messageLabel == nil) {
    _messageLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    _messageLabel.lineBreakMode = UILineBreakModeWordWrap;
    _messageLabel.numberOfLines = 10;
    _messageLabel.minimumFontSize = 12.f;
    _messageLabel.font = [UIFont systemFontOfSize:15.f];
    _messageLabel.textAlignment = UITextAlignmentCenter;
    _messageLabel.backgroundColor = [UIColor clearColor];
    _messageLabel.textColor = [UIColor whiteColor];
    [self addSubview:_messageLabel];
  }
  _messageLabel.text = messageText;
}

- (void)showHUDInView:(UIView *)view modal:(BOOL)isModal {
  
  if (view == nil) {
    NSLog(@"view cannot be nil");
    return;
  }
  
  if (isModal) {
    if (_maskView != nil) {
      [_maskView autorelease];
      [_maskView removeFromSuperview];
      _maskView = nil;
    }
    CGRect f = view.frame;
    f.origin = CGPointZero;
    _maskView = [[UIView alloc] initWithFrame:f];
    _maskView.backgroundColor = [UIColor blackColor];
    _maskView.alpha = .7f;
    [view addSubview:_maskView];
    _maskView.userInteractionEnabled = NO;
  }
  
  [view addSubview:self];
  
  CGRect frame = self.frame;
  frame.origin.x = (view.frame.size.width - frame.size.width) / 2;
  frame.origin.y = (view.frame.size.height - frame.size.height) / 2;
  self.frame = frame;
  
  self.backgroundColor = [UIColor blackColor];
  self.layer.cornerRadius = 5.f;
  self.layer.masksToBounds = YES;
}


- (void)dismissView {
  
  [_maskView removeFromSuperview];
  [self removeFromSuperview];
  
}

- (void)setProgress:(CGFloat)progress {
  
  if (_iconProgressView) {
    _iconProgressView.progress = progress;
  }
}

- (void)layoutSubviews {
  UIView *iconView = nil;
  if (_currentIconViewRef != NULL) {
    iconView = *_currentIconViewRef;
  }
  CGRect contentRect = self.frame;
  contentRect.origin.x = _contentInsets.left;
  contentRect.origin.y = _contentInsets.top;
  contentRect.size.width -= _contentInsets.left + _contentInsets.right;
  contentRect.size.height -= _contentInsets.top + _contentInsets.bottom;

  if (iconView && [_messageText length]) {
    CGRect iconViewFrame = iconView.frame;
    if (!CGSizeEqualToSize(_iconSize, CGSizeZero)) {
      iconViewFrame.size = _iconSize;
    }
    CGSize iconViewSize = iconViewFrame.size;
    if (_layoutType == kFJProgressHUDLayoutHorizontal) {
      CGPoint orig = CGPointMake(contentRect.origin.x, 
                                 (contentRect.size.height - iconViewSize.height) / 2 + contentRect.origin.y);
      
      iconViewFrame.origin = orig;
      iconView.frame = iconViewFrame;
      
      contentRect.origin.x += iconView.frame.size.width;
      contentRect.size.width -= iconView.frame.size.width;
      _messageLabel.frame = contentRect;

    } else if (_layoutType == kFJProgressHUDLayoutVertical) {
      CGPoint orig = CGPointMake((contentRect.size.width - iconViewSize.width) / 2 + contentRect.origin.x, 
                                 contentRect.origin.y);
      iconViewFrame.origin = orig;
      iconView.frame = iconViewFrame;

      contentRect.origin.y += iconView.frame.size.height;
      contentRect.size.height -= iconView.frame.size.height;
      _messageLabel.frame = contentRect;
    }
  } else if (iconView) {
    CGRect iconViewFrame = iconView.frame;
    if (!CGSizeEqualToSize(_iconSize, CGSizeZero)) {
      iconViewFrame.size = _iconSize;
    }
    CGSize iconViewSize = iconViewFrame.size;
    CGPoint orig = CGPointMake((contentRect.size.width - iconViewSize.width) / 2 + contentRect.origin.x, 
                               (contentRect.size.height - iconViewSize.height) / 2 + contentRect.origin.y);
    iconViewFrame.origin = orig;
    iconView.frame = iconViewFrame;
  } else if ([_messageText length]) {
    _messageLabel.frame = contentRect;
  } else {
    // nothing to render
  }  
}

@end
