//
// Code from : http://marc-abramowitz.com/archives/2010/06/09/the-quest-for-a-better-uialertview/
// Thanks to Marc
// http://marc-abramowitz.com
//

#import "DispatchingAlertView.h"

@implementation DispatchingAlertView

- (id)initWithTitle:(NSString *)title message:(NSString *)message
{
  if (self = [super init]) 
  {      
    _buttons = [[NSMutableDictionary alloc] init];
    _alertView = [[UIAlertView alloc] initWithTitle:title 
                                            message:message 
                                           delegate:self 
                                  cancelButtonTitle:nil 
                                  otherButtonTitles:nil];
  }
  
  return self;
}


- (void)dealloc
{
  [_buttons release];
  [_alertView release];
  [super dealloc];
}


+ (id)alertViewWithTitle:(NSString *)title message:(NSString *)message
/* All this does is call the constructor, but the reason to have this method 
 is that it looks like a factory method and so the caller doesn't think 
 that they need to release the object they get. */
{
  return [[DispatchingAlertView alloc] initWithTitle:title message:message];
}


- (void)addButtonWithTitle:(NSString *)title
                    target:(id)target
                    action:(SEL)action 
            isCancelButton:(BOOL)isCancelButton
{
  NSInteger buttonIndex = [_alertView addButtonWithTitle:title];
  
  if (isCancelButton)
  {
    [_alertView setCancelButtonIndex:buttonIndex];
  }
  
  [_buttons setObject:[NSDictionary dictionaryWithObjectsAndKeys:
                       target, @"target",
                       [NSValue valueWithPointer:action], @"action", nil]
               forKey:[NSNumber numberWithInteger:buttonIndex]];
}

- (void)addButtonWithTitle:(NSString *)title
                    target:(id)target
                    action:(SEL)action {
  [self addButtonWithTitle:title target:target action:action isCancelButton:NO];
}

- (void)show
{
  [_alertView show];
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex 
{
  NSDictionary *buttonProperties = [_buttons objectForKey:[NSNumber numberWithInteger:buttonIndex]];
  id target = [buttonProperties objectForKey:@"target"];
  SEL action = [[buttonProperties objectForKey:@"action"] pointerValue];
  
  [target performSelector:action];
  
  [self autorelease];
}

@end
