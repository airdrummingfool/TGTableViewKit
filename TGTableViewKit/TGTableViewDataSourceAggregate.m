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
/// Data source offsets are stored keyed to the index of the dataSource in the dataSources array.
@property (nonatomic, strong) NSMutableDictionary *dataSourceOffsets;

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

- (NSMutableDictionary *)dataSourceOffsets {
	if (!_dataSourceOffsets) {
		_dataSourceOffsets = [[NSMutableDictionary alloc] initWithCapacity:2];
	}
	return _dataSourceOffsets;
}

- (void)setTableView:(UITableView *)tableView {
	_tableView = tableView;
	for (NSObject<TGTableViewDataSource> *ds in self.dataSources) {
		ds.tableView = tableView;
	}
}

- (void)addDataSource:(NSObject<TGTableViewDataSource> *)dataSource {
	NSAssert(![self.dataSources containsObject:dataSource], @"Error: Cannot add the same data source twice.");
	dataSource.tableView = self.tableView;
	[self.dataSources addObject:dataSource];
	NSNumber *indexOfNewDataSource = [NSNumber numberWithInteger:([self.dataSources count] -1)];
	[self.dataSourceOffsets setObject:@0 forKey:indexOfNewDataSource];
	[self.tableView reloadData];
}

- (void)removeDataSource:(NSObject<TGTableViewDataSource> *)dataSource {
	NSAssert([self.dataSources containsObject:dataSource], @"Error: Cannot remove a data source that doesn't exist.");
	NSNumber *indexOfDataSourceToRemove = [NSNumber numberWithInteger:[self.dataSources indexOfObject:dataSource]];
	[self.dataSources removeObjectAtIndex:[indexOfDataSourceToRemove integerValue]];
	[self.dataSourceOffsets removeObjectForKey:indexOfDataSourceToRemove];
	[self.tableView reloadData];
}

#pragma mark - UITableViewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSInteger numberOfSections = 0;
	NSInteger index = 0;
	for (NSObject<TGTableViewDataSource> *dataSource in self.dataSources) {
		[self.dataSourceOffsets setObject:[NSNumber numberWithInteger:numberOfSections] forKey:[NSNumber numberWithInteger:index]];
		numberOfSections += [dataSource numberOfSectionsInTableView:self.tableView];
		index++;
	}
	return numberOfSections;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	NSObject<TGTableViewDataSource> *ds = [self dataSourceForSection:section];
	NSInteger adjustedSection = [self adjustSection:section forDataSource:ds];
	return [ds tableView:tableView titleForHeaderInSection:adjustedSection];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSObject<TGTableViewDataSource> *ds = [self dataSourceForSection:section];
	NSInteger adjustedSection = [self adjustSection:section forDataSource:ds];
	return [ds tableView:tableView numberOfRowsInSection:adjustedSection];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject<TGTableViewDataSource> *ds = [self dataSourceForSection:indexPath.section];
	NSIndexPath *adjustedIndexPath = [self adjustIndexPath:indexPath forDataSource:ds];
	return [ds tableView:tableView cellForRowAtIndexPath:adjustedIndexPath];
}

#pragma mark - TGTableViewDataSource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	NSObject<TGTableViewDataSource> *ds = [self dataSourceForSection:indexPath.section];
	NSIndexPath *adjustedIndexPath = [self adjustIndexPath:indexPath forDataSource:ds];
	return [ds tableView:tableView heightForRowAtIndexPath:adjustedIndexPath];
}

- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath {
	NSObject<TGTableViewDataSource> *ds = [self dataSourceForSection:indexPath.section];
	NSIndexPath *adjustedIndexPath = [self adjustIndexPath:indexPath forDataSource:ds];
	return [ds tableView:tableView objectAtIndexPath:adjustedIndexPath];
}

#pragma mark - Private helper methods
- (NSObject<TGTableViewDataSource> *)dataSourceForSection:(NSInteger)section {
	for (NSObject<TGTableViewDataSource> *dataSource in self.dataSources) {
		section -= [dataSource numberOfSectionsInTableView:self.tableView];
		if (section < 0) {
			return dataSource;
		}
	}
	return nil;
}

- (NSIndexPath *)adjustIndexPath:(NSIndexPath *)indexPath forDataSource:(NSObject<TGTableViewDataSource> *)dataSource {
	NSInteger adjustedSection = [self adjustSection:indexPath.section forDataSource:dataSource];
	return [NSIndexPath indexPathForRow:indexPath.row inSection:adjustedSection];
}

- (NSInteger)adjustSection:(NSInteger)section forDataSource:(NSObject<TGTableViewDataSource> *)dataSource {
	NSNumber *indexOfDS = [NSNumber numberWithInteger:[self.dataSources indexOfObject:dataSource]];
	NSInteger dsSectionOffset = [[self.dataSourceOffsets objectForKey:indexOfDS] integerValue];
	NSInteger adjustedSection = section - dsSectionOffset;
	return adjustedSection;
}

@end
