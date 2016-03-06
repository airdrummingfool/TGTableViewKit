//
//  TGTableView.h
//  TGTableViewKit
//
//  Created by Tommy Goode on 5/15/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TGTableViewDataSource.h"
#import "TGTableViewCell.h"
#import "TGTableViewClearCell.h"

@interface TGTableView : UITableView

@property (nonatomic, weak) NSObject<TGTableViewDataSource> *dataSource;

@property (nonatomic) BOOL hidesExcessiveSeparators;
@property (nonatomic, readonly) BOOL isEmpty;
@property (nonatomic, strong) UIView *emptyView;

@end
