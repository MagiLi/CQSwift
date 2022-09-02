//
//  NSAttributeString+Extension.m
//  CQSwift
//
//  Created by llbt2019 on 2022/8/26.
//  Copyright © 2022 李超群. All rights reserved.
//

#import "NSAttributedString+Extension.h"
#import <CoreText/CoreText.h>

@implementation NSAttributedString (Extension)

- (NSArray *)pageRangeArrayWithConstrainedToSize:(CGSize)size {
    NSAttributedString *attributedString = self;
    NSMutableArray * resultRange = [NSMutableArray array];
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    
    //    以下方法耗时 基本再 0.5s 以内
    // NSDate * date = [NSDate date];
    NSInteger rangeIndex = 0;//剩余的字数
    do {
        NSUInteger length = MIN(600, attributedString.length - rangeIndex);
        NSAttributedString * childString = [attributedString attributedSubstringFromRange:NSMakeRange(rangeIndex, length)];
        CTFramesetterRef childFramesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef) childString);
        UIBezierPath * bezierPath = [UIBezierPath bezierPathWithRect:rect];
        CTFrameRef frame = CTFramesetterCreateFrame(childFramesetter, CFRangeMake(0, 0), bezierPath.CGPath, NULL);
        
        CFRange range = CTFrameGetVisibleStringRange(frame);
        NSRange r = {rangeIndex, range.length};
        if (r.length > 0) {
            [resultRange addObject:[NSValue valueWithRange:r]];
        }
        rangeIndex += r.length;
        CFRelease(frame);
        CFRelease(childFramesetter);
    } while (rangeIndex < attributedString.length && attributedString.length > 0); 
    return resultRange;
}

@end
