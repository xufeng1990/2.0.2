package com.reactmodules.userinfo;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.zhuomogroup.ylyk.controller.QiYuActivityController;

import static com.reactmodules.consts.ModuleName.YLYK_QIYU_NATIVE_MODULE;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKQiyuNativeModule extends ReactContextBaseJavaModule {



    public YLYKQiyuNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return YLYK_QIYU_NATIVE_MODULE;
    }

    /**
     * 跳转到七鱼方法
     */
    @ReactMethod
    public void goToQiyu(Promise promise) {
        QiYuActivityController controller = new QiYuActivityController();
        controller.pushInterFace(getCurrentActivity());
    }
}
