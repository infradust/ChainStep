//
//  Chain.h
//  DSChainStep
//
//  Created by Dan Shelly on 19/3/2014.
//  Copyright (c) 2014 SO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class StepPlaceholder;

@interface Chain : NSManagedObject

@property (nonatomic, strong) NSArray* steps;
@property (nonatomic, retain) NSSet *stepPlaceholders;
@end

@interface Chain (CoreDataGeneratedAccessors)

- (void)addStepPlaceholdersObject:(StepPlaceholder *)value;
- (void)removeStepPlaceholdersObject:(StepPlaceholder *)value;
- (void)addStepPlaceholders:(NSSet *)values;
- (void)removeStepPlaceholders:(NSSet *)values;

@end
