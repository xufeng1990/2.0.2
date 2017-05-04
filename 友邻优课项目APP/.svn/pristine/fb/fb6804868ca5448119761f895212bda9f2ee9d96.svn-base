package com.reactmodules.request;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;

import org.json.JSONArray;
import org.json.JSONObject;

import static com.reactmodules.consts.ModuleName.YLYK_USER_SERVICE_MODULE;
import static com.reactmodules.request.YLBaseService.GET;
import static com.reactmodules.request.YLBaseService.POST;
import static com.reactmodules.request.YLBaseService.PUT;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKUserServiceModule extends ReactContextBaseJavaModule {

    private YLBaseService service;

    public YLYKUserServiceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        service = new YLBaseService(reactContext.getApplicationContext());
    }

    @Override
    public String getName() {
        return YLYK_USER_SERVICE_MODULE;
    }

    /**
     * 获取推荐用户列表
     *
     * @param limit
     * @param promise
     */
    @ReactMethod
    public void getUserHotList(String limit, Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();
            JSONObject query = new JSONObject();
            JSONArray jsonArray = new JSONArray();
            jsonArray.put("user");
            if (!"".equals(limit)) {
                query.put("limit", limit);
            }
            query.put("is_hot", true);
            jsonObject.put("url", jsonArray);
            jsonObject.put("query", query);
            jsonObject.put("type", GET);
            service.baseService(promise, jsonObject);

        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }

    /**
     * 获取指定用户的信息
     *
     * @param user_id
     * @param promise
     */
    @ReactMethod
    public void getUserById(String user_id, final Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json

            JSONObject query = new JSONObject();// 参数

            JSONArray url = new JSONArray();//url 数组

            url.put("user");
            url.put(user_id);

            jsonObject.put("url", url);
            jsonObject.put("query", query);
            jsonObject.put("type", GET);
            service.baseService(promise, jsonObject);

        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /**
     * 修改指定用户的信息
     *
     * @param user_id
     * @param promise
     */
    @ReactMethod
    public void updateUser(String user_id, ReadableMap updateUserJson, final Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject(service.getNativeString((ReadableNativeMap) updateUserJson));// 主体json

            JSONObject query = new JSONObject();// 参数

            JSONArray url = new JSONArray();//url 数组

            url.put("user");
            url.put(user_id);

            jsonObject.put("url", url);
            jsonObject.put("query", query);
            jsonObject.put("type", PUT);
            jsonObject.put("body", body);
            service.baseService(promise, jsonObject);

        } catch (Exception e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /**
     * 修改指定用户的绑定手机
     *
     * @param user_id
     * @param promise
     */
    @ReactMethod
    public void updateUserMobilephone(String user_id, String mobilephone, String captcha, final Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json

            JSONObject query = new JSONObject();// 参数

            JSONArray url = new JSONArray();//url 数组

            url.put("user");
            url.put(user_id);
            url.put("mobilephone");
            body.put("mobilephone", mobilephone);
            if (!"".equals(captcha)) {
                body.put("captcha", captcha);
                jsonObject.put("type", PUT);
            } else {
                jsonObject.put("type", POST);
            }
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
     * 修改指定用户的代言人
     *
     * @param user_id
     * @param promise
     */
    @ReactMethod
    public void updateUserDealer(String user_id, String dealer_code, final Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json

            JSONObject query = new JSONObject();// 参数

            JSONArray url = new JSONArray();//url 数组

            url.put("user");
            url.put(user_id);
            url.put("dealer");

            body.put("dealer_code", dealer_code);

            jsonObject.put("type", PUT);
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
     * 获取指定用户的任务
     *
     * @param user_id
     * @param promise
     */
    @ReactMethod
    public void getUserTaskById(String user_id, final Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json

            JSONObject query = new JSONObject();// 参数

            JSONArray url = new JSONArray();//url 数组

            url.put("user");
            url.put(user_id);
            url.put("task");


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
