package com.reactmodules.callback;

import com.zhy.http.okhttp.callback.StringCallback;

import org.json.JSONException;
import org.json.JSONObject;

import java.io.IOException;

import okhttp3.Response;

/**
 * Created by xyb on 2017/3/13.
 */

public abstract class BaseStringCallback extends StringCallback {


    /**
     * 重写是否拦截错误返回
     *
     * @param response 请求数据信息
     * @param id       请求code
     * @return 返回是否拦截 true false
     */
    @Override
    public boolean validateReponse(Response response, int id) {
        return true;
    }

    /**
     * 解析网络响应方法 异步方法
     *
     * @param response 请求数据返回
     * @param id       请求code
     * @return 返回指定String 格式数据 JSON
     * @throws IOException 捕获body close异常
     */
    @Override
    public String parseNetworkResponse(Response response, int id) throws IOException {

        try {
            int code = response.code();
            String string = response.body().string();

            JSONObject object = new JSONObject();
            object.put("code", code);
            object.put("result", response.isSuccessful());
            object.put("response", string);
            return object.toString();
        } catch (JSONException e) {
            e.printStackTrace();
        }

        return null;
    }
}
