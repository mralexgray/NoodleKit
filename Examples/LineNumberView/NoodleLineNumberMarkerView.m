//
//  MarkerTextView.m
//  Line View Test
//
//  Created by Paul Kim on 10/4/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.

#import "NoodleLineNumberMarkerView.h"
#import "NoodleLineNumberMarker.h"

#define CORNER_RADIUS	3.0
#define MARKER_HEIGHT	13.0

@implementation MarkerLineNumberView { NSMutableDictionary * markerImages; NSUInteger dragHit; }

-     (void)       setRuleThickness:(CGFloat)t  {

  // Overridden to reset the size of the marker image forcing it to redraw with the new width.
	// If doing this in a non-subclass of NoodleLineNumberView, you can set it to post frame notifications and listen for them.
	[markerImages.allValues enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
    NSLog(@"resizing:%@", [obj name]);
    super.ruleThickness = t;
    [obj setSize:NSMakeSize(super.ruleThickness, MARKER_HEIGHT)];
  }];
} /* OK */
- (NSImage*)    markerImageWithSize:(NSSize)z color:(NSColor*)c  {

		NSImage *markerImage = markerImages[[c description]];
    if (markerImage) { NSLog(@"returning cached image for %@", [c description]); return markerImage; }
    markerImage = [NSImage.alloc initWithSize:z];
		NSCustomImageRep	*rep = [NSCustomImageRep.alloc initWithSize:z
                                                          flipped:NO
                                                   drawingHandler:^BOOL(NSRect dstRect) {

      NSRect rect = (NSRect){1,2,dstRect.size.width - 2,dstRect.size.height-3};
      NSBezierPath * path = NSBezierPath.bezierPath;
      [path moveToPoint:NSMakePoint(NSMaxX(rect), NSMinY(rect) + NSHeight(rect)/2)];
      [path lineToPoint:NSMakePoint(NSMaxX(rect) - 5, NSMaxY(rect))];
      [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect) + CORNER_RADIUS, NSMaxY(rect) - CORNER_RADIUS) radius:CORNER_RADIUS startAngle:90 endAngle:180];
      [path appendBezierPathWithArcWithCenter:NSMakePoint(NSMinX(rect) + CORNER_RADIUS, NSMinY(rect) + CORNER_RADIUS) radius:CORNER_RADIUS startAngle:180 endAngle:270];
      [path lineToPoint:NSMakePoint(NSMaxX(rect) - 5, NSMinY(rect))];
      [path closePath];

      NSColor *c1 = [c colorUsingColorSpaceName:NSDeviceRGBColorSpace];//[self.markerColor ?: [NSColor colorWithCalibratedRed:0.779 green:0.247 blue:0.020 alpha:1.000] colorUsingColorSpaceName:NSDeviceRGBColorSpace];
      CGFloat newB = c1.brightnessComponent - .2;
      NSColor *c2 = [NSColor colorWithCalibratedHue:c.hueComponent saturation:c.saturationComponent brightness:newB alpha:1];
      [c1 set];
      [path fill];
      [c2 set];
      [path setLineWidth:2.0];
      [path stroke];
      return YES;
    }];
//    }:@selector(drawMarkerImageIntoRep:) delegate:self];
		[rep setSize:z];
		[markerImage addRepresentation:rep];
    [markerImage setName:[c description]];
    [markerImages = markerImages ?: NSMutableDictionary.new setValue:markerImage forKey:[c description]];
    return markerImage;
} /* OK */
-     (void)              mouseDown:(NSEvent*)e   { [self markerEvent:e]; }
-     (void)           mouseDragged:(NSEvent*)e   { [self markerEvent:e]; }
-     (void)            markerEvent:(NSEvent*)e   {


  NoodleLineNumberMarker *marker;
  NSUInteger line;
	NSPoint location = [self convertPoint:e.locationInWindow fromView:nil];

	if ((line   = [self lineNumberForLocation:location.y]) == NSNotFound || line == dragHit) return;

  dragHit = line;
  if ((marker = [self markerAtLine:line])) [self removeMarker:marker];
  else ({
    NoodleLineNumberMarker *m =

    [NoodleLineNumberMarker.alloc initWithRulerView:self
                                         lineNumber:line
                                              image:[self markerImageWithSize:(NSSize){self.ruleThickness, MARKER_HEIGHT} color:self.markerColor.copy]
                                        imageOrigin:NSMakePoint(0, MARKER_HEIGHT/2)];//color:self.markerColor.copy];
    [self addMarker:m]; });
  [self setNeedsDisplay:YES];
} /* OK */

@end
