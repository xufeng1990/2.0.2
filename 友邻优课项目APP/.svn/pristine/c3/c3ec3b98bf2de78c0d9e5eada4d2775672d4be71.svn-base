package com.reactmodules.request;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

import org.json.JSONArray;
import org.json.JSONObject;

import static com.reactmodules.consts.ModuleName.YLYK_XDY_SERVICE_MODULE;
import static com.reactmodules.request.YLBaseService.GET;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKXdyServiceModule extends ReactContextBaseJavaModule {
    private YLBaseService service;

    public YLYKXdyServiceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        service = new YLBaseService(reactContext.getApplicationContext());
    }

    @Override
    public String getName() {
        return YLYK_XDY_SERVICE_MODULE;
    }

    @ReactMethod
    public void getXdyById(String xdyId, Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject();


            JSONArray url = new JSONArray();//url 数组

            url.put("xdy");
            url.put(xdyId);


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
