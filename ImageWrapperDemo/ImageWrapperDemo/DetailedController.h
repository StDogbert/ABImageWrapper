//
//  DetailedController.h
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboym on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. 
//  See the file license.txt for copying permission.

#import <UIKit/UIKit.h>

@interface DetailedController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *image;
- (void)setImage:(UIImage*)image indexPath:(NSIndexPath*)path;
- (IBAction)removePhoto:(id)sender;

@end
