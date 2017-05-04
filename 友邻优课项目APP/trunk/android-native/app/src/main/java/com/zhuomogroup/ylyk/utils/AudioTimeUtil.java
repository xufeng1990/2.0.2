package com.zhuomogroup.ylyk.utils;

/**
 * Created by xyb on 2017/2/23 at 友邻优课 2017
 * 秒换算成  时 分 秒
 */

public class AudioTimeUtil {
    /**
     *  换算成 00:00:00 格式
     * @param time 毫秒格式
     * @return
     */
    public static String secToTime(int time) {
        String timeStr = null;
        time = time / 1000;
        int hour = 0;
        int minute = 0;
        int second = 0;
        if (time <= 0)
            return "00:00";
        else {
            minute = time / 60;
            if (minute < 60) {
                second = time % 60;
                timeStr = unitFormat(minute) + ":" + unitFormat(second);
            } else {
                hour = minute / 60;
                if (hour > 99)
                    return "99:59:59";
                minute = minute % 60;
                second = time - hour * 3600 - minute * 60;
                timeStr = unitFormat(hour) + ":" + unitFormat(minute) + ":" + unitFormat(second);
            }
        }
        return timeStr;
    }


    private static String unitFormat(int i) {
        String retStr = null;
        if (i >= 0 && i < 10)
            retStr = "0" + Integer.toString(i);
        else
            retStr = "" + i;
        return retStr;
    }
}
