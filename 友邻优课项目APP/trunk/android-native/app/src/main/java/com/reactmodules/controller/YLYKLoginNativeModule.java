package com.reactmodules.controller;

import android.app.Activity;
import android.content.Intent;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.zhuomogroup.ylyk.activity.YLLoginActivity;
import com.zhuomogroup.ylyk.activity.YLTelephoneChangeActivity;

import static com.reactmodules.consts.ModuleName.YLYK_LOGIN_NATIVE_MODULE;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKLoginNativeModule extends ReactContextBaseJavaModule {


    public YLYKLoginNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return YLYK_LOGIN_NATIVE_MODULE;
    }

    /**
     * 打开登录页面
     *
     * @param promise
     */
    @ReactMethod
    public void openLoginViewController(Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            Intent intent = new Intent(currentActivity, YLLoginActivity.class);
            currentActivity.startActivity(intent);
        }

    }

    /**
     * 打开登录页面
     *
     * @param promise
     */
    @ReactMethod
    public void changeBandPhoneNumber(Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            Intent intent = new Intent(currentActivity, YLTelephoneChangeActivity.class);
            currentActivity.startActivity(intent);
        }

    }
}
