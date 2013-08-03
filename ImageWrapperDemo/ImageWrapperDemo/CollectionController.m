//
//  CollectionController.m
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboim on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. All rights reserved.
//

#import "CollectionController.h"
#import "Cell.h"
#import "DetailedController.h"
#import "ABImageWrapper.h"
#import "DataModel.h"

UIViewController* getViewControllerWithID(NSString* controller_id)
{
    UIStoryboard* mainStoryboard;
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPad"
                                                   bundle: nil];
    }
    else
    {
        mainStoryboard = [UIStoryboard storyboardWithName:@"MainStoryboard_iPhone"
                                                   bundle: nil];
    }
    
    UIViewController* controller = [mainStoryboard instantiateViewControllerWithIdentifier:controller_id];
    
    return controller;
}

@interface CollectionController ()
{
    NSMutableArray* data_source_images;
}

@end

@implementation CollectionController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.collection registerClass:[Cell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self clearVisibleCells];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.collection reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)clearVisibleCells
{
    for (Cell* cell in self.collection.visibleCells) {
        [cell setImage:Nil];
    }
}

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section
{
    return 1;
}

- (NSInteger)numberOfSectionsInCollectionView: (UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* identifier = @"cell";
    Cell *cell = [cv dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    NSString* image_name = [NSString stringWithFormat:@"nature%d.jpg", indexPath.row%4+1];
    UIImage* image = [UIImage imageNamed:image_name];
    ABImageWrapper* wrapper = [ABImageWrapper createWithUIImage:image];
    [cell setImage:wrapper];
    
    return cell;
}

#pragma mark - UICollectionViewDelegate
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DetailedController* controller = (DetailedController*)getViewControllerWithID(@"detailed");
    [self.navigationController pushViewController:controller animated:YES];
    
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    // TODO: Deselect item
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    [((Cell*)cell) setImage:Nil];
}

#pragma mark – UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 60);
}

- (UIEdgeInsets)collectionView:
(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 20, 10, 20);
}




@end
