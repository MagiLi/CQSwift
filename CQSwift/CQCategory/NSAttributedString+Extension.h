//
//  NSAttributedString+Extension.h
//  CQSwift
//
//  Created by llbt2019 on 2022/8/26.
//  Copyright © 2022 李超群. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSAttributedString (Extension)
- (NSArray *)pageRangeArrayWithConstrainedToSize:(CGSize)size;
@end

NS_ASSUME_NONNULL_END
