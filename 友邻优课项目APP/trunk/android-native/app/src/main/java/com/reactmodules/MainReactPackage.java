package com.reactmodules;

import com.facebook.react.ReactPackage;
import com.facebook.react.bridge.JavaScriptModule;
import com.facebook.react.bridge.NativeModule;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.uimanager.ViewManager;
import com.reactmodules.controller.YLYKBugoutNativeModule;
import com.reactmodules.controller.YLYKLoginNativeModule;
import com.reactmodules.controller.YLYKPlayerNativeModule;
import com.reactmodules.controller.YLYKSearchNativeModule;
import com.reactmodules.controller.YLYKTabbarNativeModule;
import com.reactmodules.controller.YLYLScreenChangeNativeModule;
import com.reactmodules.download.YLYKDownloadNativeModule;
import com.reactmodules.encryption.YLEncryptionModule;
import com.reactmodules.loadingview.YLReactLoadingManager;
import com.reactmodules.oauth.YLYKTokenServiceModule;
import com.reactmodules.request.YLYKAddressServiceModule;
import com.reactmodules.request.YLYKAlbumServiceModule;
import com.reactmodules.request.YLYKBannerServiceModule;
import com.reactmodules.request.YLYKCourseServiceModule;
import com.reactmodules.request.YLYKFansServiceModule;
import com.reactmodules.request.YLYKFolloweeServiceModule;
import com.reactmodules.request.YLYKNoteServiceModule;
import com.reactmodules.request.YLYKOrderServiceModule;
import com.reactmodules.request.YLYKServiceModule;
import com.reactmodules.request.YLYKSigninServiceModule;
import com.reactmodules.request.YLYKTeacherServiceModule;
import com.reactmodules.request.YLYKUserServiceModule;
import com.reactmodules.request.YLYKXdyServiceModule;
import com.reactmodules.setting.YLYKApplicationNativeModule;
import com.reactmodules.setting.YLYKCacheNativeModule;
import com.reactmodules.storage.YLYKFileStorageModule;
import com.reactmodules.storage.YLYKKeyValueStorageModule;
import com.reactmodules.storage.YLYKServiceCacheModule;
import com.reactmodules.userinfo.YLYKImageSelectModule;
import com.reactmodules.userinfo.YLYKOAuthModule;
import com.reactmodules.userinfo.YLYKQiyuNativeModule;
import com.reactmodules.userinfo.YLYKSplashScreenModule;
import com.reactmodules.userinfo.YLYKUserTraceNativeModule;
import com.reactmodules.userinfo.YLYKWechatNativeModule;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.List;

/**
 * Created by xyb on 2017/2/13.
 */

public class MainReactPackage implements ReactPackage {
    @Override
    public List<NativeModule> createNativeModules(ReactApplicationContext reactContext) {
        List<NativeModule> modules = new ArrayList<>();
        modules.add(new YLEncryptionModule(reactContext));
        modules.add(new YLYKServiceModule(reactContext));
        modules.add(new YLYKTokenServiceModule(reactContext));
//        modules.add(new YLIntentModule(reactContext));
        modules.add(new YLYKDownloadNativeModule(reactContext));
        modules.add(new YLYLScreenChangeNativeModule(reactContext));
        modules.add(new YLYKPlayerNativeModule(reactContext));
        modules.add(new YLYKWechatNativeModule(reactContext));
        modules.add(new YLYKUserTraceNativeModule(reactContext));
        modules.add(new YLYKQiyuNativeModule(reactContext));
        modules.add(new YLYKOAuthModule(reactContext));
        modules.add(new YLYKServiceCacheModule(reactContext));
        modules.add(new YLYKKeyValueStorageModule(reactContext));
        modules.add(new YLYKFileStorageModule(reactContext));
        modules.add(new YLYKCacheNativeModule(reactContext));
        modules.add(new YLYKApplicationNativeModule(reactContext));
        modules.add(new YLYKAddressServiceModule(reactContext));
        modules.add(new YLYKAlbumServiceModule(reactContext));
        modules.add(new YLYKBannerServiceModule(reactContext));
        modules.add(new YLYKCourseServiceModule(reactContext));
        modules.add(new YLYKFansServiceModule(reactContext));
        modules.add(new YLYKFolloweeServiceModule(reactContext));
        modules.add(new YLYKNoteServiceModule(reactContext));
        modules.add(new YLYKOrderServiceModule(reactContext));
        modules.add(new YLYKTeacherServiceModule(reactContext));
        modules.add(new YLYKSigninServiceModule(reactContext));
        modules.add(new YLYKUserServiceModule(reactContext));
        modules.add(new YLYKXdyServiceModule(reactContext));
        modules.add(new YLYKTabbarNativeModule(reactContext));
        modules.add(new YLYKSearchNativeModule(reactContext));
        modules.add(new YLYKLoginNativeModule(reactContext));
        modules.add(new YLYKSplashScreenModule(reactContext));
        modules.add(new YLYKBugoutNativeModule(reactContext));
        modules.add(new YLYKImageSelectModule(reactContext));
        return modules;
    }

    @Override
    public List<Class<? extends JavaScriptModule>> createJSModules() {
        return Collections.emptyList();
    }

    @Override
    public List<ViewManager> createViewManagers(ReactApplicationContext reactContext) {
        return Arrays.<ViewManager>asList(
                new YLReactLoadingManager()
        );
    }
}
