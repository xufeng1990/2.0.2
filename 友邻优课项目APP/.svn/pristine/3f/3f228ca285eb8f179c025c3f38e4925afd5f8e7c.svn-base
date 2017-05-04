package com.reactmodules.userinfo;

import android.app.Activity;
import android.content.Context;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.google.gson.Gson;
import com.luck.picture.lib.model.FunctionConfig;
import com.luck.picture.lib.model.FunctionOptions;
import com.luck.picture.lib.model.PictureConfig;
import com.qiniu.android.http.ResponseInfo;
import com.qiniu.android.storage.UpCompletionHandler;
import com.qiniu.android.storage.UploadManager;
import com.reactmodules.callback.BaseStringCallback;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.yalantis.ucrop.entity.LocalMedia;
import com.zhuomogroup.ylyk.activity.YLMainActivity;
import com.zhuomogroup.ylyk.bean.FileBean;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.http.okhttp.OkHttpUtils;

import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

import io.reactivex.functions.Consumer;
import okhttp3.Call;

import static android.Manifest.permission.CAMERA;
import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
import static com.reactmodules.consts.ModuleName.YLYK_IMAGE_SELECT_MODULE;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;
import static com.zhuomogroup.ylyk.consts.YLUrlSetting.JSON_MEDIA_TYPE;

/**
 * Created by xyb on 2017/4/24.
 */

public class YLYKImageSelectModule extends ReactContextBaseJavaModule {


    public YLYKImageSelectModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return YLYK_IMAGE_SELECT_MODULE;
    }


    @ReactMethod
    public void openCamera(final Promise promise) {

        final Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            if (currentActivity instanceof YLMainActivity) {

                RxPermissions.getInstance(currentActivity)
                        .request(CAMERA, WRITE_EXTERNAL_STORAGE).subscribe(new Consumer<Boolean>() {
                    @Override
                    public void accept(Boolean aBoolean) throws Exception {


                        FunctionOptions.Builder builder = new FunctionOptions.Builder()
                                .setType(FunctionConfig.TYPE_IMAGE)
                                .setCropMode(FunctionConfig.CROP_MODEL_1_1)
                                .setCompress(true)
                                .setSelectMode(FunctionConfig.MODE_SINGLE)
                                .setEnableCrop(true);
                        FunctionOptions functionOptions = builder.create();
                        PictureConfig.getPictureConfig().init(functionOptions).startOpenCamera(currentActivity, new PictureConfig.OnSelectResultCallback() {
                            @Override
                            public void onSelectSuccess(List<LocalMedia> list) {
                                if (list != null && list.size() > 0) {
                                    getImageUpdate(list.get(0).getCompressPath());

                                    promise.resolve(list.get(0).getCompressPath());

                                }

                            }
                        });
                    }
                });


            }
        }

    }

    private void getImageUpdate(final String compressPath) {


        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            final Context applicationContext = currentActivity.getApplicationContext();
            try {
                String user_info = (String) SharedPreferencesUtil.get(applicationContext, USER_INFO, "");
                if (!"".equals(user_info)) {

                    JSONObject object = new JSONObject(user_info);
                    final int userId = object.getInt("id");
                    OkHttpUtils.postString()
                            .headers(Signature.UrlHeaders(applicationContext))
                            .url(BASE_URL_HEAD + "user/" + userId + "/avatar" + Signature.UrlSignature())
                            .content("")
                            .mediaType(JSON_MEDIA_TYPE)
                            .build()
                            .execute(new BaseStringCallback() {
                                @Override
                                public void onError(Call call, Exception e, int id) {
                                    e.printStackTrace();
                                }

                                @Override
                                public void onResponse(String response, int id) {
                                    Gson gson = new Gson();
                                    RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                                    if (requestBean.isResult()) {
                                        response = requestBean.getResponse();
                                        FileBean fileBean = gson.fromJson(response, FileBean.class);
                                        final String file_key = fileBean.getFile_key();
                                        String upload_token = fileBean.getUpload_token();
                                        UploadManager uploadManager = new UploadManager();
                                        uploadManager.put(compressPath, file_key, upload_token, new UpCompletionHandler() {
                                            @Override
                                            public void complete(String key, ResponseInfo info, JSONObject response) {
                                                if (info.statusCode == 200) {
                                                    pushNotesNetWork(userId, applicationContext, file_key);
                                                }
                                            }
                                        }, null);
                                    }


                                }
                            });
                }


            } catch (JSONException e) {
                e.printStackTrace();
            }


        }

    }

    private void pushNotesNetWork(int userId, Context applicationContext, String file_key) {
        JSONObject object = new JSONObject();
        try {
            object.put("file_key", file_key);
            OkHttpUtils.postString()
                    .headers(Signature.UrlHeaders(applicationContext))
                    .url(BASE_URL_HEAD + "user/" + userId + "/avatar" + Signature.UrlSignature())
                    .content(object.toString())
                    .mediaType(JSON_MEDIA_TYPE)
                    .build().execute(new BaseStringCallback() {
                @Override
                public void onError(Call call, Exception e, int id) {
                    e.printStackTrace();
                }

                @Override
                public void onResponse(String response, int id) {

                }
            });
        } catch (JSONException e) {
            e.printStackTrace();
        }


    }

    @ReactMethod
    public void onenImageGrid(final Promise promise) {

        final Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            if (currentActivity instanceof YLMainActivity) {

                RxPermissions.getInstance(currentActivity)
                        .request(CAMERA, WRITE_EXTERNAL_STORAGE).subscribe(new Consumer<Boolean>() {
                    @Override
                    public void accept(Boolean aBoolean) throws Exception {


                        FunctionOptions.Builder builder = new FunctionOptions.Builder()
                                .setType(FunctionConfig.TYPE_IMAGE)
                                .setCropMode(FunctionConfig.CROP_MODEL_1_1)
                                .setCompress(true)
                                .setSelectMode(FunctionConfig.MODE_SINGLE)
                                .setEnableCrop(true);
                        FunctionOptions functionOptions = builder.create();
                        PictureConfig.getPictureConfig().init(functionOptions).openPhoto(currentActivity, new PictureConfig.OnSelectResultCallback() {
                            @Override
                            public void onSelectSuccess(List<LocalMedia> list) {
                                if (list != null && list.size() > 0) {
                                    getImageUpdate(list.get(0).getCompressPath());
                                    promise.resolve(list.get(0).getCompressPath());

                                }

                            }
                        });
                    }
                });


            }
        }

    }


    @ReactMethod
    public void selectImageFromAlbumOrCamera(String from, Promise promise) {
        if (from.equals("album")) {
            onenImageGrid(promise);
        } else if (from.equals("camera")) {
            openCamera(promise);
        }

    }


}
