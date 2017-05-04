package com.zhuomogroup.ylyk.activity;

import android.content.Context;
import android.content.DialogInterface;
import android.content.Intent;
import android.support.v7.app.AlertDialog;
import android.text.Editable;
import android.text.TextWatcher;
import android.view.View;
import android.view.inputmethod.InputMethodManager;
import android.widget.EditText;
import android.widget.ImageView;
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
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.utils.RegexUtil;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhy.http.okhttp.OkHttpUtils;
import com.zhy.http.okhttp.callback.StringCallback;

import org.greenrobot.eventbus.EventBus;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.Set;

import cn.jpush.android.api.JPushInterface;
import cn.jpush.android.api.TagAliasCallback;
import okhttp3.Call;

import static com.zhuomogroup.ylyk.MainApplication.BASE_APP_KEY;
import static com.zhuomogroup.ylyk.consts.YLBaseUrl.BASE_URL_HEAD;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USERID_AUTHORIZATION;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;
import static com.zhuomogroup.ylyk.consts.YLUrlSetting.APPLICATION_JSON;
import static com.zhuomogroup.ylyk.consts.YLUrlSetting.CONTENT_TYPE;
import static com.zhuomogroup.ylyk.consts.YLUrlSetting.JSON_MEDIA_TYPE;

public class YLTelephoneLoginActivity extends YLBaseActivity implements View.OnClickListener, View.OnFocusChangeListener, TextWatcher {

    RelativeLayout window;
    EditText telephone, password;
    TextView codeText, loginButton;
    ImageView backImg;
    private boolean isSendCode = true;
    private int waiteTime = 120;

    @Override
    public int bindLayout() {
        return R.layout.activity_telephonelogin;
    }

    @Override
    public void initView(View view) {
        window = (RelativeLayout) view.findViewById(R.id.window);
        telephone = (EditText) view.findViewById(R.id.telephone);
        password = (EditText) view.findViewById(R.id.password);
        codeText = (TextView) view.findViewById(R.id.code_text);
        loginButton = (TextView) view.findViewById(R.id.login_button);
        backImg = (ImageView) view.findViewById(R.id.back_img);
    }

    @Override
    public void doBusiness(Context mContext) {
        window.setOnClickListener(this);
        backImg.setOnClickListener(this);
        loginButton.setOnClickListener(this);
        codeText.setOnClickListener(this);


        telephone.setOnFocusChangeListener(this);
        password.setOnFocusChangeListener(this);
        telephone.addTextChangedListener(this);

    }

    @Override
    public void resume() {

    }

    @Override
    public void destroy() {

    }

    @Override
    public void onClick(View v) {
        String telNum;
        switch (v.getId()) {
            case R.id.window:
                window.setFocusable(true);
                window.setFocusableInTouchMode(true);
                window.requestFocus();
                break;
            case R.id.code_text:

                window.setFocusable(true);
                window.setFocusableInTouchMode(true);
                window.requestFocus();

                telNum = telephone.getText().toString();

                getTelephoneCode(telNum);
                break;
            case R.id.back_img:
                finish();
                break;
            case R.id.login_button:
                telNum = telephone.getText().toString();
                String code = password.getText().toString();
                goToLogin(telNum, code);
                break;
        }
    }

    private void goToLogin(String telNum, String code) {
        if (!RegexUtil.isMobilephoneNumber(telNum)) {
            Toast.makeText(this, R.string.please_put_telphone, Toast.LENGTH_SHORT).show();
            return;
        }
        if (code.equals("")) {
            Toast.makeText(this, R.string.please_put_code, Toast.LENGTH_SHORT).show();
            return;
        }

        GetTokenByMobilephone(telNum, code);


    }

    @Override
    public void onFocusChange(View v, boolean hasFocus) {
        if (!hasFocus) {

            InputMethodManager imm = (InputMethodManager)
                    getSystemService(Context.INPUT_METHOD_SERVICE);

            imm.hideSoftInputFromWindow(window.getWindowToken(), InputMethodManager.HIDE_NOT_ALWAYS);


        }
    }


    public void GetTokenByMobilephone(String mobilephone, String captcha) {
        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("mobilephone", mobilephone);
            jsonObject.put("app_key", BASE_APP_KEY);
            jsonObject.put("captcha", captcha);
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
                                                 Gson gson = new Gson();
                                                 final RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                                                 if (requestBean.isResult()) {
                                                     response = requestBean.getResponse();
                                                     putAuthorization(response);
                                                 } else {
                                                     runOnUiThread(new Runnable() {
                                                         @Override
                                                         public void run() {
                                                             String response1 = requestBean.getResponse();
                                                             try {
                                                                 JSONObject object = new JSONObject(response1);
                                                                 object.getString("");
                                                             } catch (JSONException e) {
                                                                 e.printStackTrace();
                                                             }

                                                             Toast.makeText(YLTelephoneLoginActivity.this, "登录失败 验证码不正确或已过期", Toast.LENGTH_SHORT).show();
                                                         }
                                                     });
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

            JPushInterface.setAlias(YLTelephoneLoginActivity.this, userId, new TagAliasCallback() {
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
                            Toast.makeText(getContext(), "网络出错，请稍后再试", Toast.LENGTH_SHORT).show();
                        }

                        @Override
                        public void onResponse(String response, int id) {
                            if (response != null) {
                                Gson gson = new Gson();
                                RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                                if (requestBean.isResult()) {
                                    response = requestBean.getResponse();
                                    SharedPreferencesUtil.put(YLTelephoneLoginActivity.this, USER_INFO, response);
                                    // TODO: 2017/3/13 加载动画
                                    Toast.makeText(YLTelephoneLoginActivity.this, "登录成功", Toast.LENGTH_SHORT).show();




                                    MainApplication application = (MainApplication) getApplication();
                                    ReactContext reactContext = application.getReactContext();
                                    if (reactContext != null) {
                                        WritableMap params = new WritableNativeMap();
                                        params.putBoolean("LoginSuccess", true);
                                        reactContext.getJSModule(DeviceEventManagerModule.RCTDeviceEventEmitter.class).emit("LoginSuccess", params);
                                    }
                                    EventBus.getDefault().post("finish");
                                    Intent intent = new Intent(getApplicationContext(), YLMainActivity.class);
                                    startActivity(intent);
                                    finish();
                                } else {
                                    Toast.makeText(YLTelephoneLoginActivity.this, "requestBean.getCode():" + requestBean.getCode(), Toast.LENGTH_SHORT).show();
                                }
                            }
                        }
                    });

        } catch (JSONException e) {
            e.printStackTrace();
        }
    }


    private void changeBtnGetCode() {

        Thread thread = new Thread() {
            @Override
            public void run() {
                if (isSendCode) {
                    while (waiteTime > 0) {
                        waiteTime--;
                        if (YLTelephoneLoginActivity.this == null) {
                            break;
                        }

                        YLTelephoneLoginActivity.this
                                .runOnUiThread(new Runnable() {
                                    @Override
                                    public void run() {
                                        codeText.setText("" + waiteTime);
                                        codeText.setClickable(false);
                                        codeText.setSelected(false);
                                    }
                                });
                        try {
                            Thread.sleep(1000);
                        } catch (InterruptedException e) {
                            throw new RuntimeException(e);
                        }
                    }
                    isSendCode = false;
                }
                waiteTime = 120;
                isSendCode = true;
                if (YLTelephoneLoginActivity.this != null) {
                    YLTelephoneLoginActivity.this.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            codeText.setText("获取验证码");
                            codeText.setClickable(true);
                            codeText.setSelected(true);
                        }
                    });
                }
            }

        };
        thread.start();
    }

    public void getTelephoneCode(String telNum) {
        if (!RegexUtil.isMobilephoneNumber(telNum)) {
            Toast.makeText(this, R.string.please_put_telphone, Toast.LENGTH_SHORT).show();
            return;
        }
        changeBtnGetCode();
        codeText.setClickable(false);

        try {
            JSONObject jsonObject = new JSONObject();
            jsonObject.put("mobilephone", telNum);
            jsonObject.put("app_key", BASE_APP_KEY);
            String content = jsonObject.toString();
            OkHttpUtils.postString()
                    .url(BASE_URL_HEAD + "token" + Signature.UrlSignature())
                    .addHeader(CONTENT_TYPE, APPLICATION_JSON)
                    .content(content)
                    .mediaType(JSON_MEDIA_TYPE)
                    .build().execute(new StringCallback() {
                @Override
                public void onError(Call call, Exception e, int id) {
                    e.printStackTrace();
                }

                @Override
                public void onResponse(String response, int id) {
                    try {
                        JSONObject resultJson = new JSONObject(response);
                        boolean result = resultJson.getBoolean("result");
                        if (!result) {
                            waiteTime = 5;
                            runOnUiThread(new Runnable() {
                                @Override
                                public void run() {
                                    AlertDialog.Builder builder = new AlertDialog.Builder(YLTelephoneLoginActivity.this);
                                    builder.setTitle("获取失败");
                                    builder.setMessage("该手机号尚未绑定友邻优课账号。\n 请使用微信登录后到“我”-“设置”页面绑定手机后重试。");
                                    builder.setPositiveButton("好的", new DialogInterface.OnClickListener() {
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
                            });
                        }

                    } catch (JSONException e) {
                        e.printStackTrace();
                    }
                }
            });

        } catch (JSONException e) {
            e.printStackTrace();

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
        int length = s.length();
        if (length == 11) {
            if (RegexUtil.isMobilephoneNumber(s.toString())) {
                codeText.setSelected(true);
            }
        } else {
            codeText.setSelected(false);

        }
    }
}
