package com.zhuomogroup.ylyk.popupwindow;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.graphics.drawable.ColorDrawable;
import android.os.Build;
import android.view.Gravity;
import android.view.LayoutInflater;
import android.view.View;
import android.view.WindowManager;
import android.widget.ImageView;
import android.widget.PopupWindow;
import android.widget.RelativeLayout;
import android.widget.SeekBar;

import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.utils.BrightnessUtil;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhuomogroup.ylyk.utils.SystemUtil;
import com.zhy.changeskin.SkinManager;
import com.zhy.changeskin.utils.PrefUtils;

import static com.zhuomogroup.ylyk.consts.YLStorageKey.WEBVIEW_TEXT_SIZE;
import static com.zhuomogroup.ylyk.utils.BrightnessUtil.saveBrightness;
import static com.zhuomogroup.ylyk.utils.BrightnessUtil.setBrightness;


/**
 * Created by xyb on 2017/1/21.
 */

public class YLPlaySettingPopupWindow extends PopupWindow implements View.OnClickListener, SeekBar.OnSeekBarChangeListener {

    public final static int ANDROID_N = 24;
    private final ImageView close;
    private final SeekBar seek_bar;
    private ImageView playTimesImg;
    private View mMenuView;
    private PopupWindow popupWindow;

    private String[] show_type = {"", "green", "yellow", "night"};

    private int webTextSizeType;
    private int position = 0;
    private ImageView set_default;
    private ImageView set_green;
    private ImageView set_yellow;
    private ImageView set_night;
    RelativeLayout back_rel;
    private int[] bagroundColor = {R.drawable.play_more_bg, R.drawable.play_more_bg_green, R.drawable.play_more_bg_yellow, R.drawable.play_more_bg_night};
    private int[] typeColor = {R.color.play_list_bottom_bg, R.color.play_list_bottom_bg_green, R.color.play_list_bottom_bg_yellow, R.color.play_list_bottom_bg_night};
    private int[] imgs = {R.mipmap.play_icon_close, R.mipmap.play_icon_close_green, R.mipmap.play_icon_close_yellow, R.mipmap.play_icon_close_night};
    private Activity activity;

    public YLPlaySettingPopupWindow(Context context) {
        super(context);


        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        mMenuView = inflater.inflate(R.layout.dialog_setting, null, false);

        back_rel = (RelativeLayout) mMenuView.findViewById(R.id.back_rel);
        seek_bar = (SeekBar) mMenuView.findViewById(R.id.seek_bar);

        set_default = (ImageView) mMenuView.findViewById(R.id.set_default);
        set_green = (ImageView) mMenuView.findViewById(R.id.set_green);
        set_yellow = (ImageView) mMenuView.findViewById(R.id.set_yellow);
        set_night = (ImageView) mMenuView.findViewById(R.id.set_night);
        close = (ImageView) mMenuView.findViewById(R.id.close);

        set_default.setOnClickListener(this);
        set_green.setOnClickListener(this);
        set_yellow.setOnClickListener(this);
        set_night.setOnClickListener(this);
        back_rel.setOnClickListener(this);
        seek_bar.setOnSeekBarChangeListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.set_default:
                SkinManager.getInstance().changeSkin(show_type[0]);
                switchType(0);

                break;
            case R.id.set_green:
                SkinManager.getInstance().changeSkin(show_type[1]);
                switchType(1);
                break;
            case R.id.back_rel:
                if (isPopupWindowShow()) {
                    if (popupWindow != null && popupWindow.isShowing()) {
                        popupWindow.dismiss();
                        popupWindow = null;
                    }
                }

                break;
            case R.id.set_night:
                SkinManager.getInstance().changeSkin(show_type[3]);
                switchType(3);
                break;
            case R.id.set_yellow:
                SkinManager.getInstance().changeSkin(show_type[2]);
                switchType(2);
                break;

        }

    }

    private void switchType(int i) {
        mMenuView.setBackgroundResource(bagroundColor[i]);
        back_rel.setBackgroundResource(typeColor[i]);
        close.setImageResource(imgs[i]);
        set_default.setSelected(true);
        set_green.setSelected(true);
        set_night.setSelected(true);
        set_yellow.setSelected(true);
        switch (i) {
            case 0:
                set_default.setSelected(false);
                break;
            case 1:
                set_green.setSelected(false);
                break;
            case 2:
                set_yellow.setSelected(false);
                break;
            case 3:
                set_night.setSelected(false);
                break;
        }
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

    public boolean isPopupWindowShow() {
        return popupWindow != null && popupWindow.isShowing();
    }


    /**
     * 把一个View控件添加到PopupWindow上并且显示
     *
     * @param activity
     */
    public void showPopupWindow(final Activity activity) {


        if (activity != null) {
            this.activity = activity;
            PrefUtils prefUtils = new PrefUtils(activity);
            String suffix = prefUtils.getSuffix();
            for (int i = 0; i < show_type.length; i++) {
                if (show_type[i].equals(suffix)) {
                    position = i;
                }
            }


            switchType(position);

            SkinManager.getInstance().injectSkin(mMenuView);
            popupWindow = new PopupWindow(mMenuView);
            int width = activity.getWindow().getDecorView().getWidth();
            popupWindow.setWidth((int) (width * 0.95));
            popupWindow.setHeight(SystemUtil.dip2px(activity, 225));
            // ☆ 注意： 必须要设置背景，播放动画有一个前提 就是窗体必须有背景
            popupWindow.setSoftInputMode(WindowManager.LayoutParams.SOFT_INPUT_ADJUST_RESIZE);
            popupWindow.setBackgroundDrawable(new ColorDrawable(Color.TRANSPARENT));

            try {
                popupWindow.showAtLocation(activity.getWindow().getDecorView(), Gravity.CENTER | Gravity.BOTTOM, 0, SystemUtil.dip2px(activity, 8));
            } catch (Exception e) {
                e.printStackTrace();
            }
            popupWindow.setAnimationStyle(android.R.style.Animation_InputMethod);   // 设置窗口显示的动画效果
            popupWindow.setOutsideTouchable(true);                                        // 点击其他地方隐藏键盘 popupWindow
            if (Build.VERSION.SDK_INT != ANDROID_N) {
                popupWindow.update();
            }


            webTextSizeType = (int) SharedPreferencesUtil.get(activity.getApplicationContext(), WEBVIEW_TEXT_SIZE, 1);


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
            //获取当前亮度的位置
            int a = BrightnessUtil.getScreenBrightness(activity);
            seek_bar.setProgress(a);
        }

    }


    @Override
    public void onProgressChanged(SeekBar seekBar, int progress, boolean fromUser) {
        if (activity != null) {
            if (progress < 10) {
            } else {
                setBrightness(activity, progress);
                saveBrightness(activity.getContentResolver(), progress);
            }
        }
    }

    @Override
    public void onStartTrackingTouch(SeekBar seekBar) {

    }

    @Override
    public void onStopTrackingTouch(SeekBar seekBar) {

    }
}
