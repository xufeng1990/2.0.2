package com.reactmodules.controller;

import android.app.Activity;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.zhuomogroup.ylyk.activity.YLMainActivity;

import org.greenrobot.eventbus.EventBus;

import static com.reactmodules.consts.ModuleName.YLYK_TABBAR_NATIVE_MODULE;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKTabbarNativeModule extends ReactContextBaseJavaModule {



    public YLYKTabbarNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return YLYK_TABBAR_NATIVE_MODULE;
    }

    /**
     * 显示或者隐藏 tabHost
     *
     * @param isShow true or false
     */
    @ReactMethod
    public void showOrHideTabbar(String isShow) {
        EventBus.getDefault().post(isShow);
    }

    @ReactMethod
    public void androidIsHaveBar(Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity instanceof YLMainActivity) {
            boolean showBar = ((YLMainActivity) currentActivity).isShowBar();
            promise.resolve(showBar);
        }

    }
}
