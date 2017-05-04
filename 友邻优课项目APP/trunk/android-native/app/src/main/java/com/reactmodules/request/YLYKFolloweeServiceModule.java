package com.reactmodules.request;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;

import org.json.JSONArray;
import org.json.JSONObject;

import static com.reactmodules.consts.ModuleName.YLYK_FOLLOWEE_SERVICE_MODULE;
import static com.reactmodules.request.YLBaseService.DELETE;
import static com.reactmodules.request.YLBaseService.GET;
import static com.reactmodules.request.YLBaseService.POST;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKFolloweeServiceModule extends ReactContextBaseJavaModule {


    private YLBaseService service;

    public YLYKFolloweeServiceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        service = new YLBaseService(reactContext.getApplicationContext());
    }

    @Override
    public String getName() {
        return YLYK_FOLLOWEE_SERVICE_MODULE;
    }

    /**
     * 获取指定用户的关注列表
     *
     * @param promise
     */
    @ReactMethod
    public void getFolloweeList(ReadableMap addressJson, Promise promise) {
        try {

            String nativeString =   service.getNativeString((ReadableNativeMap) addressJson);
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json

            JSONObject query = new JSONObject(nativeString);// 参数

            JSONArray url = new JSONArray();//url 数组

            url.put("followee");
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

    /**
     * 关注指定的用户
     *
     * @param promise
     */
    @ReactMethod
    public void createFollowee(ReadableMap addressJson, Promise promise) {
        try {
            String nativeString =   service.getNativeString((ReadableNativeMap) addressJson);
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject(nativeString);// 主体json

            JSONObject query = new JSONObject();// 参数

            JSONArray url = new JSONArray();//url 数组

            url.put("followee");


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
     * 取消关注指定的用户
     *
     * @param promise
     */
    @ReactMethod
    public void deleteFollowee(ReadableMap addressJson, Promise promise) {
        try {
            String nativeString =   service.getNativeString((ReadableNativeMap) addressJson);

            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject(nativeString);// 主体json

            JSONObject query = new JSONObject();// 参数

            JSONArray url = new JSONArray();//url 数组

            url.put("followee");


            jsonObject.put("type", DELETE);
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
