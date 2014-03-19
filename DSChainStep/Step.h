//
//  Step.h
//  DSChainStep
//
//  Created by Dan Shelly on 19/3/2014.
//  Copyright (c) 2014 SO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Step : NSManagedObject

@property (nonatomic, retain) NSString * content;
@property (nonatomic, retain) NSSet *stepPlaceholders;
@end

@interface Step (CoreDataGeneratedAccessors)

- (void)addStepPlaceholdersObject:(NSManagedObject *)value;
- (void)removeStepPlaceholdersObject:(NSManagedObject *)value;
- (void)addStepPlaceholders:(NSSet *)values;
- (void)removeStepPlaceholders:(NSSet *)values;

@end
