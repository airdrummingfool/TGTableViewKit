//
//  TGTableViewCell.m
//  TGTableViewKit
//
//  Created by Tommy Goode on 5/15/13.
//  Copyright (c) 2014 Tommy Goode. All rights reserved.
//

#import "TGTableViewCell.h"

@implementation TGTableViewCell

+ (CGSize)defaultSize {
	return CGSizeMake(320, 44);
}

+ (NSString *)reuseIdentifier {
	return NSStringFromClass([self class]);
}

- (id)init {
	return [self initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[[self class] reuseIdentifier]];
}

- (BOOL)configureForObject:(NSObject *)object inTableView:(UITableView *)tableView atIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (void)updateDisplay {
	return;
}

- (void)prepareForReuse {
	[super prepareForReuse];
	self.imageView.image = nil;
	self.textLabel.text = @"";
	self.detailTextLabel.text = @"";
}

@end
