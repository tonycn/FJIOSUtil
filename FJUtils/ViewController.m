//
//  ViewController.m
//  FJUtils
//
//  Created by Jianjun Wu on 2/17/12.
//  Copyright (c) 2012 Fourj. All rights reserved.
//

#import "ViewController.h"
#import "IVarCodingDemo.h"
#import "DispatchingAlertViewDemo.h"
#import "FJProgressHUDDemo.h"

@implementation ViewController
@synthesize tableView = _tableView;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  
  self.title = @"Demos";
  
  _demos = [[NSArray arrayWithObjects:@"IVarCodingDemo", @"DispatchingAlertViewDemo", @"FJProgressHUDDemos", nil] retain];
}

- (void)viewDidUnload
{
    [self setTableView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
  return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)dealloc {
    [_tableView release];
    [super dealloc];
}

#pragma mark - UITableView Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return [_demos count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *cellIdentifier = @"Cell";
  
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
  
  if(cell == nil) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
  }
  
  cell.textLabel.text = [_demos objectAtIndex:indexPath.row];
  return cell;
}

#pragma mark - UITableView Delegate methods

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  UIViewController *demo;
  switch (indexPath.row) {
    case 0:
      demo = [[[IVarCodingDemo alloc] init] autorelease];
      [self.navigationController pushViewController:demo animated:YES];
      break;
    
    case 1:
      demo = [[[DispatchingAlertViewDemo alloc] init] autorelease];
      [self.navigationController pushViewController:demo animated:YES];
      break;
      
    case 2:
      demo = [[[FJProgressHUDDemo alloc] init] autorelease];
      [self.navigationController pushViewController:demo animated:YES];
      break;
      
    default:
      break;
  }
}
@end
