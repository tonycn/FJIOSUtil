//
//  DispatchingAlertView.h
//  DoubanFM_iPad
//
//  Created by Jianjun Wu on 2/17/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DispatchingAlertView : NSObject {
  UIAlertView *_alertView;
  NSMutableDictionary *_buttons;
}

+ (id)alertViewWithTitle:(NSString *)title message:(NSString *)message;

- (void)addButtonWithTitle:(NSString *)title
                    target:(id)target
                    action:(SEL)action 
            isCancelButton:(BOOL)isCancelButton;

- (void)addButtonWithTitle:(NSString *)title
                    target:(id)target
                    action:(SEL)action;

- (void)show;

@end
