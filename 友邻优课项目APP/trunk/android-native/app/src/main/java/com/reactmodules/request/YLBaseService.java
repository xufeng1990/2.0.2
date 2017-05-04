package com.reactmodules.request;

import android.content.Context;
import android.support.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReadableNativeMap;
import com.reactmodules.callback.ServiceStringCallback;
import com.zhy.http.okhttp.OkHttpUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Iterator;
import java.util.Map;
import java.util.TreeMap;

import okhttp3.RequestBody;

import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLUrlSetting.JSON_MEDIA_TYPE;
import static com.zhuomogroup.ylyk.network.Signature.UrlHeaders;
import static com.zhuomogroup.ylyk.network.Signature.UrlSignature;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLBaseService {

    public static final String GET = "get";
    public static final String PUT = "put";
    public static final String DELETE = "delete";
    public static final String POST = "post";

    private Context context;

    public YLBaseService(Context context) {
        this.context = context;
    }

    /**
     * 获得 参数地址
     *
     * @param jsonObject
     * @return
     * @throws JSONException
     */
    @NonNull
    public String getBaseUrl(JSONObject jsonObject) throws JSONException {
        JSONArray url = jsonObject.getJSONArray("url");

        String baseUrl = "";
        for (int i = 0; i < url.length(); i++) {
            baseUrl = baseUrl + url.getString(i) + "/";
        }
        if (baseUrl.length() > 0) {
            baseUrl = baseUrl.substring(0, baseUrl.length() - 1);
        }
        return baseUrl;
    }


    /**
     * 获得排序map
     *
     * @param jsonObject1
     * @return
     * @throws JSONException
     */
    @NonNull
    public TreeMap<String, String> getParams(JSONObject jsonObject1) throws JSONException {
        JSONObject jsonObject = new JSONObject(jsonObject1.getString("query"));
        Iterator<String> keys = jsonObject.keys();
        TreeMap<String, String> params = new TreeMap<>();
        while (keys.hasNext()) {
            String key = (String) keys.next();
            params.put(key, jsonObject.getString(key));
        }
        return params;
    }


    public String getNativeString(ReadableNativeMap updateUserJson) throws JSONException {
        String string = updateUserJson.toString();
        JSONObject object = new JSONObject(string);
        JSONObject nativeMap1 = object.getJSONObject("NativeMap");

        return nativeMap1.toString();
    }


    /**
     * 无body 通用的get方法
     *
     * @param promise
     * @param jsonObject
     * @throws JSONException
     */
    public void baseService(Promise promise, JSONObject jsonObject) throws JSONException {
        String baseUrl = getBaseUrl(jsonObject);// 参数
        TreeMap<String, String> params = getParams(jsonObject);
        String urlData = "";
        if (params.size() > 0) {
            for (Map.Entry<String, String> stringStringEntry : params.entrySet()) {
                urlData += "&" + stringStringEntry.getKey() + "=" + stringStringEntry.getValue();
            }
            urlData = urlData.substring(1);
            urlData = "?" + urlData;
        }
        String type = jsonObject.getString("type");
        if (GET.equals(type)) {
            OkHttpUtils.get()
                    .url(BASE_URL_HEAD + baseUrl + UrlSignature(params))
                    .headers(UrlHeaders(context))
                    .build()
                    .execute(new ServiceStringCallback(promise, BASE_URL_HEAD + baseUrl + urlData, context));
        } else if (PUT.equals(type)) {
            RequestBody requestBody = RequestBody.create(JSON_MEDIA_TYPE,
                    jsonObject.getJSONObject("body").toString());
            OkHttpUtils.put()
                    .url(BASE_URL_HEAD + baseUrl + UrlSignature(params))
                    .headers(UrlHeaders(context))
                    .requestBody(requestBody)
                    .build()
                    .execute(new ServiceStringCallback(promise, context));
        } else if (DELETE.equals(type)) {
            RequestBody requestBody = RequestBody.create(JSON_MEDIA_TYPE,
                    jsonObject.getJSONObject("body").toString());
            OkHttpUtils.delete()
                    .url(BASE_URL_HEAD + baseUrl + UrlSignature(params))
                    .headers(UrlHeaders(context))
                    .requestBody(requestBody)
                    .build()
                    .execute(new ServiceStringCallback(promise, context));
        } else if (POST.equals(type)) {
            OkHttpUtils.postString()
                    .url(BASE_URL_HEAD + baseUrl + UrlSignature(params))
                    .headers(UrlHeaders(context))
                    .content(jsonObject.getJSONObject("body").toString())
                    .mediaType(JSON_MEDIA_TYPE)
                    .build()
                    .execute(new ServiceStringCallback(promise, context));
        }
    }
}
