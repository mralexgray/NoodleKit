//
//  NoodleLineNumberView.h
//  NoodleKit
//
//  Created by Paul Kim on 9/28/08.
//  Copyright (c) 2008-2012 Noodlesoft, LLC. All rights reserved.

#import <Cocoa/Cocoa.h>

/*! @abstract Displays line numbers for an NSTextView.
 *  For more details, see the related blog post at:  http://www.noodlesoft.com/blog/2008/10/05/displaying-line-numbers-with-nstextview/
 */

@class NoodleLineNumberMarker; @interface NoodleLineNumberView : NSRulerView 

@property (strong) NSFont    *font;
@property (strong) NSColor   *textColor, *alternateTextColor, *backgroundColor, *markerColor;

- (id)initWithScrollView:(NSScrollView*)aScrollView;

- (NSUInteger)    lineNumberForLocation:(CGFloat)location;
- (NoodleLineNumberMarker*)markerAtLine:(NSUInteger)line;

@end
