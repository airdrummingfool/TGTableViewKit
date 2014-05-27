//
//  TGTableViewCell.h
//  TGTableViewKit
//
//  Created by Tommy Goode on 5/15/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TGTableViewCell <NSObject>

@required
+ (CGSize)defaultSize;
+ (NSString *)reuseIdentifier;
- (id)init;
- (BOOL)configureForObject:(NSObject *)object inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)updateDisplay;

@end

@interface TGTableViewCell : UITableViewCell <TGTableViewCell>

@end
