package com.zhuomogroup.ylyk.activity;

import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.widget.LinearLayout;
import android.widget.RelativeLayout;
import android.widget.TextView;
import android.widget.Toast;

import com.facebook.react.bridge.ReactContext;
import com.facebook.react.bridge.WritableMap;
import com.facebook.react.bridge.WritableNativeMap;
import com.facebook.react.modules.core.DeviceEventManagerModule;
import com.google.gson.Gson;
import com.reactmodules.callback.BaseStringCallback;
import com.zhuomogroup.ylyk.utils.EncryptionUtil;
import com.tencent.mm.sdk.modelbase.BaseResp;
import com.tencent.mm.sdk.modelmsg.SendAuth;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.StringCallback;

import org.greenrobot.eventbus.EventBus;
import org.greenrobot.eventbus.Subscribe;
import org.greenrobot.eventbus.ThreadMode;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Set;

import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.TagAliasCallback;
import okhttp3.Call;

import static com.zhuomogroup.ylyk.MainApplication.BASE_APP_KEY;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.LICENSE;
import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_401;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.OTHER_PASS;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USERID_AUTHORIZATION;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;
import static com.zhuomogroup.ylyk.consts.YLUrlSetting.JSON_MEDIA_TYPE;

/**
 * Created by xyb on 2017/3/6.
 */

public class YLLoginActivity extends YLBaseActivity implements View.OnClickListener {
    private LinearLayout telephone_linear;
    private TextView agreement;
    private RelativeLayout loading;


    @Override
    public int bindLayout() {
        return R.layout.activity_login;
    }

    @Override
    public void initView(View view) {
        telephone_linear = (LinearLayout) view.findViewById(R.id.telephone_linear);
        agreement = (TextView) view.findViewById(R.id.agreement);
        loading = (RelativeLayout) view.findViewById(R.id.loading);
        EventBus.getDefault().register(this); //第1步: 注册
    }

    @Override
    public void doBusiness(Context mContext) {
        telephone_linear.setOnClickListener(this);
        agreement.setOnClickListener(this);
        loading.setOnClickListener(this);

    }

    @Override
    public void resume() {

    }

    @Override
    public void destroy() {
        EventBus.getDefault().unregister(this);
    }

    public void onClickButton(View view) {

        MainApplication application = (MainApplication) getApplication();
        IWXAPI iwxapi = application.getIwxapi();


        if (!iwxapi.isWXAppInstalled()) {
            //提醒用户没有安装微信
            Toast.makeText(this, "没有安装微信,请先安装微信!", Toast.LENGTH_SHORT).show();
            return;
        }

        loading.setVisibility(View.VISIBLE);

        SendAuth.Req req = new SendAuth.Req();
        req.scope = "snsapi_userinfo";
        req.state = "ylyk";
        iwxapi.sendReq(req);

    }

    @Subscribe(threadMode = ThreadMode.MAIN) //在ui线程执行
    public void onDataSynEvent(BaseResp baseResp) {
        SendAuth.Resp req = (SendAuth.Resp) baseResp;
        OkHttpUtils.get()
                .url("https://api.weixin.qq.com/sns/oauth2/access_token")
                .addParams("appid", MainApplication.APP_ID)
                .addParams("secret", MainApplication.APP_SECRET)
                .addParams("code", req.code)
                .addParams("grant_type", "authorization_code")
                .build()
                .execute(new StringCallback() {
                    @Override
                    public void onError(Call call, Exception e, int id) {

                    }

                    @Override
                    public void onResponse(String response, int id) {

                        try {
                            JSONObject jsonObject = new JSONObject(response);
                            String access_token = jsonObject.getString("access_token");
                            String openid = jsonObject.getString("openid");
                            String unionid = jsonObject.getString("unionid");
                            GetTokenByUnionId(openid, unionid, access_token);
                        } catch (JSONException e) {
                            e.printStackTrace();
                        }
                    }
                });

    }


    @Subscribe(threadMode = ThreadMode.MAIN) //在ui线程执行
    public void onDataSynEvent(String type) {
        if (type.equals("loading")) {
            loading.setVisibility(View.GONE);
        } else if (type.equals("finish")) {
            finish();

        }

    }


    public void GetTokenByUnionId(String open_id, String union_id, String access_token) {
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("open_id", open_id);
            jsonObject.put("app_key", BASE_APP_KEY);
            jsonObject.put("union_id", union_id);
            jsonObject.put("access_token", access_token);
            String content = jsonObject.toString();
            OkHttpUtils.postString()
                    .url(BASE_URL_HEAD + "token" + Signature.UrlSignature())
                    .addHeader("Content-Type", "application/json")
                    .content(content)
                    .mediaType(JSON_MEDIA_TYPE)
                    .build().execute(new BaseStringCallback() {
                                         @Override
                                         public void onError(Call call, Exception e, int id) {
                                             e.printStackTrace();
                                         }

                                         @Override
                                         public void onResponse(String response, int id) {
                                             if (response != null) {
                                                 try {
                                                     JSONObject object = new JSONObject(response);
                                                     boolean result = object.getBoolean("result");
                                                     if (result) {
                                                         response = object.getString("response");
                                                         putAuthorization(response);
                                                     } else {
                                                         int code = object.getInt("code");
                                                         if (code == HTTP_CODE_401) {
                                                             Toast.makeText(YLLoginActivity.this, "登录授权失败,请重新登录", Toast.LENGTH_SHORT).show();
                                                         }
                                                     }
                                                 } catch (JSONException e) {
                                                     e.printStackTrace();
                                                 }

                                             }
                                         }
                                     }
            );

        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    public void putAuthorization(String response) {
        try {
            JSONObject jsonObject = new JSONObject(response);
            String appKey = jsonObject.getString("app_key");
            String appToken = jsonObject.getString("app_token");
            String userId = jsonObject.getString("user_id");
            String Authorization = EncryptionUtil.BASE64(appKey + ":" + appToken + ":" + userId);
            SharedPreferencesUtil.put(this, USERID_AUTHORIZATION, Authorization);
            JPushInterface.setAlias(YLLoginActivity.this, userId, new TagAliasCallback() {
                @Override
                public void gotResult(int i, String s, Set<String> set) {


                }
            });

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
                                    SharedPreferencesUtil.put(YLLoginActivity.this, USER_INFO, response);
                                    loading.setVisibility(View.GONE);


                                    MainApplication application = (MainApplication) getApplication();
                                    ReactContext reactContext = application.getReactContext();
                                    if (reactContext != null) {
                                        WritableMap params = new WritableNativeMap();
                                        params.putBoolean("LoginSuccess", true);
                                        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("LoginSuccess", params);
                                    }

                                    try {
                                        JSONObject object = new JSONObject(response);
                                        boolean vip = object.has("vip");
                                        if (vip) {
                                            String mobilephone = object.getString("mobilephone");
                                            boolean otherPass = (boolean) SharedPreferencesUtil.get(getApplicationContext(), OTHER_PASS, false);
                                            if (mobilephone.equals("") && (!otherPass)) {
                                                Intent intent = new Intent(getApplicationContext(), YLTelephoneChangeActivity.class);
                                                intent.putExtra("also", true);
                                                startActivity(intent);
                                            } else {
                                                startActivity(new Intent(getApplicationContext(), YLMainActivity.class));
                                            }
                                        } else {
                                            startActivity(new Intent(getApplicationContext(), YLMainActivity.class));
                                        }
                                    } catch (JSONException e) {
                                        e.printStackTrace();
                                    }
                                    finish();
                                } else {
                                    Toast.makeText(YLLoginActivity.this, "requestBean.getCode():" + requestBean.getCode(), Toast.LENGTH_SHORT).show();
                                }
                            }
                        }
                    });

        } catch (JSONException e) {
            e.printStackTrace();
        }

    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.telephone_linear:
                Intent intent = new Intent(this, YLTelephoneLoginActivity.class);
                startActivity(intent);
                break;
            case R.id.agreement:
                Intent webViewIntent = new Intent(this, YLWebViewActivity.class);
                webViewIntent.putExtra("url", LICENSE);
                startActivity(webViewIntent);
                break;
        }
    }

    @Override
    public void onBackPressed() {
        if (loading.getVisibility() == View.VISIBLE) {
            loading.setVisibility(View.GONE);
            return;
        }

        super.onBackPressed();

        // 添加返回过渡动画.
        overridePendingTransition(android.R.anim.fade_in, android.R.anim.fade_out);
    }

    public void backImg(View view) {

        Intent intent = new Intent(getApplicationContext(), YLMainActivity.class);
        startActivity(intent);
        finish();
    }

}
