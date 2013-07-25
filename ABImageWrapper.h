//  ABImageWrapper.h
//  Created by Alexandr Barenboim on 18.01.13.

#define MAXIMUM_ABImage_QUALITY 1.0

@interface ABImageWrapper : NSObject

+ (id)createWithUIImage:(UIImage*)image;

+ (id)createWithCacheID:(NSString*)cache_id;

- (id)initWithCacheID:(NSString*)cache_id;

- (id)initWithUIImage:(UIImage*)image;

- (UIImage*)fullSized;

- (UIImage*)fullSizedWithQuality:(float)quality;

- (UIImage*)smallSize;

- (UIImage*)smallSizeWithQuality:(float)quality;

- (UIImage*)mediumSize;

- (UIImage*)mediumSizeWithQuality:(float)quality;

- (UIImage*)customSize:(CGSize)size;

- (UIImage*)customSize:(CGSize)size withQuality:(float)quality;

- (NSString*)fileName;

- (NSString*)cacheForReuse;

@end
