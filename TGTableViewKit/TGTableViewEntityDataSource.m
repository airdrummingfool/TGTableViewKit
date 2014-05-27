//
//  TGTableViewEntityDataSource.m
//  TGTableViewKit
//
//  Created by Tommy Goode on 1/30/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import "TGTableViewEntityDataSource.h"

@interface TGTableViewEntityDataSource ()

@property (nonatomic, strong) NSFetchedResultsController *frc;
@property (nonatomic, strong) NSArray *sortDescriptors;

- (NSIndexPath *)frcIndexPathForTableViewIndexPath:(NSIndexPath *)tableViewIndexPath;
- (NSIndexPath *)tableViewIndexPathForFRCIndexPath:(NSIndexPath *)frcIndexPath;
- (NSInteger)frcSectionForTableViewSection:(NSInteger)tableViewSection;
- (NSInteger)tableViewSectionForFRCSection:(NSInteger)frcSection;

@end

@implementation TGTableViewEntityDataSource

@synthesize sortDescriptors = _sortDescriptors;

// Synthesize protocol properties
@synthesize tableView = _tableView;
@synthesize entityName = _entityName;
@synthesize sectionName = _sectionName;
@synthesize sectionNameKeyPath = _sectionNameKeyPath;
@synthesize cellClass = _cellClass;

#pragma mark Custom getters/setters
- (NSFetchedResultsController *)frc {
	if (!_frc) {
		NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:self.entityName];
		if (!self.sortDescriptors.count) {
			FDebug(@"Error: Cannot create fetch results controller for %@ without a sort descriptor.", self.entityName);
			return nil;
		}
		fetchRequest.sortDescriptors = self.sortDescriptors;
		NSFetchedResultsController *frc = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:NSManagedObjectContext.defaultContext sectionNameKeyPath:self.sectionNameKeyPath cacheName:nil];
		frc.delegate = self;
		[frc performFetch:nil];
		_frc = frc;
	}
	return _frc;
}

- (NSPredicate *)predicate {
	if (_frc) {
		return self.frc.fetchRequest.predicate;
	}
	return nil;
}

- (NSArray *)sortDescriptors {
	if (!_sortDescriptors) {
		_sortDescriptors = [[NSArray alloc] init];
	}
	return _sortDescriptors;
}

- (void)setPredicate:(NSPredicate *)predicate {
	self.frc.fetchRequest.predicate = predicate;
	[self performFetch];
}

- (void)setSectionNameKeyPath:(NSString *)sectionNameKeyPath {
	_sectionNameKeyPath = sectionNameKeyPath;
	if (_frc) {
		self.frc = nil;
	}
}

- (void)setSortDescriptors:(NSArray *)sortDescriptors {
	_sortDescriptors = sortDescriptors;
	if (_frc) {
		self.frc.fetchRequest.sortDescriptors = _sortDescriptors;
	}
}

#pragma mark - Object access
- (id)tableView:(UITableView *)tableView objectAtIndexPath:(NSIndexPath *)indexPath {
	indexPath = [self frcIndexPathForTableViewIndexPath:indexPath];
	return [self.frc objectAtIndexPath:indexPath];
}

- (void)performFetch {
	FDebug(@"performing fetch and reloading data");
	[self.frc performFetch:nil];
	[self.tableView reloadData];
}


#pragma mark - UITableVewDataSource methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return self.frc.sections.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	section = [self frcSectionForTableViewSection:section];
	if (self.sectionNameKeyPath.length) {
		NSObject *object = [self.frc objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]];
		return [object valueForKeyPath:self.sectionNameKeyPath];
	}
	return self.sectionName;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	section = [self frcSectionForTableViewSection:section];
	id <NSFetchedResultsSectionInfo> sectionInfo = [[self.frc sections] objectAtIndex:section];
	return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	indexPath = [self frcIndexPathForTableViewIndexPath:indexPath];

	UITableViewCell<TGTableViewCell> *cell = [tableView dequeueReusableCellWithIdentifier:[[self.cellClass class] reuseIdentifier]];
	if (!cell) {
		// if dequeue doesn't work, it's not registered. if it's not registered, assume we can alloc/init (AKA no nib)
		cell = [[[self.cellClass class] alloc] init];
	}

	NSObject *object = nil;

	// We try/catch this because of a crash that happens during a search when the non-search tableView tries to update its content after the predicate has changed
	// @TODO: maybe use a separate data source for the search view controller :p
	@try {
		object = [self.frc objectAtIndexPath:indexPath];
	}
	@catch (NSException *exception) {
		FDebug(@"FRC: Error: %@", exception);
	}

	if (![cell configureForObject:object inTableView:tableView atIndexPath:indexPath]) {
		// In case somehow CFO didn't work, show an error
		cell.textLabel.text = @"Error configuring cell";
	}

	return cell;
}

#pragma mark - FUITableVewDataSource methods
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return [[self.cellClass class] defaultSize].height;
}

#pragma mark - NSFetchedResultsController stuff
// Cool stuff from http://developer.apple.com/library/ios/#documentation/CoreData/Reference/NSFetchedResultsControllerDelegate_Protocol/Reference/Reference.html#//apple_ref/occ/intf/NSFetchedResultsControllerDelegate
- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo atIndex:(NSUInteger)sectionIndex forChangeType:(NSFetchedResultsChangeType)type {
	sectionIndex = [self tableViewSectionForFRCSection:sectionIndex];
	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath {
	indexPath = [self tableViewIndexPathForFRCIndexPath:indexPath];
	newIndexPath = [self tableViewIndexPathForFRCIndexPath:newIndexPath];

	switch(type) {
		case NSFetchedResultsChangeInsert:
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeDelete:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
		case NSFetchedResultsChangeUpdate:
			[(UITableViewCell<TGTableViewCell> *)[self.tableView cellForRowAtIndexPath:indexPath] updateDisplay];
			break;
		case NSFetchedResultsChangeMove:
			[self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
			[self.tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
			break;
	}
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
	[self.tableView endUpdates];
}

#pragma mark Private helper methods
- (NSIndexPath *)frcIndexPathForTableViewIndexPath:(NSIndexPath *)tableViewIndexPath {
	return [NSIndexPath indexPathForRow:tableViewIndexPath.row inSection:[self frcSectionForTableViewSection:tableViewIndexPath.section]];
}

- (NSIndexPath *)tableViewIndexPathForFRCIndexPath:(NSIndexPath *)frcIndexPath {
	return [NSIndexPath indexPathForRow:frcIndexPath.row inSection:[self tableViewSectionForFRCSection:frcIndexPath.section]];
}

- (NSInteger)frcSectionForTableViewSection:(NSInteger)tableViewSection {
	NSInteger frcSection = tableViewSection - self.sectionOffset;
	return frcSection;
}

- (NSInteger)tableViewSectionForFRCSection:(NSInteger)frcSection {
	NSInteger tableViewSection = frcSection + self.sectionOffset;
	return tableViewSection;
}

- (void)dealloc {
	FDebug(@"DEALLOC: %@ (%@)", NSStringFromClass([self class]), self.entityName);
	//Set the delegate to nil so that the fetch results controller doesn't try sending messages to a de-allocated tableview
	_frc.delegate = nil;
	_frc = nil;
	_tableView = nil;
}

- (void)addSortDescriptor:(NSSortDescriptor *)descriptor {
	self.sortDescriptors = [self.sortDescriptors arrayByAddingObject:descriptor];
}

@end
