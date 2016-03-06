//
//  TGTableViewObjectArrayDataSource.h
//  TGTableViewKit
//
//  Created by Tommy Goode on 3/3/16.
//  Copyright © 2016 Tommy Goode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGTableView.h"

@interface TGTableViewObjectArrayDataSource : NSObject <TGTableViewDataSource>

/// Must be registered on the tableView or alloc/init-able
@property (nonatomic) Class<TGTableViewCell> cellClass;

- (void)setObjects:(NSArray *)objects;

@end
