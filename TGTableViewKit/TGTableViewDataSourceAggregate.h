//
//  TGTableViewDataSourceAggregate.h
//  TGTableViewKit
//
//  Created by Tommy Goode on 5/22/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGTableViewEntityDataSource.h"

@interface TGTableViewDataSourceAggregate : NSObject <TGTableViewDataSource>

- (void)addDataSource:(TGTableViewEntityDataSource *)dataSource;
- (void)removeDataSource:(TGTableViewEntityDataSource *)dataSource;

- (TGTableViewEntityDataSource *)dataSourceForSection:(NSInteger)section;

@end
