package com.reactmodules.userinfo;

import android.app.Activity;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.zhuomogroup.ylyk.activity.YLMainActivity;

/**
 * Created by xyb on 2017/4/20.
 */

public class YLYKSplashScreenModule extends ReactContextBaseJavaModule {
    public YLYKSplashScreenModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return "SplashScreen";
    }


    /**
     * 将自己关闭
     */
    @ReactMethod
    public void hide() {
        final Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            if (currentActivity instanceof YLMainActivity) {
                currentActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        ((YLMainActivity) currentActivity).dismiss();
                    }
                });
            }
        }

    }
}
