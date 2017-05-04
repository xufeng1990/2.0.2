package com.zhuomogroup.ylyk.controller;

import android.app.Activity;
import android.support.v7.app.AlertDialog;

import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_401;
import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_408;
import static com.zhuomogroup.ylyk.consts.YLHTTPCode.HTTP_CODE_500;


/**
 * Created by xyb on 2017/3/26.
 */

public class DialogController {

    public void dialogShow(Activity activity, int code) {
        if (activity != null) {
            if (!activity.isFinishing()) {
                AlertDialog.Builder alertDialog;
                if (code == HTTP_CODE_401) {
                    alertDialog = new AlertDialog.Builder(activity);
                    alertDialog.setMessage("登陆失效");


                } else if (code == HTTP_CODE_408) {
                    alertDialog = new AlertDialog.Builder(activity);
                    alertDialog.setMessage("请设置您的本机时间");
                } else if (code == HTTP_CODE_500) {
                    alertDialog = new AlertDialog.Builder(activity);
                    alertDialog.setMessage("服务器错误");

                }

            }
        }
    }

}
