package com.reactmodules.encryption;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.zhuomogroup.ylyk.utils.EncryptionUtil;

import static com.reactmodules.consts.ModuleName.ENCRYPTION_MODULE;

/**
 * Created by xyb on 2017/2/13.
 */

public class YLEncryptionModule extends ReactContextBaseJavaModule {


    public YLEncryptionModule(ReactApplicationContext reactContext) {
        super(reactContext);
    }

    @Override
    public String getName() {
        return ENCRYPTION_MODULE;
    }

    /**
     * 对传入的数据进行MD5加密 然后通过Promise方法回调到JS端
     *
     * @param encryptionMsg 需要加密的字段
     * @param promise
     */
    @ReactMethod
    public void MD5(String encryptionMsg, Promise promise) {
        try {
            String result = EncryptionUtil.MD5(encryptionMsg);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
            e.printStackTrace();
        }
    }

    /**
     * 对传入的数据进行MD5加密 然后通过Promise方法回调到JS端
     *
     * @param encryptionMsg 需要加密的字段
     * @param promise
     */
    @ReactMethod
    public void SHA1(String encryptionMsg, Promise promise) {
        try {
            String result = EncryptionUtil.SHA1(encryptionMsg);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
            e.printStackTrace();
        }
    }

    /**
     * 对传入的数据进行MD5加密 然后通过Promise方法回调到JS端
     *
     * @param encryptionMsg 需要加密的字段
     * @param promise
     */
    @ReactMethod
    public void BASE64(String encryptionMsg, Promise promise) {
        try {
            String result = EncryptionUtil.BASE64(encryptionMsg);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
            e.printStackTrace();
        }
    }

    /**
     * 对传入的数据进行HmacSHA1加密 然后通过Promise方法回调到JS端
     *
     * @param encryptText 需要加密的字段
     * @param encryptKey 需要加密的key
     * @param promise
     */
    @ReactMethod
    public void HmacSHA1(String encryptText, String encryptKey, Promise promise) {
        try {
            String result = EncryptionUtil.HmacSHA1(encryptText, encryptKey);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
            e.printStackTrace();
        }
    }


    /**
     * 对传入的数据进行HmacSHA1加密 然后通过Promise方法回调到JS端
     *
     * @param encryptText 需要加密的字段
     * @param encryptKey 需要加密的key
     * @param promise
     */
    @ReactMethod
    public void HmacMD5(String encryptText, String encryptKey, Promise promise) {
        try {
            String result = EncryptionUtil.HmacMD5(encryptText, encryptKey);
            promise.resolve(result);
        } catch (Exception e) {
            promise.reject(e);
            e.printStackTrace();
        }
    }


}
