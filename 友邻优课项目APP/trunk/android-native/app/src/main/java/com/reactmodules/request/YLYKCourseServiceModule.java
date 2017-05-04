package com.reactmodules.request;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;

import org.json.JSONArray;
import org.json.JSONObject;

import static com.reactmodules.consts.ModuleName.YLYK_COURSE_SERVICE_MODULE;
import static com.reactmodules.request.YLBaseService.DELETE;
import static com.reactmodules.request.YLBaseService.GET;
import static com.reactmodules.request.YLBaseService.POST;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKCourseServiceModule extends ReactContextBaseJavaModule {


    private YLBaseService service;

    public YLYKCourseServiceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        service = new YLBaseService(reactContext.getApplicationContext());
    }

    @Override
    public String getName() {
        return YLYK_COURSE_SERVICE_MODULE;
    }

    /**
     * 获取课程列表
     *
     * @param queryJson
     * @param promise
     */
    @ReactMethod
    public void getCourseList(ReadableMap queryJson, Promise promise) {
        try {

            String nativeString =   service.getNativeString((ReadableNativeMap) queryJson);

            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject(nativeString);


            JSONArray url = new JSONArray();//url 数组

            url.put("course");


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
     * 获取指定课程的信息
     *
     * @param course_id
     * @param promise
     */
    @ReactMethod
    public void getCourseById(String course_id, Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject();


            JSONArray url = new JSONArray();//url 数组

            url.put("course");
            url.put(course_id);


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
     * 收藏指定的课程
     *
     * @param course_id
     * @param promise
     */
    @ReactMethod
    public void likeCourse(String course_id, Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject();


            JSONArray url = new JSONArray();//url 数组

            url.put("course");
            url.put(course_id);
            url.put("like");


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
     * 取消收藏指定的课程
     *
     * @param course_id
     * @param promise
     */
    @ReactMethod
    public void unlikeCourse(String course_id, Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject();


            JSONArray url = new JSONArray();//url 数组

            url.put("course");
            url.put(course_id);
            url.put("like");


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
