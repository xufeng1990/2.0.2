package com.reactmodules.controller;

import android.app.Activity;
import android.content.Intent;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.zhuomogroup.ylyk.activity.YLSearchActivity;

import static com.reactmodules.consts.ModuleName.YLYK_SEARCH_NATIVE_MODULE;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKSearchNativeModule extends ReactContextBaseJavaModule {



    public YLYKSearchNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return YLYK_SEARCH_NATIVE_MODULE;
    }

    /**
     * 打开搜索页面
     *
     * @param promise
     */
    @ReactMethod
    public void goToSearchView(Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            Intent intent = new Intent(currentActivity, YLSearchActivity.class);
            currentActivity.startActivity(intent);
        }
    }
}
