package com.zhuomogroup.ylyk.activity;

import android.annotation.SuppressLint;
import android.app.Activity;
import android.content.ComponentName;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.content.ServiceConnection;
import android.graphics.Rect;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.os.Handler;
import android.os.IBinder;
import android.os.Message;
import android.os.StrictMode;
import android.provider.Settings;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AlertDialog;
import android.text.Editable;
import android.text.TextWatcher;
import android.util.DisplayMetrics;
import android.view.GestureDetector;
import android.view.MotionEvent;
import android.view.View;
import android.view.ViewTreeObserver;
import android.view.inputmethod.InputMethodManager;
import android.webkit.WebSettings;
import android.widget.EditText;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import android.widget.SeekBar;
import android.widget.TextView;
import android.widget.Toast;

import com.google.gson.Gson;
import com.lzy.okgo.OkGo;
import com.lzy.okgo.model.HttpHeaders;
import com.lzy.okgo.request.GetRequest;
import com.lzy.okserver.download.DownloadInfo;
import com.lzy.okserver.download.DownloadManager;
import com.lzy.okserver.download.DownloadService;
import com.reactmodules.callback.BaseStringCallback;
import com.reactmodules.controller.YLYKPlayerNativeModule;
import com.reactmodules.download.AlbumBean;
import com.reactmodules.download.CourseBean;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.testin.agent.Bugout;
import com.testin.agent.BugoutConfig;
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.ScaleTransformer;
import com.zhuomogroup.ylyk.adapter.YLAudioAdapter;
import com.zhuomogroup.ylyk.bean.AudioDataBean;
import com.zhuomogroup.ylyk.bean.DataListBean;
import com.zhuomogroup.ylyk.bean.PlaySelectBean;
import com.zhuomogroup.ylyk.bean.ReactRequestBean;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.consts.YLBaseUrl;
import com.zhuomogroup.ylyk.controller.PushTipsController;
import com.zhuomogroup.ylyk.controller.QiYuActivityController;
import com.zhuomogroup.ylyk.listener.AudioDownloadListener;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.popupwindow.YLPlayListDialogFragment;
import com.zhuomogroup.ylyk.popupwindow.YLPlaySettingPopupWindow;
import com.zhuomogroup.ylyk.popupwindow.YLPlayTypePopupWindow;
import com.zhuomogroup.ylyk.service.AudioControl;
import com.zhuomogroup.ylyk.service.AudioPlaybackService;
import com.zhuomogroup.ylyk.utils.AudioTimeUtil;
import com.zhuomogroup.ylyk.utils.BrightnessUtil;
import com.zhuomogroup.ylyk.utils.NetworkUtil;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhuomogroup.ylyk.utils.SystemUtil;
import com.zhuomogroup.ylyk.views.OnScrollWebView;
import com.zhy.autolayout.AutoLayoutActivity;
import com.zhy.changeskin.SkinManager;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.StringCallback;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.lang.ref.WeakReference;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import io.reactivex.functions.Consumer;
import me.iwf.photopicker.PhotoPicker;
import me.iwf.photopicker.PhotoPreview;
import okhttp3.Call;

import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
import static com.zhuomogroup.ylyk.MainApplication.BUGOUT_APPKEY;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.PLAY_POSITION;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.PUSH_TRUE;
import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_401;
import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_404;
import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_408;
import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_500;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_LIST_TYPE;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_MODEL_TYPE_NEXT;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_MODEL_TYPE_ONE;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_MODEL_TYPE_ONLY_ONE;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_SPEED_TIME_100;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_SPEED_TIME_125;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_SPEED_TIME_150;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_SPEED_TIME_80;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.THIS_BIGIN_PLAY_TYPE;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.COURSEID;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.IS_LOGIN;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.LAST_AUDIO_ID;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.LOCAL_FOR_WIFI_TOAST;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.SELECT_IMGS;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.VIEW_PAGER_IS_GONE;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.WEBVIEW_TEXT_SIZE;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.WRITE_TIPS_ISALSO_SHOW;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.WRITE_TIPS_STRING;
import static com.zhuomogroup.ylyk.network.Signature.UrlHeaders;
import static com.zhuomogroup.ylyk.network.Signature.UrlSignature;
import static com.zhuomogroup.ylyk.utils.EncryptionUtil.MD5;
import static com.zhuomogroup.ylyk.utils.SharedPreferencesUtil.get;
import static com.zhuomogroup.ylyk.utils.SharedPreferencesUtil.put;
import static me.iwf.photopicker.PhotoPicker.REQUEST_CODE;
import static me.iwf.photopicker.utils.FileUtils.fileIsExists;


/**
 * Created by xyb on 2017/1/20.
 */

public class YLAudioActivity extends AutoLayoutActivity implements View.OnClickListener, SeekBar.OnSeekBarChangeListener, YLPlayTypePopupWindow.OnSelectedListener,
        ViewPager.OnPageChangeListener, GestureDetector.OnGestureListener, View.OnTouchListener, ViewTreeObserver.OnGlobalLayoutListener, YLPlayListDialogFragment.GoToPlay, TextWatcher
//        , View.OnFocusChangeListener
{

    public static final String APPTEXT = "APPTEXT";
    public static final String DOWNLOAD_PATH = "/Android/data/com.zhuomogroup.ylyk/downloads/62933a2951ef01f4eafd9bdf4d3cd2f0/";
    private OnScrollWebView webView;
    private TextView titleText, nowTime, allTime;
    private ImageView backImg, playBack15, playForward15, playDownload, playMore, writeTips;
    private View viewBg;
    private ImageView playTypePush;
    private ImageView selectImgPush;
    private ImageView playList;
    private ImageView play_setting;
    private TextView imgSize;
    private int courseId;
    private SeekBar playSeek;
    private int duration;
    public static final String CSS =
            "<style>html,body{background:transparent;color:#5a5a5a;}*{-webkit-user-select:text!important;-moz-user-select:text!important;-ms-user-select: text!important;}</style>";
    private String name;
    private AudioControl audioControl;
    private MyServiceConnection myServiceConna;
    private ImageView playType;
    private YLPlayTypePopupWindow playTypePopupWindow;
    private YLPlaySettingPopupWindow ylPlaySettingPopupWindow;
    private AlertDialog.Builder alertDialog;
    private AlertDialog.Builder buyDialog;
    private int userId;
    private boolean isSeek = false;
    private boolean vip;
    private JSONArray teachers;
    private JSONObject album;
    private int albumId;
    private String replace;
    private String json;
    private AlertDialog lastAlertDialog;
    private WebSettings settings;
    private int[] webTextSize = {75, 100, 150};
    private int webTextSizeType = 1;
    private ViewPager viewPager;
    private YLAudioAdapter ylAudioAdapter;
    private GestureDetector detector; // 手势监听
    private ImageView imgChange;
    private RelativeLayout imgChangeRe;
    private EditText tipsEditText;
    private boolean beforeIsShow = true;
    private View pushTipsCard;
    private View playRela;
    private GestureDetector gestureDetector;
    private ArrayList<DataListBean> dataLists;
    private ImageView pushButton;
    private PushTipsController pushTipsController;
    private boolean isFromDownload = false;
    private ArrayList<String> selectedPhotos = new ArrayList<>();
    private int MY_COURSEID = 0;
    private String response;
    private String playListName;
    private QiYuActivityController controller;
    private RelativeLayout loadingRe;
    private RelativeLayout pushTipsCardRe;
    private static final int REQUEST_CODE_WRITE_SETTINGS = 0x01;
    private MainApplication uhApplication;
    /**
     * 当前Activity的弱引用，防止内存泄露
     **/
    private static WeakReference<Activity> context = null;
    private View rootView;

    private boolean isKeyboardShown(View rootView) {
        final int softKeyboardHeight = 50;
        Rect r = new Rect();
        rootView.getWindowVisibleDisplayFrame(r);
        DisplayMetrics dm = rootView.getResources().getDisplayMetrics();
        int heightDiff = rootView.getBottom() - r.bottom;
        return heightDiff > softKeyboardHeight * dm.density;
    }

    @Override
    protected void onCreate(Bundle savedInstanceState) {

        uhApplication = new MainApplication();

        context = new WeakReference<Activity>(this);
        uhApplication.pushTask(context);

        StrictMode.ThreadPolicy policy = new StrictMode.ThreadPolicy.Builder().permitAll().build();
        StrictMode.setThreadPolicy(policy);
        SkinManager.getInstance().register(this);
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_newaudio);


        EventBus.getDefault().register(this); //第1步: 注册


        initGetIntent();
        initView();
        initWebView();

        bindService();
        int a = BrightnessUtil.getScreenBrightness(this);
        BrightnessUtil.setBrightness(this, a);
    }

    private void onServiceConnection() {
        json = (String) get(this, courseId + "last_audio", "");

        if (NetworkUtil.isNetworkAvailable(this)) {
            if (NetworkUtil.isWifi(this)) {
                checkThread("wifi");
                initData();
            } else {
                checkThread("4g");
            }
        } else {
            checkThread("noNet");
        }
         rootView = getWindow().getDecorView().findViewById(android.R.id.content);
        rootView.getViewTreeObserver().addOnGlobalLayoutListener(this);
        initBugout(); // 初始化Bugout
    }

    private void initBugout() {
        BugoutConfig config = new BugoutConfig.Builder(this)
                .withAppKey(BUGOUT_APPKEY)     // 您的应用的项目ID,如果已经在 Manifest 中配置则此处可略
                .withAppChannel(APPTEXT)
                .withUserInfo(APPTEXT)    // 用户信息-崩溃分析根据用户记录崩溃信息
                .withDebugModel(true)    // 输出更多SDK的debug信息
                .withErrorActivity(true)    // 发生崩溃时采集Activity信息
                .withCollectNDKCrash(true) //  收集NDK崩溃信息
                .withOpenCrash(true)    // 收集崩溃信息开关
                .withOpenEx(true)     // 是否收集异常信息
                .withReportOnlyWifi(true)    // 仅在 WiFi 下上报崩溃信息
                .withReportOnBack(true)    // 当APP在后台运行时,是否采集信息
                .withQAMaster(true)    // 是否收集摇一摇反馈
                .withCloseOption(true)   // 是否在摇一摇菜单展示‘关闭摇一摇选项’
                .withLogCat(true)  // 是否系统操作信息
                .build();
        Bugout.init(config);
//        boolean shakeStatus = (boolean) SharedPreferencesUtil.get(this, SHAKE_STATUS, true);
//        Bugout.setShakeStatus(this, shakeStatus);
    }

    private void bindService() {
        Intent intent = new Intent(YLAudioActivity.this, AudioPlaybackService.class);
        startService(intent);
        myServiceConna = new MyServiceConnection();
        bindService(intent, myServiceConna, BIND_AUTO_CREATE);
    }


    private void initView() {


        controller = new QiYuActivityController();
        playList = (ImageView) findViewById(R.id.play_list);
        play_setting = (ImageView) findViewById(R.id.play_setting);
        webView = (OnScrollWebView) findViewById(R.id.webview);
        imgChangeRe = (RelativeLayout) findViewById(R.id.img_change_re);
        viewPager = (ViewPager) findViewById(R.id.viewPager);
        tipsEditText = (EditText) findViewById(R.id.tips_editText);
        writeTips = (ImageView) findViewById(R.id.write_tips);
        playMore = (ImageView) findViewById(R.id.play_more);
        imgChange = (ImageView) findViewById(R.id.img_change);
        titleText = (TextView) findViewById(R.id.title_center_text);
        nowTime = (TextView) findViewById(R.id.now_time);
        imgSize = (TextView) findViewById(R.id.img_size);
        allTime = (TextView) findViewById(R.id.all_time);
        backImg = (ImageView) findViewById(R.id.back_img);
        playDownload = (ImageView) findViewById(R.id.play_download);
        playType = (ImageView) findViewById(R.id.play_type);
        playBack15 = (ImageView) findViewById(R.id.play_back_15);
        playForward15 = (ImageView) findViewById(R.id.play_forward_15);
        playTypePush = (ImageView) findViewById(R.id.play_type_push);
        selectImgPush = (ImageView) findViewById(R.id.select_img_push);
        pushButton = (ImageView) findViewById(R.id.push_button);
        playSeek = (SeekBar) findViewById(R.id.play_seek);
        loadingRe = (RelativeLayout) findViewById(R.id.loading_re);
        pushTipsCardRe = (RelativeLayout) findViewById(R.id.push_tips_card_re);

        pushTipsCard = findViewById(R.id.push_tips_card);
        playRela = findViewById(R.id.play_rela);
        viewBg = findViewById(R.id.view_bg);
        pushTipsController = new PushTipsController(this);
        playTypePopupWindow = new YLPlayTypePopupWindow(getApplicationContext());
        ylPlaySettingPopupWindow = new YLPlaySettingPopupWindow(getApplicationContext());
        alertDialog = new AlertDialog.Builder(this);
        buyDialog = new AlertDialog.Builder(this);
        ylAudioAdapter = new YLAudioAdapter(this, courseId);
        viewPager.setOffscreenPageLimit(3);
        viewPager.setPageTransformer(false, new ScaleTransformer());
        boolean is_gone = (boolean) SharedPreferencesUtil.get(this, VIEW_PAGER_IS_GONE, true);
        if (is_gone) {
            viewPager.setVisibility(View.GONE);
            imgChange.setImageResource(R.mipmap.viewpager_gone);
        } else {
            viewPager.setVisibility(View.VISIBLE);
            imgChange.setImageResource(R.mipmap.viewpager_visible);
        }
        try {
            detector = new GestureDetector(this, this);
        }catch (Exception e){
            e.printStackTrace();
        }


    }

    @SuppressLint("SetTextI18n")
    private void myLastWriteTips() {
        String my_tips = (String) SharedPreferencesUtil.get(YLAudioActivity.this, courseId + WRITE_TIPS_STRING, "");
        if (!"".equals(my_tips)) {
            try {
                JSONObject object = new JSONObject(my_tips);
                String write_tips = object.getString(WRITE_TIPS_STRING);
                MY_COURSEID = object.getInt(COURSEID);
                JSONArray jsonArray = object.getJSONArray(SELECT_IMGS);
                selectedPhotos.clear();
                for (int i = 0; i < jsonArray.length(); i++) {
                    String string = jsonArray.getString(i);
                    selectedPhotos.add(string);
                }
                if (selectedPhotos.size() > 0) {
                    imgSize.setVisibility(View.VISIBLE);
                    imgSize.setText(selectedPhotos.size() + "");
                } else {
                    imgSize.setVisibility(View.GONE);
                }
                tipsEditText.setText(write_tips);
                tipsEditText.setSelection(tipsEditText.getText().length());
            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else {
            tipsEditText.setText("");
            selectedPhotos.clear();
            imgSize.setVisibility(View.GONE);
        }
    }


    /**
     * 设置是否有点击事件
     *
     * @param isLocal 是否可点击
     */
    private void initClick(boolean isLocal) {
        if (isLocal) {
            playDownload.setVisibility(View.VISIBLE);
            playList.setOnClickListener(this);
            play_setting.setOnClickListener(this);
            playType.setOnClickListener(this);
            playBack15.setOnClickListener(this);
            playForward15.setOnClickListener(this);
            playDownload.setOnClickListener(this);
            backImg.setOnClickListener(this);
            pushTipsCardRe.setOnClickListener(this);
            imgChangeRe.setOnClickListener(this);
            viewBg.setOnClickListener(this);
            playTypePush.setOnClickListener(this);
            selectImgPush.setOnClickListener(this);
            playMore.setOnClickListener(this);
            writeTips.setOnClickListener(this);
            playTypePopupWindow.setOnSelectedListener(this);
            playSeek.setOnSeekBarChangeListener(this);
            viewPager.setAdapter(ylAudioAdapter);
            viewPager.addOnPageChangeListener(this);
            viewPager.setOnTouchListener(this);
            pushButton.setOnClickListener(this);
//            tipsEditText.setOnFocusChangeListener(this);
            tipsEditText.addTextChangedListener(this);
            try {
                gestureDetector = new GestureDetector(this, new GestureDetector.OnGestureListener() {
                    @Override
                    public boolean onDown(MotionEvent e) {
                        return false;
                    }

                    @Override
                    public void onShowPress(MotionEvent e) {

                    }

                    @Override
                    public boolean onSingleTapUp(MotionEvent e) {
                        writeTipsShow();
                        return false;
                    }

                    @Override
                    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
                        return false;
                    }

                    @Override
                    public void onLongPress(MotionEvent e) {

                    }

                    @Override
                    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
                        return false;
                    }
                });
            }catch (Exception e){
                e.printStackTrace();
            }

            webView.setOnTouchListener(new View.OnTouchListener() {
                @Override
                public boolean onTouch(View v, MotionEvent event) {
                    return gestureDetector.onTouchEvent(event);
                }
            });

            setDownLoadImg(courseId);

        } else {
            backImg.setOnClickListener(this);
        }

    }

    private void writeTipsShow() {

        if (playTypePopupWindow.isPopupWindowShow()) {
            playTypePopupWindow.dismissPopupWindow(this);
        }
        if (pushTipsCard.getVisibility() == View.VISIBLE) {
            String tips_text = tipsEditText.getText().toString();
            int length = tips_text.length();
            // 长度大于零
            if (length > 0 || selectedPhotos.size() > 0) {
                try {
                    noteWriteCache(tips_text);

                    boolean isAlsoShow = (boolean) SharedPreferencesUtil.get(YLAudioActivity.this, WRITE_TIPS_ISALSO_SHOW, false);
                    if (!isAlsoShow) {
                        AlertDialog.Builder builder = new AlertDialog.Builder(YLAudioActivity.this);
                        builder.setMessage("本次编辑已自动保存");
                        builder.setNegativeButton("我知道了", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                                pushTipsCard.setVisibility(View.GONE);
                                playRela.setVisibility(View.VISIBLE);
                                writeTips.setVisibility(View.VISIBLE);
                            }
                        });
                        builder.setNeutralButton("不再提醒", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                                SharedPreferencesUtil.put(YLAudioActivity.this, WRITE_TIPS_ISALSO_SHOW, true);
                                pushTipsCard.setVisibility(View.GONE);
                                playRela.setVisibility(View.VISIBLE);
                                writeTips.setVisibility(View.VISIBLE);
                            }
                        });
                        AlertDialog alertDialog = builder.create();
                        if (!alertDialog.isShowing()) {
                            alertDialog.show();
                        }
                    } else {
                        pushTipsCard.setVisibility(View.GONE);
                        playRela.setVisibility(View.VISIBLE);
                        writeTips.setVisibility(View.VISIBLE);
                    }
                } catch (JSONException e1) {
                    e1.printStackTrace();
                }
            } else {
                pushTipsCard.setVisibility(View.GONE);
                playRela.setVisibility(View.VISIBLE);
                writeTips.setVisibility(View.VISIBLE);
                SharedPreferencesUtil.put(YLAudioActivity.this, courseId + WRITE_TIPS_STRING, "");
            }
        }
    }

    /**
     * 心得缓存
     *
     * @param tips_text
     * @throws JSONException
     */
    private void noteWriteCache(String tips_text) throws JSONException {
        JSONObject object = new JSONObject();
        object.put(WRITE_TIPS_STRING, tips_text);
        JSONArray array = new JSONArray();
        for (int i = 0; i < selectedPhotos.size(); i++) {
            array.put(selectedPhotos.get(i));
        }
        object.put(SELECT_IMGS, array);
        object.put(COURSEID, courseId);

        SharedPreferencesUtil.put(YLAudioActivity.this, courseId + WRITE_TIPS_STRING, object.toString());
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.play_type:
                if (audioControl.isPlaying()) {
                    audioControl.pause();
                } else {
                    audioControl.play();
                }
                break;
            case R.id.play_back_15:
                if (audioControl.isPlaying()) {
                    audioControl.seekTo(playSeek.getProgress() - 10000);
                }
                break;
            case R.id.play_forward_15:
                if (audioControl.isPlaying()) {
                    audioControl.seekTo(playSeek.getProgress() + 10000);
                }
                break;
            case R.id.play_download:

                if (isLogin()) return;
                if (!vip) {
                    alertDialog.setMessage("非友邻同学无法下载");
                    alertDialog.setNegativeButton("确定", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                        }
                    });
                    AlertDialog alertDialog = this.alertDialog.create();
                    if (!alertDialog.isShowing()) {
                        alertDialog.show();
                    }
                    return;
                }


                RxPermissions.getInstance(this)
                        .request(WRITE_EXTERNAL_STORAGE).subscribe(new Consumer<Boolean>() {
                    @Override
                    public void accept(Boolean agreePermission) throws Exception {
                        if (agreePermission) {
                            DownloadManager downloadManager = DownloadService.getDownloadManager();
                            String sdCardRoot = Environment.getExternalStorageDirectory().getAbsolutePath();
                            sdCardRoot = sdCardRoot + "/Android/data/com.zhuomogroup.ylyk/" + "downloads/62933a2951ef01f4eafd9bdf4d3cd2f0/";
                            String md5 = MD5(userId + "." + courseId);
                            String filePath = md5 + ".cache";
                            String finPath = sdCardRoot + filePath;
                            boolean isDownload = fileIsExists(finPath);

                            if (isDownload) {
                                Toast.makeText(YLAudioActivity.this, "已下载", Toast.LENGTH_SHORT).show();
                                return;
                            }

                            Map<String, String> stringStringMap = UrlHeaders(getApplication().getApplicationContext());
                            HttpHeaders httpHeaders = new HttpHeaders();
                            for (String s : stringStringMap.keySet()) {
                                httpHeaders.put(s, stringStringMap.get(s));
                            }
                            String downloadUrl = BASE_URL_HEAD + "course/" + courseId + "/media";


                            GetRequest request = OkGo.get(downloadUrl + UrlSignature()).headers(httpHeaders);//
                            downloadManager.setTargetFolder(sdCardRoot);
                            CourseBean downLoadBean = new CourseBean();
                            downLoadBean.setId(courseId);
                            AlbumBean album = new AlbumBean();
                            album.setId(albumId);
                            album.setName(YLAudioActivity.this.album.getString("name"));
                            downLoadBean.setAlbum(album);
                            downLoadBean.setDuration(duration + "");
                            downLoadBean.setName(name);
                            downLoadBean.setTeachers(teachers.toString());
                            String content = (String) get(YLAudioActivity.this, courseId + "", "");
                            if (!"".equals(content)) {
                                JSONObject jsonObject = new JSONObject(content);
                                long in_time = jsonObject.getLong("in_time");
                                downLoadBean.setInTime(in_time * 1000L);
                            }

                            downloadManager.addTask(downloadUrl, downLoadBean, request, new AudioDownloadListener(getApplicationContext()));
                            Toast.makeText(YLAudioActivity.this, "已添加到下载列表", Toast.LENGTH_SHORT).show();
                        }
                    }
                });


                break;
            case R.id.play_more:
                if (!playTypePopupWindow.isPopupWindowShow()) {
                    playTypePopupWindow.showPopupWindow(this, audioControl.getRate(), response);
                }
                break;
            case R.id.play_setting:
//                RxPermissions.getInstance(this)
//                        .request(WRITE_SETTINGS,WRITE_CONTACTS,CHANGE_CONFIGURATION).subscribe(new Consumer<Boolean>() {
//                    @Override
//                    public void accept(Boolean agreePermission) throws Exception {
//                        if (agreePermission) {
//                            if (!ylPlaySettingPopupWindow.isPopupWindowShow()) {
//                                ylPlaySettingPopupWindow.showPopupWindow(YLAudioActivity.this);
//                            }
//                        }
//
//                    }
//                });

                if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                    if (Settings.System.canWrite(this)) {
                        if (!ylPlaySettingPopupWindow.isPopupWindowShow()) {
                            ylPlaySettingPopupWindow.showPopupWindow(YLAudioActivity.this);
                        }
                    } else {
                        requestWriteSettings();
                    }
                } else {
                    if (!ylPlaySettingPopupWindow.isPopupWindowShow()) {
                        ylPlaySettingPopupWindow.showPopupWindow(YLAudioActivity.this);
                    }
                }

                break;
            case R.id.write_tips:
                if (playTypePopupWindow.isPopupWindowShow()) {
                    playTypePopupWindow.dismissPopupWindow(this);
                }
                if (isLogin()) return;
                myLastWriteTips();
                if (pushTipsCard.getVisibility() == View.GONE) {
                    pushTipsCard.setVisibility(View.VISIBLE);
                    tipsEditText.requestFocus();
                    playRela.setVisibility(View.GONE);
                    writeTips.setVisibility(View.GONE);
                    InputMethodManager imm = (InputMethodManager) getSystemService(Context.INPUT_METHOD_SERVICE);
                    imm.toggleSoftInput(0, InputMethodManager.HIDE_NOT_ALWAYS);
                }
                break;
            case R.id.back_img:
                finish();
                break;

            case R.id.img_change_re:
                if (viewPager.getVisibility() == View.GONE) {
                    viewPager.setVisibility(View.VISIBLE);
                    imgChange.setImageResource(R.mipmap.viewpager_visible);
                    SharedPreferencesUtil.put(this, VIEW_PAGER_IS_GONE, false);
                } else if (viewPager.getVisibility() == View.VISIBLE) {
                    viewPager.setVisibility(View.GONE);
                    imgChange.setImageResource(R.mipmap.viewpager_gone);
                    SharedPreferencesUtil.put(this, VIEW_PAGER_IS_GONE, true);
                }
                break;
            case R.id.view_bg:
                InputMethodManager imm = (InputMethodManager)
                        getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(viewBg.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);

                writeTipsShow();

                break;
            case R.id.select_img_push:
                Intent intent = new Intent(this, YLPhotoActivity.class);
                intent.putStringArrayListExtra("selectedPhotos", selectedPhotos);
                startActivityForResult(intent, REQUEST_CODE);
                break;
            case R.id.play_type_push:
                if (audioControl.isPlaying()) {
                    audioControl.pause();
                } else {
                    audioControl.play();
                }
                break;
            case R.id.play_list:
                showPlayList();
                break;
            case R.id.push_button:
                String tipsString = tipsEditText.getText().toString().trim();
                if (tipsString.equals("")) {
                    Toast.makeText(this, "写点什么再发布吧", Toast.LENGTH_SHORT).show();
                    return;
                }
                if (MY_COURSEID == 0) {
                    pushTipsController.pushInterFace(tipsString, courseId, selectedPhotos);
                } else {
                    pushTipsController.pushInterFace(tipsString, MY_COURSEID, selectedPhotos);
                }

                break;
        }

    }

    private void noNetWork() {
        alertDialog.setMessage("请检查网络设置，或收听已缓存的节目");
        alertDialog.setCancelable(false);
        alertDialog.setNegativeButton("确定", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                finish();
            }
        });
        AlertDialog alertDialog = this.alertDialog.create();
        if (!alertDialog.isShowing()) {
            alertDialog.show();
        }
    }

    /**
     * 如果是 流量模式下的 操作提示
     */
    private void is4GWork() {
        alertDialog.setMessage("确定使用流量听课？");
        alertDialog.setCancelable(false);
        alertDialog.setPositiveButton("取消", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                finish();
            }
        });
        alertDialog.setNeutralButton("不再提醒", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                SharedPreferencesUtil.put(getApplicationContext(), LOCAL_FOR_WIFI_TOAST, true);
                playSeek.post(new Runnable() {
                    @Override
                    public void run() {
                        initData();
                    }
                });
            }
        });
        alertDialog.setNegativeButton("确定", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                dialog.dismiss();
                playSeek.post(new Runnable() {
                    @Override
                    public void run() {
                        initData();
                    }
                });
            }
        });
        AlertDialog alertDialog = this.alertDialog.create();
        if (!alertDialog.isShowing()) {
            alertDialog.show();
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN) //在ui线程执行
    public void onDataSynEvent(DownloadInfo demo1) {
        CourseBean data = (CourseBean) demo1.getData();
        if (data.getId() == courseId) {
            playDownload.setSelected(true);
        }
    }

    private boolean beforeIsPlay = false;

    @Subscribe(threadMode = ThreadMode.MAIN) //在ui线程执行
    public void isPlayIng(String message) {

        if (message.equals("true")) {
            if (audioControl.isPlaying()) {
                beforeIsPlay = true;
                audioControl.pause();
            } else {
                beforeIsPlay = false;
            }
        } else if (message.equals("false")) {
            if (beforeIsPlay) {
                audioControl.play();
            }

        } else if (message.equals(PUSH_TRUE)) {
            if (tipsEditText != null) {

                InputMethodManager imm = (InputMethodManager)
                        getSystemService(Context.INPUT_METHOD_SERVICE);
                imm.hideSoftInputFromWindow(tipsEditText.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);


                tipsEditText.setText("");
                SharedPreferencesUtil.put(YLAudioActivity.this, MY_COURSEID + WRITE_TIPS_STRING, "");
                MY_COURSEID = 0;

                if (pushTipsCard.getVisibility() == View.VISIBLE) {
                    pushTipsCard.setVisibility(View.GONE);
                    playRela.setVisibility(View.VISIBLE);
                    writeTips.setVisibility(View.VISIBLE);
                }
                selectedPhotos.clear();
                if (selectedPhotos.size() > 0) {
                    imgSize.setVisibility(View.VISIBLE);
                    imgSize.setText(selectedPhotos.size() + "");
                } else {
                    imgSize.setVisibility(View.GONE);
                }

            }


        } else if (message.equals("PLAY_TYPE")) {
            if (audioControl != null) {
                int play_type = (int) SharedPreferencesUtil.get(getApplicationContext(), PLAY_LIST_TYPE, THIS_BIGIN_PLAY_TYPE);
                audioControl.setPlayType(play_type);
            }
        }
    }

    /**
     * 检查本地 节目内容 缓存
     * <p>
     * courseId 为SP 标签
     */

    private void checkThread(final String type) {
        new Thread(new Runnable() {
            @Override
            public void run() {
                String content = (String) get(YLAudioActivity.this, courseId + "", "");
                if (!"".equals(content)) {
                    try {
                        final JSONObject jsonObject = new JSONObject(content);
                        name = jsonObject.getString("name");
                        duration = jsonObject.getInt("duration");
                        teachers = jsonObject.getJSONArray("teachers");
                        album = jsonObject.getJSONObject("album");
                        albumId = album.getInt("id");
                        String data = jsonObject.getString("content");
                        replace = data.replaceFirst(name, "");

                        boolean is_free = album.getBoolean("is_free");
                        if (!is_free) {
                            // 不是免费的
                            if (vip) {
                                // 是vip
                                localAudioPlay(jsonObject);
                            }
                        } else {
                            // 是免费的
                            localAudioPlay(jsonObject);
                        }

                    } catch (Exception e) {
                        e.printStackTrace();
                        Toast.makeText(YLAudioActivity.this, "本地解析失败", Toast.LENGTH_SHORT).show();
                        put(YLAudioActivity.this, courseId + "", "");
                    }
                } else {
                    // 本地无缓存
                    runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            if (type.equals("noNet")) {
                                noNetWork();
                            } else if (type.equals("4g")) {
                                boolean b = (boolean) SharedPreferencesUtil.get(getApplicationContext(), LOCAL_FOR_WIFI_TOAST, false);
                                if (!b) {
                                    is4GWork();
                                } else {
                                    playSeek.post(new Runnable() {
                                        @Override
                                        public void run() {
                                            initData();
                                        }
                                    });
                                }
                            }
                            initClick(false);
                            if (audioControl != null) {
                                audioControl.stop();
                            }
                        }
                    });


                }
            }

            private void localAudioPlay(final JSONObject jsonObject) {
                runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        try {
                            loadAudio(jsonObject, replace, albumId);
                            initClick(true);
                        } catch (Exception e) {
                            e.printStackTrace();
                            Toast.makeText(YLAudioActivity.this, "解析失败" + "请稍后重试", Toast.LENGTH_SHORT).show();
                        }
                    }
                });
            }
        }).start();
    }

    @SuppressLint("SetJavaScriptEnabled")
    private void initWebView() {
        settings = webView.getSettings();
        settings.setJavaScriptEnabled(true);
        settings.setDisplayZoomControls(true);
        settings.setDefaultFixedFontSize(20);
        //适应屏幕
        settings.setAppCacheEnabled(true);
        settings.setCacheMode(WebSettings.LOAD_DEFAULT);
        settings.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.NARROW_COLUMNS);
        settings.setLoadWithOverviewMode(true);
        settings.setBuiltInZoomControls(false); // 设置不显示缩放按钮

//        webView.setWebChromeClient(new android.webkit.WebChromeClient(){
//
//        });
//        webView.setWebViewClient(new android.webkit.WebViewClient(){
//
//        });
        webView.setBackgroundColor(0);

        webTextSizeType = (int) SharedPreferencesUtil.get(this, WEBVIEW_TEXT_SIZE, webTextSizeType);
        webTextSizeType = webTextSizeType % 3;
        settings.setTextZoom(webTextSize[webTextSizeType]);
    }


    private void setDownLoadImg(int courseId) {
        this.courseId = courseId;
        ylAudioAdapter.setCourseId(courseId);
        myLastWriteTips();
        try {
            String sdCardRoot = Environment.getExternalStorageDirectory().getAbsolutePath();
            sdCardRoot = sdCardRoot + DOWNLOAD_PATH;
            String md5 = MD5(userId + "." + courseId);
            String filePath = md5 + ".cache";
            sdCardRoot = sdCardRoot + filePath;
            boolean isDownload = fileIsExists(sdCardRoot);
            if (isDownload) {
                playDownload.setSelected(true);
            } else {
                playDownload.setSelected(false);
            }
        } catch (Exception e) {
            Toast.makeText(this, "SD卡未加载 或 检查读写权限" + e.getMessage(), Toast.LENGTH_SHORT).show();
        }
    }


    private void initGetIntent() {
        Intent intent = getIntent();

        Bundle objectJS = intent.getBundleExtra("AudioDataBean");
        if (objectJS != null) {
            AudioDataBean demo = objectJS.getParcelable("AudioDataBean");
            assert demo != null;
            courseId = demo.getCourseId();
            if (courseId == 0) {
                courseId = (int) get(this, LAST_AUDIO_ID, courseId);
            }
            initDataFirst();
            isFromDownload = demo.isDownload();
            if (isFromDownload) {
                dataLists = demo.getDataLists();
            }
        } else {

            courseId = (int) get(this, LAST_AUDIO_ID, courseId);

            initDataFirst();
        }
    }

    private void initDataFirst() {
        String user_info = (String) get(this, USER_INFO, "");
        if (!"".equals(user_info)) {
            try {
                JSONObject object = new JSONObject(user_info);
                this.userId = object.getInt("id");
                try {
                    JSONObject vip = object.getJSONObject("vip");
                    if (vip != null) {
                        boolean is_permanent = vip.getBoolean("is_permanent");
                        if (is_permanent) {
                            this.vip = true;
                        } else {
                            long end_time = vip.getInt("end_time");
                            long todayTime = System.currentTimeMillis() / 1000L;
                            this.vip = end_time > todayTime;
                        }
                    } else {
                        this.vip = false;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    this.vip = false;
                }

                OkHttpUtils.get()
                        .url(BASE_URL_HEAD + "user/" + userId + Signature.UrlSignature())
                        .headers(Signature.UrlHeaders(this))
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
                                        SharedPreferencesUtil.put(YLAudioActivity.this, USER_INFO, response);
                                    } else {
                                        Toast.makeText(YLAudioActivity.this, "requestBean.getCode():" + requestBean.getCode(), Toast.LENGTH_SHORT).show();
                                    }
                                }
                            }
                        });
            } catch (JSONException e) {
                e.printStackTrace();
            }
        } else {
            this.userId = 0;
            this.vip = false;
        }
        if (this.userId == 0) {
            put(this, IS_LOGIN, false);
        } else {
            put(this, IS_LOGIN, true);
        }
    }

    // 有网请求数据
    private void initData() {
        OkHttpUtils.get()
                .url(BASE_URL_HEAD + "course/" + courseId + Signature.UrlSignature())
                .headers(Signature.UrlHeaders(this))
                .build()
                .execute(
                        new BaseStringCallback() {
                            @Override
                            public void onError(Call call, Exception e, int id) {
                                e.printStackTrace();

                                Toast.makeText(getApplicationContext(), "网络出错，请稍后再试", Toast.LENGTH_SHORT).show();
                            }

                            @Override
                            public void onResponse(String response, int id) {
                                loadingRe.setVisibility(View.GONE);
                                Gson gson = new Gson();
                                ReactRequestBean myRequestBean = gson.fromJson(response, ReactRequestBean.class);
                                if (myRequestBean.isResult()) {
                                    response = myRequestBean.getResponse();
                                    getIntentData(response);
                                } else {
                                    if (myRequestBean.getCode() == HTTP_CODE_404) {
                                        Toast.makeText(YLAudioActivity.this, "课程已下线,请选择其他课程", Toast.LENGTH_SHORT).show();
                                    } else if (myRequestBean.getCode() == HTTP_CODE_401) {
                                        buyDialog.setTitle("登陆失效");
                                        buyDialog.setMessage("您的登录已失效,请重新登录");
                                        buyDialog.setNegativeButton("重新登录", new DialogInterface.OnClickListener() {
                                            @Override
                                            public void onClick(DialogInterface dialog, int which) {
                                                dialog.dismiss();
                                                Intent intent = new Intent(getApplicationContext(), YLLoginActivity.class);
                                                startActivity(intent);
                                                finish();
                                            }
                                        });
                                        buyDialog.setCancelable(false);
                                        AlertDialog alertDialog = buyDialog.create();
                                        if (!alertDialog.isShowing()) {
                                            if (YLAudioActivity.this != null) {
                                                alertDialog.show();
                                            }
                                        }
                                        if (audioControl != null) {
                                            audioControl.stop();
                                        }
                                    } else if (myRequestBean.getCode() == HTTP_CODE_408) {

                                    } else if (myRequestBean.getCode() == HTTP_CODE_500) {
                                        Toast.makeText(YLAudioActivity.this, R.string.http_500, Toast.LENGTH_SHORT).show();

                                    }


                                }

                            }
                        }
                );
    }


    private void getIntentData(String response) {
        try {
            JSONObject jsonObject = new JSONObject(response);
            name = jsonObject.getString("name");
            duration = jsonObject.getInt("duration");
            teachers = jsonObject.getJSONArray("teachers");
            album = jsonObject.getJSONObject("album");
            albumId = album.getInt("id");
            String data = jsonObject.getString("content");
            replace = data.replaceFirst(name, "");
            boolean is_free = album.getBoolean("is_free");
            if (!is_free) {
                // 不是免费的
                if (!vip) {
                    openLoginActivity();
                } else {
                    // 是vip
                    loadAudio(jsonObject, replace, albumId);
                    initClick(true);
                    Message message = new Message();
                    message.obj = response;
                    message.what = 0;
                    if (handler != null) {
                        handler.sendMessageDelayed(message, 10);
                    }
                }
            } else {
                // 是免费的
                loadAudio(jsonObject, replace, albumId);
                initClick(true);
                Message message = new Message();
                message.obj = response;
                message.what = 0;
                if (handler != null) {
                    handler.sendMessageDelayed(message, 10);
                }
            }
        } catch (JSONException e) {
            e.printStackTrace();
            Toast.makeText(YLAudioActivity.this, "解析失败", Toast.LENGTH_SHORT).show();

        }
    }

    private void openLoginActivity() {
        // 不是vip
        if (!(userId == 0)) {
            buyDialog.setMessage("成为友邻优课学员即可收听此课程");
            buyDialog.setNeutralButton("立即入学", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                    finish();
                }
            });
            buyDialog.setPositiveButton("取消", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    YLAudioActivity.this.finish();
                }
            });
            buyDialog.setNegativeButton("咨询阿树老师", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    controller.pushInterFace(YLAudioActivity.this);
                    finish();
                }
            });
            buyDialog.setCancelable(false);
            AlertDialog alertDialog = buyDialog.create();
            if (!alertDialog.isShowing()) {
                alertDialog.show();
            }
            if (audioControl != null) {
                audioControl.stop();
            }
        } else {
            buyDialog = new AlertDialog.Builder(this);
            buyDialog.setMessage("此节目为会员专享，请登录");
            buyDialog.setNeutralButton("去登录", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                    Intent intent = new Intent(getApplicationContext(), YLLoginActivity.class);
                    startActivity(intent);
                    finish();
                }
            });
            buyDialog.setNegativeButton("取消", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    YLAudioActivity.this.finish();
                }
            });
            buyDialog.setCancelable(false);
            AlertDialog alertDialog = buyDialog.create();
            if (!alertDialog.isShowing()) {
                alertDialog.show();
            }
            if (audioControl != null) {
                audioControl.stop();
            }
        }
    }

    @Subscribe(threadMode = ThreadMode.MAIN) //在ui线程执行
    public void name(YLYKPlayerNativeModule.IntentActivity intentActivity) {
        this.finish();
    }

    private Handler handler = new Handler(new Handler.Callback() {
        @Override
        public boolean handleMessage(Message msg) {
            switch (msg.what) {
                case 0:
                    String response = (String) msg.obj;
                    try {
                        JSONObject object = new JSONObject(response);
                        int id = object.getInt("id");
                        put(YLAudioActivity.this, id + "", response);

                        YLAudioActivity.this.response = response;
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    break;
                case 1:
                    try {
                        loadAudio((JSONObject) msg.obj, replace, albumId);
                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                    break;

            }
            return false;
        }
    });


    /**
     * 加载aduio 数据
     *
     * @param jsonObject
     * @param replace
     * @param albumId
     * @throws JSONException
     */
    private void loadAudio(JSONObject jsonObject, String replace, int albumId) throws JSONException {
        loadingRe.setVisibility(View.GONE);

        if (!isFromDownload) {
            // 获取节目列表
            initAlbumList(albumId);
        } else {
            audioControl.setDataList(albumId, dataLists);
            playListName = "播放列表";
        }
        String s = (String) SharedPreferencesUtil.get(YLAudioActivity.this, "NOW_CSS", "");
        String cssUrl;

        if ("".equals(s)) {
            cssUrl = "<link rel=\"stylesheet\" href=\"file:///android_asset/webView.css\"  type=\"text/css\"/>";

        } else {
            cssUrl = "<link rel=\"stylesheet\" href=\"file:///" + s + "\"  type=\"text/css\"/>";

        }

        webView.loadDataWithBaseURL(null, cssUrl + CSS + replace, "text/html", "utf-8", null);
        String media_url = jsonObject.getString("media_url");

        checkCachedStateOn(media_url);
        titleText.setText(jsonObject.getString("name"));
        if (audioControl == null) {
            Message message = new Message();
            message.what = 1;
            message.obj = jsonObject;
            if (handler != null) {
                handler.sendMessageDelayed(message, 10);
            }
            return;
        }

        int nowCourseId = audioControl.getCourseId();
        String audio_url = audioControl.getAudio_url();
        // 如果有播放返回
        if (nowCourseId == jsonObject.getInt("id") && media_url.equals(audio_url)) {
            int duration = (int) audioControl.getDurationIntenet();
            int progress = (int) audioControl.getProgress();
            String allToTime = AudioTimeUtil.secToTime(duration);
            String progressToTime = AudioTimeUtil.secToTime(progress);
            nowTime.setText(progressToTime);
            allTime.setText(allToTime);
            playSeek.setMax(duration);
            playSeek.setProgress(progress);
            return;
        }

        audioControl.setDataSource(media_url, courseId, jsonObject.getString("name"), userId, duration);
        try {
            boolean equals = json.equals("");
            if (!equals) {
                JSONObject jsonOb = new JSONObject(json);
                if (courseId == jsonOb.getInt("courseId")) {
                    final int time = jsonOb.getInt("time");
                    int learn_time = time / 1000;
                    if (learn_time < 10) {
                        audioControl.play();
                        return;

                    }
                    String timeText = AudioTimeUtil.secToTime(time);
                    alertDialog.setMessage("上次听到" + timeText + "，" + "是否继续");
                    alertDialog.setNeutralButton("取消", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                            audioControl.play();
                        }
                    });
                    alertDialog.setNegativeButton("继续", new DialogInterface.OnClickListener() {
                        @Override
                        public void onClick(DialogInterface dialog, int which) {
                            dialog.dismiss();
                            audioControl.play();
                            audioControl.seekTo(time);
                        }
                    });
                    if (lastAlertDialog == null) {
                        lastAlertDialog = this.alertDialog.create();
                        if (!lastAlertDialog.isShowing()) {
                            try {
                                if (YLAudioActivity.this != null) {
                                    alertDialog.show();
                                }
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    }
                } else {
                    audioControl.play();
                }
            } else {
                audioControl.play();
            }

        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    /**
     * 设置顺序播放列表
     *
     * @param albumId 专辑的 id
     */
    private void initAlbumList(final int albumId) {


        OkHttpUtils.get()
                .url(BASE_URL_HEAD + "album/" + albumId + Signature.UrlSignature())
                .headers(Signature.UrlHeaders(this))
                .build()
                .execute(new BaseStringCallback() {
                    @Override
                    public void onError(Call call, Exception e, int id) {

                    }

                    @Override
                    public void onResponse(String response, int id) {
                        Gson gson = new Gson();
                        RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                        if (requestBean.isResult()) {
                            response = requestBean.getResponse();
                            try {
                                JSONObject object = new JSONObject(response);
                                boolean isFinished = object.getBoolean("is_finished");

                                getAlbumList(albumId, isFinished);
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }
                    }
                });


    }

    private void getAlbumList(final int albumId, final boolean isFinished) {
        TreeMap<String, String> params = new TreeMap<>();
        params.put("album_id", albumId + "");
        params.put("limit", 100 + "");
        OkHttpUtils.get()
                .url(BASE_URL_HEAD + "course" + Signature.UrlSignature(params))
                .headers(Signature.UrlHeaders(this))
                .build()
                .execute(new StringCallback() {
                    @Override
                    public void onError(Call call, Exception e, int id) {
                        e.printStackTrace();
                    }

                    @Override
                    public void onResponse(String response, int id) {
                        try {
                            JSONArray jsonArray = new JSONArray(response);
                            dataLists = new ArrayList<>();
                            if (jsonArray.length() > 0) {
                                for (int i = 0; i < jsonArray.length(); i++) {
                                    JSONObject jsonObject = jsonArray.getJSONObject(i);
                                    int courseId = jsonObject.getInt("id");
                                    String name = jsonObject.getString("name");
                                    JSONArray teachers = jsonObject.getJSONArray("teachers");
                                    long in_time = jsonObject.getLong("in_time");
                                    int duration = jsonObject.getInt("duration");
                                    playListName = album.getString("name");

                                    DataListBean dataList = new DataListBean();
                                    dataList.setCourseId(courseId);
                                    dataList.setName(name);
                                    dataList.setTeacherName(teachers.toString());
                                    dataList.setDuration(duration);
                                    dataList.setIn_time(in_time);
                                    dataLists.add(dataList);

                                }
                            }
                            if (!isFinished) {
                                audioControl.setDataList(albumId, dataLists);
                            } else {
                                ArrayList<DataListBean> dataListBeen = new ArrayList<>();
                                for (int i = dataLists.size() - 1; i >= 0; i--) {
                                    DataListBean dataListBean = dataLists.get(i);
                                    dataListBeen.add(dataListBean);
                                }
                                dataLists.clear();
                                dataLists = null;
                                dataLists = dataListBeen;
                                audioControl.setDataList(albumId, dataLists);
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                        }
                    }
                });
    }


    /**
     * 检查缓存状态
     *
     * @param url 缓存的 网络url地址
     */
    private void checkCachedStateOn(String url) {
        try {
            boolean fullyCached = MainApplication.getProxy(getApplicationContext()).isCached(url);
            if (fullyCached && onListener != null) {
                onListener.getCacheProgress(100);
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
    }


    AudioPlaybackService.OnListener onListener = new AudioPlaybackService.OnListener() {

        private PlaySelectBean playSelectBean = new PlaySelectBean();
        private boolean isPlay;


        @Override
        public void onTimeChange() {
            int duration = (int) audioControl.getDurationIntenet();
            int progress = (int) audioControl.getProgress();
            String allToTime = AudioTimeUtil.secToTime(duration);
            String progressToTime = AudioTimeUtil.secToTime(progress);
            if (!isSeek) {
                playSeek.setMax(duration);
                playSeek.setProgress(progress);
                nowTime.setText(progressToTime);
                allTime.setText(allToTime);
            }
            if (!isPlay) {
                playType.setSelected(false);
                playTypePush.setImageResource(R.drawable.tips_pause_img);
                playSelectBean.setType(YLBaseUrl.PLAY_TYPE);
                playSelectBean.setPlay(true);
                EventBus.getDefault().post(playSelectBean);
                isPlay = true;
            }
        }

        @Override
        public void onPositionChange() {

        }


        @Override
        public void Stopped() {

            if (isPlay) {
                playType.setSelected(true);

                playTypePush.setImageResource(R.drawable.tips_play_img);
                playSelectBean.setType(YLBaseUrl.PLAY_TYPE);
                playSelectBean.setPlay(false);
                EventBus.getDefault().post(playSelectBean);
                isPlay = false;
            }

        }

        @Override
        public void onEndReached() {
            if (isPlay) {
                nowTime.setText("00:00");
                playSeek.setMax(0);
                playSeek.setProgress(0);
                playType.setSelected(true);

                playTypePush.setImageResource(R.drawable.tips_play_img);
                playSelectBean.setType(YLBaseUrl.PLAY_TYPE);
                playSelectBean.setPlay(false);
                EventBus.getDefault().post(playSelectBean);
                isPlay = false;
            }

        }

        @Override
        public void onPlaying() {

            if (!isPlay) {
                playType.setSelected(false);
                playTypePush.setImageResource(R.drawable.tips_pause_img);
                playSelectBean.setType(YLBaseUrl.PLAY_TYPE);
                playSelectBean.setPlay(true);
                EventBus.getDefault().post(playSelectBean);
                isPlay = true;

            }

        }

        @Override
        public void onPaused() {
            if (isPlay) {
                playType.setSelected(true);
                playTypePush.setImageResource(R.drawable.tips_play_img);

                playSelectBean.setType(YLBaseUrl.PLAY_TYPE);
                playSelectBean.setPlay(false);
                EventBus.getDefault().post(playSelectBean);
                isPlay = false;
            }


        }

        @Override
        public void getCacheProgress(int i) {
            int max = playSeek.getMax();
            playSeek.setSecondaryProgress(max * i / 100);

        }

        @Override
        public void checkCachedState(String url) {
            checkCachedStateOn(url);
        }

        @Override
        public void setWebViewContent(String content, String name, JSONArray teachers, boolean is_liked, String like_count, int courseId, String response) {

            Message message = new Message();
            message.obj = response;
            message.what = 0;
            if (handler != null) {
                handler.sendMessageDelayed(message, 10);
            }

            YLAudioActivity.this.name = name;
            String s = (String) SharedPreferencesUtil.get(YLAudioActivity.this, "NOW_CSS", "");
            String cssUrl;

            if ("".equals(s)) {
                cssUrl = "<link rel=\"stylesheet\" href=\"file:///android_asset/webView.css\"  type=\"text/css\"/>";

            } else {
                cssUrl = "<link rel=\"stylesheet\" href=\"file:///" + s + "\"  type=\"text/css\"/>";

            }

            webView.loadDataWithBaseURL(null, cssUrl + CSS + content, "text/html", "utf-8", null);
            titleText.setText(name);
            setDownLoadImg(courseId);

            // 发送列表postion 到 dialogfragment
            PlaySelectBean playSelectBean = new PlaySelectBean();

            playSelectBean.setType(PLAY_POSITION);
            playSelectBean.setCourseId(courseId);
            EventBus.getDefault().post(playSelectBean);
            loadingRe.setVisibility(View.GONE);

        }
    };


    /**
     * 判断是否登录 没有登录 返回 true  登录 返回 false
     *
     * @return 返回是否登录
     */
    private boolean isLogin() {
        if (userId == 0) {
            alertDialog.setMessage("请先登录");
            alertDialog.setNegativeButton("确定", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                    finish();
                }
            });
            alertDialog.setNeutralButton("取消", new DialogInterface.OnClickListener() {
                @Override
                public void onClick(DialogInterface dialog, int which) {
                    dialog.dismiss();
                }
            });
            AlertDialog alertDialog = this.alertDialog.create();
            if (!alertDialog.isShowing()) {
                alertDialog.show();
            }
            return true;
        }
        return false;
    }

    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        String allToTime = AudioTimeUtil.secToTime(seekBar.getMax());
        String progressToTime = AudioTimeUtil.secToTime(progress);
        nowTime.setText(progressToTime);
        allTime.setText(allToTime);

    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {
        isSeek = true;

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {
        isSeek = false;
        int progress = seekBar.getProgress();
        audioControl.seekTo(progress);

    }

    public void showPlayList() {
        int position = 0;
        if (dataLists != null) {
            for (int i = 0; i < dataLists.size(); i++) {
                int courseId = dataLists.get(i).getCourseId();
                if (this.courseId == courseId) {
                    position = i;
                    //   获得当前曲目的下标
                }
            }


            YLPlayListDialogFragment ylPlayListDialogFragment = YLPlayListDialogFragment.newInstance(dataLists, position, audioControl.isPlaying(), playListName);
            ylPlayListDialogFragment.showDialog(getSupportFragmentManager());


        }
    }

    @Override
    public void OnSelected(View v, int position, int type) {
        switch (position) {
            case 0:


                Intent intent = new Intent(this, YLNoteActivity.class);
                JSONObject courseInfo = new JSONObject();
                try {
                    courseInfo.put("id", courseId);
                    courseInfo.put("teachers", teachers.toString());
                    courseInfo.put("courseName", name);

                    intent.putExtra("courseInfo", courseInfo.toString());
                    startActivity(intent);

                    if (playTypePopupWindow.isPopupWindowShow()) {
                        playTypePopupWindow.dismissPopupWindow(this);
                    }
                } catch (JSONException e) {
                    e.printStackTrace();
                }


                break;
            case 1:
                if (audioControl != null) {
                    switch (type) {
                        case PLAY_SPEED_TIME_80:
                            audioControl.setRate(0.8f);
                            break;
                        case PLAY_SPEED_TIME_100:
                            audioControl.setRate(1f);
                            break;
                        case PLAY_SPEED_TIME_125:
                            audioControl.setRate(1.25f);
                            break;
                        case PLAY_SPEED_TIME_150:
                            audioControl.setRate(1.5f);
                            break;
                    }
                }


                break;
            case 2:
                if (audioControl != null) {
                    switch (type) {

                        case PLAY_MODEL_TYPE_ONE:
                            audioControl.setPlayType(PLAY_MODEL_TYPE_ONE);
                            break;
                        case PLAY_MODEL_TYPE_NEXT:
                            audioControl.setPlayType(PLAY_MODEL_TYPE_NEXT);
                            break;
                        case PLAY_MODEL_TYPE_ONLY_ONE:
                            audioControl.setPlayType(PLAY_MODEL_TYPE_ONLY_ONE);
                            break;

                    }
                }

                break;
            case 3:
                if (playTypePopupWindow.isPopupWindowShow()) {
                    playTypePopupWindow.dismissPopupWindow(this);
                }
                break;
            case 4:
                webTextSizeType++;
                webTextSizeType = webTextSizeType % 3;
                settings.setTextZoom(webTextSize[webTextSizeType]);
                SharedPreferencesUtil.put(this, WEBVIEW_TEXT_SIZE, webTextSizeType);
                break;
            case 5:
                boolean isChecked;
                if (isLogin()) {
                    return;
                }

                isChecked = type == 1;
                if (isChecked) {
                    OkHttpUtils.post()
                            .url(BASE_URL_HEAD + "course/" + courseId + "/like" + Signature.UrlSignature())
                            .headers(Signature.UrlHeaders(this))
                            .build().execute(new StringCallback() {
                        @Override
                        public void onError(Call call, Exception e, int id) {
                            e.printStackTrace();
                        }

                        @Override
                        public void onResponse(String response, int id) {
                            try {
                                JSONObject jsonObject = new JSONObject(response);
                                boolean result = jsonObject.getBoolean("result");
                                if (result) {
                                    refreshResponse();

                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }
                    });
                } else {
                    OkHttpUtils.delete()
                            .url(BASE_URL_HEAD + "course/" + courseId + "/like" + Signature.UrlSignature())
                            .headers(Signature.UrlHeaders(this))
                            .build().execute(new StringCallback() {
                        @Override
                        public void onError(Call call, Exception e, int id) {
                            e.printStackTrace();
                        }

                        @Override
                        public void onResponse(String response, int id) {
                            try {
                                JSONObject jsonObject = new JSONObject(response);
                                boolean result = jsonObject.getBoolean("result");
                                if (result) {
                                    refreshResponse();

                                }
                            } catch (JSONException e) {
                                e.printStackTrace();
                            }
                        }
                    });
                }
                break;
        }
    }

    private void refreshResponse() {
        OkHttpUtils.get()
                .url(BASE_URL_HEAD + "course/" + courseId + Signature.UrlSignature())
                .headers(Signature.UrlHeaders(this))
                .build()
                .execute(new BaseStringCallback() {
                    @Override
                    public void onError(Call call, Exception e, int id) {
                        e.printStackTrace();
                    }

                    @Override
                    public void onResponse(String response, int id) {
                        Gson gson = new Gson();
                        ReactRequestBean myRequestBean = gson.fromJson(response, ReactRequestBean.class);
                        if (myRequestBean.isResult()) {
                            YLAudioActivity.this.response = myRequestBean.getResponse();
                        } else {
                            Toast.makeText(YLAudioActivity.this, "myRequestBean.getCode():" + myRequestBean.getCode(), Toast.LENGTH_SHORT).show();
                        }
                    }
                });
    }

    @Override
    public void onBackPressed() {


        if (pushTipsCard.getVisibility() == View.VISIBLE) {
            writeTipsShow();
            return;
        }

        if (ylPlaySettingPopupWindow.isPopupWindowShow()) {
            ylPlaySettingPopupWindow.dismissPopupWindow(this);
            return;
        }

        if (playTypePopupWindow.isPopupWindowShow()) {
            playTypePopupWindow.dismissPopupWindow(this);
            return;
        }
        super.onBackPressed();

    }

    @Override
    protected void onPause() {
        super.onPause();
        if (rootView != null) {
            rootView.getViewTreeObserver()
                    .removeGlobalOnLayoutListener(this);
        }
    }


    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {
//        JCVideoPlayer.releaseAllVideos();
    }

    @Override
    public void onPageScrollStateChanged(int state) {

    }

    @Override
    public boolean onDown(MotionEvent e) {
        return false;
    }

    @Override
    public void onShowPress(MotionEvent e) {

    }

    @Override
    public boolean onSingleTapUp(MotionEvent e) {
        return false;
    }

    @Override
    public boolean onScroll(MotionEvent e1, MotionEvent e2, float distanceX, float distanceY) {
        return false;
    }

    @Override
    public void onLongPress(MotionEvent e) {

    }

    @Override
    public boolean onFling(MotionEvent e1, MotionEvent e2, float velocityX, float velocityY) {
        if (velocityY > 20) {
            // 向下
            if (Math.abs(velocityX) < Math.abs(velocityY)) {
                viewPager.setVisibility(View.VISIBLE);
                imgChange.setImageResource(R.mipmap.viewpager_visible);
                SharedPreferencesUtil.put(this, VIEW_PAGER_IS_GONE, false);
            }
        } else if (velocityY < -20) {
            // 向上
            if (Math.abs(velocityX) < Math.abs(velocityY)) {
                viewPager.setVisibility(View.GONE);
                imgChange.setImageResource(R.mipmap.viewpager_gone);
                SharedPreferencesUtil.put(this, VIEW_PAGER_IS_GONE, true);
            }
        }
        return false;
    }

    @Override
    public boolean onTouch(View v, MotionEvent event) {
        detector.onTouchEvent(event);
        return false;
    }

    @Override
    public void onGlobalLayout() {
        try {

            boolean keyboardShown = isKeyboardShown(imgChangeRe.getRootView());


            if (beforeIsShow == keyboardShown) {
                return;
            }

            if (keyboardShown) {
                beforeIsShow = true;
                RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) tipsEditText.getLayoutParams();
                layoutParams.height = RelativeLayout.LayoutParams.WRAP_CONTENT;
                tipsEditText.setLayoutParams(layoutParams);
                tipsEditText.setMaxLines(4);
                viewBg.setVisibility(View.VISIBLE);
            } else {
                beforeIsShow = false;
                RelativeLayout.LayoutParams layoutParams = (RelativeLayout.LayoutParams) tipsEditText.getLayoutParams();
                layoutParams.height = SystemUtil.dip2px(this, 119);
                tipsEditText.setLayoutParams(layoutParams);
                tipsEditText.setMaxLines(8);
                viewBg.setVisibility(View.GONE);
            }
        }catch (Exception e){
            e.printStackTrace();
        }

    }


    @Override
    public void gotoPlayById(int courseId) {
        audioControl.playByCourseId(courseId);
    }

    @Override
    public void changePlayType() {
        if (audioControl.isPlaying()) {
            audioControl.pause();
        } else {
            audioControl.play();
        }
    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {

    }

    @Override
    public void afterTextChanged(Editable s) {
        try {
            noteWriteCache(s.toString().trim());
        } catch (JSONException e) {
            e.printStackTrace();
        }
    }

//    String[] strings = {"", "green", "night", "yellow"};
//    int position = 0;
//
//    public void SkinButton(View view) {
//        SkinManager.getInstance().changeSkin(strings[position]);
//        position++;
//
//        position = position % strings.length;
//    }

//    @Override
//    public void onFocusChange(View v, boolean hasFocus) {
//
//    }


    private class MyServiceConnection implements ServiceConnection {

        @Override
        public void onServiceConnected(ComponentName name, IBinder service) {
            audioControl = (AudioControl) service;
            audioControl.setOnListener(onListener);

            runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if (userId == 0) {
                        buyDialog = new AlertDialog.Builder(YLAudioActivity.this);

                        buyDialog.setMessage("此节目为会员专享，请登录");
                        buyDialog.setNeutralButton("去登录", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                dialog.dismiss();
                                Intent intent = new Intent(getApplicationContext(), YLLoginActivity.class);
                                startActivity(intent);
                                finish();
                            }
                        });
                        buyDialog.setNegativeButton("取消", new DialogInterface.OnClickListener() {
                            @Override
                            public void onClick(DialogInterface dialog, int which) {
                                YLAudioActivity.this.finish();
                            }
                        });
                        buyDialog.setCancelable(false);
                        AlertDialog alertDialog = buyDialog.create();
                        if (!alertDialog.isShowing()) {
                            alertDialog.show();
                        }
                        if (audioControl != null) {
                            audioControl.stop();
                        }
                    } else {
                        onServiceConnection();

                    }

                }
            });

        }

        @Override
        public void onServiceDisconnected(ComponentName name) {

        }
    }

    @Override
    protected void onDestroy() {
        if (rootView != null) {
            rootView.getViewTreeObserver()
                    .removeGlobalOnLayoutListener(this);
        }

        if (handler != null) {
            handler.removeMessages(1);
        }
        super.onDestroy();

        if (myServiceConna != null) {
            unbindService(myServiceConna);
        }

        if (audioControl != null) {
            audioControl.clearSetOnListener();
        }

        EventBus.getDefault().unregister(this);
        SkinManager.getInstance().unregister(this);
        uhApplication.removeTask(context);
        System.gc();
    }

    private void requestWriteSettings() {
        Intent intent = new Intent(Settings.ACTION_MANAGE_WRITE_SETTINGS);
        intent.setData(Uri.parse("package:" + getPackageName()));
        startActivityForResult(intent, REQUEST_CODE_WRITE_SETTINGS);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);

        if (resultCode == RESULT_OK &&
                (requestCode == REQUEST_CODE || requestCode == PhotoPreview.REQUEST_CODE)) {

            List<String> photos = null;
            if (data != null) {
                photos = data.getStringArrayListExtra(PhotoPicker.KEY_SELECTED_PHOTOS);
            }
            selectedPhotos.clear();

            if (photos != null) {
                selectedPhotos.addAll(photos);
            }

            if (selectedPhotos.size() > 0) {
                imgSize.setVisibility(View.VISIBLE);
                imgSize.setText(selectedPhotos.size() + "");
            } else {
                imgSize.setVisibility(View.GONE);
            }

        } else if (requestCode == REQUEST_CODE_WRITE_SETTINGS) {
            if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
                if (Settings.System.canWrite(this)) {
                    if (!ylPlaySettingPopupWindow.isPopupWindowShow()) {
                        ylPlaySettingPopupWindow.showPopupWindow(YLAudioActivity.this);
                    }
                }
            }
        }
    }


}
