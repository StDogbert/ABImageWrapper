//  ABImageWrapper.h
//  Created by Alexandr Barenboim on 18.01.13.

#define MAXIMUM_ABImage_QUALITY 1.0
#define SMALL_ABWIDTH 70.0
#define MEDIUM_ABWIDTH 200.0

@interface ABImageWrapper : NSObject

+ (id)createWithUIImage:(UIImage*)image;

+ (id)createWithCacheID:(NSString*)cache_id;

- (id)initWithCacheID:(NSString*)cache_id;

- (id)initWithUIImage:(UIImage*)image;

- (void)fillWithImage:(UIImage*)image;

- (UIImage*)fullSized;

- (UIImage*)fullSizedWithQuality:(float)quality;

- (UIImage*)smallSize;

- (UIImage*)smallSizeWithQuality:(float)quality;

- (UIImage*)mediumSize;

- (UIImage*)mediumSizeWithQuality:(float)quality;

- (UIImage*)customSize:(CGSize)size;

- (UIImage*)customSize:(CGSize)size withQuality:(float)quality;

- (NSString*)cacheForReuse;


//Due to lazy loading nature of UIImage image named UIImage objects created with wrapper methods will be initialized only when actually needed(rendered or manualy used). This means that in case source files for created UIImages will be deleted image cache will fail to display and handle those images, which will result in different warnings and also your images will be lost and displayed like black squares in best case. This is also the reason why dealoc method doesn't remove tmp folder. So use methods for clearing cache and temp folders very carefully. If you are sure you don't need wrapper object and UIImages created by it - feel free to clear tmp folder. Tmp folder is recreated at each app laucnh. If you want to force clear it at some point and free storage memory - you can use method + (void)clearAllTmpFoldersAndFiles

//Tmp folder is recreated at each app laucnh. If you want to force clear it at some point and free storage memory - you can use method + (void)clearAllTmpFoldersAndFiles
+ (void)clearAllTmpFoldersAndFiles;

+ (void)clearAllCachedFiles;

- (void)removeFromCache;

- (void)clearTmp:(BOOL)including_initial_image;

@end
