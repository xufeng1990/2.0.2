package com.reactmodules.request;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;

import org.json.JSONArray;
import org.json.JSONObject;

import static com.reactmodules.consts.ModuleName.YLYK_FANS_SERVICE_MODULE;
import static com.reactmodules.request.YLBaseService.GET;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKFansServiceModule extends ReactContextBaseJavaModule {


    private YLBaseService service;

    public YLYKFansServiceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        service = new YLBaseService(reactContext.getApplicationContext());
    }

    @Override
    public String getName() {
        return YLYK_FANS_SERVICE_MODULE;
    }

    /**
     * 获取指定用户的粉丝列表
     *
     * @param promise
     */
    @ReactMethod
    public void getFansList(ReadableMap addressJson, Promise promise) {
        try {


            String nativeString =   service.getNativeString((ReadableNativeMap) addressJson);
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json

            JSONObject query = new JSONObject(nativeString);// 参数

            JSONArray url = new JSONArray();//url 数组

            url.put("fans");
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
