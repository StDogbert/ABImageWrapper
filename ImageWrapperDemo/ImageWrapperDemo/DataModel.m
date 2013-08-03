//
//  DataModel.m
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboim on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. All rights reserved.
//

#import "DataModel.h"

static NSMutableDictionary* instance;


NSMutableDictionary* dataModel()
{
    if (!instance) {
        instance = [[NSMutableDictionary alloc] init];
    }
    
    return instance;
}

NSString* keyForIndexPath(NSIndexPath* path)
{
    return [NSString stringWithFormat:@"%d", path.row];
}

