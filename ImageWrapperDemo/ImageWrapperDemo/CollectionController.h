//
//  CollectionController.h
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboim on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

@end
