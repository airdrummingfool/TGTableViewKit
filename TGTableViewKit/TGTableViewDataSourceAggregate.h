//
//  TGTableViewDataSourceAggregate.h
//  TGTableViewKit
//
//  Created by Tommy Goode on 5/22/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGTableViewDataSource.h"

@interface TGTableViewDataSourceAggregate : NSObject <TGTableViewDataSource>

- (void)addDataSource:(NSObject<TGTableViewDataSource> *)dataSource;
- (void)removeDataSource:(NSObject<TGTableViewDataSource> *)dataSource;

- (NSObject<TGTableViewDataSource> *)dataSourceForSection:(NSInteger)section;

@end
