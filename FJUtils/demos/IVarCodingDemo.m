//
//  IVarCodingDemo.m
//  FJUtils
//
//  Created by Jianjun Wu on 2/17/12.
//  Copyright (c) 2012 Fourj. All rights reserved.
//

#import "IVarCodingDemo.h"
#import "IVarAutoCodingObject.h"

@interface Test1 : IVarAutoCodingObject {
  
  NSNumber *_age;
  
}

@property (nonatomic, retain)   NSNumber *age;

@end

@implementation Test1

@synthesize age = _age;

@end


@interface Test2 : Test1 {
  
  NSInteger _age1;
  CGFloat _weight;
  NSTimeInterval _expires;
  
}

@property (nonatomic)   NSInteger age1;
@property (nonatomic)   CGFloat weight;
@property (nonatomic)   NSTimeInterval expires;

@end

@implementation Test2

@synthesize age1 = _age1;
@synthesize weight = _weight;
@synthesize expires = _expires;

@end

@implementation IVarCodingDemo

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

/*
// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
*/
- (void)sample1 {
  Test1 *t1 = [[Test1 alloc] init];
  t1.age = [NSNumber numberWithInt:10];
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:t1];
    
  id unarchive = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  NSLog(@"unarchive: %@", unarchive);
}


- (void)sample2 {
  Test2 *t2 = [[Test2 alloc] init];
  t2.age = [NSNumber numberWithInt:10];
  t2.age1 = 12;
  t2.weight = 108.1;
  t2.expires = [[NSDate date] timeIntervalSince1970];
  NSData *data = [NSKeyedArchiver archivedDataWithRootObject:t2];
  
  NSLog(@"archive: t2%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
  
  id unarchive = [NSKeyedUnarchiver unarchiveObjectWithData:data];
  NSLog(@"unarchive t2: %@", [(Test2 *)unarchive age]);
  NSLog(@"unarchive t2: %d", [(Test2 *)unarchive age1]);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
  
  [self sample1];
  [self sample2];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
