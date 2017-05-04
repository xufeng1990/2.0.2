//
//  YLYKHighlightingFontManager.m
//  ylyk
//
//  Created by 许锋 on 2017/4/24.
//  Copyright © 2017年 友邻优课. All rights reserved.
//

#import "YLYKHighlightingFontManager.h"

@interface YLYKHighlightingFontManager() {
    UIFont *_font; /** 字体大小  **/
    UIColor *_highlightingColor;/** 高亮字体字体颜色  **/
}
@end

@implementation YLYKHighlightingFontManager


+ (YLYKHighlightingFontManager *)shareInstance {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

/*
 *获取需要标记高亮的字符串
 *@prama aString           需要被标记的字符串
 *@prama keyString         标记高亮的关键字
 *@prama font              要被标记的字体大小
 *@prama highlightingColor 标记高亮字体颜色
 */
- (NSMutableAttributedString *)getHiglightingFontString:(NSString *)aString keyString:(NSString *)keyString font:(UIFont *)font highlightingColor:(UIColor *)highlightingColor {
    _font = font;
    _highlightingColor = highlightingColor;
    NSMutableAttributedString *attributedStr = [[NSMutableAttributedString alloc]initWithString:aString];
    NSArray *keyStrArr = [keyString componentsSeparatedByString:@" "];
    for(int i = 0; i< keyStrArr.count; i++){
        NSString *keyStr = [keyStrArr objectAtIndex:i];
        
        NSMutableArray *chineseArr = [NSMutableArray arrayWithCapacity:2];
        NSMutableArray *englishArr = [NSMutableArray arrayWithCapacity:2];
        [self splitString:keyStr chineseArray:chineseArr englishArray:englishArr];
        
        //中文高亮
        for (int i= 0;i < chineseArr.count; i++) {
            
            attributedStr = [self getHiglightingFontString:attributedStr keyCNString:[chineseArr objectAtIndex:i]];
        }
        //英文高亮
        for (int j = 0;j < englishArr.count; j++) {
            attributedStr = [self getHiglightingFontString:attributedStr keyENString:[englishArr objectAtIndex:j]];
        }
    }
    return attributedStr;
}

/*
 *中文标记高亮关键字
 */
- (NSMutableAttributedString *)getHiglightingFontString:(NSMutableAttributedString *)aString keyCNString:(NSString *)keyCNString{
    NSRange keyCNStrRange = [aString.string rangeOfString:keyCNString];
    [aString setAttributes:@{NSForegroundColorAttributeName:_highlightingColor,
                                             NSFontAttributeName :_font
                                                          } range:keyCNStrRange];
    return aString;
}

/*
 *英文标记高亮关键字
 */
- (NSMutableAttributedString *)getHiglightingFontString:(NSMutableAttributedString *)aString keyENString:(NSString *)keyENString {
    NSMutableArray *keyENStrArr = [self getENWordArrFromString:aString.string keyENString:keyENString];
    aString = [self getHiglightingFontString:aString keyENArr:keyENStrArr];
    return aString;
}

/*
 *英文标记高亮关键字
 */
- (NSMutableAttributedString *)getHiglightingFontString:(NSMutableAttributedString *)aString
    keyENArr:(NSMutableArray *)keyENArr {
    NSRange keyENStrRange;
    NSString *keyENStr = @"";
    for (int i = 0; i < keyENArr.count; i++) {
        keyENStr      = [keyENArr objectAtIndex:i];
        keyENStrRange = [aString.string rangeOfString:keyENStr];
        [aString setAttributes:@{NSForegroundColorAttributeName:_highlightingColor,                  NSFontAttributeName :_font
                                                              } range:keyENStrRange];
    }
    return aString;
}

/*
 *查找包含该英文字符的单词数组
 */
- (NSMutableArray *)getENWordArrFromString:(NSString *)aString keyENString:(NSString *)keyENString {
    NSMutableArray *enWordArr = [NSMutableArray arrayWithCapacity:1];
    NSArray *aStrArr = [aString componentsSeparatedByString:@" "];
    NSString *tempStr = @"";
    for (int i = 0; i< aStrArr.count; i++) {
        tempStr = [aStrArr objectAtIndex:i];
        
        if ([tempStr containsString:keyENString]) {
            [enWordArr addObject:tempStr];
            return enWordArr;
        }
        NSRange range;
        NSString *containStr = @"";
        for (int j = 0; j < keyENString.length; j++) {
            range = NSMakeRange(j, 1);
            containStr = [keyENString substringWithRange:range];
            if ([tempStr containsString:containStr]) {
                [enWordArr addObject:tempStr];
                return enWordArr;
            }
        }
    }
    return enWordArr;
}

/*
 *拆分字符串为中午和英文
 */
- (void)splitString:(NSString *)str chineseArray:(NSMutableArray *)chineseArr englishArray:(NSMutableArray *)englishArr {
    NSRange range ;
    NSMutableString *chinesStr  = [NSMutableString string];
    NSMutableString *englishStr = [NSMutableString string];
    
    for (int i = 0;i < str.length; i++) {
        range = NSMakeRange(i, 1);
        NSString *tempStr = [str substringWithRange:range];
        if ([self isChinese:tempStr]) {//是中文
            englishStr = [NSMutableString stringWithFormat:@""];
            [chinesStr appendString:tempStr];
            if (![chinesStr isEqualToString:@""] && [englishStr isEqualToString:@""]) {
                [chineseArr addObject:chinesStr];
            }
        } else {
            chinesStr  = [NSMutableString stringWithFormat:@""];
            [englishStr appendString:tempStr];
            if (![englishStr isEqualToString:@""] && [chinesStr isEqualToString:@""]) {
                [englishArr addObject:englishStr];
            }
        }
    }
    [self removeSameObj:chineseArr];
    [self removeSameObj:englishArr];
}

/*
 *去重
 */
- (void)removeSameObj:(NSMutableArray *)array {
    NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:16];
    NSMutableIndexSet *removeSet = [NSMutableIndexSet indexSet];
    int index = 0;
    
    for(id obj in array) {
        if(dict[obj] == nil) {
            dict[obj] = @YES;
        } else {
            [removeSet addIndex:index];
        }
        index++;
    }
    [array removeObjectsAtIndexes:removeSet];
}

/*
 *判断一个字符串是否有中文
 */
- (BOOL)isChinese:(NSString *)str {
    for (int i = 0; i < [str length]; i++) {
        int a = [str characterAtIndex:i];
        if( a > 0x4e00 && a < 0x9fff) {
            return YES;
        }
    }
    return NO;
}

@end
