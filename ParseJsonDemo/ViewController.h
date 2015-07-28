//
//  ViewController.h
//  ParseJsonDemo
//
//  Created by deveplopper on 15/7/21.
//  Copyright (c) 2015年 deveplopper. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (strong, nonatomic) UITableView *myTableView;
@property (strong, nonatomic) NSArray *movieList;

@end

