//
//  DataModel.m
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboym on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. 
//  See the file license.txt for copying permission.

#import "DataModel.h"
#import "ABImageWrapper.h"

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

