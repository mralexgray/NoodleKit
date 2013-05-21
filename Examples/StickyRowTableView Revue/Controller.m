//
//  Controller.m
//
//  Created by Paul Kim on 8/21/09.
//  Copyright 2009 Noodlesoft, LLC. All rights reserved.

#import "Controller.h"
#import "NoodleTableView.h"

@implementation Controller

- (void)awakeFromNib
{
	NSString		*fileContents;
	NSUInteger		i, count;
	NSString		*temp, *prefix, *currentPrefix;
	NSArray			*words;
	
	fileContents = [NSString stringWithContentsOfFile:@"/usr/share/dict/propernames" usedEncoding:NULL error:NULL];
	words = [fileContents componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
	
	[self willChangeValueForKey:@"names"];
	
	words = [words sortedArrayUsingSelector:@selector(caseInsensitiveCompare:)];
	_names = [[NSMutableArray alloc] init];
	
	count = [words count];
	currentPrefix = nil;
	for (i = 0; i < count; i++)
	{
		temp = [words objectAtIndex:i];
		
		if ([temp length] > 0)
		{
			prefix = [temp substringToIndex:1];
			
			if ((currentPrefix == nil) || 
				([currentPrefix caseInsensitiveCompare:prefix] != NSOrderedSame))
			{
				currentPrefix = [prefix uppercaseString];
				[_names addObject:currentPrefix];
			}
			[_names addObject:temp];
		}
	}
	NSLog(@"NAMES:  %@", _names);
	[_stickyRowTableView setShowsStickyRowHeader:YES];
	[_stickyRowTableView reloadData];
	[_iPhoneTableView reloadData];
}

- (BOOL)_isHeader:(NSInteger)rowIndex
{

	BOOL isit =  ((rowIndex == 0) ||
			[[[_names objectAtIndex:rowIndex] substringToIndex:1] caseInsensitiveCompare:[[_names objectAtIndex:rowIndex - 1] substringToIndex:1]] != NSOrderedSame);
	if (isit) NSLog(@"Its a header!  Row: %ld.  Val: %@", rowIndex, _names[rowIndex]);
	return  isit;
}

#pragma mark NSTableDataSource methods

- (NSInteger)numberOfRowsInTableView:(NSTableView *)aTableView
{
	return [_names count];
}

- (id)tableView:(NSTableView *)aTableView objectValueForTableColumn:(NSTableColumn *)aTableColumn row:(NSInteger)rowIndex
{
	return [_names objectAtIndex:rowIndex];
}

- (BOOL)tableView:(NSTableView *)tableView isGroupRow:(NSInteger)row
{
	return [self _isHeader:row];
}

@end
