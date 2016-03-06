//
//  TGTableViewClearCell.m
//  TGTableViewKit
//
//  Created by Tommy Goode on 3/5/16.
//  Copyright © 2016 Tommy Goode. All rights reserved.
//

#import "TGTableViewClearCell.h"

@implementation TGTableViewClearCell

#pragma mark - Lifecycle
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
	if (!(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])) return nil;

	self.contentView.opaque = NO;
	self.contentView.backgroundColor = [UIColor clearColor];
	self.backgroundColor = [UIColor clearColor];
	self.backgroundView = [UIView new];	// To remove border/background
	self.selectionStyle = UITableViewCellSelectionStyleNone;

	return self;
}

@end
