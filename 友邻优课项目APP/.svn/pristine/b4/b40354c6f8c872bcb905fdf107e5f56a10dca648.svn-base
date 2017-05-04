package com.reactmodules.request;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;

import org.json.JSONArray;
import org.json.JSONObject;

import static com.reactmodules.consts.ModuleName.YLYK_NOTE_SERVICE_MODULE;
import static com.reactmodules.request.YLBaseService.DELETE;
import static com.reactmodules.request.YLBaseService.GET;
import static com.reactmodules.request.YLBaseService.POST;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKNoteServiceModule extends ReactContextBaseJavaModule {


    private YLBaseService service;

    public YLYKNoteServiceModule(ReactApplicationContext reactContext) {
        super(reactContext);
        service = new YLBaseService(reactContext.getApplicationContext());
    }

    @Override
    public String getName() {
        return YLYK_NOTE_SERVICE_MODULE;
    }


    /**
     * 获取笔记列表
     *
     * @param queryJson
     * @param promise
     */
    @ReactMethod
    public void getNoteList(ReadableMap queryJson, Promise promise) {
        try {


            String nativeString =   service.getNativeString((ReadableNativeMap) queryJson);


            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject(nativeString);


            JSONArray url = new JSONArray();//url 数组

            url.put("note");


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
     * 获取指定笔记的信息
     *
     * @param note_id
     * @param promise
     */
    @ReactMethod
    public void getNoteById(String note_id, Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject();


            JSONArray url = new JSONArray();//url 数组

            url.put("note");
            url.put(note_id);


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
     * 图片上传
     *
     * @param note_id
     * @param promise
     */
    @ReactMethod
    public void createNote(String note_id, Promise promise) {
        // TODO: 2017/2/22 图片上传封装
    }

    /**
     * 删除指定的笔记
     *
     * @param note_id
     * @param promise
     */
    @ReactMethod
    public void deleteNote(String note_id, Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject();


            JSONArray url = new JSONArray();//url 数组

            url.put("note");
            url.put(note_id);


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

    /**
     * 点赞指定的笔记
     *
     * @param note_id
     * @param promise
     */
    @ReactMethod
    public void likeNote(String note_id, Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject();


            JSONArray url = new JSONArray();//url 数组

            url.put("note");
            url.put(note_id);
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
     * 点赞指定的笔记
     *
     * @param note_id
     * @param promise
     */
    @ReactMethod
    public void unlikeNote(String note_id, Promise promise) {
        try {
            JSONObject jsonObject = new JSONObject();// 主体json
            JSONObject body = new JSONObject();// 主体json
            JSONObject query = new JSONObject();


            JSONArray url = new JSONArray();//url 数组

            url.put("note");
            url.put(note_id);
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
