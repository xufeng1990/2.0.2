package com.zhuomogroup.ylyk.network;

import android.content.Context;

import com.zhuomogroup.ylyk.utils.EncryptionUtil;
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.utils.GMTTimeUtil;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhuomogroup.ylyk.utils.UserAgentUtil;

import java.util.HashMap;
import java.util.Map;
import java.util.TreeMap;

import static com.zhuomogroup.ylyk.consts.YLStorageKey.USERID_AUTHORIZATION;

/**
 * Created by xyb on 2017/2/20 at 友邻优课 2017
 */

public class Signature {
    /**
     * 多参数加密返回
     *
     * @param params
     * @return
     */
    public static String UrlSignature(TreeMap<String, String> params) {
        long timeMillis = System.currentTimeMillis() / 1000;
        int random = (int) (1 + Math.random() * (10000 - 1 + 1000));
        params.put("nonce", random + "");
        params.put("timestamp", timeMillis + "");
        String urlData = "";
        for (Map.Entry<String, String> stringStringEntry : params.entrySet()) {
            urlData += "&" + stringStringEntry.getKey() + "=" + stringStringEntry.getValue();
        }
        urlData = urlData.substring(1);
        String signature = EncryptionUtil.MD5(urlData);
        return "?" + urlData + "&signature=" + signature;
    }

    /**
     * 无参数加密返回
     *
     * @return
     */
    public static String UrlSignature() {
        long timeMillis = System.currentTimeMillis() / 1000;
        int random = (int) (1 + Math.random() * (10000 - 1 + 1000));
        String urlData = "nonce=" + random + "&timestamp=" + timeMillis;
        String signature = EncryptionUtil.MD5(urlData);
        return "?" + urlData + "&signature=" + signature;
    }

    /**
     * 添加公用请求头
     *
     * @param context
     * @return
     */
    public static Map<String, String> UrlHeaders(Context context) {
        HashMap<String, String> stringStringHashMap = new HashMap<>();
        stringStringHashMap.put("Content-Type", "application/json");
        stringStringHashMap.put("User-Agent", UserAgentUtil.getUserAgent(context) + UserAgentUtil.MANIFEST + UserAgentUtil.getVersionName(context));
        stringStringHashMap.put("X-Date", GMTTimeUtil.GetGMTZone());
        String Authorization = (String) SharedPreferencesUtil.get(context, USERID_AUTHORIZATION, MainApplication.BASE_AUTHORIZATION);
        stringStringHashMap.put("Authorization", "USERID " + Authorization);
//        stringStringHashMap.put("Connection", "close");
        return stringStringHashMap;
    }

}
