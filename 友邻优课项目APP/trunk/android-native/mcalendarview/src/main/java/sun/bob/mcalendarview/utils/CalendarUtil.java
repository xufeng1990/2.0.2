package sun.bob.mcalendarview.utils;

import java.util.Calendar;

import sun.bob.mcalendarview.vo.DateData;

/**
 * Created by bob.sun on 15/8/27.
 */
public class CalendarUtil {
    public static DateData date = CurrentCalendar.getCurrentDateData();

    public static int position2Year(int pos) {
        int tmpYear, tmpMonth;
        Calendar c = Calendar.getInstance();
//        tmpYear = c.get(Calendar.YEAR);
        // TODO: 15/12/10 Maybe using current year is a mistake.
        tmpYear = date.getYear();
        tmpMonth = CalendarUtil.position2Month(pos);
        int ret;
        if (pos == 5) {
            return tmpYear;
        }
        if (pos > 5) {
            ret = tmpYear + ((pos - 5) + c.get(Calendar.MONTH)) / 12;
        } else {
            ret = tmpYear - ((5 - pos) + tmpMonth - 1) / 12;
        }
        return ret;
    }

    public static int position2Month(int pos) {
        int tmpMonth;
        Calendar c = Calendar.getInstance();
        tmpMonth = date.getMonth();
        int ret;
        if (pos == 5) {
            return tmpMonth;
        }
        if (pos > 5) {
            ret = (tmpMonth + (pos - 5) % 12) % 12;
        } else {
            ret = (tmpMonth - (5 - pos) % 12) % 12;
            ret = ret < 0 ? 12 + ret : ret;
        }
        return ret == 0 ? 12 : ret;
    }

    public static int getWeekCount(int position) {
        Calendar calendar = Calendar.getInstance();
        calendar.set(position2Year(position), position2Month(position) - 1, 1);
        int start = calendar.get(Calendar.DAY_OF_WEEK) - 1;
        int ret = calendar.getActualMaximum(Calendar.DAY_OF_MONTH) + start;
        int more = ret % 7 == 0 ? 0 : 1;
        ret = ret / 7 + more;
        calendar = null;
        return ret;
    }
}
