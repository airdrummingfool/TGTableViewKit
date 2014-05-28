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
/// This is here so we can use a class pointer later
+ (id)alloc;
+ (CGFloat)defaultHeight;
+ (NSString *)reuseIdentifier;
- (instancetype)init;
- (BOOL)configureForObject:(NSObject *)object inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath;
- (void)updateDisplay;

@end

@interface TGTableViewCell : UITableViewCell <TGTableViewCell>

@end
