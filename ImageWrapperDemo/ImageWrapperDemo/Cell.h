//
//  Cell.h
//  ImageWrapperDemo
//
//  Created by Alexandr Barenboim on 03.08.13.
//  Copyright (c) 2013 Alexandr Barenboym. All rights reserved.
//

#import "ABImageWrapper.h"

@interface Cell : UICollectionViewCell

@property UIImageView* background_photo;

- (void)setImage:(ABImageWrapper*)wrapper;

@end
