//
//  NoodleLineNumberMarker.m
//  NoodleKit
//
//  Created by Paul Kim on 9/30/08.
//  Copyright (c) 2008 Noodlesoft, LLC. All rights reserved.
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
