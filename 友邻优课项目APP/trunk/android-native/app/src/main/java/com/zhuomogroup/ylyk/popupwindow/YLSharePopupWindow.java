package com.zhuomogroup.ylyk.popupwindow;

import android.app.Activity;
import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;

import com.tencent.mm.sdk.modelmsg.SendMessageToWX;
import com.tencent.mm.sdk.modelmsg.WXMediaMessage;
import com.tencent.mm.sdk.modelmsg.WXWebpageObject;
import com.tencent.mm.sdk.openapi.IWXAPI;
import com.zhuomogroup.ylyk.MainApplication;
import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.utils.ImageUtil;
import com.zhuomogroup.ylyk.utils.SystemUtil;

import org.json.JSONObject;

import static com.zhuomogroup.ylyk.popupwindow.YLPlayTypePopupWindow.ANDROID_N;

/**
 * Created by xyb on 2017/3/29.
 */

public class YLSharePopupWindow extends PopupWindow implements View.OnClickListener {
    private final View mMenuView;
    private final Context context;
    private PopupWindow popupWindow;
    private String nativeString;

    public YLSharePopupWindow(Context context, String json) {
        super(context);
        this.context = context;
        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        mMenuView = inflater.inflate(R.layout.dialog_share, null);
        RelativeLayout share2pengyouquan = (RelativeLayout) mMenuView.findViewById(R.id.share2pengyouquan);
        RelativeLayout share2people = (RelativeLayout) mMenuView.findViewById(R.id.share2people);
        share2people.setOnClickListener(this);
        share2pengyouquan.setOnClickListener(this);
        nativeString = json;
    }

    public void showPopwindow(final Activity activity) {
        popupWindow = new PopupWindow(mMenuView);
        int width = activity.getWindow().getDecorView().getWidth();
        popupWindow.setWidth((int) (width * 0.95));
        popupWindow.setHeight(WindowManager.LayoutParams.WRAP_CONTENT);
        // ☆ 注意： 必须要设置背景，播放动画有一个前提 就是窗体必须有背景
        popupWindow.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
        popupWindow.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));

        popupWindow.showAtLocation(activity.getWindow().getDecorView(), Gravity.CENTER | Gravity.BOTTOM, 0, SystemUtil.dip2px(activity, 8));
        popupWindow.setAnimationStyle(android.R.style.Animation_InputMethod);   // 设置窗口显示的动画效果
        popupWindow.setOutsideTouchable(true);                                        // 点击其他地方隐藏键盘 popupWindow
        if (Build.VERSION.SDK_INT != ANDROID_N) {
            popupWindow.update();
        }
        WindowManager.LayoutParams lp = activity.getWindow().getAttributes();
        lp.alpha = 0.7f;
        activity.getWindow().setAttributes(lp);
        popupWindow.setOnDismissListener(new OnDismissListener() {
            @Override
            public void onDismiss() {
                WindowManager.LayoutParams lp = activity.getWindow().getAttributes();
                lp.alpha = 1f;
                activity.getWindow().setAttributes(lp);
            }
        });
    }


    /**
     * 移除PopupWindow
     */
    public void dismissPopupWindow(Activity activity) {
        if (popupWindow != null && popupWindow.isShowing()) {
            popupWindow.dismiss();
            popupWindow = null;
            WindowManager.LayoutParams lp = activity.getWindow().getAttributes();
            lp.alpha = 1f;
            activity.getWindow().setAttributes(lp);
        }
    }

    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.share2people:
                try {
                    JSONObject object = new JSONObject(nativeString);
                    String title = object.getString("title");
                    String url = object.getString("url");
                    String courseId = object.getString("courseId");

                    WXWebpageObject webpage = new WXWebpageObject();
                    webpage.webpageUrl = url;
                    WXMediaMessage msg = new WXMediaMessage(webpage);
                    msg.title = title;
                    msg.description = "友邻优课，终身学习者的英语课堂";
                    Bitmap bmp = BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher);
                    Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, 150, 150, true);
                    bmp.recycle();
                    msg.thumbData = ImageUtil.Bitmap2Bytes(thumbBmp, true);

                    SendMessageToWX.Req req = new SendMessageToWX.Req();
                    req.transaction = buildTransaction("webPage");
                    req.message = msg;


                    req.scene = SendMessageToWX.Req.WXSceneSession;
                    MainApplication application = (MainApplication) this.context.getApplicationContext();
                    IWXAPI iwxapi = application.getIwxapi();
                    iwxapi.sendReq(req);

                } catch (Exception e) {
                    e.printStackTrace();
                }

                break;
            case R.id.share2pengyouquan:
                try {
                    JSONObject object = new JSONObject(nativeString);
                    String title = object.getString("title");
                    String url = object.getString("url");
                    String courseId = object.getString("courseId");

                    WXWebpageObject webpage = new WXWebpageObject();
                    webpage.webpageUrl = url;
                    WXMediaMessage msg = new WXMediaMessage(webpage);
                    msg.title = title;
                    msg.description = "友邻优课，终身学习者的英语课堂";
                    Bitmap bmp = BitmapFactory.decodeResource(context.getResources(), R.mipmap.ic_launcher);
                    Bitmap thumbBmp = Bitmap.createScaledBitmap(bmp, 150, 150, true);
                    bmp.recycle();
                    msg.thumbData = ImageUtil.Bitmap2Bytes(thumbBmp, true);

                    SendMessageToWX.Req req = new SendMessageToWX.Req();
                    req.transaction = buildTransaction("webPage");
                    req.message = msg;


                    req.scene = SendMessageToWX.Req.WXSceneTimeline;
                    MainApplication application = (MainApplication) this.context.getApplicationContext();
                    IWXAPI iwxapi = application.getIwxapi();
                    iwxapi.sendReq(req);
                } catch (Exception e) {
                    e.printStackTrace();
                }

                break;
        }

        if (popupWindow != null && popupWindow.isShowing()) {
            popupWindow.dismiss();
        }
    }

    private String buildTransaction(final String type) {
        return (type == null) ? String.valueOf(System.currentTimeMillis()) : type + System.currentTimeMillis();
    }
}
