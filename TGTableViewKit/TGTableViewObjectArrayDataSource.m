//
//  TGTableViewObjectArrayDataSource.m
//  benjamin
//
//  Created by Tommy Goode on 3/3/16.
//  Copyright © 2016 Ephecom. All rights reserved.
//

#import "TGTableViewObjectArrayDataSource.h"

@interface TGTableViewObjectArrayDataSource ()

@property (nonatomic, strong) NSArray *objects;

@end

@implementation TGTableViewObjectArrayDataSource

@synthesize tableView = _tableView;
@synthesize objects = _objects;

#pragma mark - Custom getters/setters
- (NSArray *)objects {
	if (!_objects) {
		return @[];
	}
	return _objects;
}

- (void)setObjects:(NSArray *)objects {
	_objects = objects;
	[self.tableView reloadData];
}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	if (section == 0) {
		return self.objects.count;
	}
	return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	UITableViewCell<TGTableViewCell> *cell = [tableView dequeueReusableCellWithIdentifier:[self.cellClass reuseIdentifier]];
	if (!cell) {
		// if dequeue doesn't work, it's not registered. if it's not registered, assume we can alloc/init (i.e. no nib)
		cell = [[self.cellClass alloc] init];
	}

	NSObject *object = [self.objects objectAtIndex:indexPath.row];

	if (![cell configureForObject:object inTableView:tableView atIndexPath:indexPath]) {
		// In case somehow CFO didn't work, show an error
		cell.textLabel.text = @"Error configuring cell";
	}

	return cell;
}

#pragma mark - TGTableVewDataSource methods
- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath {
	return [self.objects objectAtIndex:indexPath.row];
}

@end
