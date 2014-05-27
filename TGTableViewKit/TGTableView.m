//
//  TGTableView.m
//  TGTableViewKit
//
//  Created by Tommy Goode on 5/15/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import "TGTableView.h"

@implementation TGTableView

// @TODO: create <TGTableViewDelegate> that calls emptyViewForTableView:
- (void)setEmptyView:(UIView *)emptyView {
	if (_emptyView == emptyView) {
		return;
	}
	[_emptyView removeFromSuperview];
	_emptyView = emptyView;
	_emptyView.hidden = YES;
	_emptyView.alpha = 0;
	[self addSubview:_emptyView];
	[self setNeedsLayout];
}

- (BOOL)isEmpty {
	return self.visibleCells.count == 0;
}

- (void)layoutSubviews {
	[super layoutSubviews];
	if (self.isEmpty) {
		if (self.emptyView.hidden) {
			self.emptyView.hidden = NO;
			[UIView animateWithDuration:0.5 animations:^{
				self.emptyView.alpha = 1;
			}];
		}
	}
	else {
		self.emptyView.hidden = YES;
		self.emptyView.alpha = 0;
	}
}

- (void)dealloc {
	[_emptyView removeFromSuperview];
	_emptyView = nil;
	self.delegate = nil;
}

@end
