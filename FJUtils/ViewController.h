//
//  ViewController.h
//  FJUtils
//
//  Created by Jianjun Wu on 2/17/12.
//  Copyright (c) 2012 Fourj. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource> {
  
  NSArray *_demos;
}

@property (retain, nonatomic) IBOutlet UITableView *tableView;

@end
