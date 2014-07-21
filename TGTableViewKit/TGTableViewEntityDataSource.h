//
//  TGTableViewEntityDataSource.h
//  TGTableViewKit
//
//  Created by Tommy Goode on 1/30/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "TGTableView.h"
#import "TGTableViewDataSource.h"


@protocol TGTableViewEntityDataSource <TGTableViewDataSource>

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *sectionName;
/// This takes precedence over sectionName
@property (nonatomic, strong) NSString *sectionNameKeyPath;
@property (nonatomic, readwrite) NSPredicate *predicate;
/// Must be registered on the tableView or alloc/init-able
@property (nonatomic) Class<TGTableViewCell> cellClass;

@property (nonatomic, readonly) NSArray *sortDescriptors;
- (void)addSortDescriptor:(NSSortDescriptor *)descriptor;

- (instancetype)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end

@interface TGTableViewEntityDataSource : NSObject <TGTableViewEntityDataSource, NSFetchedResultsControllerDelegate>

- (void)performFetch;

@end
