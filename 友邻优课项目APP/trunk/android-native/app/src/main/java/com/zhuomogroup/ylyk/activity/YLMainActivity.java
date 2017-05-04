package com.zhuomogroup.ylyk.activity;

import android.app.ProgressDialog;
import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.os.Bundle;
import android.os.Environment;
import android.support.v4.content.FileProvider;
import android.support.v4.view.ViewPager;
import android.support.v7.app.AlertDialog;
import android.util.DisplayMetrics;
import android.view.Display;
import android.view.KeyEvent;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.RadioGroup;
import android.widget.RelativeLayout;
import android.widget.Toast;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DefaultHardwareBackBtnHandler;
import com.facebook.react.modules.core.RCTNativeAppEventEmitter;
import com.google.gson.Gson;
import com.reactmodules.callback.BaseStringCallback;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.adapter.YLMainPagerAdapter;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.base.YLYKBaseReactFragment;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.controller.DialogController;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhuomogroup.ylyk.utils.UserAgentUtil;
import com.zhuomogroup.ylyk.views.MainViewPager;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.FileCallBack;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;
import org.json.JSONException;
import org.json.JSONObject;

import java.io.File;
import java.lang.reflect.Method;
import java.util.ArrayList;

import io.reactivex.functions.Consumer;
import me.iwf.photopicker.utils.FileUtils;
import okhttp3.Call;

import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
import static com.zhuomogroup.ylyk.MainApplication.LAST_CSS_CODE;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_SERVICE_CODE;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;
import static com.zhuomogroup.ylyk.utils.SharedPreferencesUtil.get;

/**
 * Created by xyb on 2017/2/17.
 */

public class YLMainActivity extends YLBaseActivity implements ViewPager.OnPageChangeListener, RadioGroup.OnCheckedChangeListener, DefaultHardwareBackBtnHandler, View.OnClickListener {
    private static final String HOME_WILL_APPEAR = "HomeWillAppear";
    private static final String HOME_WILL_APPEAR_EVENT = "HomeWillAppearEvent";
    private static final String APPLICATION_VND_ANDROID_PACKAGE_ARCHIVE = "application/vnd.android.package-archive";
    private static final String COM_ZHUOMOGROUP_YLYK_FILEPROVIDER = "com.zhuomogroup.ylyk.provider";
    private static final String FIRST_YL_MAIN_ACTIVITY = "first_YLMainActivity";
    private static final String STRING = "当前版本已停止使用,请下载最新版本";
    private static final int ANDROID_M = 24;

    MainViewPager mViewPager;
    RadioGroup mRadioGroup;
    YLMainPagerAdapter mYlMainPagerAdapter;
    RadioButton mRadio_home;
    RadioButton mRadio_idea;
    RadioButton mRadio_know;
    RadioButton mRadio_me;
    ImageView new_user_learn;
    ImageView loading_img;

    //几个代表页面的常量
    public static final int PAGE_ONE = 0;
    public static final int PAGE_TWO = 1;
    public static final int PAGE_THREE = 2;
    public static final int PAGE_FOUR = 3;
    String[] pagers = {"homepage", "course", "note", "profile"};
    private ArrayList<YLYKBaseReactFragment> ylykBaseReactFragments = new ArrayList<>();

    private int[] imgs = {R.drawable.new_user_learn_img01, R.drawable.new_user_learn_img02};
    private int img_position = 0;
    private AlertDialog.Builder builder;
    private ProgressDialog progressDialog;
    private int userId;
    private DialogController dialogController;
    private RelativeLayout progressBar;


    @Override
    public int bindLayout() {
        return R.layout.activity_main;
    }

    @Override
    public void initView(View view) {
//        GrowingIO.enableRNNavigatorPage();
        EventBus.getDefault().register(this);
        builder = new AlertDialog.Builder(this);
        mViewPager = (MainViewPager) view.findViewById(R.id.main_viewPager);
        mRadioGroup = (RadioGroup) view.findViewById(R.id.main_radioGroup);
        mRadio_home = (RadioButton) view.findViewById(R.id.radio_home);
        mRadio_idea = (RadioButton) view.findViewById(R.id.radio_idea);
        mRadio_know = (RadioButton) view.findViewById(R.id.radio_know);
        mRadio_me = (RadioButton) view.findViewById(R.id.radio_me);
        new_user_learn = (ImageView) view.findViewById(R.id.new_user_learn);
//        loading_img = (ImageView) view.findViewById(R.id.loading_img);
        progressBar = (RelativeLayout) view.findViewById(R.id.spacer_pross);
        dialogController = new DialogController();
        boolean isFirst = (boolean) get(this, FIRST_YL_MAIN_ACTIVITY, true);
        if (isFirst) {
            new_user_learn.setVisibility(View.VISIBLE);
            img_position = 0;
        } else {
            new_user_learn.setVisibility(View.GONE);
        }


        for (String pager : pagers) {
            Bundle bundle = new Bundle();
            bundle.putString("tab_type", pager);
            YLYKBaseReactFragment ylyk = new YLYKBaseReactFragment.Builder().setComponentName("ylyk_rn").setLaunchOptions(bundle).build();
            ylykBaseReactFragments.add(ylyk);
        }

        mYlMainPagerAdapter = new YLMainPagerAdapter(getSupportFragmentManager(), ylykBaseReactFragments);


        new_user_learn.setOnClickListener(this);

        OkHttpUtils.get()
                .url(BASE_SERVICE_CODE).build().execute(new BaseStringCallback() {
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
                        JSONObject client = object.getJSONObject("client");
                        JSONObject resource = object.getJSONObject("resource");
                        JSONObject styleCss = resource.getJSONObject("style.css");
                        String version = styleCss.getString("version");
                        final String url = styleCss.getString("url");
                        final int cssVersion = Integer.parseInt(version);
                        if (cssVersion > LAST_CSS_CODE) {
                            RxPermissions.getInstance(YLMainActivity.this)
                                    .request(WRITE_EXTERNAL_STORAGE).subscribe(new Consumer<Boolean>() {
                                @Override
                                public void accept(Boolean agreePermission) throws Exception {
                                    if (agreePermission) {
                                        String apkName = "ylyk" + cssVersion + ".css";
                                        String sdCardRoot = YLMainActivity.this.getFilesDir().getAbsolutePath();
                                        String s = sdCardRoot + "/" + apkName;
                                        SharedPreferencesUtil.put(YLMainActivity.this, "NOW_CSS", s);

                                        boolean b = FileUtils.fileIsExists(s);
                                        if (!b) {
                                            OkHttpUtils.get().url(url).build().execute(new FileCallBack(sdCardRoot, apkName) {
                                                @Override
                                                public void onError(Call call, Exception e, int id) {
                                                    e.printStackTrace();
                                                }

                                                @Override
                                                public void onResponse(File response, int id) {

                                                    SharedPreferencesUtil.put(YLMainActivity.this, "NOW_CSS", response.getAbsolutePath());

                                                }
                                            });
                                        }
                                    }
                                }
                            });
                        }

                        JSONObject android = client.getJSONObject("android");
                        JSONObject latest = android.getJSONObject("latest");
                        JSONObject support = android.getJSONObject("support");
                        final String version_name = latest.getString("version_name");
                        final String version_code = latest.getString("version_code");
                        String description = latest.getString("description");
                        final String download_url = latest.getString("download_url");
                        String supportVersionCode = support.getString("version_code");
                        int newVersionCode = Integer.parseInt(version_code);
                        int supportCode = Integer.parseInt(supportVersionCode);
                        int versionCode = UserAgentUtil.getVersionCode(YLMainActivity.this);
                        description = description.replaceAll("<br\\s*\\/?>", "\r\n");
                        if (versionCode < supportCode) {
                            goToDownloadApk(version_code, description, download_url, true);
                        } else if (versionCode < newVersionCode) {
                            goToDownloadApk(version_code, description, download_url, false);
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }

                }
            }
        });


    }


    /**
     * 获取虚拟功能键高度
     */
    public int getVirtualBarHeigh() {
        int vh = 0;
        WindowManager windowManager = (WindowManager) getSystemService(Context.WINDOW_SERVICE);
        Display display = windowManager.getDefaultDisplay();
        DisplayMetrics dm = new DisplayMetrics();
        try {
            @SuppressWarnings("rawtypes")
            Class c = Class.forName("android.view.Display");
            @SuppressWarnings("unchecked")
            Method method = c.getMethod("getRealMetrics", DisplayMetrics.class);
            method.invoke(display, dm);
            vh = dm.heightPixels - windowManager.getDefaultDisplay().getHeight();
        } catch (Exception e) {
            e.printStackTrace();
        }
        return vh;
    }

    private void goToDownloadApk(final String version_code, String description, final String download_url, final boolean isAlso) {
        builder.setTitle("发现新版本");
        if (isAlso) {
            builder.setMessage(description + "\r\n" + STRING);
        } else {
            builder.setMessage(description);

        }

        builder.setNegativeButton("立即更新", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                RxPermissions.getInstance(YLMainActivity.this)
                        .request(WRITE_EXTERNAL_STORAGE).subscribe(new Consumer<Boolean>() {
                    @Override
                    public void accept(Boolean agreePermission) throws Exception {
                        if (agreePermission) {

                            String apkName = "ylyk" + version_code + ".apk";
                            String sdCardRoot = Environment.getExternalStorageDirectory().getAbsolutePath();
                            String s = sdCardRoot + "/" + apkName;
                            boolean b = FileUtils.fileIsExists(s);
                            if (b) {
                                install(YLMainActivity.this, s);
                                return;
                            }
                            progressDialog = new ProgressDialog(YLMainActivity.this);
                            progressDialog.setMax(100);
                            progressDialog.setMessage("下载中");
                            progressDialog.setProgressStyle(ProgressDialog.STYLE_HORIZONTAL);// 设置水平进度条
                            progressDialog.setCancelable(false);// 设置是否可以通过点击Back键取消
                            progressDialog.setCanceledOnTouchOutside(false);// 设置在点击Dialog外是否取消Dialog进度条
                            progressDialog.show();
                            String url = download_url.replaceFirst("https", "http");
                            OkHttpUtils.get().url(url).build().execute(new FileCallBack(sdCardRoot, apkName) {
                                @Override
                                public void onError(Call call, Exception e, int id) {
                                    e.printStackTrace();
                                }

                                @Override
                                public void onResponse(File response, int id) {


                                    String fileName = response.getAbsolutePath();

                                    install(YLMainActivity.this, fileName);

                                }

                                @Override
                                public void inProgress(float progress, long total, int id) {

                                    progressDialog.setProgress((int) (progress * 100));
                                }
                            });
                        } else {
                            Toast.makeText(YLMainActivity.this, "请确认读写权限", Toast.LENGTH_SHORT).show();
                        }
                    }
                });


            }
        });
        builder.setNeutralButton("取消", new DialogInterface.OnClickListener() {
            @Override
            public void onClick(DialogInterface dialog, int which) {
                if (isAlso) {
                    dialog.dismiss();
                    finish();
                } else {
                    dialog.dismiss();
                }
            }
        });
        if (isAlso) {
            builder.setCancelable(false);
        }
        AlertDialog alertDialog = builder.create();
        if (!alertDialog.isShowing()) {
            alertDialog.show();
        }
    }


    @Override
    public void doBusiness(Context mContext) {
        mViewPager.setAdapter(mYlMainPagerAdapter);
        mViewPager.setCurrentItem(PAGE_ONE);
        mRadio_home.setChecked(true);
        mViewPager.addOnPageChangeListener(this);
        mViewPager.setOffscreenPageLimit(4);
        mRadioGroup.setOnCheckedChangeListener(this);
    }

    @Override
    public void resume() {
        String user_info = (String) get(this, USER_INFO, "");
        if (!user_info.equals("")) {
            try {
                JSONObject object = new JSONObject(user_info);
                this.userId = object.getInt("id");
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
                                        SharedPreferencesUtil.put(YLMainActivity.this, USER_INFO, response);
                                    } else {
                                        dialogController.dialogShow(YLMainActivity.this, requestBean.getCode());
                                    }
                                }
                            }
                        });
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    @Override
    public void destroy() {
        EventBus.getDefault().unregister(this);
    }

    @Override
    public void onPageScrolled(int position, float positionOffset, int positionOffsetPixels) {

    }

    @Override
    public void onPageSelected(int position) {

    }

    @Subscribe(threadMode = ThreadMode.MAIN) //在ui线程执行
    public void isPlayIng(String message) {

        if (message.equals("show")) {
            mRadioGroup.setVisibility(View.VISIBLE);

        } else if (message.equals("hide")) {
            mRadioGroup.setVisibility(View.GONE);

        }
    }

    public boolean isShowBar() {
        return mRadioGroup.getVisibility() != View.GONE;
    }

    @Override
    public void onPageScrollStateChanged(int state) {
        //state的状态有三个，0表示什么都没做，1正在滑动，2滑动完毕
        if (state == 2) {
            switch (mViewPager.getCurrentItem()) {
                case PAGE_ONE:

                    MainApplication application = (MainApplication) getApplication();
                    ReactContext reactContext = application.getReactContext();
                    if (reactContext != null) {
                        WritableNativeMap nativeMap = new WritableNativeMap();
                        nativeMap.putBoolean(HOME_WILL_APPEAR, true);
                        reactContext
                                .getJSModule(RCTNativeAppEventEmitter.class)
                                .emit(HOME_WILL_APPEAR_EVENT, nativeMap);
                    }
                    mRadio_home.setChecked(true);
                    break;
                case PAGE_TWO:
                    mRadio_know.setChecked(true);
                    break;
                case PAGE_THREE:
                    mRadio_idea.setChecked(true);
                    break;
                case PAGE_FOUR:
                    mRadio_me.setChecked(true);
                    break;
            }
        }
    }

    @Override
    public void onCheckedChanged(RadioGroup group, int checkedId) {
        switch (checkedId) {
            case R.id.radio_home:
                mViewPager.setCurrentItem(PAGE_ONE);
                break;
            case R.id.radio_know:
                mViewPager.setCurrentItem(PAGE_TWO);
                break;
            case R.id.radio_idea:
                mViewPager.setCurrentItem(PAGE_THREE);
                break;
            case R.id.radio_me:
                mViewPager.setCurrentItem(PAGE_FOUR);
                break;
        }
    }

    @Override
    public void invokeDefaultOnBackPressed() {
        long mNowTime = System.currentTimeMillis();//获取第一次按键时间
        if ((mNowTime - mPressedTime) > 2000) {//比较两次按键时间差
            Toast.makeText(this, R.string.double_click_back, Toast.LENGTH_SHORT).show();
            mPressedTime = mNowTime;
        } else {//退出程序
            EventBus.getDefault().post("logout");
            super.onBackPressed();
            MainApplication application = (MainApplication) getApplication();
            if (application != null) {
                application.removeAll();
                System.gc();
                System.exit(0);
            }
        }
    }


    private long mPressedTime = 0;

    @Override
    public void onBackPressed() {
        YLYKBaseReactFragment item = ylykBaseReactFragments.get(mViewPager.getCurrentItem());
        try {
            item.onBackPressed();
        } catch (Exception e) {
            e.printStackTrace();
            super.onBackPressed();
        }

    }

    @Override
    public boolean onKeyUp(int keyCode, KeyEvent event) {
        YLYKBaseReactFragment item = (YLYKBaseReactFragment) mYlMainPagerAdapter.getItem(mViewPager.getCurrentItem());
        if (keyCode == KeyEvent.KEYCODE_MENU) {
            try {
                item.onKeyUp(keyCode, event);
                return true;
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        return super.onKeyUp(keyCode, event);
    }

    @Override
    public void onClick(View v) {
        img_position++;
        if (img_position > 1) {
            if (new_user_learn.getVisibility() == View.VISIBLE) {
                new_user_learn.setVisibility(View.GONE);
                SharedPreferencesUtil.put(this, FIRST_YL_MAIN_ACTIVITY, false);
            }
        } else {
            new_user_learn.setImageResource(imgs[img_position]);
        }
    }


    /**
     * 通过隐式意图调用系统安装程序安装APK
     */
    public static void install(Context context, String fileName) {
        File file = new File(fileName);
        Intent intent = new Intent(Intent.ACTION_VIEW);
        // 由于没有在Activity环境下启动Activity,设置下面的标签
        intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
        if (Build.VERSION.SDK_INT >= ANDROID_M) {
            //添加这一句表示对目标应用临时授权该Uri所代表的文件
            intent.addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION);
            //判读版本是否在7.0以上
            //参数1 上下文, 参数2 Provider主机地址 和配置文件中保持一致   参数3  共享的文件
            Uri apkUri = FileProvider.getUriForFile(context, COM_ZHUOMOGROUP_YLYK_FILEPROVIDER, file);

            intent.setDataAndType(apkUri, APPLICATION_VND_ANDROID_PACKAGE_ARCHIVE);
        } else {
            intent.setDataAndType(Uri.fromFile(file),
                    APPLICATION_VND_ANDROID_PACKAGE_ARCHIVE);
        }
        context.startActivity(intent);
    }


    public void dismiss() {
        progressBar.setVisibility(View.GONE);
    }
}
