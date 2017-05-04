package com.reactmodules.storage;

import android.content.Context;
import android.content.Intent;
import android.graphics.Bitmap;
import android.net.Uri;
import android.os.Environment;
import android.provider.MediaStore;
import android.widget.Toast;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.BitmapCallback;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;

import io.reactivex.functions.Consumer;
import okhttp3.Call;

import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
import static com.reactmodules.consts.ModuleName.YLYK_FILE_STORAGE_MODULE;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKFileStorageModule extends ReactContextBaseJavaModule {

    private final Context context;

    public YLYKFileStorageModule(ReactApplicationContext reactContext) {
        super(reactContext);
        context = reactContext.getApplicationContext();
    }

    @Override
    public String getName() {
        return YLYK_FILE_STORAGE_MODULE;
    }


    /**
     * 保存图片方法
     *
     * @param url     图片地址
     * @param promise
     */
    @ReactMethod
    public void saveImage(String url, Promise promise) {
        url = url.replaceFirst("https", "http");
        final String finalUrl = url;
        RxPermissions.getInstance(context)
                .request(WRITE_EXTERNAL_STORAGE).subscribe(new Consumer<Boolean>() {
            @Override
            public void accept(Boolean agreePermission) throws Exception {
                if (agreePermission) {
                    OkHttpUtils.get()
                            .url(finalUrl)
                            .build()
                            .execute(new BitmapCallback() {
                                @Override
                                public void onError(Call call, Exception e, int id) {
                                    e.printStackTrace();
                                }

                                @Override
                                public void onResponse(Bitmap response, int id) {
                                    if (context != null) {
                                        saveImageToGallery(context, response);
                                    }

                                }
                            });

                }
            }
        });


    }


    /**
     * 保存到本地方法
     *
     * @param context 上下文
     * @param bmp     图片信息
     */
    public static void saveImageToGallery(Context context, Bitmap bmp) {
        if (bmp == null) {
            Toast.makeText(context, "保存出错了...", Toast.LENGTH_SHORT).show();
            return;
        }
        String sdCardRoot = Environment.getExternalStorageDirectory().getAbsolutePath();
        // 首先保存图片
        File appDir = new File(sdCardRoot, "ylyk");
        if (!appDir.exists()) {
            appDir.mkdir();
        }
        String fileName = System.currentTimeMillis() + ".jpg";
        File file = new File(appDir, fileName);
        try {
            FileOutputStream fos = new FileOutputStream(file);
            bmp.compress(Bitmap.CompressFormat.JPEG, 100, fos);
            fos.flush();
            fos.close();
        } catch (Exception e) {
            e.printStackTrace();
        }

        // 最后通知图库更新
        try {
            MediaStore.Images.Media.insertImage(context.getContentResolver(), file.getAbsolutePath(), fileName, null);
        } catch (FileNotFoundException e) {
            e.printStackTrace();
        }
        Intent intent = new Intent(Intent.ACTION_MEDIA_SCANNER_SCAN_FILE);
        Uri uri = Uri.fromFile(file);
        intent.setData(uri);
        context.sendBroadcast(intent);
        Toast.makeText(context, "保存成功", Toast.LENGTH_SHORT).show();
    }

}
