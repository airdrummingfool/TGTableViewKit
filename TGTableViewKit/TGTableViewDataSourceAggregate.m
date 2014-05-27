//
//  TGTableViewDataSourceAggregate.m
//  TGTableViewKit
//
//  Created by Tommy Goode on 5/22/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import "TGTableViewDataSourceAggregate.h"

@interface TGTableViewDataSourceAggregate ()

@property (nonatomic, strong) NSMutableArray *dataSources;

@end

@implementation TGTableViewDataSourceAggregate

@synthesize tableView = _tableView;

#pragma mark - Custom getters/setters
- (NSMutableArray *)dataSources {
	if (!_dataSources) {
		_dataSources = [[NSMutableArray alloc] initWithCapacity:2];
	}
	return _dataSources;
}

- (void)setTableView:(UITableView *)tableView {
	_tableView = tableView;
	for (TGTableViewEntityDataSource *ds in self.dataSources) {
		ds.tableView = _tableView;
	}
}

- (void)addDataSource:(TGTableViewEntityDataSource *)dataSource {
	[self.dataSources addObject:dataSource];
	[self.tableView reloadData];
}

- (void)removeDataSource:(TGTableViewEntityDataSource *)dataSource {
	[self.dataSources removeObject:dataSource];
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger numberOfSections = 0;
	for (TGTableViewEntityDataSource *dataSource in self.dataSources) {
		if ([dataSource respondsToSelector:@selector(setSectionOffset:)]) {
			[dataSource setSectionOffset:numberOfSections];
		}
		numberOfSections += [dataSource numberOfSectionsInTableView:self.tableView];
	}
	return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	return [[self dataSourceForSection:section] tableView:tableView titleForHeaderInSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [[self dataSourceForSection:section] tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self dataSourceForSection:indexPath.section] tableView:tableView cellForRowAtIndexPath:indexPath];
}

#pragma mark - FUITableViewDataSource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[[self dataSourceForSection:indexPath.section].cellClass class] defaultSize].height;
}

- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath {
	return [[self dataSourceForSection:indexPath.section] tableView:tableView objectAtIndexPath:indexPath];
}

#pragma mark - Private helper methods
- (TGTableViewEntityDataSource *)dataSourceForSection:(NSInteger)section {
	for (TGTableViewEntityDataSource *dataSource in self.dataSources) {
		section -= [dataSource numberOfSectionsInTableView:self.tableView];
		if (section < 0) {
			return dataSource;
		}
	}
	return nil;
}

@end
