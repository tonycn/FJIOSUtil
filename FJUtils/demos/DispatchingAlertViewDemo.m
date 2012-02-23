//
//  DispatchingAlertViewDemo.m
//  FJUtils
//
//  Created by Jianjun Wu on 2/17/12.
//  Copyright (c) 2012 Fourj. All rights reserved.
// Thanks to Marc
// http://marc-abramowitz.com/archives/2010/06/09/the-quest-for-a-better-uialertview/

#import "DispatchingAlertViewDemo.h"
#import "DispatchingAlertView.h"

@implementation DispatchingAlertViewDemo
@synthesize label;

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
  [self setLabel:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
	return YES;
}

- (void)viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  DispatchingAlertView *alertView = [DispatchingAlertView alertViewWithTitle:@"No words left" message:@""];
  [alertView addButtonWithTitle:@"Previous game info" target:self action:@selector(previousGameInfo)];
  [alertView addButtonWithTitle:@"Report bug" target:self action:@selector(reportBug)];
  [alertView addButtonWithTitle:@"New game" target:self action:@selector(newGame) isCancelButton:YES];
  [alertView show];
}

- (void)previousGameInfo {
  
  self.label.text = @"previousGameInfo";
}

- (void)reportBug {
  
  self.label.text = @"reportBug";
}

- (void)newGame {
  
  self.label.text = @"newGame";
}

- (void)dealloc {
  [label release];
  [super dealloc];
}
@end
