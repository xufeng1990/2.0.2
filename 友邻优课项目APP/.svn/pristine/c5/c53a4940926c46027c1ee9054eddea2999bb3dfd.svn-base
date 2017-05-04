package com.zhuomogroup.ylyk.utils;

import android.annotation.SuppressLint;

import java.io.UnsupportedEncodingException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Locale;
import java.util.TimeZone;

/**
 * Created by xyb on 2017/2/20 at 友邻优课 2017
 */

public class GMTTimeUtil {
    /***
     * 转成格林威治时间
     *
     * @param LocalDate
     * @return
     */
    public static String LocalToGMT(String LocalDate) {


        SimpleDateFormat format;
        format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss", Locale.ENGLISH);
        Date result_date;
        long result_time = 0;
        if (null == LocalDate) {
            return LocalDate;
        } else {
            try {
                format.setTimeZone(TimeZone.getDefault());
                result_date = format.parse(LocalDate);
                result_time = result_date.getTime();
                format.setTimeZone(TimeZone.getTimeZone("GMT00:00"));
                return format.format(result_time);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return LocalDate;
    }


    /**
     * 获取更改时区后的时间
     * <p>
     * date    时间
     * oldZone 旧时区
     * newZone 新时区
     *
     * @return 时间
     */
    public static String GetGMTZone() {
        try {
            Date date = new Date();
            TimeZone newZone = TimeZone.getTimeZone("GMT00:00");

            @SuppressLint("SimpleDateFormat") SimpleDateFormat formatter = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", Locale.US);
            formatter.setTimeZone(newZone);
            String dat = formatter.format(date);
            return getValueEncoded(dat);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }


    /**
     * 获取更改时区后的时间
     * <p>
     * date    时间
     * oldZone 旧时区
     * newZone 新时区
     *
     * @return 时间
     */
    public static String changeTimeZone() {
        try {
            Date date = new Date();
            TimeZone oldZone = TimeZone.getDefault();
            TimeZone newZone = TimeZone.getTimeZone("GMT00:00");
            Date dateTmp = null;
            if (date != null) {
                int timeOffset = oldZone.getRawOffset() - newZone.getRawOffset();
                dateTmp = new Date(date.getTime() - timeOffset);
            }
            @SuppressLint("SimpleDateFormat") SimpleDateFormat formatter = new SimpleDateFormat("EEE, dd MMM yyyy HH:mm:ss 'GMT'", Locale.US);
            String dateString = formatter.format(dateTmp);
            return getValueEncoded(dateString);
        } catch (Exception e) {
            e.printStackTrace();
        }
        return "";
    }

    //由于okhttp header 中的 value 不支持 null, \n 和 中文这样的特殊字符,所以这里
    //会首先替换 \n ,然后使用 okhttp 的校验方式,校验不通过的话,就返回 encode 后的字符串
    private static String getValueEncoded(String value) throws UnsupportedEncodingException {
        if (value == null) return "null";
        String newValue = value.replace("\n", "");
        for (int i = 0, length = newValue.length(); i < length; i++) {
            char c = newValue.charAt(i);
            if (c <= '\u001f' || c >= '\u007f') {
                return URLEncoder.encode(newValue, "UTF-8");
            }
        }
        return newValue;
    }
}
