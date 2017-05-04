package com.reactmodules.controller;

import android.app.Activity;
import android.content.pm.ActivityInfo;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;

/**
 * Created by xyb on 2017/4/28.
 */

public class YLYLScreenChangeNativeModule extends ReactContextBaseJavaModule {
    public YLYLScreenChangeNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "YLYLScreenChangeNativeModule";
    }

    @ReactMethod
    public void landscapAction(){
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
                currentActivity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
            }
    }

    @ReactMethod
    public void portraitAction(){
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            currentActivity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
        }
    }

}
