package com.zhuomogroup.ylyk.activity;

import android.content.Context;
import android.content.Intent;
import android.os.Environment;
import android.view.View;
import android.view.animation.AlphaAnimation;
import android.view.animation.Animation;
import android.view.animation.AnimationSet;
import android.widget.ImageView;

import com.google.gson.Gson;
import com.reactmodules.callback.BaseStringCallback;
import com.tbruyelle.rxpermissions2.RxPermissions;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.utils.FileUtil;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.http.okhttp.OkHttpUtils;

import org.json.JSONException;
import org.json.JSONObject;

import io.reactivex.functions.Consumer;
import okhttp3.Call;

import static android.Manifest.permission.READ_PHONE_STATE;
import static android.Manifest.permission.WRITE_EXTERNAL_STORAGE;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.IS_FIRST_OPEN_APP;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.OTHER_PASS;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;
import static com.zhuomogroup.ylyk.utils.SharedPreferencesUtil.get;

/**
 * Created by xyb on 2017/3/22.
 */

public class YLGuideActivity extends YLBaseActivity {
    public static final String DOWNLOAD_PATH = "/Android/data/com.zhuomogroup.ylyk/downloads/62933a2951ef01f4eafd9bdf4d3cd2f0/";
    //    private int widthPixels;
//    private int heightPixels;
    private ImageView guideImg;

    @Override
    public int bindLayout() {
        return R.layout.activity_guide;
    }

    @Override
    public void initView(View view) {
        // 获取手机分辨率
//        DisplayMetrics metrics = new DisplayMetrics();
//        getWindowManager().getDefaultDisplay().getMetrics(metrics);
//        widthPixels = metrics.widthPixels;
//        heightPixels = metrics.heightPixels;

        guideImg = (ImageView) view.findViewById(R.id.guide_img);
        RxPermissions.getInstance(YLGuideActivity.this)
                .request(WRITE_EXTERNAL_STORAGE,READ_PHONE_STATE).subscribe(new Consumer<Boolean>() {
            @Override
            public void accept(Boolean agreePermission) throws Exception {
                StartAnimation(agreePermission);

            }
        });
    }

    @Override
    public void doBusiness(Context mContext) {

    }

    @Override
    public void resume() {

    }

    @Override
    public void destroy() {
        System.gc();
    }


    private void StartAnimation(final boolean agreePermission) {
        // 动画集合
        AnimationSet set = new AnimationSet(false);

        AlphaAnimation alphaAnimation = new AlphaAnimation(0.5f, 1);//渐变动画
        alphaAnimation.setDuration(1000);// 设置动画的时间
        alphaAnimation.setFillAfter(true);// 保持动画状态
        set.addAnimation(alphaAnimation);


        // 设置动画监听
        set.setAnimationListener(new Animation.AnimationListener() {
            @Override
            public void onAnimationStart(Animation animation) {
            }

            //动画结束
            @Override
            public void onAnimationEnd(Animation animation) {
                jumpNextPage(agreePermission);

            }

            @Override
            public void onAnimationRepeat(Animation animation) {

            }
        });
        guideImg.startAnimation(set);
    }


    private void jumpNextPage(Boolean agreePermission) {

        boolean userGuid = (boolean) get(this, IS_FIRST_OPEN_APP, true);
        if (!userGuid) {
            String user_info = (String) get(this, USER_INFO, "");
            if ("".equals(user_info)) {
                startActivity(new Intent(this, YLLoginActivity.class));
            } else {
                try {
                    JSONObject object = new JSONObject(user_info);
                    int userId = object.getInt("id");
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
                                            SharedPreferencesUtil.put(YLGuideActivity.this, USER_INFO, response);
                                        }
                                    }
                                }
                            });
                } catch (Exception e) {
                    e.printStackTrace();
                }

                try {
                    JSONObject object = new JSONObject(user_info);
                    boolean vip = object.has("vip");
                    if (vip) {
                        String mobilephone = object.getString("mobilephone");
                        boolean otherPass = (boolean) get(getApplicationContext(), OTHER_PASS, false);

                        if ("".equals(mobilephone) && (!otherPass)) {
                            Intent intent = new Intent(this, YLTelephoneChangeActivity.class);
                            intent.putExtra("also", true);
                            startActivity(intent);
                        } else {
                            startActivity(new Intent(this, YLMainActivity.class));
                        }
                    } else {
                        startActivity(new Intent(this, YLMainActivity.class));
                    }


                } catch (JSONException e) {
                    e.printStackTrace();
                }
            }
        } else {

            if (agreePermission) {
                String sdCardRoot = Environment.getExternalStorageDirectory().getAbsolutePath();
                sdCardRoot = sdCardRoot + DOWNLOAD_PATH;

                FileUtil.deleteFolderFile(sdCardRoot, true);
            }

            startActivity(new Intent(this, YLUserHelperActivity.class));
        }
        finish();
    }
}
