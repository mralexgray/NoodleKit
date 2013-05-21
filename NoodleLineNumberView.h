//
//  NoodleLineNumberView.h
//  NoodleKit
//
//  Created by Paul Kim on 9/28/08.
//  Copyright (c) 2008-2012 Noodlesoft, LLC. All rights reserved.

#import <Cocoa/Cocoa.h>

/*
 Displays line numbers for an NSTextView.
 
 For more details, see the related blog post at:  http://www.noodlesoft.com/blog/2008/10/05/displaying-line-numbers-with-nstextview/
 */

@class NoodleLineNumberMarker;

@interface NoodleLineNumberView : NSRulerView
{
    // Array of character indices for the beginning of each line
    NSMutableArray      *_lineIndices;
    // When text is edited, this is the start of the editing region. All line calculations after this point are invalid
    // and need to be recalculated.
    NSUInteger          _invalidCharacterIndex;
    
	// Maps line numbers to markers
	NSMutableDictionary	*_linesToMarkers;
    
	NSFont              *_font;
	NSColor				*_textColor;
	NSColor				*_alternateTextColor;
	NSColor				*_backgroundColor;
}

@property (readwrite, retain) NSFont    *font;
@property (readwrite, retain) NSColor   *textColor;
@property (readwrite, retain) NSColor   *alternateTextColor;
@property (readwrite, retain) NSColor   *backgroundColor;

- (id)initWithScrollView:(NSScrollView *)aScrollView;

- (NSUInteger)lineNumberForLocation:(CGFloat)location;
- (NoodleLineNumberMarker *)markerAtLine:(NSUInteger)line;

@end
