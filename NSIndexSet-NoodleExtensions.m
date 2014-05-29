//
//  NSIndexSet-NoodleExtensions.m
//  NoodleRowSpanningTableViewTest
//
//  Created by Paul Kim on 10/20/09.
//  Copyright 2009 Noodlesoft, LLC. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person
// obtaining a copy of this software and associated documentation
// files (the "Software"), to deal in the Software without
// restriction, including without limitation the rights to use,
// copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following
// conditions:
// 
// The above copyright notice and this permission notice shall be
// included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
// EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES
// OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
// NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT
// HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
// WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
// OTHER DEALINGS IN THE SOFTWARE.

#import "NSIndexSet-NoodleExtensions.h"

@implementation NoodleIndexSetEnumerator

+ enumeratorWithIndexSet:(NSIndexSet*)set { return [[self.new initWithIndexSet:set]autorelease]; }

- initWithIndexSet:(NSIndexSet*)set { if (!(self = super.init)) return nil;

  _currentIndex = 0; _count = set.count;
  [set getIndexes:_indexes = (NSUInteger*)malloc(sizeof(NSUInteger)*_count) maxCount:_count inIndexRange:nil];
	return self;
}

- (void)  dealloc {	free(_indexes);	_indexes = NULL;	[super dealloc]; }

- (void) finalize {	free(_indexes);	[super finalize]; }

- (NSUInteger) nextIndex {

	if (_currentIndex >= _count) return NSNotFound;

	NSUInteger i = _indexes[_currentIndex];
  _currentIndex++;
	return i;
}

@end

@implementation NSIndexSet (NoodleExtensions)

- (NoodleIndexSetEnumerator *)indexEnumerator
{
	return [NoodleIndexSetEnumerator enumeratorWithIndexSet:self];
}

@end



