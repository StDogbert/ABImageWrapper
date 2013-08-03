//
//  DetailedController.m
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboym on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. 
//  See the file license.txt for copying permission.

#import "DetailedController.h"
#import "DataModel.h"
#import <QuartzCore/QuartzCore.h>

@interface DetailedController ()
{
    NSString* key;
}

@end

@implementation DetailedController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self configureImageView];
}

- (void)configureImageView
{
    self.image.layer.borderWidth = 1;
    self.image.layer.borderColor = [UIColor grayColor].CGColor;
    self.image.layer.cornerRadius = 5;
    
    [self.image setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.image.contentMode = UIViewContentModeScaleAspectFill;
    self.image.clipsToBounds = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setImage:(UIImage*)image indexPath:(NSIndexPath*)path
{
    self.image.image = image;
    
    key = keyForIndexPath(path);
}

- (IBAction)removePhoto:(id)sender {
    self.image.image = Nil;
    
    if (key) {
        [dataModel() removeObjectForKey:key];
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
