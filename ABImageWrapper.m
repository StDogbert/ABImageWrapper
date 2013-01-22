//
//  ABImageWrapper.m
//  Jeremy
//
//  Created by Alexandr Barenboim on 18.01.13.
//  Copyright (c) 2013 GPIHolding. All rights reserved.
//

#import "ABImageWrapper.h"

#define TEMPORARY_AB_IMAGES @"TemporaryABImages"
#define SMALL_WIDTH 40.0
#define MEDIUM_WIDTH 200.0

static int counter = 0;

int getUniqueId()
{
    return counter++;
}

const float default_quality = 0.5;

@interface ABImageWrapper ()
{
    CGSize full_Size;
    NSString* tmp_folder_path;
    int uniquie_id;
    float small_width;
    float medium_width;
}

- (UIImage*)scaleToSize:(CGSize)size image:(UIImage*)image;

@end

@implementation ABImageWrapper

- (UIImage*)scaleToSize:(CGSize)size image:(UIImage*)image
{
    // Create a bitmap graphics context
    // This will also set it as the current context
    UIGraphicsBeginImageContext(size);
    
    // Draw the scaled image in the current context
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // Create a new image from current context
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // Pop the current context from the stack
    UIGraphicsEndImageContext();
    
    // Return our new scaled image
    return scaledImage;
};

+ (id)createWithUIImage:(UIImage*)image
{
    return [[self alloc] initWithUIImage:image];
}

- (id)initWithUIImage:(UIImage*)image {
    if (self = [super init]) {
        uniquie_id = getUniqueId();
        full_Size = image.size;
        small_width = MIN(SMALL_WIDTH, full_Size.width);
        medium_width = MIN(MEDIUM_WIDTH, full_Size.width);
        
        
        NSString* root_path = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];

        tmp_folder_path = [NSTemporaryDirectory() stringByAppendingPathComponent:TEMPORARY_AB_IMAGES];
        
        tmp_folder_path = [tmp_folder_path stringByReplacingOccurrencesOfString:root_path withString:@".."];
        
        NSFileManager* filemanager = [NSFileManager defaultManager];
        
        static BOOL first_time = YES;
        
        if (first_time) {
            [filemanager removeItemAtPath:tmp_folder_path error:Nil];
            [filemanager createDirectoryAtPath:tmp_folder_path withIntermediateDirectories:YES attributes:Nil error:Nil];
            first_time = NO;
        }
        
        tmp_folder_path = [tmp_folder_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", uniquie_id]];

        [filemanager removeItemAtPath:tmp_folder_path error:Nil];
        [filemanager createDirectoryAtPath:tmp_folder_path withIntermediateDirectories:YES attributes:Nil error:Nil];
        
        NSString* full_sized_file_name = [tmp_folder_path stringByAppendingPathComponent:[self fileNameWithSize:full_Size andQuality:MAXIMUM_ABImage_QUALITY]];
        
        NSData* full_sized_image_data = UIImageJPEGRepresentation(image, MAXIMUM_ABImage_QUALITY);;
        
        [full_sized_image_data writeToFile:full_sized_file_name atomically:NO];
    }
    
    return self;
}

- (void)dealloc {
    NSFileManager* filemanager = [NSFileManager defaultManager];
    [filemanager removeItemAtPath:tmp_folder_path error:Nil];
}

- (UIImage*)fullSized {
    return [self fullSizedWithQuality:default_quality];
}

- (UIImage*)fullSizedWithQuality:(float)quality
{
    return [self customSize:full_Size withQuality:quality];
}

- (UIImage*)smallSize {
    return [self smallSizeWithQuality:default_quality];
}

- (UIImage*)smallSizeWithQuality:(float)quality
{
    CGSize smallSize = CGSizeMake(small_width, small_width * full_Size.height / full_Size.width);
    return [self customSize:smallSize withQuality:quality];
}

- (UIImage*)mediumSize {
    return [self mediumSizeWithQuality:default_quality];
}

- (UIImage*)mediumSizeWithQuality:(float)quality
{
    CGSize mediumSize = CGSizeMake(medium_width, medium_width * full_Size.height / full_Size.width);
    return [self customSize:mediumSize withQuality:quality];
}

- (UIImage*)customSize:(CGSize)size {
    return [self customSize:size withQuality:default_quality];
}

- (UIImage*)customSize:(CGSize)size withQuality:(float)quality
{
    NSString* file_name = [self fileNameWithSize:size andQuality:quality];
    file_name = [tmp_folder_path stringByAppendingPathComponent:file_name];
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    BOOL file_exists = [filemanager fileExistsAtPath:file_name];
    
    if (!file_exists) {
        NSString* full_sized_image_name = [tmp_folder_path stringByAppendingPathComponent:[self fileNameWithSize:full_Size andQuality:MAXIMUM_ABImage_QUALITY]];
        
        UIImage* full_sized_image = [UIImage imageNamed:full_sized_image_name];
        
        if (!full_sized_image) {
            return Nil;
        }

        
        UIImage* scaled_image = [self scaleToSize:size image:full_sized_image];
        
        NSData* scaled_image_data = UIImageJPEGRepresentation(scaled_image, quality);
        
        [scaled_image_data writeToFile:file_name atomically:YES];
    }
    
    return [UIImage imageNamed:file_name];
}

- (NSString*)fileNameWithSize:(CGSize)size andQuality:(float)quality
{
    return [NSString stringWithFormat:@"id-%dwidth-%fheight-%fquality-%f.jpg", uniquie_id, size.width, size.height, quality];
}

@end
