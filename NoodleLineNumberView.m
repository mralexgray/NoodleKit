
//  NoodleLineNumberView.m  NoodleKit
//  Created by Paul Kim on 9/28/08.  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
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
//

#import "NoodleLineNumberView.h"
#import "NoodleLineNumberMarker.h"
#import <tgmath.h>

#define DEFAULT_THICKNESS	22.
#define      RULER_MARGIN 5.

@implementation NoodleLineNumberView
{

       NSMutableArray * _lineIndices; /*! Array of character indices for the beginning of each line */

/*! When text is edited, this is the start of the editing region.
    All line calculations after this point are invalid and need to be recalculated.
 */
           NSUInteger   _invalidCharacterIndex;

	NSMutableDictionary	* _linesToMarkers; /*! Maps line numbers to markers */
}

#pragma mark - Lifecycle 

-   (id) initWithScrollView:(NSScrollView*)s {

  return self = [super initWithScrollView:s orientation:NSVerticalRuler] ?
  _lineIndices    = NSMutableArray.new,
	_linesToMarkers = NSMutableDictionary.new,
  self.clientView = s.documentView,
  self : nil;
}
- (void) awakeFromNib {
  _lineIndices = NSMutableArray.new;
	_linesToMarkers = [[NSMutableDictionary alloc] init];
	[self setClientView:[[self scrollView] documentView]];
}
- (void) dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];

  [_lineIndices release];
	[_linesToMarkers release];
  [_font release];
  [_textColor release];
  [_alternateTextColor release];
  [_backgroundColor release];

  [super dealloc];
}

- (void) setClientView:(NSView*) aView  {

  if ((self.clientView != aView) && [self.clientView isKindOfClass:NSTextView.class])
		[NSNotificationCenter.defaultCenter removeObserver:self name:NSTextStorageDidProcessEditingNotification object:[(id)[self clientView] textStorage]];
  [super setClientView:aView];
  if ((aView != nil) && [aView isKindOfClass:[NSTextView class]])
  {
		[NSNotificationCenter.defaultCenter addObserver:self selector:@selector(textStorageDidProcessEditing:) name:NSTextStorageDidProcessEditingNotification object:[(NSTextView*) aView textStorage]];
		[self invalidateLineIndicesFromCharacterIndex:0];
  }
}
- (NSFont*)                defaultFont  { return [NSFont labelFontOfSize:[NSFont systemFontSizeForControlSize:NSMiniControlSize]]; }
- (NSColor*)          defaultTextColor  { return [NSColor colorWithCalibratedWhite:.42 alpha:1.]; }
- (NSColor*) defaultAlternateTextColor  { return NSColor.whiteColor; }

#pragma mark - Line Numbers

// Forces recalculation of line indicies starting from the given index
- (void) invalidateLineIndicesFromCharacterIndex:(NSUInteger)charIndex {
  _invalidCharacterIndex = MIN(charIndex, _invalidCharacterIndex);
}
- (NSUInteger)       lineNumberForCharacterIndex:(NSUInteger)charIndex
                                          inText:(NSString*) text {


	// We do not want to risk calculating the indices again since we are probably doing it right now, thus possibly causing an infinite loop.
  NSMutableArray *lines = _invalidCharacterIndex < NSUIntegerMax ? _lineIndices : self.lineIndices;

  // Binary search
  NSUInteger			left = 0, right = lines.count, mid, lineStart;

  while ((right - left) > 1) {

    mid       = (right + left) / 2;
    lineStart = [lines[mid] unsignedIntegerValue];

    if (charIndex < lineStart)        right = mid;
    else if (charIndex > lineStart)    left = mid;
    else return mid;
  }
  return left;
}
- (void)            textStorageDidProcessEditing:(NSNotification*)note {

  NSRange range;  // Invalidate the line indices. They will be recalculated and re-cached on demand.
  if ((range = ((NSTextStorage*)note.object).editedRange).location == NSNotFound) return;
  [self invalidateLineIndicesFromCharacterIndex:range.location];  [self setNeedsDisplay:YES];
}
- (void)         calculateLines {

  id view;  if (![view = [self clientView] isKindOfClass:[NSTextView class]]) return;

  NSString        *text = [view string];
  NSUInteger      stringLength = [text length];
  NSUInteger count = [_lineIndices count],
         charIndex = 0,
         lineIndex = [self lineNumberForCharacterIndex:_invalidCharacterIndex inText:text],
           lineEnd,
        contentEnd;
  CGFloat oldThickness, newThickness;

  if (count > 0) charIndex = [_lineIndices[lineIndex] unsignedIntegerValue];
  do
  {
    if (lineIndex < count) _lineIndices[lineIndex] = @(charIndex);
    else                  [_lineIndices addObject:@(charIndex)];
    charIndex = NSMaxRange([text lineRangeForRange:NSMakeRange(charIndex, 0)]);
    lineIndex++;
  }
  while (charIndex < stringLength);

  if (lineIndex < count) [_lineIndices removeObjectsInRange:NSMakeRange(lineIndex, count - lineIndex)];
  _invalidCharacterIndex = NSUIntegerMax;

  // Check if text ends with a new line.
  [text getLineStart:NULL end:&lineEnd contentsEnd:&contentEnd forRange:NSMakeRange([[_lineIndices lastObject] unsignedIntegerValue], 0)];
  if (contentEnd < lineEnd) [_lineIndices addObject:@(charIndex)];

  // See if we need to adjust the width of the view
  if (fabs((oldThickness = self.ruleThickness) - (newThickness = self.requiredThickness)) <= 1) return;
  NSInvocation			*invocation;
  // Not a good idea to resize the view during calculations (which can happen during
  // display). Do a delayed perform (using NSInvocation since arg is a float).
  invocation = [NSInvocation invocationWithMethodSignature:[self methodSignatureForSelector:@selector(setRuleThickness:)]];
  [invocation setSelector:@selector(setRuleThickness:)];
  [invocation setTarget:self];
  [invocation setArgument:&newThickness atIndex:2];
  [invocation performSelector:@selector(invoke) withObject:nil afterDelay:0.0];
}
- (NSMutableArray*) lineIndices {

	return _invalidCharacterIndex >= NSUIntegerMax ?: [self calculateLines], _lineIndices;
}

#pragma mark - Appearance 

- (NSDictionary*) textAttributes        {
  return @{NSFontAttributeName: self.font ?: self.defaultFont,
          NSForegroundColorAttributeName: self.textColor ?: self.defaultTextColor};
}
- (NSDictionary*) markerTextAttributes  {
  return @{NSFontAttributeName: self.font ?: self.defaultFont,
          NSForegroundColorAttributeName: self.alternateTextColor ?: self.defaultAlternateTextColor};
}
- (CGFloat) requiredThickness           {

  NSUInteger lineCount = self.lineIndices.count;
  NSUInteger digits = lineCount ? (NSUInteger)log10(lineCount) + 1 : 1;
  NSMutableString *	sampleString = @"".mutableCopy;

  // Use "8" since it is one of the fatter numbers. Anything but "1" will probably be ok here.
  // I could be pedantic and actually find the fattest number for the current font but nah.
  for (NSUInteger i = 0; i < digits; i++)     [sampleString appendString:@"8"];

  NSSize stringSize = [sampleString sizeWithAttributes:self.textAttributes];

	// Round up the value. There is a bug on 10.4 where the display gets all wonky when scrolling if you don't
	// return an integral value here.
  return ceil(MAX(DEFAULT_THICKNESS, stringSize.width + RULER_MARGIN * 2));
}
- (void) drawHashMarksAndLabelsInRect:(NSRect)aRect {
  id			view;
	NSRect		bounds;

	bounds = [self bounds];

	if (_backgroundColor != nil)
	{
		[_backgroundColor set];
		NSRectFill(bounds);

		[[NSColor colorWithCalibratedWhite:0.58 alpha:1.0] set];
		[NSBezierPath strokeLineFromPoint:NSMakePoint(NSMaxX(bounds) - 0/5, NSMinY(bounds)) toPoint:NSMakePoint(NSMaxX(bounds) - 0.5, NSMaxY(bounds))];
	}

  view = [self clientView];

  if (![view isKindOfClass:NSTextView.class]) return;

  NSLayoutManager	*layoutManager  = [view layoutManager];
  NSTextContainer *container      = [view textContainer];
  NSString *text                  = [view string];
  NSRange nullRange               = (NSRange){NSNotFound,0};
  CGFloat yinset                  = [view textContainerInset].height;
  NSRect visibleRect              = self.scrollView.contentView.bounds;
  NSDictionary * textAttributes   = self.textAttributes;
  NSMutableArray* lines           = self.lineIndices;
  // Find the characters that are currently visible
  NSRange glyphRange = [layoutManager glyphRangeForBoundingRect:visibleRect inTextContainer:container],
               range = [layoutManager characterRangeForGlyphRange:glyphRange actualGlyphRange:NULL];

  // Fudge the range a tad in case there is an extra new line at end.
  // It doesn't show up in the glyphs so would not be accounted for.
  range.length++;
  NSUInteger count = lines.count;

  NSUInteger rectCount, index;    NSImage * markerImage;
  NSSize stringSize, markerSize;  NSString * labelText;
  NSRect markerRect;              NSDictionary * currentTextAttributes;
  NSRectArray	rects;              NoodleLineNumberMarker * marker;
  CGFloat	ypos;

  for (NSUInteger line = [self lineNumberForCharacterIndex:range.location inText:text]; line < count; line++)
  {
    index = [lines[line] unsignedIntegerValue];

    if (NSLocationInRange(index, range))
    {
      rects = [layoutManager rectArrayForCharacterRange:NSMakeRange(index, 0)
                           withinSelectedCharacterRange:nullRange
                                        inTextContainer:container
                                              rectCount:&rectCount];

      if (rectCount > 0)
      {
        // Note that the ruler view is only as tall as the visible
        // portion. Need to compensate for the clipview's coordinates.
        ypos = yinset + NSMinY(rects[0]) - NSMinY(visibleRect);

        marker = _linesToMarkers[@(line)];

        if (marker != nil)
        {
          markerImage = [marker image];
          markerSize = [markerImage size];
          markerRect = NSMakeRect(0.0, 0.0, markerSize.width, markerSize.height);

          // Marker is flush right and centered vertically within the line.
          markerRect.origin.x = NSWidth(bounds) - [markerImage size].width - 1.0;
          markerRect.origin.y = ypos + NSHeight(rects[0]) / 2.0 - [marker imageOrigin].y;

          [markerImage drawInRect:markerRect fromRect:NSMakeRect(0, 0, markerSize.width, markerSize.height) operation:NSCompositeSourceOver fraction:1.0];
        }

        // Line numbers are internally stored starting at 0
        labelText             = [NSString stringWithFormat:@"%jd", (intmax_t)line + 1];
        stringSize            = [labelText sizeWithAttributes:textAttributes];
        currentTextAttributes = !marker ? textAttributes : [self markerTextAttributes];

        // Draw string flush right, centered vertically within the line
        [labelText drawInRect:
         NSMakeRect(NSWidth(bounds) - stringSize.width - RULER_MARGIN,
                    ypos + (NSHeight(rects[0]) - stringSize.height) / 2.0,
                    NSWidth(bounds) - RULER_MARGIN * 2.0, NSHeight(rects[0]))
               withAttributes:currentTextAttributes];
      }
    }
    if (index > NSMaxRange(range)) break;
  }
}

#pragma mark - Markers 

- (NSUInteger)     lineNumberForLocation:(CGFloat)location  {

	NSUInteger		line, count, index, rectCount, i;
	NSRectArray		rects;
	NSLayoutManager	*layoutManager;
	NSTextContainer	*container;
	NSRange			nullRange;
	id	  view = self.clientView;
	NSRect visibleRect = self.scrollView.contentView.bounds;

  NSMutableArray *lines = self.lineIndices;
	location += NSMinY(visibleRect);

	if ([view isKindOfClass:NSTextView.class])
	{
		nullRange = NSMakeRange(NSNotFound, 0);
		layoutManager = [view layoutManager];
		container = [view textContainer];
		count = [lines count];

		for (line = 0; line < count; line++)
		{
			index = [[lines objectAtIndex:line] unsignedIntegerValue];
			rects = [layoutManager rectArrayForCharacterRange:NSMakeRange(index, 0)
                           withinSelectedCharacterRange:nullRange
                                        inTextContainer:container
                                              rectCount:&rectCount];

			for (i = 0; i < rectCount; i++)
				if ((location >= NSMinY(rects[i])) && (location < NSMaxY(rects[i]))) return line + 1;
		}
	}
	return NSNotFound;
}
- (NoodleLineNumberMarker*) markerAtLine:(NSUInteger)line   {
	return [_linesToMarkers objectForKey:[NSNumber numberWithUnsignedInteger:line - 1]];
}
- (void)   setMarkers:(NSArray*)markers       {

	NSRulerMarker		*marker;	[_linesToMarkers removeAllObjects]; [super setMarkers:nil];

	while ((marker = markers.objectEnumerator.nextObject)) [self addMarker:marker];
}
- (void)    addMarker:(NSRulerMarker*)aMarker {

  [aMarker isKindOfClass:NoodleLineNumberMarker.class]
  ? _linesToMarkers[@(((NoodleLineNumberMarker*)aMarker).lineNumber - 1)] = aMarker
  : [super addMarker:aMarker];
}
- (void) removeMarker:(NSRulerMarker*)aMarker {

  [aMarker isKindOfClass:NoodleLineNumberMarker.class]
  ? [_linesToMarkers removeObjectForKey:@([(NoodleLineNumberMarker*) aMarker lineNumber] - 1)]
  : [super removeMarker:aMarker];
}

#pragma mark <NSCoding> methods

#define NOODLE_FONT_CODING_KEY              @"font"
#define NOODLE_TEXT_COLOR_CODING_KEY        @"textColor"
#define NOODLE_ALT_TEXT_COLOR_CODING_KEY    @"alternateTextColor"
#define NOODLE_BACKGROUND_COLOR_CODING_KEY	@"backgroundColor"

- (id)initWithCoder:(NSCoder*) decoder {
	if ((self = [super initWithCoder:decoder]) != nil)
	{
		if ([decoder allowsKeyedCoding])
		{
			_font = [[decoder decodeObjectForKey:NOODLE_FONT_CODING_KEY] retain];
			_textColor = [[decoder decodeObjectForKey:NOODLE_TEXT_COLOR_CODING_KEY] retain];
			_alternateTextColor = [[decoder decodeObjectForKey:NOODLE_ALT_TEXT_COLOR_CODING_KEY] retain];
			_backgroundColor = [[decoder decodeObjectForKey:NOODLE_BACKGROUND_COLOR_CODING_KEY] retain];
		}
		else
		{
			_font = [[decoder decodeObject] retain];
			_textColor = [[decoder decodeObject] retain];
			_alternateTextColor = [[decoder decodeObject] retain];
			_backgroundColor = [[decoder decodeObject] retain];
		}

		_linesToMarkers = [[NSMutableDictionary alloc] init];
	}
	return self;
}
- (void) encodeWithCoder:(NSCoder*) encoder {
	[super encodeWithCoder:encoder];

	if ([encoder allowsKeyedCoding])
	{
		[encoder encodeObject:_font forKey:NOODLE_FONT_CODING_KEY];
		[encoder encodeObject:_textColor forKey:NOODLE_TEXT_COLOR_CODING_KEY];
		[encoder encodeObject:_alternateTextColor forKey:NOODLE_ALT_TEXT_COLOR_CODING_KEY];
		[encoder encodeObject:_backgroundColor forKey:NOODLE_BACKGROUND_COLOR_CODING_KEY];
	}
	else
	{
		[encoder encodeObject:_font];
		[encoder encodeObject:_textColor];
		[encoder encodeObject:_alternateTextColor];
		[encoder encodeObject:_backgroundColor];
	}
}

@end
