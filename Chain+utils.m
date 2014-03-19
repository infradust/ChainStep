//
//  Chain+utils.m
//
//  Created by Dan Shelly on 18/3/2014.
//  Copyright (c) 2014. All rights reserved.
//

#import "Chain+utils.h"
#import "StepPlaceholder+utils.h"
#import "Step.h"
#import <objc/runtime.h>

static char const* const virtual_last_index_key = "virtual_last_index";
@interface NSArray (lastvirtualindex)
@property (nonatomic,assign) NSUInteger virtualLastIndex;
@end

@implementation NSArray (lastvirtualindex)
- (NSUInteger) virtualLastIndex
{
    return [objc_getAssociatedObject(self, virtual_last_index_key) unsignedIntegerValue];
}

- (void) setVirtualLastIndex:(NSUInteger)virtualLastIndex
{
    objc_setAssociatedObject(self, virtual_last_index_key, @(virtualLastIndex),OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
@end

@implementation Chain (utils)

+ (NSArray*) buildMultiDimArrayWithSortedPlaceholders:(NSArray*)placeholders
{
    NSMutableArray* map = [NSMutableArray new];
    for (StepPlaceholder* placeholder in placeholders) {
        NSMutableArray* currentMap = map;
        NSUInteger i = 0;
        NSUInteger length = [placeholder.binaryIndexPath length]/(sizeof(NSUInteger));
        const NSUInteger* indexes = [placeholder.binaryIndexPath bytes];
        for (;i < length-1; ++i) {
            if ([currentMap count] &&
                currentMap.virtualLastIndex == indexes[i] &&
                [[currentMap lastObject] isKindOfClass:[Step class]])
            {
                return nil;
            } else if ([currentMap count] == 0 || currentMap.virtualLastIndex != indexes[i]) {
                [currentMap addObject:[NSMutableArray new]];
            }
            currentMap.virtualLastIndex = indexes[i];
            currentMap = currentMap.lastObject;
        }
        [currentMap addObject:[placeholder step]];
        currentMap.virtualLastIndex = indexes[i];
    }
    return map;
}

- (NSFetchRequest*) requestForMyPlaceholders
{
    NSFetchRequest* r = [NSFetchRequest fetchRequestWithEntityName:@"StepPlaceholder"];
    r.predicate = [NSPredicate predicateWithFormat:@"chain = %@",self.objectID];
    r.relationshipKeyPathsForPrefetching = @[@"step"];
    r.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"binaryIndexPath"
                                                        ascending:YES]];
    return r;
}

- (NSArray*) steps
{
    [self willAccessValueForKey:@"steps"];
    NSArray* currentArray = [self primitiveValueForKey:@"steps"];
    if (currentArray == nil) {
        NSFetchRequest *r = [self requestForMyPlaceholders];
        NSError* error = nil;
        NSArray* results = [[self managedObjectContext] executeFetchRequest:r
                                                                      error:&error];
        currentArray = [[self class] buildMultiDimArrayWithSortedPlaceholders:results];
        [self setPrimitiveValue:currentArray forKey:@"steps"];
    }
    [self didAccessValueForKey:@"steps"];
    return currentArray;
}

@end
