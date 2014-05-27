//
//  TGTableViewEntityDataSource.h
//  TGTableViewKit
//
//  Created by Tommy Goode on 1/30/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TGTableView.h"
#import "TGTableViewDataSource.h"

@protocol TGTableViewEntityDataSource <TGTableViewDataSource>

@property (nonatomic, strong) NSString *entityName;
@property (nonatomic, strong) NSString *sectionName;
@property (nonatomic, strong) NSString *sectionNameKeyPath;	// This takes precedence over sectionName
@property (nonatomic, readwrite) NSPredicate *predicate;
@property (nonatomic, strong) UITableViewCell<TGTableViewCell> *cellClass; // Must be registered on tableView or alloc/init-able

@property (nonatomic, readonly) NSArray *sortDescriptors;
- (void)addSortDescriptor:(NSSortDescriptor *)descriptor;

@end

@interface TGTableViewEntityDataSource : NSObject <TGTableViewEntityDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic) NSInteger sectionOffset;

- (void)performFetch;

@end
