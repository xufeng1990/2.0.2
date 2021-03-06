package com.zhuomogroup.ylyk.activity;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.Intent;
import android.os.Handler;
import android.os.Message;
import android.view.View;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.reactmodules.callback.BaseStringCallback;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.consts.YLBaseUrl;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.http.okhttp.OkHttpUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.TreeMap;

import okhttp3.Call;
import sun.bob.mcalendarview.listeners.OnDateClickListener;
import sun.bob.mcalendarview.listeners.OnMonthChangeListener;
import sun.bob.mcalendarview.views.ExpCalendarView;
import sun.bob.mcalendarview.vo.DateData;
import sun.bob.mcalendarview.vo.MarkedDates;

import static com.zhuomogroup.ylyk.network.Signature.UrlHeaders;
import static com.zhuomogroup.ylyk.network.Signature.UrlSignature;

/**
 * Created by xyb on 2017/3/16.
 */

public class YLCalendarActivity extends YLBaseActivity implements View.OnClickListener {


    public static final String FIRST_CALENDAR = "firstCalendar";
    public static final String TITLE = "学习日历";
    private Handler handler;

    private ExpCalendarView expCalendarView;
    private ArrayList<String> checkDays;
    public final static String INTENT_LEARN_PATH = "INTENT_LEARN_PATH";
    private ImageView calenderRight;
    private ImageView calenderLeft;
    private ImageView backImg;
    private TextView mouthDay;
    private TextView titleCenterText;
    private String[] mouths = {"Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"};
    private ImageView firstCalendar;
    private int[] imgArr = {R.drawable.first_calendar, R.drawable.two_calendar};
    private int imgPosition = 0;


    @Override
    public int bindLayout() {
        return R.layout.activity_calendar;
    }

    @Override
    public void initView(View view) {
        expCalendarView = ((ExpCalendarView) view.findViewById(R.id.calendar_exp));
        calenderRight = ((ImageView) view.findViewById(R.id.calender_right));
        calenderLeft = ((ImageView) view.findViewById(R.id.calender_left));
        firstCalendar = ((ImageView) view.findViewById(R.id.first_calendar));
        backImg = ((ImageView) view.findViewById(R.id.back_img));
        mouthDay = ((TextView) view.findViewById(R.id.mouth_day));
        titleCenterText = ((TextView) view.findViewById(R.id.title_center_text));

    }

    @Override
    public void doBusiness(Context mContext) {
        initHandler();

        boolean isFirst = (boolean) SharedPreferencesUtil.get(this, FIRST_CALENDAR, true);

        if (isFirst) {
            firstCalendar.setVisibility(View.VISIBLE);
            imgPosition = 0;
        } else {
            firstCalendar.setVisibility(View.GONE);
        }

        checkDays = new ArrayList<>();
        Calendar calendar = Calendar.getInstance();
        final int thisYear = calendar.get(Calendar.YEAR);
        final int thisMonth = calendar.get(Calendar.MONTH) + 1;
        final int thisDay = calendar.get(Calendar.DAY_OF_MONTH);

        calenderRight.setOnClickListener(this);
        calenderLeft.setOnClickListener(this);
        backImg.setOnClickListener(this);
        firstCalendar.setOnClickListener(this);

        titleCenterText.setText(TITLE);
        mouthDay.setText(mouths[thisMonth - 1] + ", " + thisYear);


        Message message = new Message();
        message.arg1 = thisYear;
        message.arg2 = thisMonth;
        message.what = 0;
        handler.sendMessage(message);

        expCalendarView.setOnDateClickListener(new OnDateClickListener() {
            @Override
            public void onDateClick(View view, DateData date) {
                String clickDate = date.getYear() + "-" + date.getMonth() + "-" + date.getDay();
                @SuppressLint("SimpleDateFormat") SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
                try {
                    Date parse = dateFormat.parse(clickDate);
                    String format = dateFormat.format(parse);
                    String today = thisYear + "-" + thisMonth + "-" + thisDay;
                    Date todayDate = dateFormat.parse(today);
                    String todayFormat = dateFormat.format(todayDate);
                    long todayTime = todayDate.getTime() + (8 * 60 * 60L);
                    if (parse.getTime() <= todayTime) {
                        Intent intent = new Intent(getApplicationContext(), YLLearnPathActivity.class);
                        intent.putExtra(INTENT_LEARN_PATH, format);
                        startActivity(intent);
                    } else {
                        Toast.makeText(getApplicationContext(), R.string.next_day, Toast.LENGTH_SHORT).show();
                    }
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
        });
        expCalendarView.setOnMonthChangeListener(new OnMonthChangeListener() {
            @Override
            public void onMonthChange(int year, int month) {

                ArrayList<DateData> all = MarkedDates.getInstance().getAll();
                if (all != null && all.size() > 0) {
                    MarkedDates.getInstance().removeAdd();
                }
                mouthDay.setText(mouths[month - 1] + ", " + year);

                Message message = new Message();
                message.arg1 = year;
                message.arg2 = month;
                message.what = 0;
                handler.sendMessageDelayed(message, 500);
            }
        });
    }

    private void initHandler() {
        handler = new Handler(new Handler.Callback() {
            @Override
            public boolean handleMessage(Message msg) {

                TreeMap<String, String> params = new TreeMap();
                params.put("year", msg.arg1 + "");
                params.put("month", msg.arg2 + "");
                OkHttpUtils.get()
                        .url(YLBaseUrl.BASE_URL_HEAD + "signin/" + UrlSignature(params))
                        .headers(UrlHeaders(getApplicationContext()))
                        .build().execute(new BaseStringCallback() {
                    @Override
                    public void onError(Call call, Exception e, int id) {
                        e.printStackTrace();
                    }

                    @Override
                    public void onResponse(String response, int id) {
                        try {
                            ArrayList<DateData> all = MarkedDates.getInstance().getAll();
                            if (all != null && all.size() > 0) {
                                MarkedDates.getInstance().removeAdd();
                            }
                            JSONObject jsonObject = new JSONObject(response);
                            boolean result = jsonObject.getBoolean("result");
                            if (result) {
                                response = jsonObject.getString("response");
                                JSONArray jsonArray = new JSONArray(response);
                                checkDays.clear();
                                for (int i = 0; i < jsonArray.length(); i++) {
                                    String string = jsonArray.getString(i);
                                    string = getYYYY_MM_DD(string);
                                    checkDays.add(string);
                                }
                                if (checkDays.size() > 0) {
                                    expCalendarView.markDate(checkDays);
                                }
                            } else {


                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                });
                return false;
            }
        });
    }

    /**
     * 取系统给定时间:返回值为如下形式
     * 2002-10-30
     *
     * @return String
     */
    public static String getYYYY_MM_DD(String date) {
        return date.substring(0, 10);

    }

    @Override
    public void resume() {

    }

    @Override
    public void destroy() {

    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.calender_right:
                expCalendarView.setCurrentItem(expCalendarView.getCurrentIndex() + 1);
                break;
            case R.id.calender_left:
                expCalendarView.setCurrentItem(expCalendarView.getCurrentIndex() - 1);
                break;
            case R.id.back_img:
                finish();
                break;
            case R.id.first_calendar:
                imgPosition++;
                if (imgPosition > 1) {
                    if (firstCalendar.getVisibility() == View.VISIBLE) {
                        firstCalendar.setVisibility(View.GONE);
                        SharedPreferencesUtil.put(this, FIRST_CALENDAR, false);
                    }
                } else {
                    firstCalendar.setImageResource(imgArr[imgPosition]);
                }

                break;
        }
    }
}
