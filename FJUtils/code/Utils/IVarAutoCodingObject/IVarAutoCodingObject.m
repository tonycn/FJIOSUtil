//
//  PropertyAutoCodingObject.m
//  DoubanRadioCore
//
//  Created by Jianjun Wu on 2/16/12.
//  Copyright (c) 2012 Douban Inc. All rights reserved.
//

#import "IVarAutoCodingObject.h"
#import <objc/runtime.h>

@implementation IVarAutoCodingObject


- (void)setObjectValueForIVar:(Ivar)ivar forObject:(id)obj withCoder:(NSCoder *)coder{
  
  NSString *ivarNameStr = [NSString stringWithCString:ivar_getName(ivar) encoding:NSASCIIStringEncoding];
  
  const char* ivarTypeEncoding = ivar_getTypeEncoding(ivar);
  
  id value = [coder decodeObjectForKey:ivarNameStr];
  if (value == nil) {
    return;
  }
  
  if (strcmp(ivarTypeEncoding, "i") == 0) {
    
    object_setIvar(self, ivar,(id)[value intValue]);
  } else if (strcmp(ivarTypeEncoding, "f") == 0) {
    float v = [value floatValue];
    *(float *)((char *)self + ivar_getOffset(ivar)) = v;
  } else if (strcmp(ivarTypeEncoding, "d") == 0) {
    double v = [value doubleValue];
    *(double *)((char *)self + ivar_getOffset(ivar)) = v;
  } else {
    
    object_setIvar(self, ivar,value);
  }
}

- (id)initWithCoder:(NSCoder *)coder {
  
  self = [super init];
  if( self != nil )
  {
    Class clazz = [self class];
    while (clazz) {
      if (clazz == [NSObject class]) {
        break;
      }
      u_int count;
      Ivar* ivars = class_copyIvarList(clazz, &count);
      for (int i = 0; i < count ; i++) {
        [self setObjectValueForIVar:ivars[i] forObject:self withCoder:coder];
      }
      free(ivars);
      clazz = [clazz superclass];
    }
  }
  
  return self;
}

- (id)getObjectValueFromIVar:(Ivar)ivar {
  
  id value = object_getIvar(self,ivar);
  if (value == nil) {
    return nil;
  }
  
  const char* ivarTypeEncoding = ivar_getTypeEncoding(ivar);
  if (strcmp(ivarTypeEncoding, "i") == 0) {
    int i = (int)value;
    return [NSNumber numberWithInt:i];
  } if (strcmp(ivarTypeEncoding, "f") == 0) {
    float f = *(float *)((char *)self + ivar_getOffset(ivar));
    return [NSNumber numberWithFloat:f];
  } if (strcmp(ivarTypeEncoding, "d") == 0) {
    double d = *(double *)((char *)self + ivar_getOffset(ivar));
    return [NSNumber numberWithDouble:d];
  } else {
    return value;
  }
}

- (void)encodeWithCoder:(NSCoder *)coder {
  
  self = [super init];
  if( self != nil ) {
    
    Class clazz = [self class];
    while (clazz) {
      if (clazz == [NSObject class]) {
        break;
      }
      u_int count;
      Ivar* ivars = class_copyIvarList(clazz, &count);
      for (int i = 0; i < count ; i++)
      {
        NSString *ivarNameStr = [NSString stringWithCString:ivar_getName(ivars[i]) encoding:NSASCIIStringEncoding];
        
        [coder encodeObject:[self getObjectValueFromIVar:ivars[i]]
                     forKey:ivarNameStr];
        
      }
      free(ivars);
      clazz = [clazz superclass];
    }
  }
}

@end
