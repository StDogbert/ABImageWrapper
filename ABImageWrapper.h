//
//  ABImageWrapper.h
//  Jeremy
//
//  Created by Alexandr Barenboim on 18.01.13.
//  Copyright (c) 2013 GPIHolding. All rights reserved.
//

#define MAXIMUM_ABImage_QUALITY 1.0

@interface ABImageWrapper : NSObject

+ (id)createWithUIImage:(UIImage*)image;

- (id)initWithUIImage:(UIImage*)image;

- (UIImage*)fullSized;

- (UIImage*)fullSizedWithQuality:(float)quality;

- (UIImage*)smallSize;

- (UIImage*)smallSizeWithQuality:(float)quality;

- (UIImage*)mediumSize;

- (UIImage*)mediumSizeWithQuality:(float)quality;

- (UIImage*)customSize:(CGSize)size;

- (UIImage*)customSize:(CGSize)size withQuality:(float)quality;

@end
