//
//  StepPlaceholder+utils.m
//  DSChainStep
//
//  Created by Dan Shelly on 19/3/2014.
//  Copyright (c) 2014 SO. All rights reserved.
//

#import "StepPlaceholder+utils.h"
#import "Chain+utils.h"
NSUInteger tNSUInteger(NSUInteger input) {
    uint8_t* buff = (uint8_t*)(&input);
    uint8_t tmp;
    size_t size = sizeof(input);
    for (NSUInteger i = 0; i < size/2; ++i) {
        tmp = buff[i];
        buff[i] = buff[size-i-1];
        buff[size-i-1] = tmp;
    }
    return input;
}


@implementation StepPlaceholder (utils)

- (NSIndexPath*) indexPath
{
    [self willAccessValueForKey:@"indexPath"];
    NSIndexPath* indexPath = [self primitiveValueForKey:@"indexPath"];
    
    if (indexPath == nil) {
        if (self.binaryIndexPath != nil) {
            NSUInteger length =[self.binaryIndexPath length]/(sizeof(NSUInteger));
            NSUInteger* mbytes = (NSUInteger*)malloc(sizeof(NSUInteger)*length);
            const NSUInteger* bytes = [self.binaryIndexPath bytes];
            for (NSUInteger i = 0; i < length; ++i) {
                mbytes[i] = tNSUInteger(bytes[i]);
            }
            indexPath = [NSIndexPath indexPathWithIndexes:mbytes
                                                   length:length];
            free(mbytes);
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
            for (NSUInteger i = 0; i < indexPath.length; ++i) {
                bytes[i] = tNSUInteger(bytes[i]);
            }
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
