# TGTableViewKit

## Intro

I wrote TGTableViewKit while developing a few apps that were largely table view based. I needed a coherent, standard way to use table view cells, almost exclusively to represent one model object each. I did a lot of reading on how other people did it, and put a few of them together to come up with the 'CFO' method that I use in all my apps.

## Caveats

This developed over the course of a few apps that I have written, from my very first to some of my most recent, and therefore ties into my habits. Most notably, this may not work if your table view cell is defined in a nib or storyboard; I build all of my views in code.

Although this library `#import`s Core Data, it isn't an actual dependency and will work even if your app is not linked to the Core Data framework.

## Basic Usage

`import #TGTableViewCell.h`

Subclass `TGTableViewCell` and override the following methods:

- `+defaultHeight`: return the height you want the cell to be
- `configureForObject:inTableView:atIndexPath:`: Here you receive the model object to be represented by the cell. Normally I save a reference to it in a property and call `updateDisplay`. If your CFO method cannot handle the class of object passed in, return `NO` (otherwise return `YES`).
- `updateDisplay`: Read the model object and update views that depend on it.
- `layoutSubviews`: ...layout ...the subviews.

In your table view data source, do something like this (Note: this is provided in `TGTableViewEntityDataSource`, useful if you work with Core Data and `FetchedResultsController`s):

	UITableViewCell<TGTableViewCell> *cell = [tableView dequeueReusableCellWithIdentifier:[self.cellClass reuseIdentifier]];
	if (!cell) {
		// if dequeue doesn't work, it's not registered. if it's not registered, assume we can alloc/init (i.e. no nib)
		cell = [[self.cellClass alloc] init];
	}

	NSObject *object = [self objectAtIndexPath:indexPath];

	if (![cell configureForObject:object inTableView:tableView atIndexPath:indexPath]) {
		// In case somehow CFO didn't work, show an error
		cell.textLabel.text = @"Error configuring cell";
	}

	return cell;


## Advantages

- Structured way to use table view cells to display model data

- Super easy to swap out table cell classes

- Data source aggregate allows multiple `UITableViewDataSource`s to be used in one table view

- The `FetchedResultsController`-backed table view data source makes simple Core Data object lists a snap!

- Custom table view implementation (`TGTableView`) that includes extra features such as:
	- A view to show when the table is empty (`emptyView`)
	- `BOOL` to hide extra separators (`hidesExcessiveSeparators`)


