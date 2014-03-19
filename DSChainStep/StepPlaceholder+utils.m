//
//  StepPlaceholder+utils.m
//  DSChainStep
//
//  Created by Dan Shelly on 19/3/2014.
//  Copyright (c) 2014 SO. All rights reserved.
//

#import "StepPlaceholder+utils.h"
#import "Chain+utils.h"

@implementation StepPlaceholder (utils)

- (NSIndexPath*) indexPath
{
    [self willAccessValueForKey:@"indexPath"];
    NSIndexPath* indexPath = [self primitiveValueForKey:@"indexPath"];
    
    if (indexPath == nil) {
        if (self.binaryIndexPath != nil) {
            indexPath = [NSIndexPath indexPathWithIndexes:(const NSUInteger*)[self.binaryIndexPath bytes]
                                                   length:[self.binaryIndexPath length]/(sizeof(NSUInteger))];
            [self setPrimitiveValue:indexPath forKey:@"indexPath"];
        }
    }
    [self didAccessValueForKey:@"indexPath"];
    return indexPath;
}

- (void) setIndexPath:(NSIndexPath*)indexPath
{
    NSIndexPath* currentIndexPath = [self indexPath];
    if ( currentIndexPath==nil ||
        [currentIndexPath compare:indexPath] != NSOrderedSame)
    {
        [self willChangeValueForKey:@"indexPath"];
        if (indexPath) {
            NSUInteger* bytes = (NSUInteger*)malloc([indexPath length]*sizeof(NSUInteger));
            [indexPath getIndexes:bytes];
            self.binaryIndexPath = [NSData dataWithBytesNoCopy:bytes
                                                        length:[indexPath length]*sizeof(NSUInteger)];
        } else {
            self.binaryIndexPath = nil;
        }
        [self setPrimitiveValue:indexPath forKey:@"indexPath"];
        [self didChangeValueForKey:@"indexPath"];
    }
}

@end
