//
//  YLYKHighlightingFontManager.h
//  ylyk
//
//  Created by 许锋 on 2017/4/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YLYKHighlightingFontManager : NSObject


+ (YLYKHighlightingFontManager *)shareInstance;

/*
 *获取需要标记高亮的字符串
 *@prama aString           需要被标记的字符串
 *@prama keyString         标记高亮的关键字
 *@prama font              要被标记的字体大小
 *@prama highlightingColor 标记高亮字体颜色
 */
- (NSMutableAttributedString *)getHiglightingFontString:(NSString *)aString keyString:(NSString *)keyString font:(UIFont *)font highlightingColor:(UIColor *)highlightingColor;


@end
