//
//  DataModel.m
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboim on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. All rights reserved.
//

#import "DataModel.h"
#import "ABImageWrapper.h"

#define CELLS 8

static NSMutableDictionary* instance;


NSMutableDictionary* dataModel()
{
    if (!instance) {
        instance = [[NSMutableDictionary alloc] init];
        
        for (int i = 0; i < CELLS; i++) {
            NSString* image_name = [NSString stringWithFormat:@"nature%d.jpg", ((i+1)%15)+1];
            UIImage* image = [UIImage imageNamed:image_name];
            ABImageWrapper* wrapper = [ABImageWrapper createWithUIImage:image];
            NSIndexPath* path = [NSIndexPath indexPathForItem:i inSection:0];
            NSString* key = keyForIndexPath(path);
            
            [instance setValue:wrapper forKey:key];
        }
    }
    
    return instance;
}

NSString* keyForIndexPath(NSIndexPath* path)
{
    return [NSString stringWithFormat:@"%d", path.row];
}

