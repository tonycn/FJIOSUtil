//
//  FJProgressHUD.h
//  FJUtils
//
//  Created by Jianjun Wu on 2/21/12.
//  Copyright (c) 2012 Fourj. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {

  kFJProgressHUDIconNone = 0,
  kFJProgressHUDIconCustomView,
  kFJProgressHUDIconCustomImage,
  kFJProgressHUDIconActivity,
  kFJProgressHUDIconProgress

} FJProgressHUDIconType;

typedef enum {
  
  kFJProgressHUDLayoutHorizontal,
  kFJProgressHUDLayoutVertical,
  
} FJProgressHUDLayoutType;

@class MBRoundProgressView;

@interface FJProgressHUD : UIView {
  
  FJProgressHUDIconType _iconType;
  FJProgressHUDLayoutType _layoutType;
  
  UIView *_iconCustomView;
  UIImageView *_iconImageView;
  UIActivityIndicatorView *_iconActivity;
  MBRoundProgressView *_iconProgressView;
  UIView **_currentIconViewRef;
  
  UILabel *_messageLabel;
  UIView *_maskView;

  NSString *_messageText;
  
  CGSize _iconSize;
  UIEdgeInsets _contentInsets;
}

@property (nonatomic, assign) FJProgressHUDIconType iconType;
@property (nonatomic, assign) FJProgressHUDLayoutType layoutType;

@property (nonatomic, assign) CGSize iconSize;
@property (nonatomic, assign) UIEdgeInsets contentInsets;

@property (nonatomic, copy) NSString *messageText;

+ (FJProgressHUD *)ProgressHUDWithSize:(CGSize)size;

- (void)setIconCustomView:(UIView *)view;

- (void)showHUDInView:(UIView *)view modal:(BOOL)isModal;
- (void)dismissView;
- (void)setProgress:(CGFloat)progress;

@end
