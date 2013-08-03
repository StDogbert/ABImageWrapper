//
//  DataModel.m
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboim on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. All rights reserved.
//

#import "DataModel.h"

@implementation DataModel

static DataModel* instance;

+ (id)instance
{
    if (!instance) {
        instance = [[DataModel alloc] init];
    }
    
    return instance;
}

#pragma mark - NSDictionary subclass methods
- (NSUInteger)count
{
    return [super count];
}

- (id)initWithObjects:(NSArray *)objects forKeys:(NSArray *)keys
{
    return [super initWithObjects:objects forKeys:keys];
}

- (id)objectForKey:(id)aKey
{
    return [super objectForKey:aKey];
}

- (NSEnumerator *)keyEnumerator
{
    return [super keyEnumerator];
}


#pragma mark - NSMutableDictionary subclass methods
- (void)setObject:(id)anObject forKey:(id < NSCopying >)aKey
{
    [super setObject:anObject forKey:aKey];
}

- (void)removeObjectForKey:(id)aKey
{
    [super removeObjectForKey:aKey];
}

@end
