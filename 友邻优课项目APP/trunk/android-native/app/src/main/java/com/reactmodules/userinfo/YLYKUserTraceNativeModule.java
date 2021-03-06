package com.reactmodules.userinfo;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.reactmodules.callback.BaseStringCallback;
import com.zhuomogroup.ylyk.activity.YLCalendarActivity;
import com.zhuomogroup.ylyk.activity.YLLearnPathActivity;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.http.okhttp.OkHttpUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.TreeMap;

import okhttp3.Call;

import static com.reactmodules.consts.ModuleName.YLYK_USER_TRACE_NATIVE_MODULE;
import static com.zhuomogroup.ylyk.activity.YLLearnPathActivity.INTENT_LEARN_PATH;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKUserTraceNativeModule extends ReactContextBaseJavaModule {

    private final Context mContext;

    public YLYKUserTraceNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        mContext = reactContext.getApplicationContext();
    }

    @Override
    public String getName() {
        return YLYK_USER_TRACE_NATIVE_MODULE;
    }

    /**
     * 获得学习时间
     *
     * @param startTime 学习开始时间
     * @param endTime   结束时间
     * @param promise
     * @throws JSONException
     */
    @ReactMethod
    public void getLearnTimeWithStartTime(String startTime, String endTime, final Promise promise) throws JSONException {
        String user_info = (String) SharedPreferencesUtil.get(mContext, USER_INFO, "");
        if (!"".equals(user_info)) {
            JSONObject jsonObject = new JSONObject(user_info);
            int userId = jsonObject.getInt("id");
            TreeMap<String, String> treeMap = new TreeMap<>();
            treeMap.put("start_time", startTime + "");
            treeMap.put("end_time", endTime + "");

            OkHttpUtils.get()
                    .url(BASE_URL_HEAD + "user/" + userId + "/trace" + Signature.UrlSignature(treeMap))
                    .headers(Signature.UrlHeaders(mContext))
                    .build()
                    .execute(new BaseStringCallback() {
                        @Override
                        public void onError(Call call, Exception e, int id) {
                            e.printStackTrace();
                            promise.reject(e);
                        }

                        @Override
                        public void onResponse(String response, int id) {
                            try {

                                JSONObject jsonObject1 = new JSONObject(response);
                                boolean result = jsonObject1.getBoolean("result");
                                int listen_time = 0;
                                if (result) {
                                    response = jsonObject1.getString("response");
                                    JSONArray jsonArray = new JSONArray(response);
                                    for (int i = 0; i < jsonArray.length(); i++) {
                                        JSONObject json = jsonArray.getJSONObject(i);
                                        int listened_time = json.getInt("listened_time");
                                        listen_time += listened_time;
                                    }
                                    promise.resolve(listen_time + "");
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                                promise.reject(e);
                            }
                        }
                    });
        } else {
            promise.resolve(0 + "");
        }
    }

    /**
     * 打开日历页面
     *
     * @param promise
     */
    @ReactMethod
    public void goToCalendar(Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            Intent intent = new Intent(currentActivity, YLCalendarActivity.class);
            currentActivity.startActivity(intent);
        }
    }

    /**
     * 打开日历页面
     *
     * @param promise
     */
    @ReactMethod
    public void openCalendarViewController(Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            Intent intent = new Intent(currentActivity, YLCalendarActivity.class);
            currentActivity.startActivity(intent);
        }
    }

    /**
     * 打开日历页面
     *
     * @param promise
     */
    @ReactMethod
    public void goToLearnPath(String format, Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            Intent intent = new Intent(currentActivity, YLLearnPathActivity.class);
            intent.putExtra(INTENT_LEARN_PATH, format);
            currentActivity.startActivity(intent);
        }
    }

    /**
     * 跳转到学习轨迹页面
     *
     * @param time
     */
    @ReactMethod
    public void goToListenTraceWithStartTime(String time) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            Intent intent = new Intent(currentActivity, YLLearnPathActivity.class);
            intent.putExtra(INTENT_LEARN_PATH, time);
            currentActivity.startActivity(intent);
        }
    }

}
