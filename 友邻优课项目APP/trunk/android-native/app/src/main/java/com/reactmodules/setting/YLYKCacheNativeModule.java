package com.reactmodules.setting;

import android.widget.Toast;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.utils.DeviceUtil;
import com.zhuomogroup.ylyk.utils.FileUtil;

import io.reactivex.functions.Consumer;

import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
import static com.reactmodules.consts.ModuleName.YLYK_CACHE_NATIVE_MODULE;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKCacheNativeModule extends ReactContextBaseJavaModule {


    public YLYKCacheNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return YLYK_CACHE_NATIVE_MODULE;
    }


    /**
     * 获得缓存大小
     *
     * @param promise
     */
    @ReactMethod
    public void getCacheSize(final Promise promise) {
        try {
            RxPermissions.getInstance(getCurrentActivity())
                    .request(WRITE_EXTERNAL_STORAGE).subscribe(new Consumer<Boolean>() {
                @Override
                public void accept(Boolean agreePermission) throws Exception {
                    if (agreePermission) {
                        long folderSize = FileUtil.getFolderSize(getCurrentActivity().getCacheDir());
                        long folderSize1 = FileUtil.getFolderSize(getCurrentActivity().getExternalCacheDir());
                        long l = folderSize + folderSize1;
                        String formatSize = FileUtil.getFormatSize(l);
                        promise.resolve(formatSize);
                    } else {
                        promise.resolve("0 MB");
                        Toast.makeText(getCurrentActivity(), R.string.toast_licenten, Toast.LENGTH_SHORT).show();
                    }
                }
            });

        } catch (Exception e) {
            promise.reject(e);
            e.printStackTrace();
        }

    }



    /**
     * 清楚缓存方法
     *
     * @param promise
     */
    @ReactMethod
    public void clearCache(final Promise promise) {
        try {
            RxPermissions.getInstance(getCurrentActivity())
                    .request(WRITE_EXTERNAL_STORAGE).subscribe(new Consumer<Boolean>() {
                @Override
                public void accept(Boolean agreePermission) throws Exception {
                    if (agreePermission) {
                        FileUtil.cleanInternalCache(getCurrentActivity());
                        Toast.makeText(getCurrentActivity(), "删除成功", Toast.LENGTH_SHORT).show();
                        promise.resolve("删除成功");
                    } else {
                        Toast.makeText(getCurrentActivity(), R.string.toast_licenten, Toast.LENGTH_SHORT).show();
                    }

                }
            });

        } catch (Exception e) {
            promise.reject(e);
            e.printStackTrace();
        }

    }

    /**
     * 获取总的存储空间
     *
     * @return
     */
    @ReactMethod
    public void getTotalDiskSize(Promise promise) {
        long availableInternalMemorySize = DeviceUtil.getTotalInternalMemorySize();
        if (DeviceUtil.externalMemoryAvailable()) {
            availableInternalMemorySize += DeviceUtil.getTotalExternalMemorySize();
        }
        String totalMemorySize = DeviceUtil.formatFileSize(availableInternalMemorySize, false);
        promise.resolve(totalMemorySize);
    }

    /**
     * 获取剩余的 存储空间
     *
     * @return
     */
    @ReactMethod
    public void getResidueDiskSize(Promise promise) {
        long availableInternalMemorySize = DeviceUtil.getAvailableInternalMemorySize();
        if (DeviceUtil.externalMemoryAvailable()) {
            availableInternalMemorySize += DeviceUtil.getAvailableExternalMemorySize();
        }
        String totalMemorySize = DeviceUtil.formatFileSize(availableInternalMemorySize, false);
        promise.resolve(totalMemorySize);
    }
}
