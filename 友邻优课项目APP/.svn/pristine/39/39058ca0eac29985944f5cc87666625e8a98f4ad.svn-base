package com.reactmodules.storage;

import android.content.Context;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.reactmodules.request.YLBaseService;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Map;

import static com.reactmodules.consts.ModuleName.YLYK_KEY_VALUE_STORAGE_MODULE;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKKeyValueStorageModule extends ReactContextBaseJavaModule {
    private final Context context;
    private YLBaseService service;

    public YLYKKeyValueStorageModule(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext.getApplicationContext();
        service = new YLBaseService(reactContext.getApplicationContext());

    }

    @Override
    public String getName() {
        return YLYK_KEY_VALUE_STORAGE_MODULE;
    }

    /**
     * 获得key值相应的值
     *
     * @param key
     * @param promise
     */
    @ReactMethod
    public void getItem(String key, Promise promise) {
        try {
            if (context != null) {
                String result = (String) SharedPreferencesUtil.get(context, key, "");
                if ("".equals(result)) {
                    if (key.equals(USER_INFO)) {
                        promise.resolve("0");
                        return;
                    }
                    promise.reject("999", "getItem data is null ");
                } else {
                    promise.resolve(result);
                }

            }
        } catch (Exception e) {
            promise.reject(e);
            e.printStackTrace();
        }

    }

    /**
     * 设置key 内容
     *
     * @param key
     * @param value
     * @param promise
     */
    @ReactMethod
    public void setItem(String key, String value, Promise promise) {
        if (context != null) {
            SharedPreferencesUtil.put(context, key, value);
        }
    }

    /**
     * 删除item内容
     *
     * @param key
     * @param promise
     */
    @ReactMethod
    public void remove(String key, Promise promise) {
        if (context != null) {
            SharedPreferencesUtil.remove(context, key);

        }
    }

    /**
     * 清除所有key值
     *
     * @param promise
     */
    @ReactMethod
    public void clear(Promise promise) {
        if (context != null) {
            SharedPreferencesUtil.clear(context);
        }
    }

    /**
     * 获得所有key值
     *
     * @param promise
     */
    @ReactMethod
    public void getAllKeys(Promise promise) {
        if (context != null) {
            Map<String, ?> all = SharedPreferencesUtil.getAll(context);
            ArrayList arrayList = new ArrayList();
            for (Map.Entry<String, ?> stringEntry : all.entrySet()) {
                String key = stringEntry.getKey();
                arrayList.add(key);
            }
            String[] keys = new String[arrayList.size()];
            promise.resolve(Arrays.toString(keys));
        }

    }

}
