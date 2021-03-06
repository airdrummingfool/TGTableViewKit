//
//  TGTableViewDataSource.h
//  TGTableViewKit
//
//  Created by Tommy Goode on 5/23/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TGTableViewDataSource <UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@optional
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@required
- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath;

@end
