package com.zhuomogroup.ylyk.controller;

import android.app.Activity;
import android.content.Context;
import android.text.TextUtils;

import com.alibaba.fastjson.JSONArray;
import com.alibaba.fastjson.JSONObject;
import com.qiyukf.unicorn.api.UICustomization;
import com.qiyukf.unicorn.api.Unicorn;
import com.qiyukf.unicorn.api.YSFUserInfo;
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.base.YLBaseActivity;
import com.zhuomogroup.ylyk.consts.YLBaseUrl;
import com.zhuomogroup.ylyk.controinterface.QIYUInterface;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;

import org.json.JSONException;

import static com.zhuomogroup.ylyk.consts.YLStorageKey.USER_INFO;


/**
 * 七鱼客服跳转控制器
 * Created by xyb on 2017/3/24.
 */

public class QiYuActivityController implements QIYUInterface {


    private static final int QIYU_QUEUE_LEN = 2;
    private int[] xdyID = {100578, 99738};// 阿树老师1 , 阿树老师2
    private int user_xdy_id;
    private String user_id = "0";

    private YSFUserInfo getQYUserInfoA(Context currentActivity) {
        YSFUserInfo userInfoA = new YSFUserInfo();


        String nickname = "匿名用户";
        String mobilephone = "";

        String user_info = (String) SharedPreferencesUtil.get(currentActivity, USER_INFO, "");
        if (!"".equals(user_info)) {
            try {
                org.json.JSONObject jsonObject = new org.json.JSONObject(user_info);
                user_id = jsonObject.getInt("id") + "";
                user_xdy_id = jsonObject.getInt("xdy_id");
                mobilephone = jsonObject.getString("mobilephone") + "";
                org.json.JSONObject info = jsonObject.getJSONObject("info");
                nickname = info.getString("nickname");
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }

        String url = YLBaseUrl.BASE_URL_HEAD + "user/" + user_id + "/avatar";
        userInfoA.userId = nickname;
        userInfoA.data = userInfoData(nickname, mobilephone, "", url, user_id).toJSONString();

        return userInfoA;
    }


    private UICustomization uiCustomization() {
        // 以下示例的图片均无版权，请勿使用
        UICustomization customization = new UICustomization();
        customization.rightAvatar = YLBaseUrl.BASE_URL_HEAD + "user/" + user_id + "/avatar";
        return customization;
    }

    private JSONArray userInfoData(String name, String mobile, String email, String avatar, String auth) {
        JSONArray array = new JSONArray();
        array.add(userInfoDataItem("real_name", name, false, -1, null, null)); // name
        array.add(userInfoDataItem("mobile_phone", mobile, false, -1, null, null)); // mobile
        array.add(userInfoDataItem("email", email, false, -1, null, null)); // email
        array.add(userInfoDataItem("avatar", avatar, false, -1, null, null)); // icon
        array.add(userInfoDataItem("UserId", auth, false, 0, "用户ID", null));

        return array;
    }

    private JSONObject userInfoDataItem(String key, Object value, boolean hidden, int index, String label, String href) {
        JSONObject item = new JSONObject();
        item.put("key", key);
        item.put("value", value);
        if (hidden) {
            item.put("hidden", true);
        }
        if (index >= 0) {
            item.put("index", index);
        }
        if (!TextUtils.isEmpty(label)) {
            item.put("label", label);
        }
        if (!TextUtils.isEmpty(href)) {
            item.put("href", href);
        }
        return item;
    }

    @Override
    public void pushInterFace(Activity context) {
        YSFUserInfo userInfoA = getQYUserInfoA(context);
        Unicorn.setUserInfo(userInfoA);
        MainApplication application = (MainApplication) context.getApplication();
        application.getYsfOptions().uiCustomization = uiCustomization();
        int i = user_xdy_id % QIYU_QUEUE_LEN;
        int qiYuId = xdyID[i];
        YLBaseActivity.consultService(context, "", "", qiYuId, "阿树老师", null);
    }


}
