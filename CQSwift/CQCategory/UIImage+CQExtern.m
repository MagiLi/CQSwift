//
//  UIImage+CQExtern.m
//  CQSwift
//
//  Created by llbt2019 on 2022/3/23.
//  Copyright © 2022 李超群. All rights reserved.
//

#import "UIImage+CQExtern.h"
#import <objc/runtime.h>

@implementation UIImage (CQExtern)
// load方法是应用程序把这个类加载到内存的时候调用,
// 而且只会调用一次,所以在这个方法中实现方法的交换最合适

+ (void)load {
    
    // 交换方法实现,方法都是定义在类里面
    // class_getMethodImplementation:获取方法实现
    // class_getInstanceMethod:获取对象
    // class_getClassMethod:获取类方法
    // IMP:方法实现
    
    
    
    // Class:获取哪个类方法
    // SEL:获取方法编号,根据SEL就能去对应的类找方法
    // 获取系统的方法
    Method imageNameMethod = class_getClassMethod([self class],@selector(imageNamed:));
    
    
    // 获取自定义方法cq_imageNamed
    Method cq_imageNamedMethod = class_getClassMethod([UIImage class],@selector(cq_imageNamed:));
    
    // 交换方法实现
    method_exchangeImplementations(imageNameMethod, cq_imageNamedMethod);
    
}

+ (UIImage*)cq_imageNamed:(NSString*)imageName {
    // 1.恢复系统方法加载图片功能
    // 注意:这里不会死循环,因为此时已经交换了方法,调用这个方法,其实是调用系统的方法
    // 注意:这里调用系统的方法不能用super,因为在分类里面不能调用super,分类没有父类
    UIUserInterfaceIdiom style = [[UIDevice currentDevice] userInterfaceIdiom];
    if(style == UIUserInterfaceIdiomPhone){
        // iphone处理
        UIImage *image = [self cq_imageNamed:imageName];
        if(image != nil) {
            return image;
        }else{
            NSLog(@"加载image为空: %@", imageName);
            return nil;
        }
    }else{
        // ipad处理
        UIImage *image = [self cq_imageNamed:[NSString stringWithFormat:@"%@_ipad",imageName]];
        if(image !=nil) {
            return image;
        }else{
            image = [self cq_imageNamed:imageName];
            return image;
        }
    }
}

@end
