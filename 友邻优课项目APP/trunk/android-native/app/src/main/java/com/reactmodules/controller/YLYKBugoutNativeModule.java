package com.reactmodules.controller;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.testin.agent.Bugout;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;

import static com.reactmodules.consts.ModuleName.YLYK_BUGOUT_NATIVE_MODULE;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.SHAKE_STATUS;

/**
 * Created by xyb on 2017/4/21.
 */

public class YLYKBugoutNativeModule extends ReactContextBaseJavaModule {



    public YLYKBugoutNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return YLYK_BUGOUT_NATIVE_MODULE;
    }

    @ReactMethod
    public void bugoutFeedbackState(Promise promise) {
        if (getCurrentActivity() != null) {
            boolean shakeStatus = Bugout.getShakeStatus(getCurrentActivity());
            promise.resolve(shakeStatus);
        }
    }

    @ReactMethod
    public void openOrCloseBugoutFeedBack(Boolean shakeStatus) {
        if (getCurrentActivity() != null) {
            SharedPreferencesUtil.put(getCurrentActivity(), SHAKE_STATUS,shakeStatus);
            Bugout.setShakeStatus(getCurrentActivity(), shakeStatus);
        }
    }
}
