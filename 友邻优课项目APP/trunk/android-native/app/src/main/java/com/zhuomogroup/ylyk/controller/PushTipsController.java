package com.zhuomogroup.ylyk.controller;

import android.app.Activity;
import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.media.ExifInterface;
import android.support.v7.app.AlertDialog;
import android.widget.Toast;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;
import com.qiniu.android.http.ResponseInfo;
import com.qiniu.android.storage.UpCompletionHandler;
import com.qiniu.android.storage.UploadManager;
import com.reactmodules.callback.BaseStringCallback;
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.activity.YLNoteActivity;
import com.zhuomogroup.ylyk.bean.FileBean;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.controinterface.PushTipsInterface;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.http.okhttp.OkHttpUtils;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileOutputStream;
import java.io.IOException;
import java.text.DecimalFormat;
import java.util.ArrayList;
import java.util.List;

import me.shaohui.advancedluban.Luban;
import me.shaohui.advancedluban.OnMultiCompressListener;
import okhttp3.Call;

import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.PUSH_TRUE;
import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_401;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;
import static com.zhuomogroup.ylyk.consts.YLUrlSetting.JSON_MEDIA_TYPE;
import static com.zhuomogroup.ylyk.utils.SharedPreferencesUtil.get;

/**
 * 发布心得控制器
 * Created by xyb on 2017/3/12.
 */

public class PushTipsController implements PushTipsInterface {

    private UploadManager uploadManager;
    private Activity context;
    private final AlertDialog.Builder builder;
    private AlertDialog alertDialog;

    public PushTipsController(Activity context) {
        this.context = context;
        uploadManager = new UploadManager();

        builder = new AlertDialog.Builder(context);
    }

    @Override
    public void pushInterFace(final String tips, final int courseId, final ArrayList<String> imgPaths) {
        builder.setView(R.layout.pushtips_dialog);
        builder.setCancelable(false);
        alertDialog = builder.create();
        if (!alertDialog.isShowing()) {
            alertDialog.show();
        }

        if (imgPaths.size() > 0) {
            try {
                getImgName(imgPaths, tips, courseId);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else {
            pushNotesNetWork(null, tips, courseId);
        }
    }

    private void getImgName(final ArrayList<String> imgPaths, final String tips, final int courseId) throws JSONException {
        final JSONObject object = new JSONObject();
        object.put("image_count", imgPaths.size());
        OkHttpUtils.postString()
                .headers(Signature.UrlHeaders(context))
                .url(BASE_URL_HEAD + "note" + Signature.UrlSignature())
                .content(object.toString())
                .mediaType(JSON_MEDIA_TYPE)
                .build().execute(new BaseStringCallback() {
            @Override
            public void onError(Call call, Exception e, int id) {

            }

            @Override
            public void onResponse(String response, int id) {
                try {
                    JSONObject object1 = new JSONObject(response);
                    boolean result = object1.getBoolean("result");
                    if (result) {
                        response = object1.getString("response");
                        JSONArray jsonArray = new JSONArray(response);
                        Gson gson = new Gson();
                        ArrayList<FileBean> fileBeen = new ArrayList<FileBean>();
                        for (int i = 0; i < jsonArray.length(); i++) {
                            JSONObject jsonObject = jsonArray.getJSONObject(i);
                            FileBean fileBean = gson.fromJson(jsonObject.toString(), FileBean.class);
                            fileBeen.add(fileBean);
                        }

                        compressImage(imgPaths, fileBeen, tips, courseId);
                    }


                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        });

    }

    private void compressImage(final ArrayList<String> imgPaths, final ArrayList<FileBean> fileBeen, final String tips, final int courseId) {

        //线程不安全,判断是否压缩完毕;原始图片地址-压缩后文件
        final ArrayList<String> pushList = new ArrayList<>();
        ArrayList<File> fileList = new ArrayList<>();
        for (String imgPath : imgPaths) {
            File file = new File(imgPath);
            fileList.add(file);
        }
        Luban.compress(context, fileList)           // 加载多张图片
                .putGear(Luban.THIRD_GEAR)
                .launch(new OnMultiCompressListener() {
                    @Override
                    public void onStart() {

                    }

                    @Override
                    public void onSuccess(List<File> fileList) {
                        for (int i = 0; i < fileList.size(); i++) {
                            FileBean fileBean = fileBeen.get(i);
                            String file_key = fileBean.getFile_key();
                            String upload_token = fileBean.getUpload_token();
                            uploadManager.put(fileList.get(i), file_key, upload_token, new UpCompletionHandler() {
                                @Override
                                public void complete(String key, ResponseInfo info, JSONObject response) {
                                    if (info.statusCode == 200) {
                                        pushList.add(key);
                                        if (pushList.size() == imgPaths.size()) {
                                            pushNotesNetWork(fileBeen, tips, courseId);
                                        }
                                    }
                                }
                            }, null);
                        }
                    }

                    @Override
                    public void onError(Throwable e) {

                    }
                });     // 传入一个 OnMultiCompressListener


    }

    private void pushNotesNetWork(ArrayList<FileBean> fileBeen, String tips, final int courseId) {
        final JSONObject object = new JSONObject();
        try {
            object.put("course_id", courseId);
            String newTips = tips.replaceAll("\n", "<br />");
            object.put("content", newTips);
            JSONArray jsonArray = new JSONArray();
            if (fileBeen != null) {
                for (FileBean fileBean : fileBeen) {
                    String file_key = fileBean.getFile_key();
                    jsonArray.put(file_key);
                }
                object.put("file_keys", jsonArray);
            }

            OkHttpUtils.postString()
                    .headers(Signature.UrlHeaders(context))
                    .url(BASE_URL_HEAD + "note" + Signature.UrlSignature())
                    .content(object.toString())
                    .mediaType(JSON_MEDIA_TYPE)
                    .build().execute(new BaseStringCallback() {
                @Override
                public void onError(Call call, Exception e, int id) {
                    e.printStackTrace();
                }

                @Override
                public void onResponse(String response, int id) {
                    Gson gson = new Gson();
                    RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                    if (requestBean.isResult()) {
                        getReward();
                        getCourseInfo(courseId);
                        EventBus.getDefault().post(PUSH_TRUE);

                    } else {
                        int code = requestBean.getCode();
                        if (code == HTTP_CODE_401) {
                            Toast.makeText(context, "登录失效 请重新登录", Toast.LENGTH_SHORT).show();
                        }
                        Toast.makeText(context, "code:" + code, Toast.LENGTH_SHORT).show();
                    }
                    if (alertDialog != null) {
                        if (alertDialog.isShowing()) {
                            alertDialog.dismiss();
                        }
                    }
                }
            });
        } catch (JSONException e) {

            e.printStackTrace();
        }
    }

    private void getCourseInfo(int courseId) {
        OkHttpUtils.get()
                .url(BASE_URL_HEAD + "course/" + courseId + Signature.UrlSignature())
                .headers(Signature.UrlHeaders(context))
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
                            try {
                                JSONObject object = new JSONObject(response);
                                Intent intent = new Intent(context, YLNoteActivity.class);
                                JSONObject courseInfo = new JSONObject();
                                courseInfo.put("id", object.getInt("id"));
                                courseInfo.put("teachers", object.getJSONArray("teachers").toString());
                                courseInfo.put("courseName", object.getString("name"));
                                intent.putExtra("courseInfo", courseInfo.toString());
                                context.startActivity(intent);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        } else {
                            int code = requestBean.getCode();
                            Toast.makeText(context, "code:" + code, Toast.LENGTH_SHORT).show();
                        }

                    }
                });


    }

    private void getReward() {
        final JSONObject object = new JSONObject();
        try {
            object.put("source", "task");
            object.put("type_id", 4);
            OkHttpUtils.postString()
                    .headers(Signature.UrlHeaders(context))
                    .url(BASE_URL_HEAD + "umoney/reward" + Signature.UrlSignature())
                    .content(object.toString())
                    .mediaType(JSON_MEDIA_TYPE)
                    .build().execute(new BaseStringCallback() {
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
                        try {
                            JSONObject object1 = new JSONObject(response);
                            boolean result = object1.getBoolean("result");
                            if (result) {
                                JSONObject aPackage = object1.getJSONObject("package");
                                double umoney = aPackage.getDouble("umoney");
                                int umInt = (int) (umoney * 10);
                                int i = umInt / 10;
                                DecimalFormat integerFormat = new DecimalFormat("#.#");
                                DecimalFormat doubleFormat = new DecimalFormat("#");

                                if (i != 0) {
                                    Toast.makeText(context, "恭喜获得" + integerFormat.format(umoney) + "优币", Toast.LENGTH_SHORT).show();
                                } else {
                                    Toast.makeText(context, "恭喜获得" + doubleFormat.format(umoney) + "优币", Toast.LENGTH_SHORT).show();
                                }

                                getUserInfo();

                            } else {
                                Toast.makeText(context, "心得发布成功", Toast.LENGTH_SHORT).show();
                            }
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    } else {
                        Toast.makeText(context, "requestBean.getCode():" + requestBean.getCode(), Toast.LENGTH_SHORT).show();
                    }
                }

                private void getUserInfo() {
                    String user_info = (String) get(context, USER_INFO, "");
                    if (!"".equals(user_info)) {
                        try {
                            JSONObject object = new JSONObject(user_info);

                            int userId = object.getInt("id");
                            OkHttpUtils.get()
                                    .url(BASE_URL_HEAD + "user/" + userId + Signature.UrlSignature())
                                    .headers(Signature.UrlHeaders(context))
                                    .build()
                                    .execute(new BaseStringCallback() {
                                        @Override
                                        public void onError(Call call, Exception e, int id) {
                                            e.printStackTrace();
                                        }

                                        @Override
                                        public void onResponse(String response, int id) {
                                            if (response != null) {
                                                Gson gson = new Gson();
                                                RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                                                if (requestBean.isResult()) {
                                                    response = requestBean.getResponse();
                                                    SharedPreferencesUtil.put(context, USER_INFO, response);
                                                    if (context != null) {
                                                        MainApplication application = (MainApplication) context.getApplication();
                                                        ReactContext reactContext = application.getReactContext();
                                                        if (reactContext != null) {
                                                            WritableMap params = new WritableNativeMap();
                                                            params.putBoolean("sendNoteEvent", true);
                                                            reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("sendNoteEvent", params);
                                                        }
                                                    }
                                                }
                                            }
                                        }
                                    });
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                }
            });


        } catch (JSONException e) {
            e.printStackTrace();
        }


    }


    private void clearSmallFile(ArrayList<String> selectedPhotos) {
        for (String selectedPhoto : selectedPhotos) {
            deleteFile(selectedPhoto + "small");
        }

    }

    /**
     * 删除单个文件
     *
     * @param fileName 要删除的文件的文件名
     * @return 单个文件删除成功返回true，否则返回false
     */
    public boolean deleteFile(String fileName) {
        File file = new File(fileName);
        // 如果文件路径所对应的文件存在，并且是一个文件，则直接删除
        if (file.exists() && file.isFile()) {
            if (file.delete()) {
                return true;
            } else {
                return false;
            }
        } else {
            return false;
        }
    }

    public void saveBitmapFile(Bitmap bitmap, String path) {
        File file = new File(path);//将要保存图片的路径
        try {
            BufferedOutputStream bos = new BufferedOutputStream(new FileOutputStream(file));
            bitmap.compress(Bitmap.CompressFormat.JPEG, 100, bos);
            bos.flush();
            bos.close();
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    /**
     * 从给定的路径加载图片，并指定是否自动旋转方向
     */
    public Bitmap loadBitmap(String imgpath, boolean adjustOritation) {
        if (!adjustOritation) {
            return loadBitmap(imgpath);
        } else {
            Bitmap bm = loadBitmap(imgpath);
            int digree = 0;
            ExifInterface exif = null;
            try {
                exif = new ExifInterface(imgpath);
            } catch (IOException e) {
                e.printStackTrace();
                exif = null;
            }
            if (exif != null) {
                // 读取图片中相机方向信息
                int ori = exif.getAttributeInt(ExifInterface.TAG_ORIENTATION,
                        ExifInterface.ORIENTATION_UNDEFINED);
                // 计算旋转角度
                switch (ori) {
                    case ExifInterface.ORIENTATION_ROTATE_90:
                        digree = 90;
                        break;
                    case ExifInterface.ORIENTATION_ROTATE_180:
                        digree = 180;
                        break;
                    case ExifInterface.ORIENTATION_ROTATE_270:
                        digree = 270;
                        break;
                    default:
                        digree = 0;
                        break;
                }
            }
            if (digree != 0) {
                // 旋转图片
                Matrix m = new Matrix();
                m.postRotate(digree);
                bm = Bitmap.createBitmap(bm, 0, 0, bm.getWidth(),
                        bm.getHeight(), m, true);
            }
            return bm;
        }
    }


    /**
     * 从给定路径加载图片
     */
    public Bitmap loadBitmap(String imgpath) {
        return BitmapFactory.decodeFile(imgpath, getBitmapOption(2));
    }


    private BitmapFactory.Options getBitmapOption(int inSampleSize) {
        System.gc();
        BitmapFactory.Options options = new BitmapFactory.Options();
        options.inPurgeable = true;
        options.inSampleSize = inSampleSize;
        return options;
    }


}
