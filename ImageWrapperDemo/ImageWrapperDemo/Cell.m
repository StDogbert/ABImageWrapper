//
//  Cell.m
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboym on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. 
//  See the file license.txt for copying permission.

#import "Cell.h"
#import <QuartzCore/QuartzCore.h>

@implementation Cell

- (void)customInit
{
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor grayColor].CGColor;
    self.layer.cornerRadius = 5;
    
    self.clipsToBounds = YES;
    
    self.contentView.backgroundColor = [UIColor clearColor];
    self.backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [self.backgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    
    self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.bounds];
    [self.selectedBackgroundView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.selectedBackgroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.6];
    
    self.background_photo = [[UIImageView alloc] initWithFrame:self.bounds];
    [self.background_photo setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    self.background_photo.clipsToBounds = YES;
    [self.backgroundView addSubview:self.background_photo];
    
    [self setImage:Nil];
}

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self customInit];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        [self customInit];
    }
    
    return self;
}

- (void)setImage:(UIImage*)image
{
    self.background_photo.contentMode = UIViewContentModeScaleAspectFill;
    
    self.background_photo.image = image;
    
    if (!image) {
        self.background_photo.image = [UIImage imageNamed:@"camera.png"];
        self.background_photo.contentMode = UIViewContentModeScaleAspectFit;
    }
}

@end
