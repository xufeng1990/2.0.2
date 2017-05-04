package com.reactmodules.setting;

import android.app.Activity;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.zhuomogroup.ylyk.utils.UserAgentUtil;

import static com.reactmodules.consts.ModuleName.YLYK_APPLICATION_NATIVE_MODULE;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKApplicationNativeModule extends ReactContextBaseJavaModule {


    public YLYKApplicationNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return YLYK_APPLICATION_NATIVE_MODULE;
    }

    /**
     * 获得构建版本code号
     *
     * @param promise
     */

    @ReactMethod
    public void getBuild(Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity == null) {
            promise.reject("999", "activity null");
            return;
        }
        int versionCode = UserAgentUtil.getVersionCode(currentActivity);
        promise.resolve(versionCode + "");
    }

    /**
     * 获得构建版本name
     *
     * @param promise
     */
    @ReactMethod
    public void getVersion(Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity == null) {
            promise.reject("999", "activity null");
            return;
        }
        String versionName = UserAgentUtil.getVersionName(currentActivity);
        promise.resolve(versionName);
    }
}
