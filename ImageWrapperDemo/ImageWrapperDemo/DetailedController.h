//
//  DetailedController.h
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboim on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailedController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *image;
- (void)setImage:(UIImage*)image indexPath:(NSIndexPath*)path;
- (IBAction)removePhoto:(id)sender;

@end
