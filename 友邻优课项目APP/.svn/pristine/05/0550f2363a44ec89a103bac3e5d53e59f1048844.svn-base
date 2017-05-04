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
import android.widget.TextView;

import com.zhuomogroup.ylyk.R;
import com.zhuomogroup.ylyk.utils.SharedPreferencesUtil;
import com.zhuomogroup.ylyk.utils.SystemUtil;
import com.zhy.changeskin.SkinManager;
import com.zhy.changeskin.utils.PrefUtils;

import org.json.JSONException;
import org.json.JSONObject;

import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_SPEED_TIME_100;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_SPEED_TIME_125;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_SPEED_TIME_150;
import static com.zhuomogroup.ylyk.consts.YLPlayCode.PLAY_SPEED_TIME_80;
import static com.zhuomogroup.ylyk.consts.YLStorageKey.WEBVIEW_TEXT_SIZE;


/**
 * Created by xyb on 2017/1/21.
 */

public class YLPlayTypePopupWindow extends PopupWindow implements View.OnClickListener {

    public final static int ANDROID_N = 24;
    private ImageView playTimesImg;
    private View mMenuView;
    private OnSelectedListener mOnSelectedListener;
    private PopupWindow popupWindow;
    private int[] playTimeArr = {R.mipmap.play_button_0_8times, R.mipmap.play_button_1times, R.mipmap.play_button_1_25times, R.mipmap.play_button_1_5times};
    private int[] playTimeArr_green = {R.mipmap.play_button_0_8times_green, R.mipmap.play_button_1times_green, R.mipmap.play_button_1_25times_green, R.mipmap.play_button_1_5times_green};
    private int[] playTimeArr_night = {R.mipmap.play_button_0_8times_night, R.mipmap.play_button_1times_night, R.mipmap.play_button_1_25times_night, R.mipmap.play_button_1_5times_night};
    private int[] playTimeArr_yellow = {R.mipmap.play_button_0_8times_yellow, R.mipmap.play_button_1times_yellow, R.mipmap.play_button_1_25times_yellow, R.mipmap.play_button_1_5times_yellow};
//    private String[] textSizes = {"小", "中", "大"};

    private int[] playFontsizeArr = {R.mipmap.web_fontsize_small, R.mipmap.web_fontsize_cener, R.mipmap.web_fontsize_big};
    private int[] playFontsizeArr_green = {R.mipmap.web_fontsize_small_green, R.mipmap.web_fontsize_cener_green, R.mipmap.web_fontsize_big_green};
    private int[] playFontsizeArr_night = {R.mipmap.web_fontsize_small_night, R.mipmap.web_fontsize_cener_night, R.mipmap.web_fontsize_big_night};
    private int[] playFontsizeArr_yellow = {R.mipmap.web_fontsize_small_yellow, R.mipmap.web_fontsize_cener_yellow, R.mipmap.web_fontsize_big_yellow};


    private String[] show_type = {"", "green", "night", "yellow"};
    private int playTimesNow;

    private int[][] allTips = {playTimeArr, playTimeArr_green, playTimeArr_night, playTimeArr_yellow};
    private int[][] fontSizes = {playFontsizeArr, playFontsizeArr_green, playFontsizeArr_night, playFontsizeArr_yellow};

    private TextView  likeTextSize, tipsTextSize;
    private ImageView likeImg;
    private ImageView ImageView;
    private int likeCount;
    private int webTextSizeType;
    private int position = 0;


    public YLPlayTypePopupWindow(Context context) {
        super(context);


        LayoutInflater inflater = (LayoutInflater) context.getSystemService(Context.LAYOUT_INFLATER_SERVICE);
        mMenuView = inflater.inflate(R.layout.dialog_more, null, false);


        RelativeLayout all_tips = (RelativeLayout) mMenuView.findViewById(R.id.all_tips);
        RelativeLayout play_times = (RelativeLayout) mMenuView.findViewById(R.id.play_times);
        RelativeLayout back_rel = (RelativeLayout) mMenuView.findViewById(R.id.back_rel);
        RelativeLayout like_album = (RelativeLayout) mMenuView.findViewById(R.id.like_album);
        RelativeLayout add_re = (RelativeLayout) mMenuView.findViewById(R.id.add_re);
        playTimesImg = (ImageView) mMenuView.findViewById(R.id.play_times_img);
        likeImg = (ImageView) mMenuView.findViewById(R.id.like_img);
        ImageView = (ImageView) mMenuView.findViewById(R.id.text_size);
        likeTextSize = (TextView) mMenuView.findViewById(R.id.like_text_size);
        tipsTextSize = (TextView) mMenuView.findViewById(R.id.tips_text_size);

        all_tips.setOnClickListener(this);
        like_album.setOnClickListener(this);
        add_re.setOnClickListener(this);
        play_times.setOnClickListener(this);
        back_rel.setOnClickListener(this);
    }


    @Override
    public void onClick(View v) {
        switch (v.getId()) {
            case R.id.all_tips:
                if (null != mOnSelectedListener) {
                    mOnSelectedListener.OnSelected(v, 0, 0);
                }
                break;
            case R.id.play_times:
                if (null != mOnSelectedListener) {
                    playTimesNow = playTimesNow + 1;
                    int position = playTimesNow % 4;
                    playTimesImg.setImageResource(allTips[this.position][position]);
                    mOnSelectedListener.OnSelected(v, 1, position);
                }
                break;
            case R.id.back_rel:
                if (mOnSelectedListener != null) {
                    mOnSelectedListener.OnSelected(v, 3, 0);
                }
                break;
            case R.id.add_re:
                if (mOnSelectedListener != null) {
                    mOnSelectedListener.OnSelected(v, 4, 0);
                    webTextSizeType++;
                    webTextSizeType = webTextSizeType % 3;
                    ImageView.setImageResource(fontSizes[position][webTextSizeType]);
                }
                break;
            case R.id.like_album:

                if (likeImg.isSelected()) {
                    likeImg.setSelected(false);
                    likeCount = likeCount - 1;
                    if (likeCount > 0) {
                        likeTextSize.setText("赞(" + likeCount + ")");
                    }
                    mOnSelectedListener.OnSelected(v, 5, 0);
                } else {
                    mOnSelectedListener.OnSelected(v, 5, 1);
                    likeImg.setSelected(true);
                    likeCount = likeCount + 1;

                    likeTextSize.setText("赞(" + likeCount + ")");
                }
                break;

        }

    }

    /**
     * 设置选择监听
     *
     * @param l
     */
    public void setOnSelectedListener(OnSelectedListener l) {
        this.mOnSelectedListener = l;
    }

    /**
     * 选择监听接口
     */
    public interface OnSelectedListener {
        void OnSelected(View v, int position, int type);
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
     * @param rate
     */
    public void showPopupWindow(final Activity activity, float rate, String response) {


        if (activity != null) {
            PrefUtils prefUtils = new PrefUtils(activity);
            String suffix = prefUtils.getSuffix();
            for (int i = 0; i < show_type.length; i++) {
                if (show_type[i].equals(suffix)) {
                    position = i;
                }
            }

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

            if (rate == 1.25f) {
                playTimesNow = PLAY_SPEED_TIME_125;
            } else if (rate == 0.8f) {
                playTimesNow = PLAY_SPEED_TIME_80;
            } else if (rate == 1f) {
                playTimesNow = PLAY_SPEED_TIME_100;
            } else if (rate == 1.5f) {
                playTimesNow = PLAY_SPEED_TIME_150;
            }

            webTextSizeType = (int) SharedPreferencesUtil.get(activity.getApplicationContext(), WEBVIEW_TEXT_SIZE, 1);
            ImageView.setImageResource(fontSizes[position][webTextSizeType]);

            try {
                if (response != null) {
                    JSONObject object = new JSONObject(response);
                    int note_count = object.getInt("note_count");
                    likeCount = object.getInt("like_count");
                    likeTextSize.setText("赞(" + likeCount + ")");
                    if (note_count >= 99) {
                        tipsTextSize.setText("心得(" + 99 + "+)");
                    } else {
                        tipsTextSize.setText("心得(" + note_count + ")");
                    }

                    boolean is_liked = object.getBoolean("is_liked");
                    if (is_liked) {
                        likeImg.setSelected(true);
                    } else {
                        likeImg.setSelected(false);
                    }
                }
            } catch (JSONException e) {
                e.printStackTrace();
            }


            playTimesImg.setImageResource(allTips[this.position][playTimesNow]);

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

    }


}
