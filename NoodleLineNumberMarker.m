//
//  NoodleLineNumberMarker.m
//  NoodleKit
//
//  Created by Paul Kim on 9/30/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.

#import "NoodleLineNumberMarker.h"

#define NOODLE_LINE_CODING_KEY		@"line"

@implementation NoodleLineNumberMarker

- (id) initWithRulerView:(NSRulerView*)rv lineNumber:(CGFloat)l image:(NSImage*)i imageOrigin:(NSPoint)iO {

	return self = [super initWithRulerView:rv markerLocation:0 image:i imageOrigin:iO] ? _lineNumber = l, self : nil;
}

#pragma mark NSCoding methods

- (id) initWithCoder:(NSCoder*)decoder { return self = [super initWithCoder:decoder] ?

    _lineNumber = [decoder allowsKeyedCoding]
                ? [decoder decodeIntegerForKey:NOODLE_LINE_CODING_KEY]
                : [decoder.decodeObject unsignedIntegerValue], self : nil;
}

- (void)encodeWithCoder:(NSCoder *)encoder {	[super encodeWithCoder:encoder];

  [encoder allowsKeyedCoding] ? [encoder encodeInteger:_lineNumber forKey:NOODLE_LINE_CODING_KEY]
                              : [encoder encodeObject:@(_lineNumber)];

}

#pragma mark NSCopying methods

- (id) copyWithZone:(NSZone *)z { id new = [super copyWithZone:z];

  [new setLineNumber:_lineNumber]; return new;
}

@end
