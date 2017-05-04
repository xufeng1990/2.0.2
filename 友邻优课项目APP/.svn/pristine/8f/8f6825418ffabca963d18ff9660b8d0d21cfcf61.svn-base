package com.reactmodules.userinfo;

import android.content.Context;
import android.widget.Toast;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.ReadableMap;
import com.facebook.react.bridge.ReadableNativeMap;
import com.google.gson.Gson;
import com.reactmodules.callback.BaseStringCallback;
import com.reactmodules.request.YLBaseService;
import com.tencent.mm.sdk.modelpay.PayReq;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.bean.RequestBean;
import com.zhuomogroup.ylyk.consts.YLBaseUrl;
import com.zhuomogroup.ylyk.network.Signature;
import com.zhuomogroup.ylyk.popupwindow.YLSharePopupWindow;
import com.zhy.http.okhttp.OkHttpUtils;

import org.json.JSONException;
import org.json.JSONObject;

import okhttp3.Call;

import static com.reactmodules.consts.ModuleName.YLYK_WECHAT_NATIVE_MODULE;
import static com.zhuomogroup.ylyk.consts.YLUrlSetting.JSON_MEDIA_TYPE;

/**
 * Created by xyb on 2017/4/19.
 */

public class YLYKWechatNativeModule extends ReactContextBaseJavaModule {

    private static final String CODE_500 = "500";

    private static final String NOT_REGISTERED = "微信需要注册APP_ID";
    private final YLBaseService service;
    private final Context mContext;

    public YLYKWechatNativeModule(ReactApplicationContext reactContext) {
        super(reactContext);
        service = new YLBaseService(reactContext.getApplicationContext());
        mContext = reactContext.getApplicationContext();
    }

    @Override
    public String getName() {
        return YLYK_WECHAT_NATIVE_MODULE;
    }

    /**
     * 微信分享信息
     *
     * @param readableMap
     * @param promise
     */

    @ReactMethod
    public void shareWXMesage(ReadableMap readableMap, Promise promise) {
        if (getCurrentActivity() != null) {
            try {
                final String nativeString = service.getNativeString((ReadableNativeMap) readableMap);
                getCurrentActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        YLSharePopupWindow sharePopupWindow = new YLSharePopupWindow(getCurrentActivity(), nativeString);
                        sharePopupWindow.showPopwindow(getCurrentActivity());
                    }
                });


            } catch (JSONException e) {
                e.printStackTrace();
            }
        }


    }


    /**
     * 打开微信
     *
     * @param promise
     */
    @ReactMethod
    public void openWXApp(Promise promise) {
        if (getCurrentActivity() != null) {
            MainApplication application = (MainApplication) getCurrentActivity().getApplication();
            IWXAPI iwxapi = application.getIwxapi();
            if (iwxapi != null) {
                promise.resolve(iwxapi.openWXApp());
            } else {
                promise.reject(CODE_500, NOT_REGISTERED);
            }
        }

    }


    /**
     * 去微信支付方法
     *
     * @param readableMap
     * @param promise
     */
    @ReactMethod
    public void goToPay(ReadableMap readableMap, Promise promise) {
        String id = readableMap.getString("goodsId");
        String count = readableMap.getString("count");
        String chanel = readableMap.getString("channel");
        JSONObject object = new JSONObject();
        try {
            object.put("goods_id", id);
            object.put("channel", chanel);
            object.put("count", count);
            OkHttpUtils.postString()
                    .headers(Signature.UrlHeaders(mContext))
                    .url(YLBaseUrl.BASE_URL_HEAD + "order" + Signature.UrlSignature())
                    .content(object.toString())
                    .mediaType(JSON_MEDIA_TYPE)
                    .build().execute(new BaseStringCallback() {
                @Override
                public void onError(Call call, Exception e, int id) {

                }

                @Override
                public void onResponse(String response, int id) {
                    try {
                        Gson gson = new Gson();
                        RequestBean requestBean = gson.fromJson(response, RequestBean.class);
                        if (requestBean.isResult()) {
                            response = requestBean.getResponse();
                            JSONObject object1 = new JSONObject(response);
                            boolean result = object1.getBoolean("result");
                            JSONObject aPackage = object1.getJSONObject("package");
                            if (result) {

                                JSONObject payment = aPackage.getJSONObject("payment");
                                sendMsg(payment);
                            } else {
                                String message = aPackage.getString("message");
                                Toast.makeText(mContext, message, Toast.LENGTH_SHORT).show();
                            }

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


    public void sendMsg(JSONObject json) throws JSONException {
        PayReq req = new PayReq();
        req.appId = json.getString("app_id");
        req.partnerId = json.getString("partner_id");
        req.prepayId = json.getString("prepay_id");
        req.nonceStr = json.getString("nonce_str");
        req.timeStamp = json.getString("timestamp");
        req.packageValue = json.getString("package");
        req.sign = json.getString("sign");
        req.extData = "app data"; // optional
        if (getCurrentActivity() != null) {
            // 在支付之前，如果应用没有注册到微信，应该先调用IWXMsg.registerApp将应用注册到微信
            MainApplication application = (MainApplication) getCurrentActivity().getApplication();
            application.getIwxapi().sendReq(req);
        }
    }


}
