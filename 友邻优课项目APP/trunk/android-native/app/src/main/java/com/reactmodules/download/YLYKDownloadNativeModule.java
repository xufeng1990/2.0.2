package com.reactmodules.download;

import android.app.Activity;
import android.content.Context;
import android.os.Environment;
import android.widget.Toast;

import com.bumptech.glide.Glide;
import com.bumptech.glide.request.animation.GlideAnimation;
import com.bumptech.glide.request.target.SimpleTarget;
import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.HttpHeaders;
import com.lzy.okgo.request.GetRequest;
import com.lzy.okserver.download.DownloadInfo;
import com.lzy.okserver.download.DownloadManager;
import com.lzy.okserver.download.DownloadService;
import com.lzy.okserver.listener.DownloadListener;
import com.reactmodules.callback.BaseStringCallback;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.consts.YLBaseUrl;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.utils.FileUtil;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.http.okhttp.OkHttpUtils;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.io.Serializable;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import io.reactivex.functions.Consumer;
import okhttp3.Call;

import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
import static com.reactmodules.consts.ModuleName.YLYK_DOWNLOAD_NATIVE_MODULE;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;
import static com.zhuomogroup.ylyk.network.Signature.UrlHeaders;
import static com.zhuomogroup.ylyk.network.Signature.UrlSignature;
import static com.zhuomogroup.ylyk.utils.EncryptionUtil.MD5;
import static com.zhuomogroup.ylyk.utils.SharedPreferencesUtil.put;

/**
 * Created by xyb on 2017/2/27 at 友邻优课 2017
 */

public class YLYKDownloadNativeModule extends ReactContextBaseJavaModule {

    private static final String DOWNLOAD_PATH = "/Android/data/com.zhuomogroup.ylyk/downloads/62933a2951ef01f4eafd9bdf4d3cd2f0/";
    private static final int TIME_OUT_500 = 500;
    private final DownloadManager downloadManager;
    private ReactContext reactContext;
    private long mExitTime;


    public YLYKDownloadNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
        downloadManager = DownloadService.getDownloadManager();
    }

    @Override
    public String getName() {
        return YLYK_DOWNLOAD_NATIVE_MODULE;
    }

    /**
     * 获得当前的下载列表
     *
     * @param promise RN 回调
     */
    @ReactMethod
    public void getDownloadList(Promise promise) {
        List<DownloadInfo> allTask = downloadManager.getAllTask();
        JSONArray jsonArray = new JSONArray();
        TreeMap<Long, JSONObject> longStringTreeMap = new TreeMap<>();
        long position = 0L;
        for (DownloadInfo downloadInfo : allTask) {
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("saveName", downloadInfo.getFileName());
                jsonObject.put("savePath", downloadInfo.getTargetPath());
                jsonObject.put("downloadSize", downloadInfo.getDownloadLength());
                jsonObject.put("totalSize", downloadInfo.getTotalLength());
                jsonObject.put("flag", downloadInfo.getState());
                Serializable data = downloadInfo.getData();
                Gson gson = new Gson();
                if (data instanceof CourseBean) {
                    String downloadBeanString = gson.toJson((CourseBean) data);
                    JSONObject extra = new JSONObject(downloadBeanString);
                    jsonObject.put("extra", extra);
                    longStringTreeMap.put(((CourseBean) data).getInTime(), jsonObject);
                } else if (data instanceof com.reactutils.download.CourseBean) {
                    String toJson = gson.toJson((com.reactutils.download.CourseBean) data);
                    JSONObject extra = new JSONObject(toJson);
                    jsonObject.put("extra", extra);
                    longStringTreeMap.put(position, jsonObject);
                    position++;
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        for (Map.Entry<Long, JSONObject> longJSONObjectEntry : longStringTreeMap.entrySet()) {
            JSONObject value = longJSONObjectEntry.getValue();
            jsonArray.put(value);
        }
        promise.resolve(jsonArray.toString());

    }

    /**
     * 开始 或者 继续下载
     *
     * @param urls    下载的地址
     * @param promise RN 回调
     */
    @ReactMethod
    public void startDownload(final String urls, final Promise promise) {
        Activity currentActivity = getCurrentActivity();
        if (currentActivity != null) {
            RxPermissions.getInstance(currentActivity)
                    .request(WRITE_EXTERNAL_STORAGE).subscribe(new Consumer<Boolean>() {
                @Override
                public void accept(Boolean agreePermission) throws Exception {
                    if (agreePermission) {
                        try {
                            JSONArray urlArray = new JSONArray(urls);
                            for (int i = 0; i < urlArray.length(); i++) {
                                JSONObject urlObject = urlArray.getJSONObject(i);
                                int courseId = urlObject.getInt("id");
                                Gson gson = new Gson();
                                CourseBean downLoadBean = gson.fromJson(urlObject.toString(), CourseBean.class);

                                String sdCardRoot = Environment.getExternalStorageDirectory().getAbsolutePath();
                                sdCardRoot = sdCardRoot + DOWNLOAD_PATH;
                                Map<String, String> stringStringMap = UrlHeaders(getCurrentActivity().getApplication().getApplicationContext());
                                HttpHeaders httpHeaders = new HttpHeaders();
                                for (String s : stringStringMap.keySet()) {
                                    httpHeaders.put(s, stringStringMap.get(s));
                                }
                                String downloadUrl = BASE_URL_HEAD + "course/" + courseId + "/media";
                                GetRequest request = OkGo.get(downloadUrl + UrlSignature()).headers(httpHeaders);//
                                downloadManager.setTargetFolder(sdCardRoot);

                                downloadManager.addTask(downloadUrl, downLoadBean, request, new RNDownloadListener(getCurrentActivity().getApplication().getApplicationContext()));

                            }
                            promise.resolve("{\"result\":true }");
                        } catch (Exception e) {
                            e.printStackTrace();
                            promise.reject(e);
                        }
                    } else {
                        Toast.makeText(reactContext, R.string.toast_licenten, Toast.LENGTH_SHORT).show();
                    }
                }
            });
        }

    }


    /**
     * 暂停下载
     *
     * @param urls    url 数组
     * @param promise RN 回调
     */
    @ReactMethod
    public void pauseDownload(String urls, Promise promise) {
        try {
            JSONArray jsonArray = new JSONArray(urls);
            for (int i = 0; i < jsonArray.length(); i++) {
                String url = jsonArray.getString(i);
                String downloadUrl = BASE_URL_HEAD + "course/" + url + "/media";
                downloadManager.pauseTask(downloadUrl);
            }
            promise.resolve("{\"result\":true }");
        } catch (JSONException e) {
            e.printStackTrace();
            promise.reject(e);
        }
    }


    /**
     * 删除下载方法
     *
     * @param urls       需要删除的urls 数组
     * @param deleteFile
     * @param promise
     */
    @ReactMethod
    public void deleteDownload(String urls, boolean deleteFile, Promise promise) {
        try {
            JSONArray jsonArray = new JSONArray(urls);
            for (int i = 0; i < jsonArray.length(); i++) {
                String courseId = jsonArray.getString(i);
                String downloadUrl = BASE_URL_HEAD + "course/" + courseId + "/media";
                downloadManager.removeTask(downloadUrl, deleteFile);
                String user_info = (String) SharedPreferencesUtil.get(getCurrentActivity(), USER_INFO, "");
                JSONObject object = new JSONObject(user_info);
                int userId = object.getInt("id");

                String md5 = MD5(userId + "." + courseId);
                String filePath = md5 + ".cache";
                String sdCardRoot = Environment.getExternalStorageDirectory().getAbsolutePath();
                sdCardRoot = sdCardRoot + DOWNLOAD_PATH;
                deleteFile(sdCardRoot + filePath);

            }
            promise.resolve("{\"result\":true }");
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

    /**
     * 删除单个文件
     *
     * @param fileName 要删除的文件的文件名
     * @return 单个文件删除成功返回true，否则返回false
     */
    private boolean deleteFile(String fileName) {
        File file = new File(fileName);
        // 如果文件路径所对应的文件存在，并且是一个文件，则直接删除
        return file.exists() && file.isFile() && file.delete();
    }

    /**
     * 发送消息事件
     */
    @ReactMethod
    public void sendEvent(Promise promise) {
        List<DownloadInfo> allTask = downloadManager.getAllTask();
        for (int i = 0; i < allTask.size(); i++) {
            String taskKey = allTask.get(i).getTaskKey();
            RNDownloadListener myDownloadListener = new RNDownloadListener(getCurrentActivity().getApplication().getApplicationContext());
            downloadManager.getDownloadInfo(taskKey).setListener(myDownloadListener);

        }

        promise.resolve("{\"result\":true }");
    }

    @ReactMethod
    public void clearEvent(Promise promise) {
        promise.resolve("{\"result\":true }");
    }


    private class RNDownloadListener extends DownloadListener {
        private Context applicationContext;

        private RNDownloadListener(Context applicationContext) {
            this.applicationContext = applicationContext;
        }

        @Override
        public void onProgress(DownloadInfo downloadInfo) {
            if ((System.currentTimeMillis() - mExitTime) > TIME_OUT_500 && downloadInfo.getProgress() < 0.3) {
                mExitTime = System.currentTimeMillis();
                sendEvent(downloadInfo);
            }
        }


        @Override
        public void onFinish(DownloadInfo downloadInfo) {
            sendEvent(downloadInfo);
            int courseId = 0;
            try {
                CourseBean data = (CourseBean) downloadInfo.getData();
                courseId = data.getId();
                String user_info = (String) SharedPreferencesUtil.get(applicationContext, USER_INFO, "");
                JSONObject object = new JSONObject(user_info);
                int userId = object.getInt("id");

                String md5 = MD5(userId + "." + courseId);
                String filePath = md5 + ".cache";
                FileUtil.renameFile(downloadInfo.getTargetPath(), downloadInfo.getTargetFolder() + filePath);
            } catch (Exception e) {
                e.printStackTrace();
            }
            OkHttpUtils.get()
                    .url(BASE_URL_HEAD + "course/" + courseId + UrlSignature())
                    .headers(Signature.UrlHeaders(applicationContext))
                    .build()
                    .execute(new BaseStringCallback() {
                        @Override
                        public void onError(Call call, Exception e, int id) {
                            e.printStackTrace();
                        }

                        @Override
                        public void onResponse(String response, int id) {
                            try {
                                JSONObject object = new JSONObject(response);
                                boolean result = object.getBoolean("result");
                                if (result) {
                                    response = object.getString("response");
                                    JSONObject object1 = new JSONObject(response);
                                    put(applicationContext, object1.getInt("id") + "", response);
                                    JSONObject album = object1.getJSONObject("album");
                                    Glide.with(applicationContext)
                                            .load(YLBaseUrl.BASE_URL_HEAD + "course/" + object1.getInt("id") + "/cover").downloadOnly(new SimpleTarget<File>() {
                                        @Override
                                        public void onResourceReady(File resource, GlideAnimation<? super File> glideAnimation) {
                                        }
                                    });
                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }
                    });


        }

        @Override
        public void onError(DownloadInfo downloadInfo, String errorMsg, Exception e) {
            if (getCurrentActivity() != null) {
                sendEvent(downloadInfo);
                CourseBean downLoadBean = (CourseBean) downloadInfo.getData();
                if (downLoadBean != null) {
                    String downloadUrl = BASE_URL_HEAD + "course/" + downLoadBean.getId() + "/media";
                    downloadManager.removeTask(downloadUrl, true);
                    Map<String, String> stringStringMap = UrlHeaders(getCurrentActivity().getApplication().getApplicationContext());
                    HttpHeaders httpHeaders = new HttpHeaders();
                    for (String s : stringStringMap.keySet()) {
                        httpHeaders.put(s, stringStringMap.get(s));
                    }
                    GetRequest request = OkGo.get(downloadUrl + UrlSignature()).headers(httpHeaders);//

                    downloadManager.addTask(downloadUrl, downLoadBean, request, new RNDownloadListener(getCurrentActivity().getApplication().getApplicationContext()));

                }
            }

        }

        private void sendEvent(DownloadInfo downloadInfo) {
            WritableMap params = new WritableNativeMap();
            JSONObject jsonObject = new JSONObject();
            try {
                jsonObject.put("saveName", downloadInfo.getFileName());
                jsonObject.put("savePath", downloadInfo.getTargetPath());
                jsonObject.put("downloadSize", downloadInfo.getProgress());
                jsonObject.put("totalSize", downloadInfo.getTotalLength());
                jsonObject.put("flag", downloadInfo.getState());
                CourseBean downLoadBean = (CourseBean) downloadInfo.getData();
                if (downLoadBean != null) {
                    Gson gson = new Gson();
                    String downloadBeanString = gson.toJson(downLoadBean);
                    JSONObject extra = new JSONObject(downloadBeanString);
                    jsonObject.put("extra", extra);
                }
                params.putString("downloadEvent", jsonObject.toString());
                reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("downloadEvent", params);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
    }


}
