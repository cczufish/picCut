//
//  UIImage+Extensions.h
//  OCR
//
//  Created by ren6 on 2/14/13.
//  Copyright (c) 2013 ren6. All rights reserved.
//

//
//  UIImage-Extensions.h
//
//  Created by Hardy Macia on 7/1/09.
//  Copyright 2009 Catamount Software. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface UIImage (Extensions)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;
- (UIImage *)compressedImage;
- (UIImage *)compressedSmallImage ;

- (CGFloat)compressionQuality;

- (NSData *)compressedData;

- (NSData *)compressedData:(CGFloat)compressionQuality;

- (UIImage *)imageAtRect:(CGRect)rect;
- (UIImage *)imageByScalingProportionallyToMinimumSize:(CGSize)targetSize;
- (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize;
- (UIImage *)imageByScalingToSize:(CGSize)targetSize;
- (UIImage *)imageRotatedByRadians:(CGFloat)radians;
- (UIImage *)imageRotatedByDegrees:(CGFloat)degrees;
- (UIImage *)getImageFromImage:(UIImage*)bigImage;
- (UIImage *)getRatio_One_One:(UIImage *)convertImage;

@end;