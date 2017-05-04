package com.reactmodules.loadingview;

import android.app.Activity;
import android.content.DialogInterface;
import android.support.v7.app.AlertDialog;

import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.zhuomogroup.ylyk.MainApplication;

import static com.reactmodules.consts.ModuleName.YLYK_DIALOG_NATIVE_MODULE;

/**
 * Created by xyb on 2017/4/13.
 */

public class YLYKDialogNativeModule extends ReactContextBaseJavaModule {
    private final Activity activity;

    public YLYKDialogNativeModule(ReactApplicationContext reactContext, Activity activity) {
        super(reactContext);
        this.activity = activity;
    }

    @Override
    public String getName() {
        return YLYK_DIALOG_NATIVE_MODULE;
    }


    @ReactMethod
    public void showDialog(String title) {
        AlertDialog.Builder builder = new AlertDialog.Builder(activity);
        builder.setMessage(title);
        builder.setNegativeButton("打开微信", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                MainApplication application = (MainApplication) activity.getApplication();
                IWXAPI iwxapi = application.getIwxapi();
                if (iwxapi.openWXApp()) {

                }
                dialog.dismiss();
            }
        });
        builder.setPositiveButton("取消", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
            }
        });
        AlertDialog alertDialog = builder.create();
        if (!alertDialog.isShowing()) {
            alertDialog.show();
        }

    }


}
