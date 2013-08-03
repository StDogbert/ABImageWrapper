//
//  CollectionController.h
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboym on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. 
//  See the file license.txt for copying permission.

#import <UIKit/UIKit.h>

@interface CollectionController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collection;

- (IBAction)fill:(id)sender;

@end
