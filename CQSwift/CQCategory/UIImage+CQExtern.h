//
//  UIImage+CQExtern.h
//  CQSwift
//
//  Created by llbt2019 on 2022/3/23.
//  Copyright © 2022 李超群. All rights reserved.
// 查看警告 CUICatalog: Invalid asset name supplied

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIImage (CQExtern)

+ (__kindof UIImage*)cq_imageNamed:(NSString*)imageName;

@end

NS_ASSUME_NONNULL_END
