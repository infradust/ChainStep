//
//  StepPlaceholder.h
//  DSChainStep
//
//  Created by Dan Shelly on 19/3/2014.
//  Copyright (c) 2014 SO. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Step;

@interface StepPlaceholder : NSManagedObject

@property (nonatomic, retain) NSData * binaryIndexPath;
@property (nonatomic, strong) NSIndexPath* indexPath;
@property (nonatomic, retain) NSManagedObject *chain;
@property (nonatomic, retain) Step *step;

@end
