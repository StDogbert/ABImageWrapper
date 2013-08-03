//  ABImageWrapper.m
//  Created by Alexandr Barenboym on 18.01.13.

#import "ABImageWrapper.h"
#include <stdio.h>

#define TEMPORARY_AB_IMAGES @"TemporaryABImages"
#define CACHED_AB_IMAGES @"CachedABImages"

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
    NSString* cached_folder_path;
    NSString* uuid_string;
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

+ (id)createWithCacheID:(NSString*)cache_id
{
    return [[self alloc] initWithCacheID:cache_id];
}

- (id)init
{
    if (self = [super init]) {
        uniquie_id = getUniqueId();
        
        [self prepareTmpFolderPath];
        
        [self prepareCachedFolderPath];
    }
    
    return self;
}

- (id)initWithCacheID:(NSString*)cache_id
{
    if (self = [self init]) {
        
        if (!(cache_id.length)) {
            return self;
        }
        
        uuid_string = cache_id;
        UIImage* image = [self getUIImageFromCache:cache_id];
        
        if (image) {
            [self fillWithImage:image];
        }
    }
    
    return self;
}

- (id)initWithUIImage:(UIImage*)image {
    if (self = [self init]) {
        [self fillWithImage:image];
    }
    
    return self;
}

- (void)fillWithImage:(UIImage*)image
{
    full_Size = image.size;
    small_width = MIN(SMALL_ABWIDTH, full_Size.width);
    medium_width = MIN(MEDIUM_ABWIDTH, full_Size.width);
    
    NSString* full_sized_file_path = [self filePathWithSize:full_Size andQuality:MAXIMUM_ABImage_QUALITY relative:NO];
    
    NSData* full_sized_image_data = UIImageJPEGRepresentation(image, MAXIMUM_ABImage_QUALITY);
    
    [[NSFileManager defaultManager] createFileAtPath:full_sized_file_path
                                            contents:nil attributes:nil];
    
    [full_sized_image_data writeToFile:full_sized_file_path atomically:YES];
}

- (void)prepareTmpFolderPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* tmp_folder_directory = [paths lastObject];
    
    tmp_folder_path = [tmp_folder_directory stringByAppendingPathComponent:TEMPORARY_AB_IMAGES];
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    static BOOL first_time = YES;
    
    NSError *error = Nil;
    
    if (first_time) {
        [filemanager removeItemAtPath:tmp_folder_path error:&error];
        [filemanager createDirectoryAtPath:tmp_folder_path withIntermediateDirectories:YES attributes:Nil error:&error];
        first_time = NO;
    }
    
    tmp_folder_path = [tmp_folder_path stringByAppendingPathComponent:[NSString stringWithFormat:@"%d", uniquie_id]];
    
    [filemanager removeItemAtPath:tmp_folder_path error:Nil];
    [filemanager createDirectoryAtPath:tmp_folder_path withIntermediateDirectories:YES attributes:Nil error:Nil];
}

- (void)prepareCachedFolderPath
{
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documents_directory = [paths lastObject];
    
    cached_folder_path = [documents_directory stringByAppendingPathComponent:CACHED_AB_IMAGES];
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    if (![filemanager fileExistsAtPath:cached_folder_path]) {
        [filemanager createDirectoryAtPath:cached_folder_path withIntermediateDirectories:YES attributes:Nil error:Nil];
    }
}

- (void)dealloc {
}

- (UIImage*)fullSized {
    return [self fullSizedWithQuality:MAXIMUM_ABImage_QUALITY];
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
    NSString* file_path = [self filePathWithSize:size andQuality:quality relative:NO];
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    BOOL file_exists = [filemanager fileExistsAtPath:file_path];
    
    if (!file_exists) {
        NSString* relative_full_sized_file_path = [self filePathWithSize:full_Size andQuality:MAXIMUM_ABImage_QUALITY relative:YES];
        
        UIImage* full_sized_image = [UIImage imageNamed:relative_full_sized_file_path];
        
        if (!full_sized_image) {
            return Nil;
        }
        
        UIImage* scaled_image = [self scaleToSize:size image:full_sized_image];
        
        NSData* scaled_image_data = UIImageJPEGRepresentation(scaled_image, quality);
        
        [[NSFileManager defaultManager] createFileAtPath:file_path
                                                contents:nil attributes:nil];
        
        [scaled_image_data writeToFile:file_path atomically:YES];
    }
    
    NSString* relative_file_path = [self filePathWithSize:size andQuality:quality relative:YES];
    
    UIImage* response_image = [UIImage imageNamed:relative_file_path];
    
    return response_image;
}

- (NSString*)fileNameWithSize:(CGSize)size andQuality:(float)quality
{
    return [NSString stringWithFormat:@"id-%dwidth-%fheight-%fquality-%f.jpg", uniquie_id, size.width, size.height, quality];
}

- (NSString*)filePathWithSize:(CGSize)size andQuality:(float)quality relative:(BOOL)relative
{
    NSString* file_path = [tmp_folder_path stringByAppendingPathComponent:[self fileNameWithSize:size andQuality:quality]];
    if (relative) {
        NSString* root_path = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
        file_path = [file_path stringByReplacingOccurrencesOfString:root_path withString:@".."];
    }
    
    return file_path;
}

- (NSString*)cacheForReuse
{
    if (!uuid_string) {
        uuid_string = [self generateUUID];
    }
    
    NSString* file_name = [uuid_string stringByAppendingPathExtension:@"png"];
    file_name = [cached_folder_path stringByAppendingPathComponent:file_name];
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    BOOL file_exists = [filemanager fileExistsAtPath:file_name];
    
    if (!file_exists) {
        NSData* image_data = UIImagePNGRepresentation([self fullSizedWithQuality:MAXIMUM_ABImage_QUALITY]);
        
        if (!image_data) {
            return Nil;
        }
        
        [[NSFileManager defaultManager] createFileAtPath:file_name
                                                contents:nil attributes:nil];
        
        [image_data writeToFile:file_name atomically:YES];
    }
    
    return uuid_string;
}

- (UIImage*)getUIImageFromCache:(NSString*)uuid
{
    if (!uuid.length) {
        return Nil;
    }
    
    NSString* file_name = [uuid stringByAppendingPathExtension:@"png"];
    file_name = [cached_folder_path stringByAppendingPathComponent:file_name];
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    BOOL file_exists = [filemanager fileExistsAtPath:file_name];
    
    UIImage* response;
    
    if (file_exists) {
        NSString* root_path = [[[NSBundle mainBundle] bundlePath] stringByDeletingLastPathComponent];
        file_name = [file_name stringByReplacingOccurrencesOfString:root_path withString:@".."];
        response = [UIImage imageNamed:file_name];
    }
    
    return response;
}

- (void)removeFromCache
{
    if (!uuid_string) {
        return;
    }
    
    NSString* file_name = [uuid_string stringByAppendingPathExtension:@"png"];
    file_name = [cached_folder_path stringByAppendingPathComponent:file_name];
    
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    [filemanager removeItemAtPath:file_name error:Nil];
    
    uuid_string = Nil;
}

- (NSString*)generateUUID
{
    CFUUIDRef uuid = CFUUIDCreate(NULL);
    NSString *uuid_str = (NSString *)CFBridgingRelease(CFUUIDCreateString(NULL, uuid));
    
    return uuid_str;
}

- (void)clearTmp:(BOOL)including_initial_image
{
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    if (including_initial_image) {
        
        [filemanager removeItemAtPath:tmp_folder_path error:Nil];
        
        return;
    }
    
    NSString* full_sized_file_name = [self fileNameWithSize:full_Size andQuality:MAXIMUM_ABImage_QUALITY];
    NSDirectoryEnumerator* en = [filemanager enumeratorAtPath:tmp_folder_path];
    NSString* file;
    while (file = [en nextObject]) {
        if ([file isEqualToString:full_sized_file_name]) {
            continue;
        }
        
        [filemanager removeItemAtPath:[tmp_folder_path stringByAppendingPathComponent:file] error:Nil];
    }
}

+ (void)clearAllTmpFoldersAndFiles
{
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString* tmp_folder_directory = [paths lastObject];
    
    tmp_folder_directory = [tmp_folder_directory stringByAppendingPathComponent:TEMPORARY_AB_IMAGES];
    
    [filemanager removeItemAtPath:tmp_folder_directory error:Nil];
}

+ (void)clearAllCachedFiles
{
    NSFileManager* filemanager = [NSFileManager defaultManager];
    
    NSArray* paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString* documents_directory = [paths lastObject];
    
    documents_directory = [documents_directory stringByAppendingPathComponent:CACHED_AB_IMAGES];
    
    [filemanager removeItemAtPath:documents_directory error:Nil];
}

@end
