package com.zhuomogroup.ylyk.activity;

import android.annotation.SuppressLint;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v4.widget.NestedScrollView;
import android.support.v7.app.AlertDialog;
import android.support.v7.widget.LinearLayoutManager;
import android.support.v7.widget.RecyclerView;
import android.view.MotionEvent;
import android.view.View;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.reactmodules.callback.BaseStringCallback;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.adapter.YLLearnListAdapter;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.bean.ReactRequestBean;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.popupwindow.YLSharePopupWindow;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhuomogroup.ylyk.views.ScrollTextView;
import com.zhy.autolayout.AutoRelativeLayout;
import com.zhy.http.okhttp.OkHttpUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Date;
import java.util.Map;
import java.util.TreeMap;

import butterknife.BindView;
import butterknife.ButterKnife;
import butterknife.OnClick;
import okhttp3.Call;

import static com.zhuomogroup.ylyk.R.id.learn_alltime;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_401;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;

/**
 * Created by xyb on 2017/3/17.
 */

public class YLLearnPathActivity extends YLBaseActivity {


    public static final int SE2MIN = 60;
    public static final String TITLE = "学习轨迹";
    public static final String INTENT_LEARN_PATH = "INTENT_LEARN_PATH";
    @BindView(R.id.back_img)
    ImageView backImg;
    @BindView(R.id.play_share)
    ImageView playShare;
    @BindView(R.id.title_center_text)
    ScrollTextView titleCenterText;
    @BindView(R.id.play_download)
    ImageView playDownload;
    @BindView(R.id.min_text)
    TextView minText;
    @BindView(R.id.center_oral)
    AutoRelativeLayout centerOral;
    @BindView(learn_alltime)
    TextView learnAlltime;
    @BindView(R.id.learn_alltime_lin)
    LinearLayout learnAlltimeLin;
    @BindView(R.id.learn_allday)
    TextView learnAllday;
    @BindView(R.id.learn_allday_lay)
    LinearLayout learnAlldayLay;
    @BindView(R.id.center_re)
    AutoRelativeLayout centerRe;
    @BindView(R.id.view_center)
    View viewCenter;
    @BindView(R.id.view_left)
    View viewLeft;
    @BindView(R.id.text)
    TextView text;
    @BindView(R.id.view_right)
    View viewRight;
    @BindView(R.id.all_time_re)
    RelativeLayout allTimeRe;

    @BindView(R.id.null_network)
    RelativeLayout nullNetwork;
    @BindView(R.id.null_re)
    RelativeLayout nullRe;
    @BindView(R.id.loading_re)

    RelativeLayout loadingRe;

    @BindView(R.id.learn_line_re)

    RelativeLayout learnLineRe;
    @BindView(R.id.learm_more)
    RelativeLayout learmMore;
    @BindView(R.id.today_center_text)

    TextView todayCenterText;
    @BindView(R.id.recycler_view)
    RecyclerView recyclerView;
    @BindView(R.id.scrollView)
    NestedScrollView scrollView;
    private int userId;
    private TreeMap<Long, JSONObject> map;
    private ArrayList<JSONObject> jsonObjects = new ArrayList<JSONObject>();
    private YLLearnListAdapter ylLearnListAdapter;
    private String intentLearnPath = null;
    private boolean isToday = false;
    private int alltime;
    private YLSharePopupWindow sharePopupWindow;

    @Override
    public int bindLayout() {
        return R.layout.activity_learnpath;
    }

    @Override
    public void initView(View view) {
        ButterKnife.bind(this);
    }

    @Override
    public void doBusiness(final Context mContext) {
        ylLearnListAdapter = new YLLearnListAdapter(this, jsonObjects);
        LinearLayoutManager linearLayoutManager = new LinearLayoutManager(this);
        recyclerView.setFocusable(false);
        linearLayoutManager.setSmoothScrollbarEnabled(true);
        linearLayoutManager.setAutoMeasureEnabled(true);
        recyclerView.setLayoutManager(linearLayoutManager);
        recyclerView.setHasFixedSize(true);
        recyclerView.setNestedScrollingEnabled(false);
        recyclerView.setAdapter(ylLearnListAdapter);
        backImg.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                finish();
            }
        });
        playShare.setVisibility(View.VISIBLE);

        titleCenterText.setText(TITLE);
        Intent intent = getIntent();
        if (intent != null) {
            intentLearnPath = intent.getStringExtra(INTENT_LEARN_PATH);
            @SuppressLint("SimpleDateFormat") SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
            String format = dateFormat.format(new Date());
            if (format.equals(intentLearnPath)) {
                isToday = true;
                allTimeRe.setVisibility(View.VISIBLE);
                learnLineRe.setVisibility(View.VISIBLE);
                todayCenterText.setText("今日学习");
            } else {
                isToday = false;
                @SuppressLint("SimpleDateFormat") SimpleDateFormat date = new SimpleDateFormat("yyyy年MM月dd日");
                try {
                    Date parse = dateFormat.parse(intentLearnPath);
                    String today_center = date.format(parse);
                    todayCenterText.setText(today_center.substring(5) + "学习");
                } catch (ParseException e) {
                    e.printStackTrace();
                }
            }
            try {
                Date parse = dateFormat.parse(intentLearnPath);
                final long startTime = parse.getTime() / 1000L;
                final long endTime = startTime + (24 * 60 * 60L);
                String userInfo = (String) SharedPreferencesUtil.get(this, USER_INFO, "");
                if (!"".equals(userInfo)) {
                    JSONObject jsonObject = new JSONObject(userInfo);
                    userId = jsonObject.getInt("id");
                    TreeMap<String, String> treeMap = new TreeMap<>();
                    treeMap.put("start_time", startTime + "");
                    treeMap.put("end_time", endTime + "");
                    OkHttpUtils.get()
                            .url(BASE_URL_HEAD + "user/" + userId + "/trace" + Signature.UrlSignature(treeMap))
                            .headers(Signature.UrlHeaders(this))
                            .build()
                            .execute(new BaseStringCallback() {
                                @Override
                                public void onError(Call call, Exception e, int id) {
                                    loadingRe.setVisibility(View.GONE);
                                    nullRe.setVisibility(View.GONE);
                                    scrollView.setVisibility(View.GONE);
                                    nullNetwork.setVisibility(View.VISIBLE);
                                }

                                @Override
                                public void onResponse(String response, int id) {
                                    map = new TreeMap<Long, JSONObject>(new Comparator<Long>() {
                                        @Override
                                        public int compare(Long o1, Long o2) {
                                            return o2.compareTo(o1);
                                        }
                                    });
                                    try {
                                        JSONObject jsonObject1 = new JSONObject(response);
                                        boolean result = jsonObject1.getBoolean("result");
                                        int listen_time = 0;
                                        if (result) {
                                            response = jsonObject1.getString("response");
                                            JSONArray jsonArray = new JSONArray(response);
                                            for (int i = 0; i < jsonArray.length(); i++) {
                                                JSONObject json = jsonArray.getJSONObject(i);
                                                long in_time = json.getLong("in_time");
                                                JSONObject jsonNow = new JSONObject();
                                                jsonNow.put("type", "learn");
                                                jsonNow.put("json", json);
                                                int listened_time = json.getInt("listened_time");
                                                listen_time += listened_time;
                                                if (listened_time > SE2MIN) {
                                                    map.put(in_time, jsonNow);
                                                }
                                            }
                                            alltime = listen_time / SE2MIN;
                                            minText.setText(alltime + "");

                                            initTipsMap(startTime, endTime);
                                        } else {
                                            int code = jsonObject1.getInt("code");
                                            if (code == HTTP_CODE_401) {
                                                AlertDialog.Builder buy_dialog = new AlertDialog.Builder(YLLearnPathActivity.this);
                                                buy_dialog.setTitle("登陆失效");
                                                buy_dialog.setMessage("您的登录已失效,请重新登录");
                                                buy_dialog.setNegativeButton("重新登录", new DialogInterface.OnClickListener() {
                                                    @Override
                                                    public void onClick(DialogInterface dialog, int which) {
                                                        dialog.dismiss();
                                                        Intent intent = new Intent(getApplicationContext(), YLLoginActivity.class);
                                                        startActivity(intent);
                                                        finish();
                                                    }
                                                });
                                                AlertDialog alertDialog = buy_dialog.create();
                                                if (!alertDialog.isShowing()) {
                                                    alertDialog.show();
                                                }

                                            }
                                        }
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                }
                            });
                    OkHttpUtils.get()
                            .url(BASE_URL_HEAD + "user/" + userId + Signature.UrlSignature())
                            .headers(Signature.UrlHeaders(this))
                            .build()
                            .execute(new BaseStringCallback() {
                                @Override
                                public void onError(Call call, Exception e, int id) {
                                    e.printStackTrace();
                                    loadingRe.setVisibility(View.GONE);
                                    nullRe.setVisibility(View.GONE);
                                    scrollView.setVisibility(View.GONE);
                                    nullNetwork.setVisibility(View.VISIBLE);
                                }

                                @Override
                                public void onResponse(String response, int id) {
                                    Gson gson = new Gson();
                                    ReactRequestBean myRequestBean = gson.fromJson(response, ReactRequestBean.class);
                                    if (myRequestBean.isResult()) {
                                        response = myRequestBean.getResponse();
                                        try {
                                            JSONObject object = new JSONObject(response);
                                            JSONObject stat = object.getJSONObject("stat");
                                            int listened_time = stat.getInt("listened_time");
                                            int signin_period = stat.getInt("signin_period");
                                            learnAlltime.setText((listened_time / SE2MIN) + "");
                                            learnAllday.setText(signin_period + "");
                                        } catch (JSONException e) {
                                            e.printStackTrace();
                                        }

                                    } else {
                                        Toast.makeText(mContext, "myRequestBean.getCode():" + myRequestBean.getCode(), Toast.LENGTH_SHORT).show();
                                    }

                                }
                            });
                }

            } catch (ParseException | JSONException e) {
                e.printStackTrace();
            }
        }

    }

    private void initTipsMap(long start_time, long end_time) {
        TreeMap<String, String> treeMap = new TreeMap<>();
        treeMap.put("start_time", start_time + "");
        treeMap.put("end_time", end_time + "");
        treeMap.put("user_id", userId + "");
        OkHttpUtils.get()
                .url(BASE_URL_HEAD + "note" + Signature.UrlSignature(treeMap))
                .headers(Signature.UrlHeaders(this))
                .build()
                .execute(new BaseStringCallback() {
                    @Override
                    public void onError(Call call, Exception e, int id) {
                        loadingRe.setVisibility(View.GONE);
                        nullRe.setVisibility(View.GONE);
                        scrollView.setVisibility(View.GONE);
                        nullNetwork.setVisibility(View.VISIBLE);
                    }

                    @Override
                    public void onResponse(String response, int id) {
                        try {
                            JSONObject jsonObject1 = new JSONObject(response);
                            boolean result = jsonObject1.getBoolean("result");
                            if (result) {
                                response = jsonObject1.getString("response");
                                JSONArray jsonArray = new JSONArray(response);
                                for (int i = 0; i < jsonArray.length(); i++) {
                                    JSONObject json = jsonArray.getJSONObject(i);
                                    long in_time = json.getLong("in_time");
                                    JSONObject jsonNow = new JSONObject();
                                    jsonNow.put("type", "tips");
                                    jsonNow.put("json", json);
                                    map.put(in_time, jsonNow);
                                }
                                jsonObjects.clear();
                                for (Map.Entry<Long, JSONObject> longJSONObjectEntry : map.entrySet()) {
                                    jsonObjects.add(longJSONObjectEntry.getValue());
                                }
                                ylLearnListAdapter.setJsonObjects(jsonObjects);
                                loadingRe.setVisibility(View.GONE);
                                if (jsonObjects.size() > 0) {
                                    nullRe.setVisibility(View.GONE);
                                    scrollView.setVisibility(View.VISIBLE);
                                }
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                });

    }

    @Override
    public void resume() {

    }

    @Override
    public void destroy() {

    }


    @OnClick({R.id.back_img, R.id.learm_more, R.id.play_share})
    public void onClick(View view) {
        switch (view.getId()) {
            case R.id.back_img:
                break;
            case R.id.learm_more:
                break;
            case R.id.play_share:
                JSONObject jsonObject = new JSONObject();
                try {
                    if (userId != 0 && intentLearnPath != null) {
                        String date = intentLearnPath.replaceAll("-", "");
                        String url = "http://m.youlinyouke.com/share/user/" + userId + "/trace.html?date=" + date;
                        if (isToday) {
                            jsonObject.put("title", "我今天在友邻优课学习了" + alltime + "分钟。学无用的英文，做自由的灵魂。");
                        } else {
                            String substring = intentLearnPath.substring(5);
                            jsonObject.put("title", "我" + substring + "在友邻优课学习了" + alltime + "分钟。学无用的英文，做自由的灵魂。");
                        }
                        jsonObject.put("url", url);
                        jsonObject.put("courseId", "title");

                        sharePopupWindow = new YLSharePopupWindow(this, jsonObject.toString());
                        sharePopupWindow.showPopwindow(this);
                    }

                } catch (JSONException e) {
                    e.printStackTrace();
                }
                break;
        }
    }


    @Override
    public boolean onTouchEvent(MotionEvent event) {
        if (sharePopupWindow != null) {
            sharePopupWindow.dismissPopupWindow(this);
        }

        return super.onTouchEvent(event);
    }
}
