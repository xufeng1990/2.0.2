package com.reactmodules.request;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;

import org.json.JSONArray;
import org.json.JSONObject;

import static com.reactmodules.consts.ModuleName.YLYK_SIGNIN_SERVICE_MODULE;
import static com.reactmodules.request.YLBaseService.GET;
import static com.reactmodules.request.YLBaseService.POST;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKSigninServiceModule extends ReactContextBaseJavaModule {


    private YLBaseService service;

    public YLYKSigninServiceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        service = new YLBaseService(reactContext.getApplicationContext());
    }

    @Override
    public String getName() {
        return YLYK_SIGNIN_SERVICE_MODULE;
    }

    /**
     * 打卡
     *
     * @param promise
     */
    @ReactMethod
    public void createSignin(Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject();


            JSONArray url = new JSONArray();//url 数组

            url.put("signin");


            jsonObject.put("type", POST);
            jsonObject.put("url", url);
            jsonObject.put("query", query);
            jsonObject.put("body", body);

            service.baseService(promise, jsonObject);

        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取打卡日历
     *
     * @param queryJson
     * @param promise
     */
    @ReactMethod
    public void getSigninCalendar(ReadableMap queryJson, Promise promise) {
        try {

            String nativeString =   service.getNativeString((ReadableNativeMap) queryJson);

            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject(nativeString);


            JSONArray url = new JSONArray();//url 数组

            url.put("signin");


            jsonObject.put("type", GET);
            jsonObject.put("url", url);
            jsonObject.put("query", query);
            jsonObject.put("body", body);

            service.baseService(promise, jsonObject);

        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }
}
