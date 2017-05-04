package com.zhuomogroup.ylyk.utils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * Created by xyb on 2017/4/19.
 */

public class RegexUtil {
    /**
     * 验证手机号码
     *
     * @param phoneNumber 手机号码
     * @return boolean
     */
    public static boolean isMobilephoneNumber(String phoneNumber) {
        String regExp = "^[1][3,4,5,7,8]\\d{9}$";
        Pattern pattern = Pattern.compile(regExp);
        Matcher matcher = pattern.matcher(phoneNumber);
        return matcher.matches();
    }
}
