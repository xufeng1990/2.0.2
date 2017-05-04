package com.reactmodules.request;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;

import org.json.JSONArray;
import org.json.JSONObject;

import static com.reactmodules.consts.ModuleName.YLYK_ORDER_SERVICE_MODULE;
import static com.reactmodules.request.YLBaseService.POST;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKOrderServiceModule extends ReactContextBaseJavaModule {
    private YLBaseService service;

    public YLYKOrderServiceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        service = new YLBaseService(reactContext.getApplicationContext());

    }

    @Override
    public String getName() {
        return YLYK_ORDER_SERVICE_MODULE;
    }


    @ReactMethod
    public void createOrder(ReadableMap readableMap, Promise promise) {
        try {
            String nativeString = service.getNativeString((ReadableNativeMap) readableMap);
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject(nativeString);// 主体json
            JSONObject query = new JSONObject();
            JSONArray url = new JSONArray();//url 数组
            url.put("order");
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
}
